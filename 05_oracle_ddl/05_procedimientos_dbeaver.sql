-- ========================================================================
-- 05_procedimientos_dbeaver.sql
-- Compilación del procedimiento usando EXECUTE IMMEDIATE.
-- Uso recomendado cuando DBeaver divide incorrectamente CREATE PROCEDURE.
-- Ejecutar el bloque completo con Ctrl + Enter, SIN barra "/" final.
-- ========================================================================

BEGIN
    EXECUTE IMMEDIATE q'[
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_PAGO (
    p_id_plan_pago IN NUMBER,
    p_id_asistente IN NUMBER,
    p_monto IN NUMBER,
    p_metodo_pago IN VARCHAR2,
    p_comprobante IN VARCHAR2
)
AS
    v_saldo_actual PLAN_PAGO.saldo_pendiente%TYPE;
BEGIN
    SELECT saldo_pendiente
    INTO v_saldo_actual
    FROM PLAN_PAGO
    WHERE id_plan_pago = p_id_plan_pago;

    IF p_monto <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El monto del pago debe ser mayor a cero.');
    END IF;

    IF p_monto > v_saldo_actual THEN
        RAISE_APPLICATION_ERROR(-20002, 'El monto a pagar excede el saldo pendiente.');
    END IF;

    INSERT INTO PAGO (
        id_plan_pago,
        id_asistente,
        monto_abonado,
        metodo_pago,
        nro_comprobante
    )
    VALUES (
        p_id_plan_pago,
        p_id_asistente,
        p_monto,
        p_metodo_pago,
        p_comprobante
    );

    UPDATE PLAN_PAGO
    SET saldo_pendiente = saldo_pendiente - p_monto
    WHERE id_plan_pago = p_id_plan_pago;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'El plan de pago especificado no existe.');
END SP_REGISTRAR_PAGO;
]';
END;
