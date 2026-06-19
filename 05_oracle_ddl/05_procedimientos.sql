-- ========================================================================
-- 05_procedimientos.sql
-- Procedimientos almacenados PL/SQL
-- ========================================================================

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_PAGO (
    p_id_plan_pago IN NUMBER,
    p_id_asistente IN NUMBER,
    p_monto IN NUMBER,
    p_metodo_pago IN VARCHAR2,
    p_comprobante IN VARCHAR2
)
IS
    v_saldo_actual NUMBER(10,2);
BEGIN
    SELECT saldo_pendiente INTO v_saldo_actual
    FROM PLAN_PAGO
    WHERE id_plan_pago = p_id_plan_pago;

    IF p_monto > v_saldo_actual THEN
        RAISE_APPLICATION_ERROR(-20002, 'El monto a pagar excede el saldo pendiente.');
    END IF;

    INSERT INTO PAGO (id_plan_pago, id_asistente, monto_abonado, metodo_pago, nro_comprobante)
    VALUES (p_id_plan_pago, p_id_asistente, p_monto, p_metodo_pago, p_comprobante);

    UPDATE PLAN_PAGO
    SET saldo_pendiente = saldo_pendiente - p_monto
    WHERE id_plan_pago = p_id_plan_pago;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pago registrado y saldo actualizado con éxito.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: El Plan de Pago especificado no existe.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en la transacción: ' || SQLERRM);
END;
/
