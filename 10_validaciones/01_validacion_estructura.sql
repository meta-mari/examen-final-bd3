-- ========================================================================
-- 01_validacion_estructura.sql
-- Validación de objetos creados en Oracle Database 19c
-- Proyecto: Examen Final BD3 - Farmacias
-- ========================================================================

-- 1. Tablas creadas
SELECT table_name
FROM user_tables
ORDER BY table_name;

-- 2. Conteo general de objetos por tipo
SELECT object_type, COUNT(*) AS cantidad
FROM user_objects
WHERE object_name IN (
    'ASISTENTE',
    'FOLDER',
    'TRATAMIENTO',
    'DOCTOR',
    'PROVEEDOR',
    'SUMINISTRO',
    'PACIENTE',
    'CITA',
    'ODONTOGRAMA',
    'DETALLE_ODONTOGRAMA',
    'PLAN_PAGO',
    'PAGO',
    'COMPRA',
    'DETALLE_COMPRA',
    'ALMACEN_INVENTARIO',
    'VW_HISTORIAL_CLINICO',
    'TRG_ACTUALIZAR_STOCK_COMPRA',
    'TRG_AUDITAR_PLAN_PAGO',
    'SP_REGISTRAR_PAGO'
)
GROUP BY object_type
ORDER BY object_type;

-- 3. Restricciones por tabla
SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM user_constraints
WHERE table_name IN (
    'ASISTENTE',
    'FOLDER',
    'TRATAMIENTO',
    'DOCTOR',
    'PROVEEDOR',
    'SUMINISTRO',
    'PACIENTE',
    'CITA',
    'ODONTOGRAMA',
    'DETALLE_ODONTOGRAMA',
    'PLAN_PAGO',
    'PAGO',
    'COMPRA',
    'DETALLE_COMPRA',
    'ALMACEN_INVENTARIO'
)
ORDER BY table_name, constraint_type, constraint_name;

-- 4. Claves foráneas
SELECT
    uc.table_name,
    uc.constraint_name,
    ucc.column_name,
    ruc.table_name AS tabla_referenciada,
    rucc.column_name AS columna_referenciada
FROM user_constraints uc
JOIN user_cons_columns ucc
    ON uc.constraint_name = ucc.constraint_name
JOIN user_constraints ruc
    ON uc.r_constraint_name = ruc.constraint_name
JOIN user_cons_columns rucc
    ON ruc.constraint_name = rucc.constraint_name
WHERE uc.constraint_type = 'R'
ORDER BY uc.table_name, uc.constraint_name, ucc.position;

-- 5. Estado de vista, triggers y procedimiento
SELECT
    object_name,
    object_type,
    status
FROM user_objects
WHERE object_name IN (
    'VW_HISTORIAL_CLINICO',
    'TRG_ACTUALIZAR_STOCK_COMPRA',
    'TRG_AUDITAR_PLAN_PAGO',
    'SP_REGISTRAR_PAGO'
)
ORDER BY object_type, object_name;
