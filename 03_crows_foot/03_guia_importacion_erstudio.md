# Guía de importación en ER/Studio 2003

## Archivo de entrada

Usar:

`03_crows_foot/02_ddl_importacion_erstudio_oracle.sql`

## Configuración usada

- Plataforma destino: Oracle 11g.
- Modelo físico: Relational.
- Layout inicial: Orthogonal.
- Infer Primary Keys: desmarcado.
- Infer Foreign Keys from Indexes: desmarcado.
- Infer Foreign Keys from Names: desmarcado.
- Infer Domains: desmarcado.
- Use Physical Viewer Parser Option: marcado.

Se eligió Oracle 11g porque es la plataforma Oracle más reciente disponible en ER/Studio 2003. El archivo de importación usa tipos y restricciones compatibles con Oracle 11g y Oracle 19c.

## Procedimiento

1. Abrir ER/Studio 2003 mediante Bottles.
2. Crear un modelo nuevo o importar desde DDL.
3. Seleccionar plataforma Oracle 11g.
4. Importar el archivo `02_ddl_importacion_erstudio_oracle.sql`.
5. Verificar que se hayan creado las 15 tablas.
6. Verificar que las relaciones aparezcan en notación Crow's Foot.
7. Reacomodar manualmente el diagrama por módulos:
   - Registro y citas.
   - Odontograma y tratamientos.
   - Finanzas y pagos.
   - Compras e inventario.
8. Guardar el modelo como:

`03_crows_foot/modelo_logico_crows_foot_bd3.DM1`

9. Exportar o capturar la vista del modelo lógico como:

`03_crows_foot/modelo_logico_crows_foot_bd3.jpg`

## Criterio de revisión

El modelo debe mostrar:

- Tablas con claves primarias.
- Claves foráneas.
- Relaciones padre-hija.
- Cardinalidad Crow's Foot.
- Obligatoriedad de relaciones.
- Separación visual por módulos.
