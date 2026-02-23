# Oracle Agent Instructions

## Default Schema

The default schema for all database objects is `EEFISA_PREPROD` unless the user specifies a different one. If an object is not found there, check the `EAPPFISA_PREPROD`  

## Query Templates (QT)

When the user asks about a QT or QueryTemplate:

1. Query `TAPD_QUERY_TEMPLATE` using the user's parameter as `QUERY_TEMPLATE_ID`.
2. Return these columns: `QUERY_TEMPLATE_ID`, `TITLE`, `DATA_SOURCE_ID`, `DATA_SOURCE_CLASS`, `FIELDS_ENTITIES`, `CONDITION`, `ORDER_BY`.
3. If any column value is truncated by the JDBC driver, don't attempt to reconstruct it. Show what you retrieved and add a note indicating the data is truncated.
4. For deeper detail, check related tables: `TAPD_QT_PARAMETER`, `TAPD_QT_FILTER`, `TAPD_QT_FIELD`, `TAPD_QT_ACTION`.
5. Any table matching `TAPD%QT%` may be related. Ignore tables ending in `_HIS`.

## Business Templates (BT)

When the user asks about a BT or BusinessTemplate:

1. Query `TAPD_BUSINESS_TEMPLATE` using the user's parameter as `BUSINESS_TEMPLATE_ID`.
2. Return: `BUSINESS_TEMPLATE_ID`, `APPLICATION_ID`, `SHORT_NAME`, `CONTROLLER`.
3. Also look up the parent application in `TAPD_APPLICATION` using the `APPLICATION_ID` from the BT. Return: `APPLICATION_ID`, `SHORT_NAME`, `CONTROLLER`.
4. For deeper detail, check related tables: `TAPD_BT_FIELD`, `TAPD_VISUAL_BT_FIELD`, `TAPD_VISUAL_BT_FIELD_QT`, `TAPD_BT_GROUP`.
5. Any table matching `TAPD%BT%` may be related. Ignore tables ending in `_HIS`.
6. If the `TYPE` column on `TAPD_BUSINESS_TEMPLATE` is `3` or `4` tell the user that this is a Custom BT and provide the value of the `URL` column. 

## Sequences

When the user asks about a sequence, these are not Oracle database sequences unless explicitly stated. Look them up in the `TGEN_SEQUENCE` table instead.

## Response Guidelines

- Format query results as readable tables when possible.
- When data is truncated, clearly mark which columns are affected.
- If a query returns no results, confirm the identifier and schema with the user before trying alternatives.
- When showing related data from multiple tables, explain the relationship between them.