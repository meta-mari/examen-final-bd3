-- ========================================================================
-- 03_prueba_procedimiento_pago.sql
-- Prueba funcional del procedimiento SP_REGISTRAR_PAGO
-- Usa IDs dinámicos para evitar depender de valores identity específicos.
-- ========================================================================

-- Saldo antes del pago
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
WHERE p.ci_dni = 'P001';

-- Ejecutar pago parcial
DECLARE
    v_id_plan_pago PLAN_PAGO.id_plan_pago%TYPE;
    v_id_asistente ASISTENTE.id_asistente%TYPE;
BEGIN
    SELECT pp.id_plan_pago
    INTO v_id_plan_pago
    FROM PLAN_PAGO pp
    JOIN PACIENTE p
        ON pp.id_paciente = p.id_paciente
    WHERE p.ci_dni = 'P001';

    SELECT id_asistente
    INTO v_id_asistente
    FROM ASISTENTE
    WHERE ci_dni = 'A001';

    SP_REGISTRAR_PAGO(
        p_id_plan_pago => v_id_plan_pago,
        p_id_asistente => v_id_asistente,
        p_monto => 80,
        p_metodo_pago => 'Efectivo',
        p_comprobante => 'REC-001'
    );
END;

-- Pagos registrados
SELECT
    pg.id_pago,
    pg.id_plan_pago,
    pg.id_asistente,
    pg.monto_abonado,
    pg.metodo_pago,
    pg.nro_comprobante,
    pg.fecha_pago
FROM PAGO pg
ORDER BY pg.id_pago;

-- Saldo después del pago
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
WHERE p.ci_dni = 'P001';
