-- ========================================================================
-- 04_diccionario_tecnico_oracle.sql
-- Extracción técnica del diccionario desde Oracle Database 19c
-- Proyecto: Examen Final BD3 - Farmacias
-- ========================================================================

-- 1. Columnas, tipos de datos, nulabilidad y orden físico
SELECT
    utc.table_name,
    utc.column_id,
    utc.column_name,
    utc.data_type,
    CASE
        WHEN utc.data_type IN ('VARCHAR2', 'CHAR') THEN TO_CHAR(utc.data_length)
        WHEN utc.data_type = 'NUMBER' AND utc.data_precision IS NOT NULL THEN utc.data_precision || ',' || utc.data_scale
        ELSE NULL
    END AS longitud_precision,
    utc.nullable,
    utc.data_default
FROM user_tab_columns utc
WHERE utc.table_name IN (
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
ORDER BY utc.table_name, utc.column_id;

-- 2. Restricciones primarias, únicas, foráneas y check
SELECT
    uc.table_name,
    uc.constraint_name,
    CASE uc.constraint_type
        WHEN 'P' THEN 'PRIMARY KEY'
        WHEN 'R' THEN 'FOREIGN KEY'
        WHEN 'U' THEN 'UNIQUE'
        WHEN 'C' THEN 'CHECK / NOT NULL'
        ELSE uc.constraint_type
    END AS tipo_restriccion,
    uc.status,
    uc.delete_rule,
    uc.search_condition
FROM user_constraints uc
WHERE uc.table_name IN (
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
ORDER BY uc.table_name, uc.constraint_type, uc.constraint_name;

-- 3. Columnas que participan en restricciones
SELECT
    ucc.table_name,
    ucc.constraint_name,
    ucc.column_name,
    ucc.position
FROM user_cons_columns ucc
WHERE ucc.table_name IN (
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
ORDER BY ucc.table_name, ucc.constraint_name, ucc.position;

-- 4. Relaciones de claves foráneas
SELECT
    child.table_name AS tabla_hija,
    child_cols.column_name AS columna_hija,
    child.constraint_name AS fk_name,
    parent.table_name AS tabla_padre,
    parent_cols.column_name AS columna_padre,
    child.delete_rule
FROM user_constraints child
JOIN user_cons_columns child_cols
    ON child.constraint_name = child_cols.constraint_name
JOIN user_constraints parent
    ON child.r_constraint_name = parent.constraint_name
JOIN user_cons_columns parent_cols
    ON parent.constraint_name = parent_cols.constraint_name
   AND child_cols.position = parent_cols.position
WHERE child.constraint_type = 'R'
ORDER BY child.table_name, child.constraint_name, child_cols.position;

-- 5. Vista, triggers y procedimiento documentados
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
