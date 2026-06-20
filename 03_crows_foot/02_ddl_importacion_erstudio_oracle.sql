-- ========================================================================
-- 02_ddl_importacion_erstudio_oracle.sql
-- DDL simplificado para importación en ER/Studio 2003
-- Proyecto: Examen Final BD3 - Farmacias
--
-- Objetivo:
-- Representar el modelo lógico Crow's Foot. Este archivo no reemplaza el
-- DDL físico Oracle 19c; solo facilita la importación visual en ER/Studio.
-- ========================================================================

CREATE TABLE ASISTENTE (
    id_asistente NUMBER NOT NULL,
    ci_dni VARCHAR2(20) NOT NULL,
    nombres VARCHAR2(80) NOT NULL,
    apellidos VARCHAR2(80) NOT NULL,
    telefono VARCHAR2(15),
    turno VARCHAR2(20),
    fecha_contratacion DATE,
    estado NUMBER(1) NOT NULL,
    CONSTRAINT pk_asistente PRIMARY KEY (id_asistente),
    CONSTRAINT uk_asistente_ci UNIQUE (ci_dni)
);

CREATE TABLE FOLDER (
    id_folder NUMBER NOT NULL,
    codigo_archivo VARCHAR2(20) NOT NULL,
    estante VARCHAR2(20),
    seccion VARCHAR2(20),
    observaciones VARCHAR2(255),
    CONSTRAINT pk_folder PRIMARY KEY (id_folder),
    CONSTRAINT uk_folder_codigo UNIQUE (codigo_archivo)
);

CREATE TABLE TRATAMIENTO (
    id_tratamiento NUMBER NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(255),
    costo_referencial NUMBER(10,2) NOT NULL,
    estado NUMBER(1) NOT NULL,
    CONSTRAINT pk_tratamiento PRIMARY KEY (id_tratamiento)
);

CREATE TABLE DOCTOR (
    id_doctor NUMBER NOT NULL,
    ci_dni VARCHAR2(20) NOT NULL,
    nombres VARCHAR2(80) NOT NULL,
    apellidos VARCHAR2(80) NOT NULL,
    especialidad VARCHAR2(100),
    telefono VARCHAR2(15),
    correo VARCHAR2(100),
    estado NUMBER(1) NOT NULL,
    CONSTRAINT pk_doctor PRIMARY KEY (id_doctor),
    CONSTRAINT uk_doctor_ci UNIQUE (ci_dni),
    CONSTRAINT uk_doctor_correo UNIQUE (correo)
);

CREATE TABLE PROVEEDOR (
    id_proveedor NUMBER NOT NULL,
    nit_ruc VARCHAR2(20) NOT NULL,
    razon_social VARCHAR2(100) NOT NULL,
    nombre_contacto VARCHAR2(80),
    telefono VARCHAR2(15),
    direccion VARCHAR2(255),
    correo VARCHAR2(100),
    CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor),
    CONSTRAINT uk_proveedor_nit UNIQUE (nit_ruc)
);

CREATE TABLE SUMINISTRO (
    id_suministro NUMBER NOT NULL,
    codigo_barras VARCHAR2(50),
    nombre VARCHAR2(100) NOT NULL,
    categoria VARCHAR2(50),
    unidad_medida VARCHAR2(20),
    stock_minimo NUMBER(5) NOT NULL,
    estado NUMBER(1) NOT NULL,
    CONSTRAINT pk_suministro PRIMARY KEY (id_suministro),
    CONSTRAINT uk_suministro_codigo UNIQUE (codigo_barras)
);

CREATE TABLE PACIENTE (
    id_paciente NUMBER NOT NULL,
    id_folder NUMBER,
    ci_dni VARCHAR2(20) NOT NULL,
    nombres VARCHAR2(80) NOT NULL,
    apellidos VARCHAR2(80) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1),
    telefono VARCHAR2(15),
    direccion VARCHAR2(255),
    antecedentes_medicos VARCHAR2(500),
    fecha_registro DATE,
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente),
    CONSTRAINT uk_paciente_ci UNIQUE (ci_dni),
    CONSTRAINT fk_paciente_folder FOREIGN KEY (id_folder)
        REFERENCES FOLDER(id_folder)
);

CREATE TABLE CITA (
    id_cita NUMBER NOT NULL,
    id_paciente NUMBER NOT NULL,
    id_doctor NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_hora TIMESTAMP NOT NULL,
    motivo VARCHAR2(255) NOT NULL,
    estado VARCHAR2(20) NOT NULL,
    fecha_creacion DATE,
    CONSTRAINT pk_cita PRIMARY KEY (id_cita),
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_cita_doctor FOREIGN KEY (id_doctor)
        REFERENCES DOCTOR(id_doctor),
    CONSTRAINT fk_cita_asistente FOREIGN KEY (id_asistente)
        REFERENCES ASISTENTE(id_asistente)
);

CREATE TABLE ODONTOGRAMA (
    id_odontograma NUMBER NOT NULL,
    id_paciente NUMBER NOT NULL,
    id_doctor NUMBER NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    observaciones_generales VARCHAR2(500),
    CONSTRAINT pk_odontograma PRIMARY KEY (id_odontograma),
    CONSTRAINT fk_odonto_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_odonto_doctor FOREIGN KEY (id_doctor)
        REFERENCES DOCTOR(id_doctor)
);

CREATE TABLE DETALLE_ODONTOGRAMA (
    id_detalle NUMBER NOT NULL,
    id_odontograma NUMBER NOT NULL,
    id_tratamiento NUMBER,
    pieza_dental VARCHAR2(10) NOT NULL,
    cara VARCHAR2(20) NOT NULL,
    diagnostico VARCHAR2(100) NOT NULL,
    estado VARCHAR2(20),
    CONSTRAINT pk_detalle_odontograma PRIMARY KEY (id_detalle),
    CONSTRAINT fk_det_odontograma FOREIGN KEY (id_odontograma)
        REFERENCES ODONTOGRAMA(id_odontograma),
    CONSTRAINT fk_det_tratamiento FOREIGN KEY (id_tratamiento)
        REFERENCES TRATAMIENTO(id_tratamiento)
);

CREATE TABLE PLAN_PAGO (
    id_plan_pago NUMBER NOT NULL,
    id_paciente NUMBER NOT NULL,
    id_odontograma NUMBER NOT NULL,
    fecha_creacion DATE,
    costo_total NUMBER(10,2) NOT NULL,
    saldo_pendiente NUMBER(10,2) NOT NULL,
    estado VARCHAR2(20),
    CONSTRAINT pk_plan_pago PRIMARY KEY (id_plan_pago),
    CONSTRAINT fk_plan_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_plan_odonto FOREIGN KEY (id_odontograma)
        REFERENCES ODONTOGRAMA(id_odontograma)
);

CREATE TABLE PAGO (
    id_pago NUMBER NOT NULL,
    id_plan_pago NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_pago TIMESTAMP NOT NULL,
    monto_abonado NUMBER(10,2) NOT NULL,
    metodo_pago VARCHAR2(30) NOT NULL,
    nro_comprobante VARCHAR2(50),
    CONSTRAINT pk_pago PRIMARY KEY (id_pago),
    CONSTRAINT fk_pago_plan FOREIGN KEY (id_plan_pago)
        REFERENCES PLAN_PAGO(id_plan_pago),
    CONSTRAINT fk_pago_asistente FOREIGN KEY (id_asistente)
        REFERENCES ASISTENTE(id_asistente)
);

CREATE TABLE COMPRA (
    id_compra NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_compra DATE NOT NULL,
    nro_factura VARCHAR2(50),
    total_compra NUMBER(10,2) NOT NULL,
    estado VARCHAR2(20),
    CONSTRAINT pk_compra PRIMARY KEY (id_compra),
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES PROVEEDOR(id_proveedor),
    CONSTRAINT fk_compra_asistente FOREIGN KEY (id_asistente)
        REFERENCES ASISTENTE(id_asistente)
);

CREATE TABLE DETALLE_COMPRA (
    id_detalle_compra NUMBER NOT NULL,
    id_compra NUMBER NOT NULL,
    id_suministro NUMBER NOT NULL,
    cantidad NUMBER(8,2) NOT NULL,
    precio_unitario NUMBER(10,2) NOT NULL,
    subtotal NUMBER(10,2) NOT NULL,
    CONSTRAINT pk_detalle_compra PRIMARY KEY (id_detalle_compra),
    CONSTRAINT fk_detcompra_compra FOREIGN KEY (id_compra)
        REFERENCES COMPRA(id_compra),
    CONSTRAINT fk_detcompra_suministro FOREIGN KEY (id_suministro)
        REFERENCES SUMINISTRO(id_suministro)
);

CREATE TABLE ALMACEN_INVENTARIO (
    id_inventario NUMBER NOT NULL,
    id_suministro NUMBER NOT NULL,
    stock_actual NUMBER(8,2) NOT NULL,
    ultima_actualizacion TIMESTAMP,
    CONSTRAINT pk_almacen_inventario PRIMARY KEY (id_inventario),
    CONSTRAINT uk_inventario_suministro UNIQUE (id_suministro),
    CONSTRAINT fk_inventario_suministro FOREIGN KEY (id_suministro)
        REFERENCES SUMINISTRO(id_suministro)
);
