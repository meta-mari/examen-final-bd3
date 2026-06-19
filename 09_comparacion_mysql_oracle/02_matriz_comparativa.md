# Matriz comparativa MySQL/Laravel vs Oracle 19c

| Criterio | MySQL/Laravel documentado en la tesis | Oracle 19c implementado en el proyecto |
|---|---|---|
| Objetivo | Persistencia de datos para un sistema web odontológico. | Diseño, implementación y validación formal de la base de datos. |
| Arquitectura | MVC con Laravel. | Modelo relacional físico con SQL y PL/SQL. |
| Motor | MySQL. | Oracle Database 19c. |
| Entorno | Aplicación web Laravel. | Docker, DBeaver y schema Oracle. |
| Identificadores | Enteros autoincrementales o equivalentes. | `NUMBER GENERATED ALWAYS AS IDENTITY`. |
| Texto | `VARCHAR`. | `VARCHAR2`. |
| Fechas | `DATE`, `DATETIME`, `TIMESTAMP`. | `DATE`, `TIMESTAMP`, `SYSDATE`, `SYSTIMESTAMP`. |
| Montos | `DECIMAL`. | `NUMBER(10,2)`. |
| Integridad referencial | Relacional, con apoyo de aplicación. | Claves foráneas explícitas en el motor. |
| Validación de estados | Validación desde aplicación o base de datos. | `CHECK` en estados de cita y montos. |
| Pagos | Módulo funcional de pagos. | `PLAN_PAGO`, `PAGO`, trigger y procedimiento almacenado. |
| Inventario | Módulo funcional de inventario. | `SUMINISTRO`, `COMPRA`, `DETALLE_COMPRA`, `ALMACEN_INVENTARIO` y trigger de stock. |
| Historial clínico | Consultado desde la aplicación. | Vista `VW_HISTORIAL_CLINICO`. |
| Automatización | Principalmente desde lógica de aplicación. | Triggers y procedimiento PL/SQL. |
| Evidencia | Interfaces, sprints y resultados del sistema. | Scripts, consultas, capturas y validaciones del catálogo Oracle. |
| Documentación técnica | Integrada dentro de una tesis de sistema web. | Diccionario de datos completo y comparación técnica directa. |
