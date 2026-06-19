-- ========================================================================
-- 03_prueba_procedimiento_pago.sql
-- Prueba funcional del procedimiento SP_REGISTRAR_PAGO
-- ========================================================================

-- Saldo antes del pago
SELECT
    id_plan_pago,
    costo_total,
    saldo_pendiente,
    estado
FROM PLAN_PAGO
ORDER BY id_plan_pago;

-- Ejecutar pago parcial
BEGIN
    SP_REGISTRAR_PAGO(
        p_id_plan_pago => 1,
        p_id_asistente => 1,
        p_monto => 80,
        p_metodo_pago => 'Efectivo',
        p_comprobante => 'REC-001'
    );
END;

-- Pagos registrados
SELECT
    id_pago,
    id_plan_pago,
    id_asistente,
    monto_abonado,
    metodo_pago,
    nro_comprobante,
    fecha_pago
FROM PAGO
ORDER BY id_pago;

-- Saldo después del pago
SELECT
    id_plan_pago,
    costo_total,
    saldo_pendiente,
    estado
FROM PLAN_PAGO
ORDER BY id_plan_pago;
