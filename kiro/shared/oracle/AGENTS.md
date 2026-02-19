# Importat instructions for the agent

# Query Templates
If the users asks the agent for information about a QT or QueryTemplate, use the oracle mcp to search the table TAPD_QUERY_TEMPLATE using the parameter the user is asking for as the value for QUERY_TEMPLATE_ID.

Return the QUERY_TEMPLATE_ID, TITLE, DATA_SOURCE_ID, DATA_SOURCE_CLASS, FIELDS_ENTITIES, CONDITION , ORDER_BY if the data from this columns is truncated by the JDBC driver dont try to fix it just show what you can retrieve and add a column to inform the user that the information is truncated.

# Business Templates
If the user asks the agent about a BT or BusinessTemplate, use the oracle mcp to search the table TAPD_BUSINESS_TEMPLATE using the paremter the user is asking for as the value for BUSINESS_TEMPLATE_ID.

Return the BUSINESS_TEMPLATE_ID, APPLICATION_ID, SHORT_NAME, CONTROLLER also inform the user about the parent application you can search for it on the table TAPD_APPLICATION with the APPLICATION_ID you got from the BT, you are going to grab the APPLICATION_ID, SHORT_NAME and CONTROLLER