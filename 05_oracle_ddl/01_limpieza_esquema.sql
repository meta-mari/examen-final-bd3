-- ========================================================================
-- 01_limpieza_esquema.sql
-- Limpieza idempotente de objetos del esquema
-- Proyecto: Examen Final BD3 - Farmacias
-- Motor: Oracle Database 19c
-- ========================================================================

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
