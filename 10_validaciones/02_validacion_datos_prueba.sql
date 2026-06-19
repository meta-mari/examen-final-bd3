-- ========================================================================
-- 02_validacion_datos_prueba.sql
-- Validaciones posteriores a la carga de datos de prueba
-- ========================================================================

-- 1. Cantidad de registros por tabla principal
SELECT 'ASISTENTE' AS tabla, COUNT(*) AS cantidad FROM ASISTENTE
UNION ALL SELECT 'FOLDER', COUNT(*) FROM FOLDER
UNION ALL SELECT 'DOCTOR', COUNT(*) FROM DOCTOR
UNION ALL SELECT 'TRATAMIENTO', COUNT(*) FROM TRATAMIENTO
UNION ALL SELECT 'PROVEEDOR', COUNT(*) FROM PROVEEDOR
UNION ALL SELECT 'SUMINISTRO', COUNT(*) FROM SUMINISTRO
UNION ALL SELECT 'PACIENTE', COUNT(*) FROM PACIENTE
UNION ALL SELECT 'CITA', COUNT(*) FROM CITA
UNION ALL SELECT 'ODONTOGRAMA', COUNT(*) FROM ODONTOGRAMA
UNION ALL SELECT 'DETALLE_ODONTOGRAMA', COUNT(*) FROM DETALLE_ODONTOGRAMA
UNION ALL SELECT 'PLAN_PAGO', COUNT(*) FROM PLAN_PAGO
UNION ALL SELECT 'COMPRA', COUNT(*) FROM COMPRA
UNION ALL SELECT 'DETALLE_COMPRA', COUNT(*) FROM DETALLE_COMPRA
UNION ALL SELECT 'ALMACEN_INVENTARIO', COUNT(*) FROM ALMACEN_INVENTARIO
ORDER BY tabla;

-- 2. Validación del trigger de inventario
SELECT
    s.codigo_barras,
    s.nombre,
    ai.stock_actual,
    ai.ultima_actualizacion
FROM SUMINISTRO s
JOIN ALMACEN_INVENTARIO ai
    ON s.id_suministro = ai.id_suministro
ORDER BY s.codigo_barras;

-- 3. Validación de la vista de historial clínico
SELECT
    dni_paciente,
    nombre_paciente,
    doctor_tratante,
    fecha_evaluacion,
    pieza_dental,
    diagnostico,
    tratamiento_aplicado,
    estado_tratamiento
FROM VW_HISTORIAL_CLINICO
ORDER BY fecha_evaluacion, dni_paciente;

-- 4. Validación de planes de pago
SELECT
    pp.id_plan_pago,
    p.ci_dni,
    p.nombres || ' ' || p.apellidos AS paciente,
    pp.costo_total,
    pp.saldo_pendiente,
    pp.estado
FROM PLAN_PAGO pp
JOIN PACIENTE p
    ON pp.id_paciente = p.id_paciente
ORDER BY pp.id_plan_pago;
