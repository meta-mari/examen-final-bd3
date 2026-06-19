-- ========================================================================
-- SISTEMA DE GESTIÓN CLÍNICA: LALYSDENT (ORACLE 19c)
-- SCRIPT DE DESPLIEGUE COMPLETO (DDL + PL/SQL)
-- ========================================================================

-- ------------------------------------------------------------------------
-- 0. LIMPIEZA DEL ESQUEMA (Idempotencia)
-- ------------------------------------------------------------------------
BEGIN
   FOR cur_rec IN (SELECT table_name FROM user_tables WHERE table_name IN (
       'ALMACEN_INVENTARIO', 'DETALLE_COMPRA', 'COMPRA', 
       'PAGO', 'PLAN_PAGO', 'DETALLE_ODONTOGRAMA', 'ODONTOGRAMA', 
       'CITA', 'PACIENTE', 'SUMINISTRO', 'PROVEEDOR', 
       'DOCTOR', 'TRATAMIENTO', 'FOLDER', 'ASISTENTE')) 
   LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || cur_rec.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;
/

-- ------------------------------------------------------------------------
-- 1. MÓDULO ORGANIZATIVO Y CATÁLOGOS BASE
-- ------------------------------------------------------------------------
CREATE TABLE ASISTENTE (
    id_asistente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ci_dni VARCHAR2(20) UNIQUE NOT NULL,
    nombres VARCHAR2(80) NOT NULL,
    apellidos VARCHAR2(80) NOT NULL,
    telefono VARCHAR2(15),
    turno VARCHAR2(20),
    fecha_contratacion DATE,
    estado NUMBER(1) DEFAULT 1 NOT NULL 
);

CREATE TABLE FOLDER (
    id_folder NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_archivo VARCHAR2(20) UNIQUE NOT NULL,
    estante VARCHAR2(20),
    seccion VARCHAR2(20),
    observaciones VARCHAR2(255)
);

CREATE TABLE TRATAMIENTO (
    id_tratamiento NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(255),
    costo_referencial NUMBER(10, 2) NOT NULL,
    estado NUMBER(1) DEFAULT 1 NOT NULL
);

CREATE TABLE DOCTOR (
    id_doctor NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ci_dni VARCHAR2(20) UNIQUE NOT NULL,
    nombres VARCHAR2(80) NOT NULL,
    apellidos VARCHAR2(80) NOT NULL,
    especialidad VARCHAR2(100),
    telefono VARCHAR2(15),
    correo VARCHAR2(100) UNIQUE,
    estado NUMBER(1) DEFAULT 1 NOT NULL
);

CREATE TABLE PROVEEDOR (
    id_proveedor NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nit_ruc VARCHAR2(20) UNIQUE NOT NULL,
    razon_social VARCHAR2(100) NOT NULL,
    nombre_contacto VARCHAR2(80),
    telefono VARCHAR2(15),
    direccion VARCHAR2(255),
    correo VARCHAR2(100)
);

CREATE TABLE SUMINISTRO (
    id_suministro NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_barras VARCHAR2(50) UNIQUE,
    nombre VARCHAR2(100) NOT NULL,
    categoria VARCHAR2(50),
    unidad_medida VARCHAR2(20),
    stock_minimo NUMBER(5) DEFAULT 5 NOT NULL,
    estado NUMBER(1) DEFAULT 1 NOT NULL
);

-- ------------------------------------------------------------------------
-- 2. MÓDULO CLÍNICO Y PACIENTES
-- ------------------------------------------------------------------------
CREATE TABLE PACIENTE (
    id_paciente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_folder NUMBER,
    ci_dni VARCHAR2(20) UNIQUE NOT NULL,
    nombres VARCHAR2(80) NOT NULL,
    apellidos VARCHAR2(80) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1), 
    telefono VARCHAR2(15),
    direccion VARCHAR2(255),
    antecedentes_medicos VARCHAR2(500),
    fecha_registro DATE DEFAULT SYSDATE,
    CONSTRAINT fk_paciente_folder FOREIGN KEY (id_folder) REFERENCES FOLDER(id_folder) ON DELETE SET NULL
);

CREATE TABLE CITA (
    id_cita NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente NUMBER NOT NULL,
    id_doctor NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_hora TIMESTAMP NOT NULL,
    motivo VARCHAR2(255) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Pendiente' NOT NULL, 
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_cita_doctor FOREIGN KEY (id_doctor) REFERENCES DOCTOR(id_doctor),
    CONSTRAINT fk_cita_asistente FOREIGN KEY (id_asistente) REFERENCES ASISTENTE(id_asistente),
    CONSTRAINT chk_estado_cita CHECK (estado IN ('Pendiente', 'Confirmada', 'Atendida', 'Cancelada', 'Reprogramada'))
);

CREATE TABLE ODONTOGRAMA (
    id_odontograma NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente NUMBER NOT NULL,
    id_doctor NUMBER NOT NULL,
    fecha_evaluacion DATE DEFAULT SYSDATE NOT NULL,
    observaciones_generales VARCHAR2(500),
    CONSTRAINT fk_odonto_paciente FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_odonto_doctor FOREIGN KEY (id_doctor) REFERENCES DOCTOR(id_doctor)
);

CREATE TABLE DETALLE_ODONTOGRAMA (
    id_detalle NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_odontograma NUMBER NOT NULL,
    id_tratamiento NUMBER,
    pieza_dental VARCHAR2(10) NOT NULL,
    cara VARCHAR2(20) NOT NULL,
    diagnostico VARCHAR2(100) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Por tratar',
    CONSTRAINT fk_det_odontograma FOREIGN KEY (id_odontograma) REFERENCES ODONTOGRAMA(id_odontograma) ON DELETE CASCADE,
    CONSTRAINT fk_det_tratamiento FOREIGN KEY (id_tratamiento) REFERENCES TRATAMIENTO(id_tratamiento)
);

-- ------------------------------------------------------------------------
-- 3. MÓDULO FINANCIERO
-- ------------------------------------------------------------------------
CREATE TABLE PLAN_PAGO (
    id_plan_pago NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente NUMBER NOT NULL,
    id_odontograma NUMBER NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    costo_total NUMBER(10, 2) NOT NULL,
    saldo_pendiente NUMBER(10, 2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Vigente',
    CONSTRAINT fk_plan_paciente FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_plan_odonto FOREIGN KEY (id_odontograma) REFERENCES ODONTOGRAMA(id_odontograma)
);

CREATE TABLE PAGO (
    id_pago NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_plan_pago NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_pago TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    monto_abonado NUMBER(10, 2) NOT NULL,
    metodo_pago VARCHAR2(30) NOT NULL,
    nro_comprobante VARCHAR2(50),
    CONSTRAINT fk_pago_plan FOREIGN KEY (id_plan_pago) REFERENCES PLAN_PAGO(id_plan_pago),
    CONSTRAINT fk_pago_asistente FOREIGN KEY (id_asistente) REFERENCES ASISTENTE(id_asistente),
    CONSTRAINT chk_monto_pago CHECK (monto_abonado > 0)
);

-- ------------------------------------------------------------------------
-- 4. MÓDULO LOGÍSTICO Y ALMACÉN
-- ------------------------------------------------------------------------
CREATE TABLE COMPRA (
    id_compra NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_proveedor NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_compra DATE NOT NULL,
    nro_factura VARCHAR2(50),
    total_compra NUMBER(10, 2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Completada',
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR(id_proveedor),
    CONSTRAINT fk_compra_asistente FOREIGN KEY (id_asistente) REFERENCES ASISTENTE(id_asistente)
);

CREATE TABLE DETALLE_COMPRA (
    id_detalle_compra NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_compra NUMBER NOT NULL,
    id_suministro NUMBER NOT NULL,
    cantidad NUMBER(8,2) NOT NULL,
    precio_unitario NUMBER(10, 2) NOT NULL,
    subtotal NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_detcompra_compra FOREIGN KEY (id_compra) REFERENCES COMPRA(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_detcompra_suministro FOREIGN KEY (id_suministro) REFERENCES SUMINISTRO(id_suministro)
);

CREATE TABLE ALMACEN_INVENTARIO (
    id_inventario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_suministro NUMBER UNIQUE NOT NULL,
    stock_actual NUMBER(8,2) DEFAULT 0 NOT NULL,
    ultima_actualizacion TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_inventario_suministro FOREIGN KEY (id_suministro) REFERENCES SUMINISTRO(id_suministro)
);

-- ------------------------------------------------------------------------
-- 5. VISTAS GERENCIALES (VIEWS)
-- ------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_HISTORIAL_CLINICO AS
SELECT 
    p.ci_dni AS dni_paciente,
    p.nombres || ' ' || p.apellidos AS nombre_paciente,
    d.nombres || ' ' || d.apellidos AS doctor_tratante,
    o.fecha_evaluacion,
    det.pieza_dental,
    det.diagnostico,
    t.nombre AS tratamiento_aplicado,
    det.estado AS estado_tratamiento
FROM PACIENTE p
JOIN ODONTOGRAMA o ON p.id_paciente = o.id_paciente
JOIN DOCTOR d ON o.id_doctor = d.id_doctor
JOIN DETALLE_ODONTOGRAMA det ON o.id_odontograma = det.id_odontograma
LEFT JOIN TRATAMIENTO t ON det.id_tratamiento = t.id_tratamiento;

-- ------------------------------------------------------------------------
-- 6. DISPARADORES Y AUTOMATIZACIÓN (TRIGGERS)
-- ------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_STOCK_COMPRA
AFTER INSERT ON DETALLE_COMPRA
FOR EACH ROW
BEGIN
    UPDATE ALMACEN_INVENTARIO
    SET stock_actual = stock_actual + :NEW.cantidad,
        ultima_actualizacion = SYSTIMESTAMP
    WHERE id_suministro = :NEW.id_suministro;
    
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO ALMACEN_INVENTARIO (id_suministro, stock_actual)
        VALUES (:NEW.id_suministro, :NEW.cantidad);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_AUDITAR_PLAN_PAGO
BEFORE UPDATE OF saldo_pendiente ON PLAN_PAGO
FOR EACH ROW
BEGIN
    IF :NEW.saldo_pendiente < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El saldo pendiente no puede ser menor a cero.');
    ELSIF :NEW.saldo_pendiente = 0 THEN
        :NEW.estado := 'Pagado';
    END IF;
END;
/

-- ------------------------------------------------------------------------
-- 7. PROCEDIMIENTOS ALMACENADOS (STORED PROCEDURES)
-- ------------------------------------------------------------------------
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