# Resumen de validaciones realizadas

## Propósito

Este documento resume las validaciones ejecutadas sobre el schema `FARMACIAS_BD3` en Oracle Database 19c.

## Validaciones de estructura

Se ejecutó el archivo:

`10_validaciones/01_validacion_estructura.sql`

Este script valida:

- Tablas creadas.
- Objetos por tipo.
- Restricciones por tabla.
- Claves foráneas.
- Estado de vista, triggers y procedimiento.

## Validaciones de datos de prueba

Se ejecutó el archivo:

`10_validaciones/02_validacion_datos_prueba.sql`

Este script valida:

- Cantidad de registros por tabla.
- Funcionamiento del trigger de inventario.
- Consulta de la vista `VW_HISTORIAL_CLINICO`.
- Estado de planes de pago.

## Validación del procedimiento de pago

Se ejecutó el archivo:

`10_validaciones/03_prueba_procedimiento_pago.sql`

La prueba valida que el procedimiento `SP_REGISTRAR_PAGO` registre un pago de 80 unidades monetarias y actualice el saldo pendiente de 180 a 100.

## Validación del diccionario técnico

Se ejecutó el archivo:

`10_validaciones/04_diccionario_tecnico_oracle.sql`

Este script extrae desde Oracle:

- Columnas.
- Tipos de datos.
- Nulabilidad.
- Valores por defecto.
- Restricciones.
- Relaciones de claves foráneas.
- Estado de objetos programables.

## Evidencias disponibles

Las evidencias se dividen en dos tipos:

### Capturas

Se encuentran en:

`06_evidencias/`

Incluyen evidencia de:

- Estado inicial del repositorio.
- Creación del schema.
- Creación de tablas.
- Validación de vista, triggers y procedimiento.
- Carga de datos de prueba.
- Prueba del procedimiento de pago.
- Diccionario técnico Oracle.

### Artefactos

Incluyen archivos generados durante el desarrollo:

- Modelo conceptual Chen en `.drawio`, `.png` y `.pdf`.
- Modelo lógico Crow's Foot en `.DM1` y `.jpg`.
- Scripts SQL y PL/SQL.
- Diccionario de datos.
- Comparación MySQL/Laravel vs Oracle 19c.
