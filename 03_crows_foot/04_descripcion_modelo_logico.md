# Descripción del modelo lógico Crow's Foot

## Propósito

El modelo lógico Crow's Foot representa la transformación relacional del modelo conceptual Chen. Fue elaborado en ER/Studio 2003 a partir de un DDL simplificado compatible con Oracle 11g, tomando como base el esquema implementado posteriormente en Oracle Database 19c.

El objetivo del modelo lógico es mostrar tablas, claves primarias, claves foráneas, relaciones, cardinalidades y obligatoriedad de manera visual.

## Artefactos generados

- `modelo_logico_crows_foot_bd3.DM1`: archivo editable del modelo en ER/Studio.
- `modelo_logico_crows_foot_bd3.jpg`: imagen exportada o capturada del modelo lógico.
- `02_ddl_importacion_erstudio_oracle.sql`: DDL usado para importar las tablas y relaciones.

## Organización del modelo

El modelo se organiza en cuatro bloques principales:

1. **Registro y citas:** `PACIENTE`, `FOLDER`, `CITA`, `DOCTOR`, `ASISTENTE`.
2. **Odontograma y tratamientos:** `ODONTOGRAMA`, `DETALLE_ODONTOGRAMA`, `TRATAMIENTO`.
3. **Finanzas y pagos:** `PLAN_PAGO`, `PAGO`.
4. **Compras e inventario:** `PROVEEDOR`, `COMPRA`, `DETALLE_COMPRA`, `SUMINISTRO`, `ALMACEN_INVENTARIO`.

## Relaciones principales

El bloque clínico se centra en `PACIENTE`, que se relaciona con `CITA`, `ODONTOGRAMA` y `PLAN_PAGO`. La tabla `ODONTOGRAMA` se detalla mediante `DETALLE_ODONTOGRAMA`, donde se registra la pieza dental, cara, diagnóstico, estado y tratamiento asociado.

El bloque financiero separa el compromiso económico (`PLAN_PAGO`) de los pagos realizados (`PAGO`). Esto permite registrar múltiples pagos sobre un mismo plan.

El bloque de inventario separa compras (`COMPRA`), detalle de compras (`DETALLE_COMPRA`) y stock actual (`ALMACEN_INVENTARIO`). Esta separación permite mantener trazabilidad entre compras realizadas y existencias actuales.

## Diferencia frente al modelo físico Oracle 19c

El DDL usado para ER/Studio es una versión lógica simplificada. No incluye `GENERATED ALWAYS AS IDENTITY`, triggers, procedimientos ni vistas, porque ER/Studio 2003 se usa en este proyecto para representar el modelo lógico, no para ejecutar la base de datos final.

La implementación física completa se mantiene en `05_oracle_ddl/`.
