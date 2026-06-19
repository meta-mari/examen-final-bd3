-- ========================================================================
-- 06_datos_prueba.sql
-- Carga de datos de prueba para validar el esquema Farmacias_BD3
-- Proyecto: Examen Final BD3 - Farmacias
-- Motor: Oracle Database 19c
-- ========================================================================

-- Limpieza lógica de datos, respetando dependencias
DELETE FROM PAGO;
DELETE FROM PLAN_PAGO;
DELETE FROM DETALLE_ODONTOGRAMA;
DELETE FROM ODONTOGRAMA;
DELETE FROM CITA;
DELETE FROM DETALLE_COMPRA;
DELETE FROM COMPRA;
DELETE FROM ALMACEN_INVENTARIO;
DELETE FROM PACIENTE;
DELETE FROM SUMINISTRO;
DELETE FROM PROVEEDOR;
DELETE FROM DOCTOR;
DELETE FROM TRATAMIENTO;
DELETE FROM FOLDER;
DELETE FROM ASISTENTE;

COMMIT;

-- Asistentes
INSERT INTO ASISTENTE (ci_dni, nombres, apellidos, telefono, turno, fecha_contratacion, estado)
VALUES ('A001', 'María', 'Quispe Flores', '70000001', 'Mañana', DATE '2026-01-10', 1);

INSERT INTO ASISTENTE (ci_dni, nombres, apellidos, telefono, turno, fecha_contratacion, estado)
VALUES ('A002', 'Luis', 'Mamani Rojas', '70000002', 'Tarde', DATE '2026-02-15', 1);

-- Archivadores / folders
INSERT INTO FOLDER (codigo_archivo, estante, seccion, observaciones)
VALUES ('FOL-001', 'E1', 'A', 'Historia clínica activa');

INSERT INTO FOLDER (codigo_archivo, estante, seccion, observaciones)
VALUES ('FOL-002', 'E1', 'B', 'Historia clínica activa');

-- Doctores
INSERT INTO DOCTOR (ci_dni, nombres, apellidos, especialidad, telefono, correo, estado)
VALUES ('D001', 'Carlos', 'Ramos Salas', 'Odontología general', '71000001', 'carlos.ramos@demo.test', 1);

INSERT INTO DOCTOR (ci_dni, nombres, apellidos, especialidad, telefono, correo, estado)
VALUES ('D002', 'Andrea', 'Torres Vega', 'Ortodoncia', '71000002', 'andrea.torres@demo.test', 1);

-- Tratamientos
INSERT INTO TRATAMIENTO (nombre, descripcion, costo_referencial, estado)
VALUES ('Limpieza dental', 'Profilaxis dental básica', 120.00, 1);

INSERT INTO TRATAMIENTO (nombre, descripcion, costo_referencial, estado)
VALUES ('Curación dental', 'Restauración con resina', 180.00, 1);

INSERT INTO TRATAMIENTO (nombre, descripcion, costo_referencial, estado)
VALUES ('Ortodoncia control', 'Control mensual de ortodoncia', 250.00, 1);

-- Proveedores
INSERT INTO PROVEEDOR (nit_ruc, razon_social, nombre_contacto, telefono, direccion, correo)
VALUES ('PRV-001', 'Dental Supply SRL', 'Roxana Paredes', '72000001', 'Av. Central 123', 'ventas@dentalsupply.test');

INSERT INTO PROVEEDOR (nit_ruc, razon_social, nombre_contacto, telefono, direccion, correo)
VALUES ('PRV-002', 'Insumos Odonto Bolivia', 'Javier López', '72000002', 'Calle Comercio 456', 'contacto@insumosodonto.test');

-- Suministros
INSERT INTO SUMINISTRO (codigo_barras, nombre, categoria, unidad_medida, stock_minimo, estado)
VALUES ('SUM-001', 'Guantes descartables', 'Bioseguridad', 'Caja', 5, 1);

INSERT INTO SUMINISTRO (codigo_barras, nombre, categoria, unidad_medida, stock_minimo, estado)
VALUES ('SUM-002', 'Anestesia dental', 'Medicamento', 'Unidad', 10, 1);

INSERT INTO SUMINISTRO (codigo_barras, nombre, categoria, unidad_medida, stock_minimo, estado)
VALUES ('SUM-003', 'Resina compuesta', 'Material odontológico', 'Unidad', 3, 1);

-- Pacientes
INSERT INTO PACIENTE (
    id_folder, ci_dni, nombres, apellidos, fecha_nacimiento, sexo,
    telefono, direccion, antecedentes_medicos
)
SELECT
    f.id_folder, 'P001', 'Daniel', 'Choque Lima', DATE '1998-05-12', 'M',
    '73000001', 'Zona Norte 100', 'Sin antecedentes relevantes'
FROM FOLDER f
WHERE f.codigo_archivo = 'FOL-001';

INSERT INTO PACIENTE (
    id_folder, ci_dni, nombres, apellidos, fecha_nacimiento, sexo,
    telefono, direccion, antecedentes_medicos
)
SELECT
    f.id_folder, 'P002', 'Lucía', 'Vargas Soto', DATE '2001-09-21', 'F',
    '73000002', 'Zona Sur 200', 'Alergia declarada a penicilina'
FROM FOLDER f
WHERE f.codigo_archivo = 'FOL-002';

-- Citas
INSERT INTO CITA (id_paciente, id_doctor, id_asistente, fecha_hora, motivo, estado)
SELECT p.id_paciente, d.id_doctor, a.id_asistente,
       TIMESTAMP '2026-06-20 09:00:00',
       'Evaluación inicial', 'Confirmada'
FROM PACIENTE p, DOCTOR d, ASISTENTE a
WHERE p.ci_dni = 'P001'
  AND d.ci_dni = 'D001'
  AND a.ci_dni = 'A001';

INSERT INTO CITA (id_paciente, id_doctor, id_asistente, fecha_hora, motivo, estado)
SELECT p.id_paciente, d.id_doctor, a.id_asistente,
       TIMESTAMP '2026-06-20 10:00:00',
       'Control de ortodoncia', 'Pendiente'
FROM PACIENTE p, DOCTOR d, ASISTENTE a
WHERE p.ci_dni = 'P002'
  AND d.ci_dni = 'D002'
  AND a.ci_dni = 'A002';

-- Odontograma
INSERT INTO ODONTOGRAMA (id_paciente, id_doctor, fecha_evaluacion, observaciones_generales)
SELECT p.id_paciente, d.id_doctor, DATE '2026-06-20', 'Evaluación inicial registrada'
FROM PACIENTE p, DOCTOR d
WHERE p.ci_dni = 'P001'
  AND d.ci_dni = 'D001';

INSERT INTO DETALLE_ODONTOGRAMA (
    id_odontograma, id_tratamiento, pieza_dental, cara, diagnostico, estado
)
SELECT o.id_odontograma, t.id_tratamiento, '16', 'Oclusal', 'Caries inicial', 'Por tratar'
FROM ODONTOGRAMA o
JOIN PACIENTE p ON o.id_paciente = p.id_paciente
JOIN TRATAMIENTO t ON t.nombre = 'Curación dental'
WHERE p.ci_dni = 'P001';

-- Plan de pago
INSERT INTO PLAN_PAGO (id_paciente, id_odontograma, fecha_creacion, costo_total, saldo_pendiente, estado)
SELECT p.id_paciente, o.id_odontograma, DATE '2026-06-20', 180.00, 180.00, 'Vigente'
FROM PACIENTE p
JOIN ODONTOGRAMA o ON p.id_paciente = o.id_paciente
WHERE p.ci_dni = 'P001';

-- Compra y detalle de compra
INSERT INTO COMPRA (id_proveedor, id_asistente, fecha_compra, nro_factura, total_compra, estado)
SELECT pr.id_proveedor, a.id_asistente, DATE '2026-06-19', 'FAC-001', 450.00, 'Completada'
FROM PROVEEDOR pr, ASISTENTE a
WHERE pr.nit_ruc = 'PRV-001'
  AND a.ci_dni = 'A001';

INSERT INTO DETALLE_COMPRA (id_compra, id_suministro, cantidad, precio_unitario, subtotal)
SELECT c.id_compra, s.id_suministro, 10, 25.00, 250.00
FROM COMPRA c, SUMINISTRO s
WHERE c.nro_factura = 'FAC-001'
  AND s.codigo_barras = 'SUM-001';

INSERT INTO DETALLE_COMPRA (id_compra, id_suministro, cantidad, precio_unitario, subtotal)
SELECT c.id_compra, s.id_suministro, 5, 40.00, 200.00
FROM COMPRA c, SUMINISTRO s
WHERE c.nro_factura = 'FAC-001'
  AND s.codigo_barras = 'SUM-003';

COMMIT;
