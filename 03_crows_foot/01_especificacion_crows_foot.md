# Especificación del modelo lógico Crow's Foot

## Propósito

El modelo lógico Crow's Foot se construirá en ER/Studio 2003 a partir del esquema relacional implementado en Oracle 19c. El objetivo es representar tablas, claves primarias, claves foráneas, obligatoriedad, cardinalidades y relaciones identificativas o no identificativas.

## Tablas del modelo

El modelo lógico debe incluir las siguientes tablas:

1. ASISTENTE.
2. FOLDER.
3. TRATAMIENTO.
4. DOCTOR.
5. PROVEEDOR.
6. SUMINISTRO.
7. PACIENTE.
8. CITA.
9. ODONTOGRAMA.
10. DETALLE_ODONTOGRAMA.
11. PLAN_PAGO.
12. PAGO.
13. COMPRA.
14. DETALLE_COMPRA.
15. ALMACEN_INVENTARIO.

## Clasificación de tablas

| Tipo | Tablas |
|---|---|
| Catálogos o referencia | DOCTOR, ASISTENTE, TRATAMIENTO, PROVEEDOR, SUMINISTRO, FOLDER |
| Operativas clínicas | PACIENTE, CITA, ODONTOGRAMA, DETALLE_ODONTOGRAMA |
| Operativas financieras | PLAN_PAGO, PAGO |
| Operativas de inventario | COMPRA, DETALLE_COMPRA, ALMACEN_INVENTARIO |

## Relaciones para ER/Studio

| Relación | Tabla padre | Tabla hija | Obligatoriedad en hija | Acción |
|---|---|---|---|---|
| FK_PACIENTE_FOLDER | FOLDER | PACIENTE | Opcional | ON DELETE SET NULL |
| FK_CITA_PACIENTE | PACIENTE | CITA | Obligatoria | Restrictiva |
| FK_CITA_DOCTOR | DOCTOR | CITA | Obligatoria | Restrictiva |
| FK_CITA_ASISTENTE | ASISTENTE | CITA | Opcional | Restrictiva |
| FK_ODONTO_PACIENTE | PACIENTE | ODONTOGRAMA | Obligatoria | Restrictiva |
| FK_ODONTO_DOCTOR | DOCTOR | ODONTOGRAMA | Obligatoria | Restrictiva |
| FK_DET_ODONTOGRAMA | ODONTOGRAMA | DETALLE_ODONTOGRAMA | Obligatoria | ON DELETE CASCADE |
| FK_DET_TRATAMIENTO | TRATAMIENTO | DETALLE_ODONTOGRAMA | Opcional | Restrictiva |
| FK_PLAN_PACIENTE | PACIENTE | PLAN_PAGO | Obligatoria | Restrictiva |
| FK_PLAN_ODONTO | ODONTOGRAMA | PLAN_PAGO | Obligatoria | Restrictiva |
| FK_PAGO_PLAN | PLAN_PAGO | PAGO | Obligatoria | Restrictiva |
| FK_PAGO_ASISTENTE | ASISTENTE | PAGO | Opcional | Restrictiva |
| FK_COMPRA_PROVEEDOR | PROVEEDOR | COMPRA | Obligatoria | Restrictiva |
| FK_COMPRA_ASISTENTE | ASISTENTE | COMPRA | Opcional | Restrictiva |
| FK_DETCOMPRA_COMPRA | COMPRA | DETALLE_COMPRA | Obligatoria | ON DELETE CASCADE |
| FK_DETCOMPRA_SUMINISTRO | SUMINISTRO | DETALLE_COMPRA | Obligatoria | Restrictiva |
| FK_INVENTARIO_SUMINISTRO | SUMINISTRO | ALMACEN_INVENTARIO | Obligatoria | Restrictiva |

## Criterio visual recomendado

Para mejorar la lectura del diagrama:

- Ubicar `PACIENTE` al centro del bloque clínico.
- Ubicar `DOCTOR`, `ASISTENTE`, `FOLDER` y `TRATAMIENTO` como tablas de soporte alrededor del bloque clínico.
- Ubicar `PLAN_PAGO` y `PAGO` debajo de `PACIENTE` y `ODONTOGRAMA`.
- Ubicar `PROVEEDOR`, `COMPRA`, `DETALLE_COMPRA`, `SUMINISTRO` y `ALMACEN_INVENTARIO` en un bloque lateral de inventario.
- Evitar cruces de líneas innecesarios.
- Mostrar nombres de claves primarias y foráneas.
- Mostrar obligatoriedad con notación Crow's Foot.

## Archivos esperados

- `03_crows_foot/modelo_logico_crows_foot_bd3.DM1`
- `03_crows_foot/modelo_logico_crows_foot_bd3.png`
