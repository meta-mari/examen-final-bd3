# Guía de importación en ER/Studio 2003

## Archivo de entrada

Usar:

`03_crows_foot/02_ddl_importacion_erstudio_oracle.sql`

## Procedimiento

1. Abrir ER/Studio 2003 mediante Bottles.
2. Crear un modelo nuevo.
3. Seleccionar importación desde DDL o reverse engineering desde script SQL.
4. Elegir plataforma Oracle.
5. Importar el archivo `02_ddl_importacion_erstudio_oracle.sql`.
6. Verificar que se hayan creado las 15 tablas.
7. Verificar que las relaciones aparezcan en notación Crow's Foot.
8. Reacomodar manualmente el diagrama por módulos:
   - Registro y citas.
   - Odontograma y tratamientos.
   - Finanzas y pagos.
   - Compras e inventario.
9. Guardar el modelo como:

`03_crows_foot/modelo_logico_crows_foot_bd3.DM1`

10. Exportar la imagen como:

`03_crows_foot/modelo_logico_crows_foot_bd3.png`

11. Opcionalmente exportar PDF como:

`03_crows_foot/modelo_logico_crows_foot_bd3.pdf`

## Criterio de revisión

El modelo debe mostrar:

- Tablas con claves primarias.
- Claves foráneas.
- Relaciones padre-hija.
- Cardinalidad Crow's Foot.
- Obligatoriedad de relaciones.
- Separación visual por módulos.
