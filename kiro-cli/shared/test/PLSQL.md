# Configuracion y Reglas Fundamentales para Pruebas Unitarias PL/SQL

## Configuracion del Proyecto

### Framework de Pruebas

- Usar **utPLSQL v3** como framework de pruebas unitarias
- El agente debe verificar que utPLSQL este instalado en el esquema de pruebas ejecutando `SELECT * FROM all_objects WHERE object_name = 'UT' AND object_type = 'PACKAGE'`
- Si utPLSQL no esta instalado, advertir al usuario e indicar que debe instalarlo desde el repositorio oficial
- Ejecutar pruebas con `EXEC ut.run()` o mediante `utPLSQL-cli` para integracion con CI/CD
- Usar **utPLSQL annotations** (`--%suite`, `--%test`, `--%beforeall`, `--%afterall`, `--%beforeeach`, `--%aftereach`) para estructura de tests
- Los paquetes de test deben crearse en un **esquema separado** dedicado a pruebas (por ejemplo, `<SCHEMA>_TEST`), nunca en el esquema de produccion

### Regla de Idioma en Codigo

**Todo el codigo generado por el agente debe usar identificadores en ingles**: nombres de paquetes, nombres de procedimientos de test, variables, constantes y parametros. Los comentarios estructurales dentro del codigo generado (`-- Arrange`, `-- Act`, `-- Assert`, `-- Happy path`, etc.) tambien deben estar en ingles. Las explicaciones y reglas del presente documento estan en espanol; los comentarios pedagogicos dentro de los ejemplos de este documento pueden estar en espanol para facilitar la comprension de las reglas, pero el agente no debe reproducirlos en el codigo que genere.

---

## REGLA FUNDAMENTAL DE DECISION

### PROBAR SI Y SOLO SI el procedimiento/funcion contiene

1. **Operadores logicos**: `IF`, `ELSIF`, `CASE`, `FOR`, `WHILE`, `LOOP`
2. **Calculos matematicos**: `+`, `-`, `*`, `/`, `MOD`, comparaciones numericas
3. **Multiples sentencias DML CON transformacion** entre ellas
4. **Reglas de negocio** que pueden ser validadas o rechazadas
5. **Coordinacion de interacciones** entre 2 o mas tablas/cursores/APIs
6. **Validaciones combinadas** (multiples condiciones con logica)
7. **Cursores con logica condicional** dentro del FETCH loop
8. **Manejo de excepciones con logica de negocio** (WHEN clauses con acciones distintas)

### NO PROBAR SI el procedimiento/funcion

1. **Solo ejecuta UN SELECT/INSERT/UPDATE/DELETE** sin transformar el resultado (delegacion pura a una tabla)
2. Es **getter** trivial (funcion que solo retorna `SELECT column FROM table WHERE id = p_id`)
3. Solo **asigna parametros** a variables sin logica (`l_var := p_param`)
4. **Solo valida nulidad** y lanza excepcion, sin ninguna otra logica. **Excepcion**: si la validacion de nulidad es parte de un procedimiento que SI tiene logica de negocio adicional, incluir un test de excepcion por nulidad como parte del set de tests de ese procedimiento
5. Es procedimiento **generado** por herramientas (TAPI generados por Oracle Designer, etc.)
6. Solo **agrega/remueve** elementos de colecciones PL/SQL sin logica de negocio
7. Es **delegacion pura** a otro procedimiento sin transformacion
8. Es **job scheduler callback** sin logica propia (`DBMS_SCHEDULER` wrappers)
9. Es **sinonimo** o **wrapper DDL** (`CREATE SYNONYM`, grants, etc.)
10. Es **vista** o **tipo** sin logica embebida
11. Es **trigger** que solo copia valores de `:NEW` a campos de auditoria (created_by, created_date) sin logica condicional

---

## CHECKLIST DE DECISION RAPIDA

Antes de generar una prueba para un procedimiento/funcion, el agente debe responder estas preguntas:

- [ ] Tiene el procedimiento `IF`/`ELSIF`/`CASE`/`FOR`/`WHILE`/calculos?
- [ ] Transforma datos (no solo los pasa a otra tabla/procedimiento)?
- [ ] Hay reglas de negocio explicitas?
- [ ] Se coordinan multiples tablas o llamadas a otros procedimientos?
- [ ] El procedimiento puede lanzar excepciones de negocio (`RAISE_APPLICATION_ERROR`)?

**Si la respuesta es NO a TODAS las preguntas anteriores, NO generar prueba para ese procedimiento.** El agente debe omitir silenciosamente estos procedimientos; no es necesario agregar comentarios ni logs sobre procedimientos excluidos.

**Regla de desempate**: si el agente no esta seguro de si un procedimiento califica para prueba, debe generar la prueba. Es preferible una prueba que resulte marginalmente util a omitir un procedimiento con logica de negocio real.

Si al menos una respuesta es SI:

- [ ] Crear maximo 5 tests por procedimiento/funcion
- [ ] Usar nomenclatura `should_<action>_when_<condition>` (snake_case, limite de 30 caracteres para nombres de procedimientos Oracle)
- [ ] Aplicar patron AAA estrictamente (Arrange - Act - Assert)
- [ ] Usar savepoints para aislamiento transaccional
- [ ] Probar casos de excepcion con numero de error y mensaje especificos
- [ ] Verificar resultados consultando datos directamente con SELECT
- [ ] NO verificar implementacion interna (logs, orden irrelevante de operaciones DML internas)

---

## AISLAMIENTO: Savepoints y Rollback

### Patron Obligatorio de Aislamiento

Toda prueba que modifica datos debe usar savepoints para mantener la base de datos limpia:

```sql
--%beforeeach
PROCEDURE setup IS
BEGIN
    SAVEPOINT test_start;
    -- Insert test data
END;

--%aftereach
PROCEDURE teardown IS
BEGIN
    ROLLBACK TO test_start;
END;
```

### Alternativa: Tablas Temporales / Datos de Test Dedicados

Para escenarios donde el rollback no es viable (por ejemplo, autonomous transactions):

- Usar un conjunto de datos de prueba con IDs en un rango reservado (por ejemplo, IDs negativos o un rango alto)
- Limpiar explicitamente en `teardown`

```sql
--%aftereach
PROCEDURE teardown IS
BEGIN
    DELETE FROM orders WHERE order_id < 0; -- Test data range
    DELETE FROM customers WHERE customer_id < 0;
    COMMIT;
END;
```

### NUNCA hacer

- Ejecutar tests contra datos de produccion
- Dejar datos de test en la base de datos despues de la ejecucion
- Depender de datos preexistentes en tablas (cada test debe crear sus propios datos)
- Usar `COMMIT` dentro de los tests (a menos que se este probando autonomous transactions)

---

## MOCKS Y STUBS EN PL/SQL

### Estrategias de Mocking

PL/SQL no tiene un framework de mocks como Mockito. En su lugar, usar estas tecnicas:

#### 1. Inyeccion via Paquetes de Abstraccion

Encapsular dependencias externas en paquetes que puedan ser reemplazados en tests:

```sql
-- Paquete de produccion
CREATE OR REPLACE PACKAGE email_service AS
    PROCEDURE send_email(p_to VARCHAR2, p_subject VARCHAR2, p_body VARCHAR2);
END;

-- Paquete stub para tests (mismo nombre, diferente esquema o conditional compilation)
CREATE OR REPLACE PACKAGE BODY email_service AS
    g_last_to      VARCHAR2(200);
    g_last_subject VARCHAR2(200);
    g_call_count   NUMBER := 0;

    PROCEDURE send_email(p_to VARCHAR2, p_subject VARCHAR2, p_body VARCHAR2) IS
    BEGIN
        g_last_to := p_to;
        g_last_subject := p_subject;
        g_call_count := g_call_count + 1;
    END;

    FUNCTION get_last_to RETURN VARCHAR2 IS BEGIN RETURN g_last_to; END;
    FUNCTION get_call_count RETURN NUMBER IS BEGIN RETURN g_call_count; END;

    PROCEDURE reset IS
    BEGIN
        g_last_to := NULL;
        g_last_subject := NULL;
        g_call_count := 0;
    END;
END;
```

#### 2. Tablas de Control para Simular Dependencias Externas

```sql
-- Tabla de control para simular respuestas de servicios web
CREATE GLOBAL TEMPORARY TABLE test_ws_responses (
    service_name VARCHAR2(100),
    response_code NUMBER,
    response_body CLOB
) ON COMMIT DELETE ROWS;
```

#### 3. Conditional Compilation

```sql
CREATE OR REPLACE PACKAGE BODY order_service AS
    PROCEDURE notify_customer(p_order_id NUMBER) IS
    BEGIN
        $IF $$TESTING $THEN
            -- Stub: record call in test log table
            INSERT INTO test_call_log (procedure_name, param_value, call_time)
            VALUES ('notify_customer', p_order_id, SYSTIMESTAMP);
        $ELSE
            -- Production: actual notification logic
            real_notification_pkg.send(p_order_id);
        $END
    END;
END;
```

### SIEMPRE aislar

- **Llamadas a servicios web** (UTL_HTTP, APEX_WEB_SERVICE)
- **Envio de emails** (UTL_MAIL, UTL_SMTP)
- **Acceso al filesystem** (UTL_FILE)
- **Jobs y schedulers** (DBMS_SCHEDULER, DBMS_JOB)
- **Colas de mensajeria** (DBMS_AQ, Advanced Queuing)
- **Llamadas a DBMS_PIPE / DBMS_ALERT**

### NUNCA aislar

- **Tablas del esquema** (usar datos reales en tablas temporales o con savepoint/rollback)
- **Secuencias** (usar las reales; los IDs no importan en tests)
- **Funciones PL/SQL puras** sin side-effects (calculos, conversiones)
- **Tipos y records** PL/SQL

---

## Nomenclatura de Pruebas

### Patron Obligatorio

```
should_<action>_when_<condition>
```

**Nota**: Oracle limita los nombres de procedimientos a 128 caracteres (30 en versiones anteriores a 12.2). Si el nombre excede el limite, abreviar la condicion manteniendo la legibilidad.

### Ejemplos Correctos

```sql
should_calc_discount_when_vip()
should_raise_err_when_amt_neg()
should_return_empty_when_no_rows()
should_update_status_when_paid()
should_reject_order_when_no_stock()
```

### Ejemplos Incorrectos

```sql
test_calculate_discount()              -- No usa patron should...when
calculate_discount_vip()               -- No inicia con "should"
should_calculate_discount()            -- Falta condicion "when"
deberia_calcular_descuento()           -- Nombres deben ser en ingles
```

---

## Estructura de Prueba Obligatoria

### Patron AAA (Arrange - Act - Assert)

Toda prueba debe seguir estrictamente este patron:

```sql
--%test(Should calculate discount when customer is VIP)
PROCEDURE should_calc_discount_when_vip IS
    l_result NUMBER;
    l_expected NUMBER := 150;
BEGIN
    -- Arrange
    INSERT INTO customers (customer_id, name, customer_type)
    VALUES (-1, 'Test Customer', 'VIP');

    INSERT INTO orders (order_id, customer_id, amount)
    VALUES (-1, -1, 1000);

    -- Act
    l_result := order_pkg.calculate_discount(p_order_id => -1);

    -- Assert
    ut.expect(l_result).to_equal(l_expected);
END;
```

---

## Limites y Cobertura

### Objetivo: Cubrir todas las ramas de decision visibles

El agente debe generar tests que cubran todas las ramas de decision (branches) visibles en el codigo fuente: cada bloque `IF`/`ELSIF`/`ELSE`, cada rama de `CASE`, cada handler de excepcion con logica, y los escenarios de error de negocio.

**NO INCLUIR en la cobertura**:
- Getters triviales (SELECT simple sin logica)
- Wrappers de una sola llamada
- Procedimientos generados (TAPI)
- Triggers de auditoria sin logica condicional
- Sinonimos y grants

### Maximo de Tests por Procedimiento/Funcion

**Limite: 5 tests por procedimiento/funcion**

Distribucion recomendada:
1. **1 test**: Caso feliz (happy path)
2. **2 tests**: Casos limite (edge cases)
   - Valores en los limites (NULL, vacio, 0, negativo, maximo)
   - Condiciones de frontera (cursor vacio, coleccion vacia)
3. **2 tests**: Excepciones
   - Validaciones de negocio rechazadas (`RAISE_APPLICATION_ERROR`)
   - Errores esperados de dependencias (NO_DATA_FOUND, TOO_MANY_ROWS)

**Cuando un procedimiento tiene mas de 5 ramas de decision**, priorizar en este orden:
1. Happy path
2. Branch con mayor impacto de negocio
3. Excepciones de negocio
4. Omitir branches puramente defensivos o de infraestructura

### Ejemplo de Cobertura Completa

```sql
-- Funcion bajo prueba
CREATE OR REPLACE FUNCTION calculate_discount(
    p_customer_id NUMBER,
    p_amount      NUMBER
) RETURN NUMBER IS
    l_customer_type VARCHAR2(10);
BEGIN
    IF p_customer_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer ID cannot be null');
    END IF;
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Amount must be positive');
    END IF;

    SELECT customer_type INTO l_customer_type
    FROM customers
    WHERE customer_id = p_customer_id;

    IF l_customer_type = 'VIP' THEN
        RETURN p_amount * 0.15;
    ELSIF p_amount > 1000 THEN
        RETURN p_amount * 0.05;
    ELSE
        RETURN 0;
    END IF;
END;

-- Tests (5 maximo)
--%test(Should calculate 15 percent discount when customer is VIP)
PROCEDURE should_calc_15pct_when_vip IS
    -- Happy path
END;

--%test(Should calculate 5 percent discount when amount exceeds one thousand)
PROCEDURE should_calc_5pct_when_amt_gt_1k IS
    -- Edge case 1
END;

--%test(Should return zero when amount is under one thousand)
PROCEDURE should_return_zero_when_lt_1k IS
    -- Edge case 2
END;

--%test(Should raise error when customer ID is null)
PROCEDURE should_raise_when_cust_null IS
    -- Exception 1
END;

--%test(Should raise error when amount is negative)
PROCEDURE should_raise_when_amt_neg IS
    -- Exception 2
END;
```

---

# Casos Especiales - Guia de Decision Detallada

## PROBAR - Validaciones Combinadas

```sql
-- Multiples condiciones con logica de negocio
FUNCTION is_eligible(p_customer_id NUMBER) RETURN BOOLEAN IS
    l_age     NUMBER;
    l_balance NUMBER;
BEGIN
    SELECT age, balance INTO l_age, l_balance
    FROM customers WHERE customer_id = p_customer_id;

    RETURN l_age >= 18 AND l_balance > 0;
END;

-- Validacion con multiples reglas
PROCEDURE validate_order(p_order_id NUMBER) IS
    l_item_count NUMBER;
    l_total      NUMBER;
BEGIN
    SELECT COUNT(*), NVL(SUM(amount), 0)
    INTO l_item_count, l_total
    FROM order_items WHERE order_id = p_order_id;

    IF l_item_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Order has no items');
    END IF;
    IF l_total < 10 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Insufficient amount');
    END IF;
END;
```

## NO PROBAR - Validaciones Triviales

```sql
-- Solo validacion de nulidad sin otra logica
PROCEDURE validate_input(p_value VARCHAR2) IS
BEGIN
    IF p_value IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Value cannot be null');
    END IF;
END;

-- Setter con validacion trivial en tabla
PROCEDURE set_name(p_id NUMBER, p_name VARCHAR2) IS
BEGIN
    IF p_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Name is required');
    END IF;
    UPDATE customers SET name = p_name WHERE customer_id = p_id;
END;
```

## PROBAR - Delegacion con Logica Condicional

```sql
-- Consulta con fallback — SI tiene branch
FUNCTION get_product(p_code VARCHAR2) RETURN product_rec IS
    l_product product_rec;
BEGIN
    BEGIN
        SELECT * INTO l_product FROM products WHERE code = p_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_product := create_default_product(p_code);
    END;
    RETURN l_product;
END;

-- Coordinacion de multiples operaciones con transformacion
PROCEDURE process_and_notify(p_order_id NUMBER) IS
    l_total NUMBER;
    l_tax   NUMBER;
BEGIN
    SELECT total INTO l_total FROM orders WHERE order_id = p_order_id;
    l_tax := tax_pkg.calculate(l_total);
    UPDATE orders SET tax = l_tax, grand_total = l_total + l_tax
    WHERE order_id = p_order_id;
    notification_pkg.send_confirmation(p_order_id);
END;
```

## PROBAR - Cursores con Logica

```sql
-- Cursor con logica condicional dentro del loop
PROCEDURE process_pending_orders IS
    CURSOR c_orders IS
        SELECT order_id, amount, customer_type FROM pending_orders_v;
BEGIN
    FOR r IN c_orders LOOP
        IF r.customer_type = 'VIP' THEN
            apply_vip_discount(r.order_id, r.amount);
        ELSIF r.amount > 5000 THEN
            apply_bulk_discount(r.order_id, r.amount);
        ELSE
            process_standard(r.order_id);
        END IF;
    END LOOP;
END;
```

## NO PROBAR - Delegacion Pura

```sql
-- Solo consulta directa sin transformacion
FUNCTION find_customer(p_id NUMBER) RETURN customers%ROWTYPE IS
    l_cust customers%ROWTYPE;
BEGIN
    SELECT * INTO l_cust FROM customers WHERE customer_id = p_id;
    RETURN l_cust;
END;

-- Delegacion directa
PROCEDURE save_customer(p_rec customers%ROWTYPE) IS
BEGIN
    INSERT INTO customers VALUES p_rec;
END;

-- Delegacion secuencial sin logica — NO probar
FUNCTION find_and_convert(p_id NUMBER) RETURN customer_dto IS
    l_cust customers%ROWTYPE;
BEGIN
    SELECT * INTO l_cust FROM customers WHERE customer_id = p_id;
    RETURN mapping_pkg.to_dto(l_cust);
END;
```

## PROBAR - Procedimientos con Side-Effects Multiples

```sql
-- Coordina multiples operaciones DML
PROCEDURE process_payment(p_payment_id NUMBER) IS
    l_amount NUMBER;
BEGIN
    SELECT amount INTO l_amount FROM payments WHERE payment_id = p_payment_id;

    UPDATE payments SET status = 'PROCESSED', processed_date = SYSDATE
    WHERE payment_id = p_payment_id;

    INSERT INTO payment_audit (payment_id, action, amount, audit_date)
    VALUES (p_payment_id, 'PROCESSED', l_amount, SYSDATE);

    INSERT INTO notifications (notification_type, reference_id, created_date)
    VALUES ('PAYMENT', p_payment_id, SYSDATE);
END;

-- Test correspondiente
--%test(Should process payment and create audit when payment is valid)
PROCEDURE should_process_and_audit IS
    l_status       VARCHAR2(20);
    l_audit_count  NUMBER;
    l_notif_count  NUMBER;
BEGIN
    -- Arrange
    INSERT INTO payments (payment_id, amount, status)
    VALUES (-1, 100, 'PENDING');

    -- Act
    payment_pkg.process_payment(p_payment_id => -1);

    -- Assert
    SELECT status INTO l_status FROM payments WHERE payment_id = -1;
    ut.expect(l_status).to_equal('PROCESSED');

    SELECT COUNT(*) INTO l_audit_count
    FROM payment_audit WHERE payment_id = -1 AND action = 'PROCESSED';
    ut.expect(l_audit_count).to_equal(1);

    SELECT COUNT(*) INTO l_notif_count
    FROM notifications WHERE reference_id = -1 AND notification_type = 'PAYMENT';
    ut.expect(l_notif_count).to_equal(1);
END;
```

## PROBAR - Transformaciones Complejas

```sql
-- Conversion con logica condicional
FUNCTION to_export_record(p_order_id NUMBER) RETURN export_rec IS
    l_rec   orders%ROWTYPE;
    l_export export_rec;
BEGIN
    SELECT * INTO l_rec FROM orders WHERE order_id = p_order_id;
    l_export.id := l_rec.order_id;
    l_export.status_code := CASE l_rec.status
        WHEN 'ACTIVE' THEN 'A'
        WHEN 'CANCELLED' THEN 'C'
        ELSE 'U'
    END;
    l_export.amount := ROUND(l_rec.amount, 2);
    l_export.export_date := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
    RETURN l_export;
END;
```

## NO PROBAR - Transformaciones Triviales

```sql
-- Solo copia de campos sin logica
FUNCTION to_dto(p_rec customers%ROWTYPE) RETURN customer_dto IS
    l_dto customer_dto;
BEGIN
    l_dto.id := p_rec.customer_id;
    l_dto.name := p_rec.name;
    l_dto.email := p_rec.email;
    RETURN l_dto;
END;
```

---

## Escenarios Obligatorios a Cubrir

Para cada procedimiento/funcion con logica de negocio, cubrir:

1. **Caso feliz (happy path)**: Entrada valida, resultado esperado
2. **Valores limite**:
   - `NULL`, vacio, 0, negativo
   - Valores maximos de columnas (`VARCHAR2(4000)`, `NUMBER(38)`)
   - Cursores vacios (NO_DATA_FOUND) vs con datos
3. **Excepciones esperadas**:
   - `RAISE_APPLICATION_ERROR` con numero y mensaje
   - `NO_DATA_FOUND`, `TOO_MANY_ROWS`
   - Errores de constraint (UNIQUE, FK, CHECK)
4. **Condiciones de frontera**:
   - Primer/ultimo registro en cursor
   - Transiciones de estado (de PENDING a PROCESSED, etc.)
   - Valores justo en el limite de condiciones

---

# Plantilla Base de Prueba utPLSQL

```sql
CREATE OR REPLACE PACKAGE test_order_pkg AS

    --%suite(Order Package Tests)
    --%suitepath(business.orders)

    --%beforeeach
    PROCEDURE setup;

    --%aftereach
    PROCEDURE teardown;

    --%test(Should calculate total with tax when order is valid)
    PROCEDURE should_calc_total_when_valid;

    --%test(Should apply VIP discount when customer is VIP)
    PROCEDURE should_apply_disc_when_vip;

    --%test(Should raise error when order has no items)
    --%throws(-20010)
    PROCEDURE should_raise_when_no_items;

    --%test(Should raise error when amount is negative)
    --%throws(-20002)
    PROCEDURE should_raise_when_amt_neg;

    --%test(Should return zero discount when amount is below threshold)
    PROCEDURE should_return_zero_when_low;

END test_order_pkg;
/

CREATE OR REPLACE PACKAGE BODY test_order_pkg AS

    PROCEDURE setup IS
    BEGIN
        SAVEPOINT test_start;

        INSERT INTO customers (customer_id, name, customer_type)
        VALUES (-1, 'Test Customer', 'STANDARD');

        INSERT INTO customers (customer_id, name, customer_type)
        VALUES (-2, 'VIP Customer', 'VIP');
    END;

    PROCEDURE teardown IS
    BEGIN
        ROLLBACK TO test_start;
    END;

    PROCEDURE should_calc_total_when_valid IS
        l_result NUMBER;
        l_base_amount   NUMBER := 1000;
        l_expected_tax  NUMBER := 210;  -- 21%
        l_expected_total NUMBER := 1210;
    BEGIN
        -- Arrange
        INSERT INTO orders (order_id, customer_id, amount)
        VALUES (-1, -1, l_base_amount);

        -- Act
        l_result := order_pkg.calculate_total(p_order_id => -1);

        -- Assert
        ut.expect(l_result).to_equal(l_expected_total);
    END;

    PROCEDURE should_apply_disc_when_vip IS
        l_discount NUMBER;
        l_amount   NUMBER := 1000;
        l_expected NUMBER := 150;  -- 15%
    BEGIN
        -- Arrange
        INSERT INTO orders (order_id, customer_id, amount)
        VALUES (-1, -2, l_amount);

        -- Act
        l_discount := order_pkg.calculate_discount(p_order_id => -1);

        -- Assert
        ut.expect(l_discount).to_equal(l_expected);
    END;

    PROCEDURE should_raise_when_no_items IS
    BEGIN
        -- Arrange
        INSERT INTO orders (order_id, customer_id, amount)
        VALUES (-1, -1, 100);
        -- No items inserted

        -- Act (exception expected via --%throws annotation)
        order_pkg.validate_order(p_order_id => -1);
    END;

    PROCEDURE should_raise_when_amt_neg IS
    BEGIN
        -- Act (exception expected via --%throws annotation)
        order_pkg.calculate_discount(
            p_customer_id => -1,
            p_amount => -100
        );
    END;

    PROCEDURE should_return_zero_when_low IS
        l_discount NUMBER;
        l_amount   NUMBER := 500;
    BEGIN
        -- Arrange
        INSERT INTO orders (order_id, customer_id, amount)
        VALUES (-1, -1, l_amount);

        -- Act
        l_discount := order_pkg.calculate_discount(p_order_id => -1);

        -- Assert
        ut.expect(l_discount).to_equal(0);
    END;

END test_order_pkg;
/
```

## Convenciones de Ubicacion

- Los paquetes de test deben ubicarse en un **esquema separado** (por ejemplo, `APP_TEST` para el esquema `APP`)
- Nombre del paquete de test: `TEST_<PaqueteBajoPrueba>` (ejemplo: `ORDER_PKG` -> `TEST_ORDER_PKG`)
- Un paquete de test por paquete bajo prueba
- Opcionalmente usar `--%suitepath` para organizar jerarquicamente: `--%suitepath(business.orders)`

## Tests Parametrizados con Cursores

Cuando un procedimiento tiene multiples combinaciones de entrada/salida que siguen el mismo patron, usar un cursor para iterar escenarios:

```sql
--%test(Should calculate correct discount for various inputs)
PROCEDURE should_calc_disc_for_inputs IS
    TYPE test_case_rec IS RECORD (
        amount          NUMBER,
        customer_type   VARCHAR2(10),
        expected_disc   NUMBER
    );
    TYPE test_case_tab IS TABLE OF test_case_rec;
    l_cases test_case_tab := test_case_tab();
    l_result NUMBER;
BEGIN
    -- Define test cases
    l_cases.EXTEND(4);
    l_cases(1) := test_case_rec(1000, 'VIP', 150);
    l_cases(2) := test_case_rec(6000, 'STANDARD', 600);
    l_cases(3) := test_case_rec(2000, 'STANDARD', 100);
    l_cases(4) := test_case_rec(500, 'STANDARD', 0);

    FOR i IN 1..l_cases.COUNT LOOP
        -- Arrange
        DELETE FROM customers WHERE customer_id = -1;
        INSERT INTO customers (customer_id, name, customer_type)
        VALUES (-1, 'Test', l_cases(i).customer_type);

        -- Act
        l_result := order_pkg.calculate_discount(
            p_customer_id => -1,
            p_amount => l_cases(i).amount
        );

        -- Assert
        ut.expect(l_result).to_equal(l_cases(i).expected_disc);
    END LOOP;
END;
```

---

# Manejo de Excepciones

## Principios para Pruebas de Excepciones

1. **Toda regla de negocio que usa `RAISE_APPLICATION_ERROR` DEBE tener test**
2. **Verificar numero de error especifico** (por ejemplo, `-20001`), no solo que se lance una excepcion
3. **Validar mensaje** si contiene informacion relevante de negocio
4. **Probar `NO_DATA_FOUND` y `TOO_MANY_ROWS`** cuando el procedimiento bajo prueba los maneja con logica

## Forma 1: Anotacion --%throws (solo para verificar numero de error)

```sql
--%test(Should raise error when order has no items)
--%throws(-20010)
PROCEDURE should_raise_when_no_items IS
BEGIN
    order_pkg.validate_order(p_order_id => -999);
END;
```

## Forma 2: Bloque BEGIN/EXCEPTION (para verificar mensaje y numero)

```sql
--%test(Should raise error with message when amount is negative)
PROCEDURE should_raise_msg_when_amt_neg IS
    l_error_code NUMBER;
    l_error_msg  VARCHAR2(4000);
BEGIN
    -- Act
    BEGIN
        order_pkg.calculate_discount(
            p_customer_id => -1,
            p_amount => -100
        );
        -- If we reach here, the test should fail
        ut.fail('Expected exception -20002 was not raised');
    EXCEPTION
        WHEN OTHERS THEN
            l_error_code := SQLCODE;
            l_error_msg := SQLERRM;
    END;

    -- Assert
    ut.expect(l_error_code).to_equal(-20002);
    ut.expect(l_error_msg).to_be_like('%Amount must be positive%');
END;
```

## Forma 3: ut.expect con raises (utPLSQL 3.1.13+)

```sql
--%test(Should raise error when customer not found)
PROCEDURE should_raise_when_not_found IS
BEGIN
    ut.expect(
        ut_runner.item(
            'BEGIN order_pkg.get_customer(p_id => -999); END;'
        )
    ).to_raise(-20001);
END;
```

## Pruebas de Interrupcion de Flujo por Excepcion

Verificar que cuando ocurre una excepcion en medio de un flujo, las operaciones posteriores NO se ejecutan:

```sql
--%test(Should not create notification when save fails)
PROCEDURE should_not_notify_on_fail IS
    l_notif_count NUMBER;
BEGIN
    -- Arrange: create scenario where save will fail (e.g., FK violation)
    -- Do NOT insert parent record so FK constraint fails

    -- Act
    BEGIN
        payment_pkg.process_payment(p_payment_id => -999);
    EXCEPTION
        WHEN OTHERS THEN NULL; -- Expected failure
    END;

    -- Assert: notification should NOT have been created
    SELECT COUNT(*) INTO l_notif_count
    FROM notifications WHERE reference_id = -999;
    ut.expect(l_notif_count).to_equal(0);
END;
```

---

# Verificacion de Resultados

## Estrategias de Asercion

A diferencia de Java donde se verifican return values y se usan verify() para mocks, en PL/SQL las aserciones se basan en:

### 1. Retorno de Funciones

```sql
l_result := my_pkg.calculate(p_input => 100);
ut.expect(l_result).to_equal(150);
```

### 2. Estado de la Base de Datos (para procedimientos)

```sql
-- Act
my_pkg.update_status(p_order_id => -1, p_status => 'SHIPPED');

-- Assert via SELECT
SELECT status INTO l_status FROM orders WHERE order_id = -1;
ut.expect(l_status).to_equal('SHIPPED');
```

### 3. Parametros OUT

```sql
my_pkg.process(
    p_input    => 100,
    p_result   => l_result,
    p_err_code => l_err_code,
    p_err_msg  => l_err_msg
);
ut.expect(l_result).to_equal(150);
ut.expect(l_err_code).to_equal(0);
```

### 4. Cursores (comparacion de result sets)

```sql
--%test(Should return active customers ordered by name)
PROCEDURE should_return_active_custs IS
    l_actual   SYS_REFCURSOR;
    l_expected SYS_REFCURSOR;
BEGIN
    -- Arrange
    INSERT INTO customers VALUES (-1, 'Alice', 'ACTIVE');
    INSERT INTO customers VALUES (-2, 'Bob', 'ACTIVE');
    INSERT INTO customers VALUES (-3, 'Charlie', 'INACTIVE');

    -- Act
    l_actual := customer_pkg.get_active_customers;

    -- Assert
    OPEN l_expected FOR
        SELECT -1 AS customer_id, 'Alice' AS name FROM DUAL
        UNION ALL
        SELECT -2, 'Bob' FROM DUAL;

    ut.expect(l_actual).to_equal(l_expected);
END;
```

## Matchers utPLSQL Mas Usados

| Matcher | Uso |
|---|---|
| `to_equal(value)` | Igualdad exacta |
| `to_be_null()` | Verificar NULL |
| `not_to_be_null()` | Verificar NOT NULL |
| `to_be_like(pattern)` | LIKE pattern matching |
| `to_match(regex)` | Regex matching |
| `to_be_between(low, high)` | Rango inclusivo |
| `to_be_greater_than(value)` | Mayor que |
| `to_be_less_than(value)` | Menor que |
| `to_be_empty()` | Coleccion/cursor vacio |
| `to_have_count(n)` | Conteo de elementos |
| `to_equal(cursor)` | Comparacion de result sets |

---

# Verificar Orden de Operaciones DML

Cuando el orden de las operaciones DML es critico para el negocio (por ejemplo, insertar auditoria ANTES de enviar notificacion), verificar mediante timestamps o secuencias:

```sql
--%test(Should audit before notification when invoice is processed)
PROCEDURE should_audit_before_notify IS
    l_audit_time TIMESTAMP;
    l_notif_time TIMESTAMP;
BEGIN
    -- Arrange
    INSERT INTO invoices (invoice_id, amount, status)
    VALUES (-1, 1000, 'PENDING');

    -- Act
    invoice_pkg.process_invoice(p_invoice_id => -1);

    -- Assert
    SELECT created_date INTO l_audit_time
    FROM audit_log WHERE reference_id = -1 AND action = 'PROCESSED';

    SELECT created_date INTO l_notif_time
    FROM notifications WHERE reference_id = -1;

    ut.expect(l_audit_time).to_be_less_or_equal(l_notif_time);
END;
```

---

# Anti-Patrones Prohibidos

## Anti-Patrones que NO se Deben Implementar

### 1. Tests que dependen de datos preexistentes

```sql
-- Incorrecto: depende de datos en la BD
PROCEDURE test_customer IS
    l_name VARCHAR2(100);
BEGIN
    SELECT name INTO l_name FROM customers WHERE customer_id = 1;
    ut.expect(l_name).to_equal('John');
END;

-- Correcto: insertar datos propios del test
PROCEDURE should_find_cust_when_exists IS
    l_name VARCHAR2(100);
BEGIN
    -- Arrange
    INSERT INTO customers (customer_id, name) VALUES (-1, 'John');

    -- Act
    SELECT name INTO l_name FROM customers WHERE customer_id = -1;

    -- Assert
    ut.expect(l_name).to_equal('John');
END;
```

### 2. Tests con DBMS_LOCK.SLEEP o waits

```sql
-- Incorrecto
PROCEDURE test_processing IS
BEGIN
    my_pkg.start_process;
    DBMS_LOCK.SLEEP(5); -- NO hacer esto
    ut.expect(my_pkg.is_completed).to_be_true();
END;

-- Correcto: mock del tiempo o verificar estado directamente
PROCEDURE should_complete_when_run IS
BEGIN
    -- Act
    my_pkg.process_synchronously(p_id => -1);

    -- Assert
    ut.expect(get_status(-1)).to_equal('COMPLETED');
END;
```

### 3. Tests que dependen del orden de ejecucion

```sql
-- Incorrecto: test 2 depende de que test 1 se ejecute primero
PROCEDURE test_create IS BEGIN
    INSERT INTO orders VALUES (-1, 100, 'NEW');
    COMMIT; -- datos persistidos para test_update
END;

PROCEDURE test_update IS BEGIN
    UPDATE orders SET status = 'DONE' WHERE order_id = -1; -- depende de test_create
END;

-- Correcto: tests independientes con setup propio
PROCEDURE should_update_when_exists IS
BEGIN
    -- Arrange
    INSERT INTO orders (order_id, amount, status) VALUES (-1, 100, 'NEW');

    -- Act
    order_pkg.update_status(p_order_id => -1, p_status => 'DONE');

    -- Assert
    ut.expect(get_status(-1)).to_equal('DONE');
END;
```

### 4. COMMIT dentro de tests

```sql
-- Incorrecto: COMMIT persiste datos de test
PROCEDURE test_save IS
BEGIN
    INSERT INTO customers VALUES (-1, 'Test');
    COMMIT; -- Contamina la BD
    ut.expect(count_customers).to_be_greater_than(0);
END;

-- Correcto: usar savepoints (ver seccion de aislamiento)
```

### 5. Multiples operaciones independientes en un solo test

```sql
-- Incorrecto: mezcla verificaciones de comportamientos distintos
PROCEDURE test_service IS
BEGIN
    ut.expect(my_pkg.method_a).to_equal('A');
    ut.expect(my_pkg.method_b).to_equal('B');
    ut.expect(my_pkg.method_c).to_equal('C');
END;

-- Correcto: dividir en tests separados
PROCEDURE should_return_a_when_method_a IS
BEGIN
    ut.expect(my_pkg.method_a).to_equal('A');
END;

PROCEDURE should_return_b_when_method_b IS
BEGIN
    ut.expect(my_pkg.method_b).to_equal('B');
END;
```

**NOTA IMPORTANTE**: Multiples aserciones sobre el MISMO resultado de una unica operacion son validas y esperadas:

```sql
PROCEDURE should_create_invoice_with_tax IS
    l_rec invoices%ROWTYPE;
BEGIN
    -- Act
    invoice_pkg.create_invoice(p_amount => 1000, p_customer_id => -1);

    -- Assert — todos validan el mismo resultado
    SELECT * INTO l_rec FROM invoices WHERE customer_id = -1;
    ut.expect(l_rec.amount).to_equal(1000);
    ut.expect(l_rec.tax).to_equal(210);
    ut.expect(l_rec.total).to_equal(1210);
    ut.expect(l_rec.status).to_equal('ISSUED');
END;
```

### 6. Verificar implementacion interna

```sql
-- Incorrecto: verificar detalles internos
PROCEDURE test_process IS
BEGIN
    my_pkg.process(-1);
    -- No verificar que se llamo a tal funcion interna
    -- No verificar que se uso tal variable de paquete
END;

-- Correcto: verificar estado observable
PROCEDURE should_process_when_valid IS
    l_status VARCHAR2(20);
BEGIN
    -- Arrange
    INSERT INTO orders (order_id, status) VALUES (-1, 'NEW');

    -- Act
    my_pkg.process(p_order_id => -1);

    -- Assert: verificar resultado observable
    SELECT status INTO l_status FROM orders WHERE order_id = -1;
    ut.expect(l_status).to_equal('PROCESSED');
END;
```

### 7. Hardcodear valores magicos

```sql
-- Incorrecto
PROCEDURE test_calculate IS
BEGIN
    ut.expect(my_pkg.calculate(100)).to_equal(150); -- Por que 150?
END;

-- Correcto: usar variables con nombres significativos
PROCEDURE should_calc_total_with_tax IS
    l_base_amount    NUMBER := 100;
    l_tax_rate       NUMBER := 0.50; -- 50%
    l_expected_total NUMBER := 150;
    l_result         NUMBER;
BEGIN
    l_result := my_pkg.calculate(l_base_amount);
    ut.expect(l_result).to_equal(l_expected_total);
END;
```

### 8. Tests sin aserciones

```sql
-- Incorrecto: no verifica nada
PROCEDURE test_process IS
BEGIN
    my_pkg.process(-1);
    -- Y que se verifica?
END;

-- Correcto: siempre verificar algo
PROCEDURE should_process_when_valid IS
    l_count NUMBER;
BEGIN
    -- Arrange
    INSERT INTO orders (order_id, status) VALUES (-1, 'NEW');

    -- Act
    my_pkg.process(p_order_id => -1);

    -- Assert
    SELECT COUNT(*) INTO l_count FROM processed_orders WHERE order_id = -1;
    ut.expect(l_count).to_equal(1);
END;
```

---

## Que NO Verificar en Tests

### Principio: Probar comportamiento, no implementacion

**NO verificar**:
- Llamadas a `DBMS_OUTPUT.PUT_LINE` (logging)
- Orden exacto de operaciones internas sin importancia de negocio
- Implementacion especifica de cursores (explicito vs implicito)
- Uso de estructuras internas (associative array vs nested table)
- Numero exacto de iteraciones en loops
- Procedimientos privados del paquete (body-only)
- Que se haya llamado a una funcion auxiliar interna

**SI verificar**:
- Resultado final de funciones
- Estado de la base de datos despues de operaciones DML
- Excepciones lanzadas por reglas de negocio (`RAISE_APPLICATION_ERROR`)
- Parametros OUT del procedimiento
- Cursores retornados (content y orden)
- Efectos secundarios esperados (registros de auditoria, notificaciones en tablas)

---

# Ejemplo Completo: Paquete con Logica de Negocio

```sql
-- Paquete bajo prueba
CREATE OR REPLACE PACKAGE invoice_pkg AS
    FUNCTION create_invoice(
        p_customer_id NUMBER,
        p_amount      NUMBER,
        p_type        VARCHAR2
    ) RETURN NUMBER; -- Returns invoice_id
END invoice_pkg;
/

CREATE OR REPLACE PACKAGE BODY invoice_pkg AS

    FUNCTION create_invoice(
        p_customer_id NUMBER,
        p_amount      NUMBER,
        p_type        VARCHAR2
    ) RETURN NUMBER IS
        l_tax          NUMBER;
        l_total        NUMBER;
        l_invoice_id   NUMBER;
        l_cust_type    VARCHAR2(10);
    BEGIN
        IF p_amount <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Amount must be positive');
        END IF;

        SELECT customer_type INTO l_cust_type
        FROM customers WHERE customer_id = p_customer_id;

        -- Tax calculation
        l_tax := CASE p_type
            WHEN 'VAT' THEN p_amount * 0.21
            WHEN 'REDUCED' THEN p_amount * 0.10
            ELSE 0
        END;

        l_total := p_amount + l_tax;

        -- VIP gets additional 5% discount on total
        IF l_cust_type = 'VIP' THEN
            l_total := l_total * 0.95;
        END IF;

        INSERT INTO invoices (customer_id, amount, tax, total, status, created_date)
        VALUES (p_customer_id, p_amount, l_tax, l_total, 'ISSUED', SYSDATE)
        RETURNING invoice_id INTO l_invoice_id;

        INSERT INTO invoice_audit (invoice_id, action, audit_date)
        VALUES (l_invoice_id, 'CREATED', SYSDATE);

        RETURN l_invoice_id;
    END;

END invoice_pkg;
/

-- Tests
CREATE OR REPLACE PACKAGE test_invoice_pkg AS

    --%suite(Invoice Package Tests)
    --%suitepath(business.invoicing)

    --%beforeeach
    PROCEDURE setup;

    --%aftereach
    PROCEDURE teardown;

    --%test(Should create invoice with VAT and audit record when data is valid)
    PROCEDURE should_create_with_vat;

    --%test(Should apply VIP discount on total when customer is VIP)
    PROCEDURE should_apply_vip_disc;

    --%test(Should calculate reduced tax when type is REDUCED)
    PROCEDURE should_calc_reduced_tax;

    --%test(Should raise error when amount is zero)
    --%throws(-20001)
    PROCEDURE should_raise_when_amt_zero;

    --%test(Should raise error when amount is negative)
    --%throws(-20001)
    PROCEDURE should_raise_when_amt_neg;

END test_invoice_pkg;
/

CREATE OR REPLACE PACKAGE BODY test_invoice_pkg AS

    PROCEDURE setup IS
    BEGIN
        SAVEPOINT test_start;

        INSERT INTO customers (customer_id, name, customer_type)
        VALUES (-1, 'Standard Customer', 'STANDARD');

        INSERT INTO customers (customer_id, name, customer_type)
        VALUES (-2, 'VIP Customer', 'VIP');
    END;

    PROCEDURE teardown IS
    BEGIN
        ROLLBACK TO test_start;
    END;

    PROCEDURE should_create_with_vat IS
        l_invoice_id  NUMBER;
        l_rec         invoices%ROWTYPE;
        l_audit_count NUMBER;
        l_base_amount NUMBER := 1000;
        l_expected_tax NUMBER := 210;    -- 21%
        l_expected_total NUMBER := 1210;
    BEGIN
        -- Act
        l_invoice_id := invoice_pkg.create_invoice(
            p_customer_id => -1,
            p_amount      => l_base_amount,
            p_type        => 'VAT'
        );

        -- Assert
        SELECT * INTO l_rec FROM invoices WHERE invoice_id = l_invoice_id;
        ut.expect(l_rec.amount).to_equal(l_base_amount);
        ut.expect(l_rec.tax).to_equal(l_expected_tax);
        ut.expect(l_rec.total).to_equal(l_expected_total);
        ut.expect(l_rec.status).to_equal('ISSUED');

        SELECT COUNT(*) INTO l_audit_count
        FROM invoice_audit
        WHERE invoice_id = l_invoice_id AND action = 'CREATED';
        ut.expect(l_audit_count).to_equal(1);
    END;

    PROCEDURE should_apply_vip_disc IS
        l_invoice_id     NUMBER;
        l_total          NUMBER;
        l_base_amount    NUMBER := 1000;
        l_expected_total NUMBER := 1149.5; -- (1000 + 210) * 0.95
    BEGIN
        -- Act
        l_invoice_id := invoice_pkg.create_invoice(
            p_customer_id => -2,  -- VIP customer
            p_amount      => l_base_amount,
            p_type        => 'VAT'
        );

        -- Assert
        SELECT total INTO l_total FROM invoices WHERE invoice_id = l_invoice_id;
        ut.expect(l_total).to_equal(l_expected_total);
    END;

    PROCEDURE should_calc_reduced_tax IS
        l_invoice_id   NUMBER;
        l_tax          NUMBER;
        l_base_amount  NUMBER := 1000;
        l_expected_tax NUMBER := 100; -- 10%
    BEGIN
        -- Act
        l_invoice_id := invoice_pkg.create_invoice(
            p_customer_id => -1,
            p_amount      => l_base_amount,
            p_type        => 'REDUCED'
        );

        -- Assert
        SELECT tax INTO l_tax FROM invoices WHERE invoice_id = l_invoice_id;
        ut.expect(l_tax).to_equal(l_expected_tax);
    END;

    PROCEDURE should_raise_when_amt_zero IS
    BEGIN
        -- Act (exception expected via --%throws annotation)
        invoice_pkg.create_invoice(
            p_customer_id => -1,
            p_amount      => 0,
            p_type        => 'VAT'
        );
    END;

    PROCEDURE should_raise_when_amt_neg IS
    BEGIN
        -- Act (exception expected via --%throws annotation)
        invoice_pkg.create_invoice(
            p_customer_id => -1,
            p_amount      => -100,
            p_type        => 'VAT'
        );
    END;

END test_invoice_pkg;
/
```

---

# Ejecucion y CI/CD

## Ejecutar Tests

```sql
-- Ejecutar todos los tests
EXEC ut.run();

-- Ejecutar un paquete especifico
EXEC ut.run('test_invoice_pkg');

-- Ejecutar por suitepath
EXEC ut.run(':business.invoicing');

-- Ejecutar con reporter JUnit (para CI/CD)
SELECT * FROM TABLE(ut.run('test_invoice_pkg', ut_junit_reporter()));

-- Ejecutar con cobertura
SELECT * FROM TABLE(
    ut.run(
        'test_invoice_pkg',
        ut_coverage_cobertura_reporter()
    )
);
```

## Linea de Comandos (utPLSQL-cli)

```bash
# Ejecutar tests con reporte JUnit
utplsql run app_test/password@host:1521/service \
    -f=ut_junit_reporter    -o=test-results.xml \
    -f=ut_coverage_cobertura_reporter -o=coverage.xml

# Ejecutar solo un suitepath
utplsql run app_test/password@host:1521/service \
    -p=business.invoicing \
    -f=ut_documentation_reporter
```

---

## Resumen de Mejores Practicas

### Hacer:
1. Seguir patron AAA estrictamente
2. Nombrar tests descriptivamente con patron `should_<action>_when_<condition>` en ingles
3. Usar savepoints para aislamiento transaccional
4. Probar casos felices, limites y excepciones
5. Verificar estado de la BD despues de operaciones DML
6. Maximo 5 tests por procedimiento/funcion
7. Insertar datos de test propios (nunca depender de datos preexistentes)
8. Usar IDs negativos o rangos reservados para datos de test
9. Multiples aserciones sobre el mismo resultado son validas
10. Usar `--%throws` para verificar excepciones por numero de error

### No Hacer:
1. Probar getters triviales (SELECT simple sin logica)
2. Probar procedimientos privados del body directamente
3. Usar `COMMIT` dentro de tests (contamina la BD)
4. Usar `DBMS_LOCK.SLEEP()` para esperar resultados
5. Tests que dependen del orden de ejecucion
6. Verificar implementacion interna (logs, variables de paquete, orden irrelevante)
7. Mezclar aserciones de operaciones independientes en un solo test
8. Tests sin aserciones
9. Probar delegacion pura sin logica
10. Depender de datos preexistentes en la base de datos
11. Probar triggers de auditoria triviales, sinonimos, o configuracion DDL
12. Probar wrappers de TAPI generados sin logica adicional
