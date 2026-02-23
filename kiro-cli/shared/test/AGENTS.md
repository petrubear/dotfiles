# Configuracion y Reglas Fundamentales para Pruebas Unitarias Java

## Configuracion del Proyecto

### Framework de Pruebas

- El agente debe detectar automaticamente la version de JUnit configurada en el `pom.xml` o `build.gradle`
- Usar **JUnit 4** si encuentra `junit:junit:4.x` en las dependencias
- Usar **JUnit 5** si encuentra `org.junit.jupiter:junit-jupiter:5.x`
- Si no se detecta ninguna version de JUnit, usar **JUnit 5** como predeterminado y advertir al usuario
- Ejecutar pruebas en modo quiet (`-q`) para reducir ruido en la salida de Maven/Gradle
- Usar **Mockito** para crear mocks de dependencias
- Para metodos estaticos con side-effects externos, usar `mockStatic()` de Mockito (requiere `mockito-inline` o Mockito 5+)

### Regla de Idioma en Codigo

**Todo el codigo generado por el agente debe usar identificadores en ingles**: nombres de clases, nombres de metodos de test, variables, constantes y parametros. Los comentarios estructurales dentro del codigo generado (`// Arrange`, `// Act`, `// Assert`, `// Happy path`, etc.) tambien deben estar en ingles. Las explicaciones y reglas del presente documento estan en espanol; los comentarios pedagogicos dentro de los ejemplos de este documento pueden estar en espanol para facilitar la comprension de las reglas, pero el agente no debe reproducirlos en el codigo que genere.

---

## REGLA FUNDAMENTAL DE DECISION

### PROBAR SI Y SOLO SI el metodo contiene

1. **Operadores logicos**: `if`, `for`, `while`, `switch`, `? :`
2. **Calculos matematicos**: `+`, `-`, `*`, `/`, `%`, comparaciones numericas
3. **Multiples llamadas a metodos CON transformacion** entre ellas
4. **Reglas de negocio** que pueden ser validadas o rechazadas
5. **Coordinacion de interacciones** entre 2 o mas dependencias
6. **Validaciones combinadas** (multiples condiciones con logica)

### NO PROBAR SI el metodo

1. **Solo llama a UN metodo** de dependencia sin transformar el resultado (delegacion pura)
2. Es **getter/setter** sin validacion
3. Es **constructor** sin logica (solo asignaciones `this.field = field`)
4. **Solo valida nulidad** y lanza excepcion, sin ninguna otra logica. **Excepcion**: si la validacion de nulidad es parte de un metodo que SI tiene logica de negocio adicional, incluir un test de excepcion por nulidad como parte del set de tests de ese metodo
5. Es metodo **generado** (Lombok, IDE, `toString`, `equals`, `hashCode`)
6. Solo **agrega/remueve** elementos de colecciones sin logica de negocio
7. Es **delegacion pura** a otro metodo sin transformacion
8. Es metodo **`main()`**, **`@PostConstruct`**, **`@PreDestroy`**, **`@Scheduled`** u otros lifecycle hooks del framework
9. Es **configuracion de Spring** (`@Value`, `@ConfigurationProperties`, `@Bean` sin logica)
10. Es **interfaz**, **clase abstracta sin implementacion**, o **anotacion**
11. Es **`@EventListener`** que solo delega a otro servicio sin logica propia
12. Es **builder generado** por Lombok (`@Builder`) u otras herramientas de generacion de codigo

---

## CHECKLIST DE DECISION RAPIDA

Antes de generar una prueba para un metodo, el agente debe responder estas preguntas:

- [ ] Tiene el metodo `if`/`for`/`while`/`switch`/calculos?
- [ ] Transforma datos (no solo los pasa a otra dependencia)?
- [ ] Hay reglas de negocio explicitas?
- [ ] Se coordinan multiples dependencias?
- [ ] El metodo puede lanzar excepciones de negocio?

**Si la respuesta es NO a TODAS las preguntas anteriores, NO generar prueba para ese metodo.** El agente debe omitir silenciosamente estos metodos; no es necesario agregar comentarios ni logs sobre metodos excluidos.

**Regla de desempate**: si el agente no esta seguro de si un metodo califica para prueba, debe generar la prueba. Es preferible una prueba que resulte marginalmente util a omitir un metodo con logica de negocio real.

Si al menos una respuesta es SI:

- [ ] Identificar version de JUnit en el proyecto (4 o 5)
- [ ] Crear maximo 5 tests por metodo
- [ ] Usar nomenclatura `should<Action>When<Condition>`
- [ ] Aplicar patron AAA estrictamente
- [ ] Mockear todas las dependencias externas
- [ ] Usar `ArgumentCaptor` solo para verificar objetos construidos o transformados internamente por el metodo bajo prueba
- [ ] Probar casos de excepcion con tipo y mensaje especificos
- [ ] Verificar con `verify()` las interacciones con dependencias externas (repositorios, publishers, APIs externas), NO con helpers internos ni loggers
- [ ] NO verificar implementacion interna (logs, orden irrelevante, estructuras internas)

---

## MOCKS: Que y Cuando Mockear

### SIEMPRE mockear

- **Repositorios** anotados con `@Repository`
- **Servicios externos** (HTTP clients, REST clients, SOAP clients)
- **Sistemas de mensajeria** (Kafka producers, RabbitMQ publishers)
- **Cache** (Redis, Ehcache, Caffeine)
- **Utilidades del framework** (`ServiceLocator`, `PropertiesManager`)
- **Beans inyectados** por OSGI o Spring (`@Autowired`, `@Inject`)
- **Publicadores de eventos** (event publishers, domain events)
- **Productores de auditoria** (audit loggers)
- **Metodos estaticos con side-effects externos** (BD, filesystem, HTTP) — usar `mockStatic()`

### NUNCA mockear

- **DTOs, POJOs, Entities** sin dependencias
- **Objetos de dominio** sin dependencias externas
- **Value Objects** inmutables
- **Objetos creados con `new`** dentro del test
- **Clases de utilidad** sin estado (pure functions)
- **Enums** y constantes

---

## Nomenclatura de Pruebas

### Patron Obligatorio

```
should<Action>When<Condition>()
```

### Ejemplos Correctos

```java
shouldCalculateDiscountWhenCustomerIsVIP()
shouldThrowExceptionWhenAmountIsNegative()
shouldReturnEmptyListWhenNoResultsExist()
shouldUpdateStatusWhenPaymentIsSuccessful()
shouldRejectOrderWhenStockIsInsufficient()
```

### Ejemplos Incorrectos

```java
testCalculateDiscount()               // No usa patron should...When
calculateDiscountVIP()                 // No inicia con "should"
shouldCalculateDiscount()              // Falta condicion "When"
deberiaCalcularDescuento()             // Nombres de metodos deben ser en ingles
```

---

## Estructura de Prueba Obligatoria

### Patron AAA (Arrange - Act - Assert)

Toda prueba debe seguir estrictamente este patron:

```java
@Test
public void should<Action>When<Condition>() {
    // Arrange: Preparar datos y configurar mocks
    InputType input = new InputType(data);
    when(mockDependency.method(any())).thenReturn(expectedValue);

    // Act: Ejecutar el metodo bajo prueba
    OutputType result = service.execute(input);

    // Assert: Verificar resultado e interacciones
    assertEquals(expectedValue, result.getField());
    verify(mockDependency).method(any());
}
```

**Nota sobre `verifyNoMoreInteractions`**: NO incluirlo de forma predeterminada. Solo usarlo cuando sea critico garantizar que NO se realizaron interacciones adicionales (por ejemplo, que no se envio un email duplicado o que no se realizo un cobro extra). Usarlo por defecto genera tests fragiles.

---

## Limites y Cobertura

### Objetivo: Cubrir todas las ramas de decision visibles

El agente debe generar tests que cubran todas las ramas de decision (branches) visibles en el codigo fuente: cada bloque `if`/`else`, cada caso de `switch`, y los escenarios de error de negocio.

**NO INCLUIR en la cobertura**:
- Getters/setters
- Constructores triviales
- Metodos generados (`toString`, `equals`, `hashCode`)
- Delegacion pura sin transformacion
- Configuracion de framework

### Maximo de Tests por Metodo

**Limite: 5 tests por metodo**

Distribucion recomendada:
1. **1 test**: Caso feliz (happy path)
2. **2 tests**: Casos limite (edge cases)
   - Valores en los limites (0, null, vacio, maximo)
   - Condiciones de frontera
3. **2 tests**: Excepciones
   - Validaciones de negocio rechazadas
   - Errores de dependencias externas

**Cuando un metodo tiene mas de 5 ramas de decision**, priorizar en este orden:
1. Happy path
2. Branch con mayor impacto de negocio
3. Excepciones de negocio
4. Omitir branches puramente defensivos o de infraestructura

### Ejemplo de Cobertura Completa

```java
// Metodo con logica compleja
public BigDecimal calculateDiscount(Customer customer, BigDecimal amount) {
    if (customer == null) {
        throw new IllegalArgumentException("Customer cannot be null");
    }
    if (amount.compareTo(BigDecimal.ZERO) <= 0) {
        throw new IllegalArgumentException("Amount must be positive");
    }

    if (customer.getType() == CustomerType.VIP) {
        return amount.multiply(new BigDecimal("0.15"));
    }
    if (amount.compareTo(new BigDecimal("1000")) > 0) {
        return amount.multiply(new BigDecimal("0.05"));
    }
    return BigDecimal.ZERO;
}

// Tests (5 maximo)
@Test
public void shouldCalculate15PercentDiscountWhenCustomerIsVIP() {
    // Happy path
}

@Test
public void shouldCalculate5PercentDiscountWhenAmountExceedsOneThousand() {
    // Edge case 1
}

@Test
public void shouldReturnZeroWhenAmountIsUnderOneThousand() {
    // Edge case 2
}

@Test
public void shouldThrowExceptionWhenCustomerIsNull() {
    // Exception 1
}

@Test
public void shouldThrowExceptionWhenAmountIsNegative() {
    // Exception 2
}
```

---

# Casos Especiales - Guia de Decision Detallada

## PROBAR - Validaciones Combinadas

```java
// Multiples condiciones con logica de negocio
public boolean isEligible(Customer customer) {
    return customer != null &&
           customer.getAge() >= 18 &&
           customer.getBalance().compareTo(BigDecimal.ZERO) > 0;
}

// Validacion con transformacion
public void validateOrder(Order order) {
    if (order.getItems().isEmpty()) {
        throw new InvalidOrderException("Order has no items");
    }
    if (order.getTotal().compareTo(MINIMUM_AMOUNT) < 0) {
        throw new InvalidOrderException("Insufficient amount");
    }
}
```

## NO PROBAR - Validaciones Triviales

```java
// Solo validacion de nulidad — metodo cuya UNICA logica es un null-check
public void validate(String input) {
    if (input == null) throw new IllegalArgumentException();
}

// Setter con validacion trivial
public void setName(String name) {
    if (name == null) throw new IllegalArgumentException("Name is required");
    this.name = name;
}
```

## PROBAR - Delegacion con Logica Condicional

```java
// Delegacion con logica condicional — SI tiene branch
public Product getProduct(String code) {
    Product product = repository.findByCode(code);
    if (product == null) {
        return createDefaultProduct(code);
    }
    return product;
}

// Coordinacion de multiples dependencias con transformacion
public OrderSummary processAndNotify(Long orderId) {
    Order order = orderRepository.findById(orderId);
    BigDecimal tax = taxCalculator.calculate(order.getTotal());
    order.setTax(tax);
    order.setGrandTotal(order.getTotal().add(tax));
    orderRepository.save(order);
    notificationService.sendConfirmation(order);
    return mapper.toSummary(order);
}
```

## PROBAR - Metodos con Optional

Los repositorios de Spring frecuentemente retornan `Optional<T>`. Si el metodo bajo prueba tiene logica condicional basada en `Optional.empty()` vs `Optional.of(value)`, se debe probar:

```java
public Customer getOrFail(Long id) {
    return repository.findById(id)
        .orElseThrow(() -> new CustomerNotFoundException("Customer not found: " + id));
}

// Test - rama con valor presente
@Test
void shouldReturnCustomerWhenFound() {
    // Arrange
    Customer expected = new Customer(1L, "John");
    when(repository.findById(1L)).thenReturn(Optional.of(expected));

    // Act
    Customer result = service.getOrFail(1L);

    // Assert
    assertEquals(expected, result);
}

// Test - rama con Optional vacio
@Test
void shouldThrowExceptionWhenCustomerNotFound() {
    // Arrange
    when(repository.findById(99L)).thenReturn(Optional.empty());

    // Act & Assert
    assertThrows(CustomerNotFoundException.class, () -> service.getOrFail(99L));
}
```

**NO PROBAR** si el metodo solo retorna el `Optional` sin desenvolverlo ni aplicar logica:

```java
// Delegacion pura — NO probar
public Optional<Customer> find(Long id) {
    return repository.findById(id);
}
```

## NO PROBAR - Delegacion Pura

**Aclaracion sobre "transformacion"**: si la logica de transformacion reside enteramente dentro del metodo llamado (mapper, calculator), y el metodo bajo prueba simplemente encadena llamadas sin logica condicional ni computacional propia, sigue siendo delegacion pura. La prueba debe ir en el test del mapper/calculator, no aqui.

```java
// Solo llama a un metodo sin transformacion
public Customer find(Long id) {
    return repository.findById(id);
}

// Delegacion directa
public List<Order> listAll() {
    return repository.findAll();
}

// Delegacion secuencial sin logica — NO probar aunque sean 2 llamadas,
// porque no hay ninguna decision ni transformacion propia del metodo
public CustomerDTO findAndConvert(Long id) {
    Customer customer = repository.findById(id);
    return mapper.toDTO(customer);
}
```

## PROBAR - Metodos Void con Side-Effects

```java
// Coordina multiples interacciones
public void processPayment(Payment payment) {
    validatePayment(payment);
    payment.markAsProcessed();
    repository.save(payment);
    eventPublisher.publish(new PaymentEvent(payment));
}

// Test correspondiente
@Test
public void shouldProcessPaymentAndPublishEventWhenPaymentIsValid() {
    // Arrange
    Payment payment = new Payment(new BigDecimal("100"));

    // Act
    service.processPayment(payment);

    // Assert
    assertEquals(PaymentStatus.PROCESSED, payment.getStatus());
    verify(repository).save(payment);
    ArgumentCaptor<PaymentEvent> captor = ArgumentCaptor.forClass(PaymentEvent.class);
    verify(eventPublisher).publish(captor.capture());
    assertEquals(new BigDecimal("100"), captor.getValue().getAmount());
}
```

## PROBAR - Transformaciones Complejas

```java
// Conversion con logica (operador ternario, formateo, escalado)
public Map<String, Object> toSQL() {
    Map<String, Object> params = new HashMap<>();
    params.put("id", this.id);
    params.put("status", this.active ? "A" : "I");
    params.put("created_at", formatDate(this.createdAt));
    params.put("amount", this.amount.setScale(2, RoundingMode.HALF_UP));
    return params;
}

// Comparacion con logica compleja
@Override
public int compareTo(Order other) {
    if (this.priority != other.priority) {
        return Integer.compare(other.priority, this.priority); // descending
    }
    return this.createdAt.compareTo(other.createdAt); // ascending
}
```

## NO PROBAR - Transformaciones Triviales

```java
// Solo copia de campos — sin ninguna logica
public DTO toDTO() {
    DTO dto = new DTO();
    dto.setId(this.id);
    dto.setName(this.name);
    return dto;
}

// toString simple
@Override
public String toString() {
    return "Customer[id=" + id + ", name=" + name + "]";
}
```

---

## Escenarios Obligatorios a Cubrir

Para cada metodo con logica de negocio, cubrir:

1. **Caso feliz (happy path)**: Entrada valida, resultado esperado
2. **Valores limite**:
   - `null`, vacio, 0, negativo
   - Valores maximos/minimos
   - Colecciones vacias vs con elementos
3. **Excepciones esperadas**:
   - Validaciones de negocio rechazadas
   - Fallos de dependencias
4. **Condiciones de frontera**:
   - Primer/ultimo elemento
   - Transiciones de estado
   - Valores justo en el limite de condiciones

---

# Plantillas por Version de JUnit

## JUnit 4 - Plantilla Base

```java
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.InjectMocks;
import org.mockito.junit.MockitoJUnitRunner;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class ServiceTest {

    @Mock
    private Dependency mockDependency;

    @InjectMocks
    private Service service;

    @Before
    public void setUp() {
        // Inicializacion adicional si es necesaria
    }

    @Test
    public void shouldReturnResultWhenInputIsValid() {
        // Arrange
        Input input = new Input("value");
        when(mockDependency.process(input)).thenReturn("result");

        // Act
        String result = service.execute(input);

        // Assert
        assertEquals("result", result);
        verify(mockDependency).process(input);
    }

    @Test(expected = IllegalArgumentException.class)
    public void shouldThrowExceptionWhenInputIsNull() {
        // Act
        service.execute(null);
    }
}
```

## JUnit 5 - Plantilla Base

```java
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ServiceTest {

    @Mock
    private Dependency mockDependency;

    @InjectMocks
    private Service service;

    @BeforeEach
    void setUp() {
        // Inicializacion adicional si es necesaria
    }

    @Test
    void shouldReturnResultWhenInputIsValid() {
        // Arrange
        Input input = new Input("value");
        when(mockDependency.process(input)).thenReturn("result");

        // Act
        String result = service.execute(input);

        // Assert
        assertEquals("result", result);
        verify(mockDependency).process(input);
    }

    @Test
    void shouldThrowExceptionWhenInputIsNull() {
        // Assert
        assertThrows(IllegalArgumentException.class, () -> {
            // Act
            service.execute(null);
        });
    }
}
```

## Convenciones de Ubicacion de Archivos de Test

- La clase de test debe ubicarse en el mismo paquete que la clase bajo prueba, pero bajo `src/test/java` en lugar de `src/main/java`
- Nombre de la clase de test: `<ClaseBajoPrueba>Test` (ejemplo: `OrderService` -> `OrderServiceTest`)
- Un archivo de test por clase bajo prueba

## Tests Parametrizados (opcional, para metodos con muchas combinaciones de datos)

Cuando un metodo tiene multiples combinaciones de entrada/salida que siguen el mismo patron, usar `@ParameterizedTest` (JUnit 5) o `@Parameterized` (JUnit 4) para cubrir mas escenarios dentro del limite de 5 tests:

### JUnit 5
```java
@ParameterizedTest
@CsvSource({
    "1000, true, 150.00",   // VIP customer
    "6000, false, 600.00",  // High amount
    "2000, false, 100.00",  // Medium amount
    "500, false, 0"          // No discount
})
void shouldCalculateCorrectDiscountWhenGivenVariousInputs(
        String amount, boolean isVIP, String expectedDiscount) {
    // Arrange
    Customer customer = new Customer();
    customer.setVIP(isVIP);
    Order order = new Order(new BigDecimal(amount));

    // Act
    BigDecimal discount = calculator.calculateDiscount(order, customer);

    // Assert
    assertEquals(0, new BigDecimal(expectedDiscount).compareTo(discount));
}
```

**Nota**: los tests parametrizados son un complemento, no un reemplazo. El agente puede usar tests individuales o parametrizados segun lo que produzca tests mas claros y mantenibles.

## Uso de @Spy (Mocking Parcial)

Usar `@Spy` unicamente cuando un metodo publico del servicio bajo prueba llama a otro metodo publico de la misma clase y se necesita aislar el metodo bajo prueba.

### JUnit 5
```java
@Spy
@InjectMocks
private OrderService service;

@Test
void shouldProcessOrderWhenValidationPasses() {
    // Arrange
    Order order = new Order(new BigDecimal("100"));
    doNothing().when(service).validateOrder(order); // mock parcial del mismo servicio

    // Act
    service.processOrder(order);

    // Assert
    verify(repository).save(order);
}
```

**Evitar `@Spy` cuando sea posible** — si se necesita frecuentemente, es senal de que la clase tiene demasiadas responsabilidades y deberia refactorizarse. Preferir siempre `@Mock` + `@InjectMocks`.

---

# Manejo de Excepciones

## Principios para Pruebas de Excepciones

1. **Toda regla de negocio que lanza excepcion DEBE tener test**
2. **Verificar tipo especifico** de excepcion, no solo `Exception`
3. **Validar mensaje** si contiene informacion relevante de negocio
4. **NO probar el mecanismo de transacciones de Spring** — solo verificar el flujo de ejecucion del metodo

## JUnit 4 - Pruebas de Excepciones

### Forma 1: Anotacion (solo para verificar tipo)
```java
@Test(expected = InvalidOrderException.class)
public void shouldThrowExceptionWhenOrderHasNoItems() {
    Order order = new Order(Collections.emptyList());
    service.validateOrder(order);
}
```

### Forma 2: Try-catch (para verificar mensaje y causa)
```java
@Test
public void shouldThrowExceptionWithMessageWhenAmountIsNegative() {
    Order order = new Order(new BigDecimal("-100"));

    try {
        service.processOrder(order);
        fail("Should have thrown InvalidOrderException");
    } catch (InvalidOrderException e) {
        assertEquals("Amount cannot be negative", e.getMessage());
        assertTrue(e.getCause() instanceof ValidationException);
    }
}
```

## JUnit 5 - Pruebas de Excepciones

### Forma recomendada: assertThrows
```java
@Test
void shouldThrowExceptionWhenOrderHasNoItems() {
    Order order = new Order(Collections.emptyList());

    InvalidOrderException exception = assertThrows(
        InvalidOrderException.class,
        () -> service.validateOrder(order)
    );

    assertEquals("Order must have at least one item", exception.getMessage());
}
```

### Verificar causa raiz
```java
@Test
void shouldThrowExceptionWithCauseWhenRepositoryFails() {
    when(repository.save(any())).thenThrow(new DataRetrievalFailureException("DB error"));

    Order order = new Order(new BigDecimal("100"));

    PersistenceException exception = assertThrows(
        PersistenceException.class,
        () -> service.processOrder(order)
    );

    assertInstanceOf(DataRetrievalFailureException.class, exception.getCause());
    assertEquals("DB error", exception.getCause().getMessage());
}
```

## Pruebas de Interrupcion de Flujo por Excepcion

Estas pruebas verifican que cuando ocurre una excepcion en medio de un flujo, las operaciones posteriores NO se ejecutan. **No se esta probando el mecanismo de rollback de Spring/JPA**, sino el flujo de ejecucion del propio metodo.

Dado un flujo: `validate -> markAsProcessed -> save -> publish`, si `save` falla, `publish` no debe ejecutarse:

```java
@Test
public void shouldNotPublishEventWhenSaveFails() {
    // Arrange
    Payment payment = new Payment(new BigDecimal("100"));
    doThrow(new PersistenceException("DB error")).when(repository).save(any());

    // Act & Assert
    assertThrows(PersistenceException.class, () -> service.processPayment(payment));

    // Verificar que NO se ejecutaron operaciones posteriores al fallo de save
    verify(eventPublisher, never()).publish(any());
}
```

## Excepciones Encadenadas

### JUnit 4
```java
@Test
public void shouldThrowExceptionWithCauseWhenRepositoryFails() {
    // Arrange
    when(repository.save(any())).thenThrow(new SQLException("Connection timeout"));
    Order order = new Order(new BigDecimal("100"));

    try {
        // Act
        service.processOrder(order);
        fail("Should have thrown PersistenceException");
    } catch (PersistenceException e) {
        // Assert
        assertNotNull(e.getCause());
        assertTrue(e.getCause() instanceof SQLException);
        assertEquals("Connection timeout", e.getCause().getMessage());
    }
}
```

### JUnit 5
```java
@Test
void shouldThrowPersistenceExceptionWithSQLCauseWhenRepositoryFails() {
    // Arrange
    when(repository.save(any())).thenThrow(new SQLException("Connection timeout"));
    Order order = new Order(new BigDecimal("100"));

    // Act & Assert
    PersistenceException exception = assertThrows(
        PersistenceException.class,
        () -> service.processOrder(order)
    );

    assertNotNull(exception.getCause());
    assertInstanceOf(SQLException.class, exception.getCause());
    assertEquals("Connection timeout", exception.getCause().getMessage());
}
```

---

# ArgumentCaptor y Metodos Transaccionales

## Uso de ArgumentCaptor

### Cuando usar ArgumentCaptor:

**Usar cuando necesites verificar**:
- **Objetos complejos** (objetos con 2+ campos construidos o transformados internamente por el metodo bajo prueba) pasados a mocks
- **Multiples campos** del argumento
- **Transformaciones aplicadas** antes de pasar el argumento
- **Estado interno** del objeto capturado

### Ejemplos de Uso Correcto

```java
@Test
public void shouldSaveCustomerWithTransformedDataWhenDtoIsProvided() {
    // Arrange
    CustomerDTO dto = new CustomerDTO("john doe", "12345678");

    // Act
    service.create(dto);

    // Assert
    ArgumentCaptor<Customer> captor = ArgumentCaptor.forClass(Customer.class);
    verify(repository).save(captor.capture());

    Customer savedCustomer = captor.getValue();
    assertEquals("JOHN DOE", savedCustomer.getName()); // transformed to uppercase
    assertEquals("12345678", savedCustomer.getDocument());
    assertEquals(CustomerStatus.ACTIVE, savedCustomer.getStatus());
}

@Test
public void shouldPublishEventWithCorrectDataWhenOrderIsProcessed() {
    // Arrange
    Order order = new Order(new BigDecimal("250"));

    // Act
    service.processOrder(order);

    // Assert
    ArgumentCaptor<OrderEvent> captor = ArgumentCaptor.forClass(OrderEvent.class);
    verify(eventPublisher).publish(captor.capture());

    OrderEvent event = captor.getValue();
    assertEquals("PROCESSED", event.getStatus());
    assertEquals(new BigDecimal("250"), event.getAmount());
    assertNotNull(event.getProcessedAt());
}
```

### NO usar ArgumentCaptor cuando verify directo es suficiente

```java
// Incorrecto: sobreingenieria
ArgumentCaptor<Long> captor = ArgumentCaptor.forClass(Long.class);
verify(repository).findById(captor.capture());
assertEquals(Long.valueOf(123), captor.getValue());

// Correcto: verify directo es mas simple
verify(repository).findById(123L);
```

## Metodos con @Transactional

### Principios:
1. **NO anotar la clase o metodo de prueba** con `@Transactional`
2. **Mockear todos los repositorios** y dependencias
3. **Verificar que se llamen los metodos correctos** en el orden esperado
4. **Probar interrupcion de flujo** simulando excepciones
5. **NO intentar probar el mecanismo de transacciones** de Spring — eso es responsabilidad del framework

### Ejemplo Completo

```java
// Clase bajo prueba
@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final InventoryRepository inventoryRepository;
    private final EventPublisher eventPublisher;

    @Transactional
    public void processOrder(Order order) {
        validateOrder(order);
        order.markAsProcessed();
        orderRepository.save(order);
        inventoryRepository.deductStock(order.getItems());
        eventPublisher.publish(new OrderEvent(order));
    }
}

// Test — SIN @Transactional
@RunWith(MockitoJUnitRunner.class)
public class OrderServiceTest {

    @Mock
    private OrderRepository orderRepository;

    @Mock
    private InventoryRepository inventoryRepository;

    @Mock
    private EventPublisher eventPublisher;

    @InjectMocks
    private OrderService service;

    @Test
    public void shouldProcessOrderAndUpdateInventoryWhenOrderIsValid() {
        // Arrange
        Order order = new Order(Arrays.asList(
            new Item("PROD-1", 2),
            new Item("PROD-2", 1)
        ));

        // Act
        service.processOrder(order);

        // Assert — Verificar orden de operaciones
        InOrder inOrder = inOrder(orderRepository, inventoryRepository, eventPublisher);
        inOrder.verify(orderRepository).save(order);
        inOrder.verify(inventoryRepository).deductStock(order.getItems());
        inOrder.verify(eventPublisher).publish(any(OrderEvent.class));

        assertEquals(OrderStatus.PROCESSED, order.getStatus());
    }

    @Test
    public void shouldNotPublishEventWhenStockDeductionFails() {
        // Arrange
        Order order = new Order(Arrays.asList(new Item("PROD-1", 100)));
        doThrow(new InsufficientStockException("Out of stock"))
            .when(inventoryRepository).deductStock(any());

        // Act & Assert
        assertThrows(InsufficientStockException.class, () ->
            service.processOrder(order)
        );

        // Verificar que NO se publico evento (flujo interrumpido)
        verify(eventPublisher, never()).publish(any());
    }
}
```

### Verificar Orden de Operaciones

```java
@Test
public void shouldExecuteOperationsInCorrectOrderWhenInvoiceIsProcessed() {
    // Arrange
    Invoice invoice = new Invoice(new BigDecimal("1000"));

    // Act
    service.processInvoice(invoice);

    // Assert — Verificar orden estricto
    InOrder inOrder = inOrder(repository, emailService, auditService);
    inOrder.verify(repository).save(invoice);
    inOrder.verify(emailService).sendNotification(invoice);
    inOrder.verify(auditService).log("INVOICE_PROCESSED", invoice.getId());
}
```

---

# Anti-Patrones Prohibidos

## Anti-Patrones que NO se Deben Implementar

### 1. Probar metodos privados directamente

```java
// Incorrecto
@Test
public void testPrivateMethod() throws Exception {
    Method method = Service.class.getDeclaredMethod("privateMethod", String.class);
    method.setAccessible(true);
    String result = (String) method.invoke(service, "input");
    assertEquals("expected", result);
}

// Correcto: Probar a traves del metodo publico
@Test
public void shouldExecuteFlowWhenPublicMethodIsInvoked() {
    // El metodo publico llama internamente al privado
    service.publicMethod("input");

    // Verificar el resultado observable
    verify(mock).operation();
}
```

### 2. Tests que requieren BD real

```java
// Incorrecto
@Test
public void testSave() {
    Customer customer = new Customer("John");
    repository.save(customer); // Acceso a BD real

    Customer saved = repository.findById(customer.getId());
    assertNotNull(saved);
}

// Correcto: Mock del repository
@Test
public void shouldSaveCustomerWhenDataIsValid() {
    // Arrange
    Customer customer = new Customer("John");
    when(repository.save(customer)).thenReturn(customer);

    // Act
    service.create(customer);

    // Assert
    verify(repository).save(customer);
}
```

### 3. Tests con sleeps/waits

```java
// Incorrecto
@Test
public void testProcessing() throws InterruptedException {
    service.startProcess();
    Thread.sleep(5000); // NO hacer esto
    assertTrue(service.isCompleted());
}

// Correcto: Mock o simulacion del tiempo
@Test
public void shouldCompleteProcessWhenTimeElapses() {
    // Arrange
    when(clock.now()).thenReturn(INITIAL_TIME, FINAL_TIME);

    // Act
    service.startProcess();

    // Assert
    assertTrue(service.isCompleted());
}
```

### 4. Tests que dependen del orden de ejecucion

```java
// Incorrecto
static int counter = 0;

@Test
public void test1() {
    counter = 1;
}

@Test
public void test2() {
    assertEquals(1, counter); // Falla si test1 no se ejecuto antes
}

// Correcto: Tests independientes
@Test
public void shouldReturnOneWhenCounterIsInitialized() {
    int counter = service.initialize();
    assertEquals(1, counter);
}

@Test
public void shouldReturnIncrementedValueWhenCounterIsIncremented() {
    service.initialize();
    int result = service.increment();
    assertEquals(1, result);
}
```

### 5. Multiples asserts de operaciones independientes

```java
// Incorrecto: mezcla verificaciones de comportamientos distintos
@Test
public void testService() {
    assertEquals("A", service.method1());
    assertEquals("B", service.method2());
    assertEquals("C", service.method3());
}

// Correcto: Dividir en tests separados
@Test
public void shouldReturnAWhenMethod1IsInvoked() {
    assertEquals("A", service.method1());
}

@Test
public void shouldReturnBWhenMethod2IsInvoked() {
    assertEquals("B", service.method2());
}
```

**NOTA IMPORTANTE**: Multiples asserts sobre el MISMO resultado de una unica operacion son validos y esperados. El anti-patron se refiere a mezclar verificaciones de operaciones o comportamientos independientes en un solo test. Ejemplo valido:

```java
@Test
public void shouldCreateInvoiceWithCalculatedTaxWhenDataIsValid() {
    // Act
    Invoice result = service.create(dto);

    // Assert — todos validan el mismo resultado
    assertEquals(new BigDecimal("100"), result.getAmount());
    assertEquals(expectedTax, result.getTax());
    assertEquals(new BigDecimal("121"), result.getTotal());
    assertEquals(InvoiceStatus.ISSUED, result.getStatus());
}
```

### 6. Verificar implementacion interna

```java
// Incorrecto: verificar detalles de implementacion
@Test
public void testProcess() {
    service.process(data);

    verify(cache).get("key");
    verify(cache).put("key", value);
    verify(logger).info(anyString());
    verify(validator).validate(data);
}

// Correcto: Verificar comportamiento observable
@Test
public void shouldProcessDataWhenNotInCache() {
    // Arrange
    when(cache.get("key")).thenReturn(null);

    // Act
    Result result = service.process(data);

    // Assert
    assertEquals(expectedValue, result);
    verify(repository).find(data); // Solo verificar interaccion clave
}
```

### 7. Hardcodear valores magicos

```java
// Incorrecto
@Test
public void testCalculate() {
    assertEquals(150, service.calculate(100)); // Por que 150?
}

// Correcto: Usar variables con nombres significativos
@Test
public void shouldCalculateTotalWithTaxWhenAmountIsValid() {
    // Arrange
    BigDecimal baseAmount = new BigDecimal("100");
    BigDecimal taxRate = new BigDecimal("0.50"); // 50%
    BigDecimal expectedTotal = new BigDecimal("150");

    // Act
    BigDecimal result = service.calculate(baseAmount);

    // Assert
    assertEquals(expectedTotal, result);
}
```

### 8. Tests sin asserts

```java
// Incorrecto: No verifica nada
@Test
public void testProcess() {
    service.process(data);
    // Y que se verifica?
}

// Correcto: Siempre verificar algo
@Test
public void shouldProcessDataWhenValid() {
    // Act
    service.process(data);

    // Assert
    verify(repository).save(any());
}
```

---

## Que NO Verificar en Tests

### Principio: Probar comportamiento, no implementacion

**NO verificar**:
- Llamadas a loggers (`info`, `debug`, `trace`)
- Orden exacto de operaciones internas sin importancia de negocio
- Implementacion especifica de algoritmos
- Uso de estructuras de datos internas (`HashMap` vs `TreeMap`)
- Numero exacto de iteraciones en loops
- Llamadas a metodos privados

**SI verificar**:
- Resultado final del metodo
- Excepciones lanzadas por reglas de negocio
- Interacciones con dependencias externas (repositorios, APIs)
- Estado observable del objeto despues de la operacion
- Efectos secundarios esperados (eventos publicados, auditoria)

---

# Ejemplo Completo 1: Servicio con Logica de Negocio (JUnit 4)

```java
// Clase bajo prueba
@Service
public class InvoiceService {

    private final InvoiceRepository repository;
    private final TaxCalculator calculator;
    private final EventPublisher eventPublisher;

    public Invoice create(InvoiceDTO dto) {
        validateDTO(dto);

        BigDecimal tax = calculator.calculate(dto.getAmount(), dto.getType());
        BigDecimal total = dto.getAmount().add(tax);

        Invoice invoice = new Invoice();
        invoice.setAmount(dto.getAmount());
        invoice.setTax(tax);
        invoice.setTotal(total);
        invoice.setStatus(InvoiceStatus.ISSUED);

        Invoice saved = repository.save(invoice);
        eventPublisher.publish(new InvoiceIssuedEvent(saved.getId()));

        return saved;
    }

    private void validateDTO(InvoiceDTO dto) {
        if (dto.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new InvalidInvoiceException("Amount must be positive");
        }
    }
}

// Tests (JUnit 4)
@RunWith(MockitoJUnitRunner.class)
public class InvoiceServiceTest {

    @Mock
    private InvoiceRepository repository;

    @Mock
    private TaxCalculator calculator;

    @Mock
    private EventPublisher eventPublisher;

    @InjectMocks
    private InvoiceService service;

    @Test
    public void shouldCreateInvoiceWithCalculatedTaxWhenDataIsValid() {
        // Arrange
        InvoiceDTO dto = new InvoiceDTO(new BigDecimal("100"), TaxType.VAT);
        BigDecimal expectedTax = new BigDecimal("21");

        when(calculator.calculate(dto.getAmount(), dto.getType()))
            .thenReturn(expectedTax);
        when(repository.save(any(Invoice.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        Invoice result = service.create(dto);

        // Assert
        assertEquals(new BigDecimal("100"), result.getAmount());
        assertEquals(expectedTax, result.getTax());
        assertEquals(new BigDecimal("121"), result.getTotal());
        assertEquals(InvoiceStatus.ISSUED, result.getStatus());

        verify(repository).save(any(Invoice.class));
        verify(eventPublisher).publish(any(InvoiceIssuedEvent.class));
    }

    @Test
    public void shouldPublishEventWithCorrectIdWhenInvoiceIsSaved() {
        // Arrange
        InvoiceDTO dto = new InvoiceDTO(new BigDecimal("100"), TaxType.VAT);
        when(calculator.calculate(any(), any())).thenReturn(new BigDecimal("21"));

        Invoice savedInvoice = new Invoice();
        savedInvoice.setId(123L);
        when(repository.save(any())).thenReturn(savedInvoice);

        // Act
        service.create(dto);

        // Assert
        ArgumentCaptor<InvoiceIssuedEvent> captor =
            ArgumentCaptor.forClass(InvoiceIssuedEvent.class);
        verify(eventPublisher).publish(captor.capture());
        assertEquals(Long.valueOf(123), captor.getValue().getInvoiceId());
    }

    @Test(expected = InvalidInvoiceException.class)
    public void shouldThrowExceptionWhenAmountIsZero() {
        // Arrange
        InvoiceDTO dto = new InvoiceDTO(BigDecimal.ZERO, TaxType.VAT);

        // Act
        service.create(dto);
    }

    @Test(expected = InvalidInvoiceException.class)
    public void shouldThrowExceptionWhenAmountIsNegative() {
        // Arrange
        InvoiceDTO dto = new InvoiceDTO(new BigDecimal("-100"), TaxType.VAT);

        // Act
        service.create(dto);
    }

    @Test
    public void shouldCalculateTotalCorrectlyWhenTaxIs15Percent() {
        // Arrange
        InvoiceDTO dto = new InvoiceDTO(new BigDecimal("200"), TaxType.REDUCED);
        when(calculator.calculate(any(), any())).thenReturn(new BigDecimal("30"));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        // Act
        Invoice result = service.create(dto);

        // Assert
        assertEquals(new BigDecimal("230"), result.getTotal());
    }
}
```

---

# Ejemplo Completo 2: Metodo con Logica Compleja (JUnit 5)

```java
// Clase bajo prueba
public class DiscountCalculator {

    public BigDecimal calculateDiscount(Order order, Customer customer) {
        if (order == null || customer == null) {
            throw new IllegalArgumentException("Order and customer are required");
        }

        BigDecimal amount = order.getTotal();

        // VIP discount: 15%
        if (customer.isVIP()) {
            return amount.multiply(new BigDecimal("0.15"));
        }

        // High amount discount: 10%
        if (amount.compareTo(new BigDecimal("5000")) > 0) {
            return amount.multiply(new BigDecimal("0.10"));
        }

        // Medium amount discount: 5%
        if (amount.compareTo(new BigDecimal("1000")) > 0) {
            return amount.multiply(new BigDecimal("0.05"));
        }

        // No discount
        return BigDecimal.ZERO;
    }
}

// Tests (JUnit 5)
@ExtendWith(MockitoExtension.class)
class DiscountCalculatorTest {

    private DiscountCalculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new DiscountCalculator();
    }

    @Test
    void shouldCalculate15PercentDiscountWhenCustomerIsVIP() {
        // Arrange
        Customer customer = new Customer();
        customer.setVIP(true);
        Order order = new Order(new BigDecimal("1000"));
        BigDecimal expectedDiscount = new BigDecimal("150.00");

        // Act
        BigDecimal discount = calculator.calculateDiscount(order, customer);

        // Assert
        assertEquals(0, expectedDiscount.compareTo(discount));
    }

    @Test
    void shouldCalculate10PercentDiscountWhenAmountExceedsFiveThousand() {
        // Arrange
        Customer customer = new Customer();
        customer.setVIP(false);
        Order order = new Order(new BigDecimal("6000"));
        BigDecimal expectedDiscount = new BigDecimal("600.00");

        // Act
        BigDecimal discount = calculator.calculateDiscount(order, customer);

        // Assert
        assertEquals(0, expectedDiscount.compareTo(discount));
    }

    @Test
    void shouldCalculate5PercentDiscountWhenAmountExceedsOneThousand() {
        // Arrange
        Customer customer = new Customer();
        customer.setVIP(false);
        Order order = new Order(new BigDecimal("2000"));
        BigDecimal expectedDiscount = new BigDecimal("100.00");

        // Act
        BigDecimal discount = calculator.calculateDiscount(order, customer);

        // Assert
        assertEquals(0, expectedDiscount.compareTo(discount));
    }

    @Test
    void shouldReturnZeroWhenAmountIsUnderOneThousand() {
        // Arrange
        Customer customer = new Customer();
        customer.setVIP(false);
        Order order = new Order(new BigDecimal("500"));

        // Act
        BigDecimal discount = calculator.calculateDiscount(order, customer);

        // Assert
        assertEquals(0, BigDecimal.ZERO.compareTo(discount));
    }

    @Test
    void shouldThrowExceptionWhenOrderIsNull() {
        // Arrange
        Customer customer = new Customer();

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->
            calculator.calculateDiscount(null, customer)
        );
    }
}
```

---

## Resumen de Mejores Practicas

### Hacer:
1. Seguir patron AAA estrictamente
2. Nombrar tests descriptivamente con patron `should...When...` en ingles
3. Mockear todas las dependencias externas
4. Probar casos felices, limites y excepciones
5. Verificar interacciones clave con mocks
6. Maximo 5 tests por metodo cuando sea necesario, mantener las minimas pruebas necesarias para cubrir la logica importante del negocio.
7. Usar ArgumentCaptor solo para objetos complejos
8. Detectar automaticamente version de JUnit del proyecto
9. Multiples asserts sobre el mismo resultado son validos

### No Hacer:
1. Probar getters/setters triviales
2. Probar metodos privados directamente
3. Usar bases de datos reales
4. Usar `Thread.sleep()`
5. Tests que dependen del orden
6. Verificar implementacion interna (logs, orden irrelevante, estructuras internas)
7. Mezclar asserts de operaciones independientes en un solo test
8. Tests sin asserts
9. Probar delegacion pura sin logica (incluyendo delegacion secuencial sin decisiones)
10. Probar configuracion de framework (`@Value`, `@Bean`, `@PostConstruct`, `@Scheduled`, lifecycle hooks)
11. Probar interfaces, clases abstractas sin implementacion, anotaciones o builders generados
12. Usar `verifyNoMoreInteractions` de forma predeterminada
13. Probar `@EventListener` que solo delega sin logica propia
