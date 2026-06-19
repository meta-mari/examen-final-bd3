# Comparación directa entre MySQL/Laravel de la tesis y la transformación a Oracle 19c

## Propósito de la comparación

La presente comparación documenta las diferencias principales entre el enfoque de base de datos descrito en la tesis base y la transformación realizada en este proyecto hacia Oracle Database 19c.

La tesis base desarrolla un sistema de información web para el consultorio odontológico LALYSDENT, orientado a los procesos de registro, atención, inventario y finanzas. Su implementación se apoya en Laravel 11, Jetstream, Livewire, Tailwind CSS, JQuery y MySQL dentro de una arquitectura MVC.

En este proyecto, el foco no está en la aplicación web, sino en la base de datos como producto académico principal. Por ello, el diseño se implementa de forma explícita en Oracle Database 19c mediante scripts SQL y PL/SQL, ejecutados y validados desde DBeaver.

## Alcance de la comparación

La comparación se realiza a nivel conceptual, lógico y físico. No se dispone de un DDL MySQL original completo de la tesis; por tanto, la comparación no pretende afirmar equivalencias línea por línea entre sentencias MySQL y Oracle, sino explicar cómo las decisiones de persistencia descritas para el sistema web fueron transformadas hacia una implementación Oracle 19c verificable.

## Enfoque general

| Aspecto | Tesis con MySQL/Laravel | Proyecto transformado a Oracle 19c |
|---|---|---|
| Enfoque principal | Sistema web completo. | Base de datos documentada, implementada y validada. |
| Capa dominante | Aplicación Laravel bajo arquitectura MVC. | Esquema relacional Oracle con SQL y PL/SQL. |
| Motor de base de datos | MySQL como SGBD relacional para sistema web. | Oracle Database 19c en contenedor Docker. |
| Cliente de trabajo | Integrado al desarrollo web y al stack Laravel. | DBeaver conectado al schema `FARMACIAS_BD3`. |
| Documentación | Tesis orientada al desarrollo del sistema. | Informe técnico orientado al diseño, diccionario y validación de base de datos. |

## Comparación por arquitectura

En la tesis, Laravel se ubica como núcleo de desarrollo de la aplicación. La arquitectura MVC separa la lógica en modelos, vistas y controladores. En ese contexto, MySQL funciona como repositorio persistente para los datos administrados por la aplicación.

En la transformación a Oracle 19c, se reduce la dependencia de la capa de aplicación para documentar la lógica de datos. Las reglas principales se expresan directamente mediante:

- Claves primarias.
- Claves foráneas.
- Restricciones `UNIQUE`.
- Restricciones `CHECK`.
- Valores por defecto.
- Triggers.
- Procedimientos almacenados.
- Vistas de consulta.

Esto permite que la base de datos tenga una definición más autónoma, auditable y verificable desde el propio motor.

## Comparación por modelado de datos

| Elemento | Enfoque en MySQL/Laravel según la tesis | Transformación en Oracle 19c |
|---|---|---|
| Pacientes | Módulo funcional para registro de pacientes. | Tabla `PACIENTE` con identificación única, datos personales, antecedentes y relación con `FOLDER`. |
| Historias clínicas y odontograma | Módulos de atención clínica y odontograma. | Tablas `ODONTOGRAMA` y `DETALLE_ODONTOGRAMA`, separando cabecera clínica y detalle por pieza dental. |
| Tratamientos | Administración de tratamientos. | Tabla catálogo `TRATAMIENTO` con costo referencial y estado. |
| Citas | Gestión de citas odontológicas. | Tabla `CITA` relacionada con `PACIENTE`, `DOCTOR` y `ASISTENTE`, con control de estado mediante `CHECK`. |
| Pagos | Administración de pagos de pacientes. | Tablas `PLAN_PAGO` y `PAGO`, procedimiento `SP_REGISTRAR_PAGO` y trigger de control de saldo. |
| Inventario | Control de suministros e inventario odontológico. | Tablas `SUMINISTRO`, `COMPRA`, `DETALLE_COMPRA` y `ALMACEN_INVENTARIO`, con trigger de actualización automática de stock. |
| Reportes | Reportes consolidados en el sistema web. | Vista `VW_HISTORIAL_CLINICO` y consultas de validación desde Oracle. |

## Comparación de tipos de datos

| Necesidad de dato | MySQL/Laravel | Oracle 19c |
|---|---|---|
| Identificadores enteros | `INT`, `BIGINT`, `AUTO_INCREMENT` o equivalentes usados por el framework. | `NUMBER GENERATED ALWAYS AS IDENTITY`. |
| Texto corto | `VARCHAR`. | `VARCHAR2`. |
| Texto fijo | `CHAR`. | `CHAR`. |
| Fechas | `DATE`, `DATETIME`, `TIMESTAMP`. | `DATE` y `TIMESTAMP`. |
| Decimales monetarios | `DECIMAL(p,s)`. | `NUMBER(p,s)`. |
| Estado lógico | Entero, booleano o cadena según implementación. | `NUMBER(1)` o `VARCHAR2` con restricciones cuando corresponde. |
| Fecha actual por defecto | Funciones como `NOW()` o `CURRENT_TIMESTAMP`. | `SYSDATE` y `SYSTIMESTAMP`. |

## Comparación de claves e integridad

En MySQL, especialmente en sistemas Laravel, muchas reglas pueden definirse en la base de datos y también reforzarse desde la aplicación. La tesis se concentra en el sistema web, por lo que la documentación prioriza módulos, interfaces, historias de usuario y resultados funcionales.

En Oracle 19c, las reglas se hicieron explícitas en el modelo físico. Las relaciones principales se expresan con claves foráneas, por ejemplo:

- `PACIENTE` depende opcionalmente de `FOLDER`.
- `CITA` depende de `PACIENTE`, `DOCTOR` y opcionalmente `ASISTENTE`.
- `ODONTOGRAMA` depende de `PACIENTE` y `DOCTOR`.
- `DETALLE_ODONTOGRAMA` depende de `ODONTOGRAMA` y opcionalmente de `TRATAMIENTO`.
- `PLAN_PAGO` depende de `PACIENTE` y `ODONTOGRAMA`.
- `PAGO` depende de `PLAN_PAGO`.
- `COMPRA` depende de `PROVEEDOR`.
- `DETALLE_COMPRA` depende de `COMPRA` y `SUMINISTRO`.
- `ALMACEN_INVENTARIO` depende de `SUMINISTRO`.

Esta transformación fortalece el control de integridad directamente en el motor Oracle.

## Comparación de reglas de negocio

| Regla | Enfoque posible en MySQL/Laravel | Implementación Oracle 19c |
|---|---|---|
| Un paciente debe tener documento único. | Validación en aplicación y/o índice único. | Restricción `UNIQUE` sobre `PACIENTE.ci_dni`. |
| Una cita debe tener estado válido. | Validación desde formulario/controlador. | Restricción `CHECK` sobre `CITA.estado`. |
| Un pago no puede tener monto negativo o cero. | Validación desde aplicación. | Restricción `CHECK` y procedimiento `SP_REGISTRAR_PAGO`. |
| Un saldo no debe quedar negativo. | Validación desde controlador o servicio. | Trigger `TRG_AUDITAR_PLAN_PAGO`. |
| Una compra debe actualizar inventario. | Lógica desde aplicación. | Trigger `TRG_ACTUALIZAR_STOCK_COMPRA`. |
| El historial clínico debe poder consultarse integrado. | Consulta desde modelos/controladores. | Vista `VW_HISTORIAL_CLINICO`. |

## Comparación sobre procedimientos y triggers

La tesis base se orienta a un sistema web construido con Laravel. En ese enfoque, parte importante de la lógica suele implementarse en la aplicación. La transformación a Oracle 19c traslada reglas críticas hacia el motor de base de datos.

Los triggers y procedimientos implementados cumplen una finalidad académica y técnica:

- `TRG_ACTUALIZAR_STOCK_COMPRA` automatiza la actualización del inventario cuando se registra un detalle de compra.
- `TRG_AUDITAR_PLAN_PAGO` impide saldos negativos y cambia el estado del plan cuando el saldo llega a cero.
- `SP_REGISTRAR_PAGO` encapsula la transacción de pago, validando monto, saldo e inserción del pago.

Esta decisión reduce la posibilidad de inconsistencias cuando los datos se manipulan desde herramientas distintas al frontend.

## Comparación sobre seguridad y esquema

| Aspecto | MySQL/Laravel | Oracle 19c |
|---|---|---|
| Separación lógica | Base de datos usada por la aplicación. | Usuario/schema `FARMACIAS_BD3`. |
| Autenticación | Usuario de conexión configurado en el entorno Laravel. | Usuario Oracle con permisos específicos. |
| Permisos | Dependen del usuario MySQL configurado. | `CREATE SESSION`, `CREATE TABLE`, `CREATE VIEW`, `CREATE PROCEDURE`, `CREATE TRIGGER`, `CREATE SEQUENCE`. |
| Aislamiento | Base de datos o schema según configuración MySQL. | En Oracle, el usuario y el schema coinciden conceptualmente. |

## Comparación sobre ejecución y evidencias

En la tesis, la evidencia se concentra en interfaces, sprints, diagramas y evaluación del sistema. En este proyecto, la evidencia se concentra en la ejecución de scripts y validaciones de base de datos:

- Creación del usuario/schema.
- Creación de tablas.
- Creación de vista, triggers y procedimiento.
- Carga de datos de prueba.
- Validación de inventario.
- Validación de plan de pago.
- Prueba del procedimiento de pago.
- Extracción técnica del diccionario desde Oracle.

## Diferencias principales

1. La tesis documenta un sistema web completo; el presente proyecto documenta la base de datos como eje principal.
2. MySQL aparece como motor de persistencia dentro del stack Laravel; Oracle 19c se usa como motor central de modelado, reglas e integridad.
3. La lógica en la tesis se apoya en la arquitectura MVC; la transformación refuerza reglas dentro del motor mediante SQL y PL/SQL.
4. La documentación de la tesis es funcional y metodológica; la documentación del proyecto es técnica, relacional y verificable.
5. La implementación Oracle permite evidenciar el diccionario de datos directamente desde vistas del catálogo del sistema.

## Conclusión comparativa

La transformación desde el enfoque MySQL/Laravel descrito en la tesis hacia Oracle 19c no se limita a cambiar nombres de tipos de datos. Implica trasladar una parte importante del control de integridad hacia el motor de base de datos, formalizar las relaciones mediante claves foráneas, documentar las columnas en un diccionario completo y validar el comportamiento mediante scripts reproducibles.

Mientras que MySQL en la tesis cumple el rol de almacenamiento relacional para una aplicación web Laravel, Oracle 19c en este proyecto cumple un rol más académico y estructural: demostrar diseño físico, restricciones, automatización, validación y trazabilidad documental de la base de datos.
