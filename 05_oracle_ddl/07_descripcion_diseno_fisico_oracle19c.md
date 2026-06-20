# Diseño físico en Oracle Database 19c

## Propósito

El diseño físico corresponde a la implementación real del modelo relacional en Oracle Database 19c. A diferencia del modelo lógico Crow's Foot, que se utiliza para representar tablas y relaciones, el diseño físico incorpora detalles propios del motor Oracle, como tipos de datos, generación automática de identificadores, restricciones, vistas, triggers y procedimientos almacenados.

La implementación fue ejecutada en un contenedor Docker con Oracle Database 19c y validada mediante DBeaver, conectándose al schema `FARMACIAS_BD3`.

## Schema de trabajo

En Oracle, el concepto de schema está asociado al usuario propietario de los objetos. Por ello, se creó el usuario:

`FARMACIAS_BD3`

Este usuario funciona como schema de la base de datos del proyecto y contiene las tablas, vista, triggers y procedimiento almacenado.

## Scripts físicos principales

| Script | Propósito |
|---|---|
| `00_admin_crear_schema.sql` | Crea el usuario/schema `FARMACIAS_BD3` y asigna permisos. |
| `00_completo_farmacia.sql` | Script completo consolidado del proyecto. |
| `01_limpieza_esquema.sql` | Elimina objetos previos para permitir reejecución. |
| `02_tablas.sql` | Crea tablas, claves primarias, claves foráneas, restricciones únicas y restricciones check. |
| `03_vistas.sql` | Crea la vista `VW_HISTORIAL_CLINICO`. |
| `04_triggers.sql` | Crea triggers para stock e integridad de pagos. |
| `05_procedimientos.sql` | Define el procedimiento formal Oracle. |
| `05_procedimientos_dbeaver.sql` | Variante compatible con DBeaver mediante `EXECUTE IMMEDIATE`. |
| `06_datos_prueba.sql` | Inserta datos de prueba para validación funcional. |
| `99_ejecutar_todo.sql` | Script maestro para herramientas que soportan `@@`. |

## Tablas implementadas

El esquema físico contiene 15 tablas:

1. `ASISTENTE`
2. `FOLDER`
3. `TRATAMIENTO`
4. `DOCTOR`
5. `PROVEEDOR`
6. `SUMINISTRO`
7. `PACIENTE`
8. `CITA`
9. `ODONTOGRAMA`
10. `DETALLE_ODONTOGRAMA`
11. `PLAN_PAGO`
12. `PAGO`
13. `COMPRA`
14. `DETALLE_COMPRA`
15. `ALMACEN_INVENTARIO`

## Tipos de datos usados

| Necesidad | Tipo Oracle usado | Justificación |
|---|---|---|
| Identificadores | `NUMBER GENERATED ALWAYS AS IDENTITY` | Permite generación automática de claves primarias. |
| Texto variable | `VARCHAR2(n)` | Tipo recomendado en Oracle para cadenas variables. |
| Texto fijo | `CHAR(1)` | Usado para valores cortos de longitud fija, como sexo. |
| Fechas | `DATE` | Adecuado para fechas sin necesidad de fracción de segundo. |
| Fecha y hora | `TIMESTAMP` | Adecuado para citas, pagos y actualización de inventario. |
| Montos | `NUMBER(10,2)` | Controla valores monetarios con dos decimales. |
| Cantidades | `NUMBER(8,2)` | Permite cantidades enteras o fraccionarias de suministros. |
| Estados numéricos | `NUMBER(1)` | Control lógico simple para registros activos/inactivos. |

## Claves primarias

Todas las tablas poseen clave primaria técnica generada mediante columnas `id_*`. Esta decisión permite simplificar las relaciones y mantener independencia frente a posibles cambios en datos naturales como documentos, correos o códigos internos.

Ejemplos:

- `PACIENTE.id_paciente`
- `CITA.id_cita`
- `ODONTOGRAMA.id_odontograma`
- `PLAN_PAGO.id_plan_pago`
- `PAGO.id_pago`
- `COMPRA.id_compra`

## Restricciones únicas

Se definieron restricciones únicas para evitar duplicidad en datos naturalmente identificables:

| Tabla | Columna | Propósito |
|---|---|---|
| `ASISTENTE` | `ci_dni` | Evita duplicar asistentes. |
| `DOCTOR` | `ci_dni` | Evita duplicar doctores. |
| `DOCTOR` | `correo` | Evita duplicar correos profesionales. |
| `PACIENTE` | `ci_dni` | Evita duplicar pacientes. |
| `FOLDER` | `codigo_archivo` | Evita duplicar archivadores. |
| `PROVEEDOR` | `nit_ruc` | Evita duplicar proveedores tributarios. |
| `SUMINISTRO` | `codigo_barras` | Evita duplicar suministros por código. |
| `ALMACEN_INVENTARIO` | `id_suministro` | Garantiza un solo inventario por suministro. |

## Integridad referencial

Las relaciones se implementaron mediante claves foráneas explícitas. Algunas relaciones aceptan nulos para representar participación opcional, por ejemplo:

- `PACIENTE.id_folder`
- `CITA.id_asistente`
- `PAGO.id_asistente`
- `COMPRA.id_asistente`
- `DETALLE_ODONTOGRAMA.id_tratamiento`

También se definieron acciones referenciales específicas:

| Relación | Acción |
|---|---|
| `PACIENTE` → `FOLDER` | `ON DELETE SET NULL` |
| `DETALLE_ODONTOGRAMA` → `ODONTOGRAMA` | `ON DELETE CASCADE` |
| `DETALLE_COMPRA` → `COMPRA` | `ON DELETE CASCADE` |

## Restricciones CHECK

Se implementaron restricciones de dominio para controlar valores válidos:

### Estado de cita

La tabla `CITA` restringe el estado a:

- `Pendiente`
- `Confirmada`
- `Atendida`
- `Cancelada`
- `Reprogramada`

### Monto de pago

La tabla `PAGO` exige que `monto_abonado > 0`.

## Vista implementada

### `VW_HISTORIAL_CLINICO`

Integra información de:

- Paciente.
- Doctor tratante.
- Odontograma.
- Detalle odontológico.
- Tratamiento aplicado.

Su objetivo es facilitar consultas clínicas sin repetir manualmente un conjunto amplio de joins.

## Triggers implementados

### `TRG_ACTUALIZAR_STOCK_COMPRA`

Se ejecuta después de insertar un detalle de compra. Su función es actualizar el stock del suministro en `ALMACEN_INVENTARIO`. Si el suministro aún no tiene registro de inventario, el trigger lo crea automáticamente.

### `TRG_AUDITAR_PLAN_PAGO`

Se ejecuta antes de actualizar el saldo pendiente de un plan de pago. Su función es impedir que el saldo quede negativo y cambiar el estado del plan a `Pagado` cuando el saldo llega a cero.

## Procedimiento almacenado

### `SP_REGISTRAR_PAGO`

Encapsula la lógica de registro de pagos:

1. Busca el saldo pendiente del plan.
2. Valida que el monto sea mayor a cero.
3. Valida que el monto no exceda el saldo pendiente.
4. Inserta el pago en `PAGO`.
5. Actualiza el saldo en `PLAN_PAGO`.

Este procedimiento evita que la lógica crítica de pagos dependa únicamente de la aplicación cliente.

## Compatibilidad con DBeaver

Durante la ejecución en DBeaver se detectaron dos particularidades:

1. DBeaver puede interpretar `:NEW` en triggers como parámetro bind si se ejecuta incorrectamente.
2. DBeaver puede dividir mal un `CREATE PROCEDURE` cuando se ejecuta como sentencias separadas por `;`.

Por esta razón se mantuvo el script formal Oracle y se agregó una variante compatible con DBeaver:

`05_procedimientos_dbeaver.sql`

Esta variante usa `EXECUTE IMMEDIATE` para enviar el procedimiento completo al motor Oracle como una sola unidad.

## Diferencia entre DDL lógico y DDL físico

El archivo usado para ER/Studio es un DDL lógico simplificado. No incluye elementos físicos avanzados como identity, triggers, procedimientos o vistas, porque su finalidad es construir el modelo Crow's Foot.

El DDL físico real se encuentra en `05_oracle_ddl/` y es el que se ejecuta contra Oracle Database 19c.
