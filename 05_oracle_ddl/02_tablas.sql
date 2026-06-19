-- ========================================================================
-- 02_tablas.sql
-- Creación de tablas, claves primarias, claves foráneas y restricciones
-- Proyecto: Examen Final BD3 - Farmacias
-- Motor: Oracle Database 19c
-- ========================================================================

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
    CONSTRAINT fk_paciente_folder FOREIGN KEY (id_folder)
        REFERENCES FOLDER(id_folder) ON DELETE SET NULL
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
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_cita_doctor FOREIGN KEY (id_doctor)
        REFERENCES DOCTOR(id_doctor),
    CONSTRAINT fk_cita_asistente FOREIGN KEY (id_asistente)
        REFERENCES ASISTENTE(id_asistente),
    CONSTRAINT chk_estado_cita
        CHECK (estado IN ('Pendiente', 'Confirmada', 'Atendida', 'Cancelada', 'Reprogramada'))
);

CREATE TABLE ODONTOGRAMA (
    id_odontograma NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente NUMBER NOT NULL,
    id_doctor NUMBER NOT NULL,
    fecha_evaluacion DATE DEFAULT SYSDATE NOT NULL,
    observaciones_generales VARCHAR2(500),
    CONSTRAINT fk_odonto_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_odonto_doctor FOREIGN KEY (id_doctor)
        REFERENCES DOCTOR(id_doctor)
);

CREATE TABLE DETALLE_ODONTOGRAMA (
    id_detalle NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_odontograma NUMBER NOT NULL,
    id_tratamiento NUMBER,
    pieza_dental VARCHAR2(10) NOT NULL,
    cara VARCHAR2(20) NOT NULL,
    diagnostico VARCHAR2(100) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Por tratar',
    CONSTRAINT fk_det_odontograma FOREIGN KEY (id_odontograma)
        REFERENCES ODONTOGRAMA(id_odontograma) ON DELETE CASCADE,
    CONSTRAINT fk_det_tratamiento FOREIGN KEY (id_tratamiento)
        REFERENCES TRATAMIENTO(id_tratamiento)
);

CREATE TABLE PLAN_PAGO (
    id_plan_pago NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente NUMBER NOT NULL,
    id_odontograma NUMBER NOT NULL,
    fecha_creacion DATE DEFAULT SYSDATE,
    costo_total NUMBER(10, 2) NOT NULL,
    saldo_pendiente NUMBER(10, 2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Vigente',
    CONSTRAINT fk_plan_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_plan_odonto FOREIGN KEY (id_odontograma)
        REFERENCES ODONTOGRAMA(id_odontograma)
);

CREATE TABLE PAGO (
    id_pago NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_plan_pago NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_pago TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    monto_abonado NUMBER(10, 2) NOT NULL,
    metodo_pago VARCHAR2(30) NOT NULL,
    nro_comprobante VARCHAR2(50),
    CONSTRAINT fk_pago_plan FOREIGN KEY (id_plan_pago)
        REFERENCES PLAN_PAGO(id_plan_pago),
    CONSTRAINT fk_pago_asistente FOREIGN KEY (id_asistente)
        REFERENCES ASISTENTE(id_asistente),
    CONSTRAINT chk_monto_pago CHECK (monto_abonado > 0)
);

CREATE TABLE COMPRA (
    id_compra NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_proveedor NUMBER NOT NULL,
    id_asistente NUMBER,
    fecha_compra DATE NOT NULL,
    nro_factura VARCHAR2(50),
    total_compra NUMBER(10, 2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'Completada',
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES PROVEEDOR(id_proveedor),
    CONSTRAINT fk_compra_asistente FOREIGN KEY (id_asistente)
        REFERENCES ASISTENTE(id_asistente)
);

CREATE TABLE DETALLE_COMPRA (
    id_detalle_compra NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_compra NUMBER NOT NULL,
    id_suministro NUMBER NOT NULL,
    cantidad NUMBER(8,2) NOT NULL,
    precio_unitario NUMBER(10, 2) NOT NULL,
    subtotal NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_detcompra_compra FOREIGN KEY (id_compra)
        REFERENCES COMPRA(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_detcompra_suministro FOREIGN KEY (id_suministro)
        REFERENCES SUMINISTRO(id_suministro)
);

CREATE TABLE ALMACEN_INVENTARIO (
    id_inventario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_suministro NUMBER UNIQUE NOT NULL,
    stock_actual NUMBER(8,2) DEFAULT 0 NOT NULL,
    ultima_actualizacion TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_inventario_suministro FOREIGN KEY (id_suministro)
        REFERENCES SUMINISTRO(id_suministro)
);
