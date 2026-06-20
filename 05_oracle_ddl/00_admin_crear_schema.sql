-- ========================================================================
-- 00_admin_crear_schema.sql
-- Creación de schema/usuario para el proyecto
-- Motor: Oracle Database 19c
-- ========================================================================

SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor_actual
FROM dual;

CREATE USER farmacias_bd3
IDENTIFIED BY FarmaciasBD3_2026
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

GRANT CREATE SESSION TO farmacias_bd3;
GRANT CREATE TABLE TO farmacias_bd3;
GRANT CREATE VIEW TO farmacias_bd3;
GRANT CREATE SEQUENCE TO farmacias_bd3;
GRANT CREATE TRIGGER TO farmacias_bd3;
GRANT CREATE PROCEDURE TO farmacias_bd3;

SELECT username,
       account_status,
       default_tablespace,
       temporary_tablespace
FROM dba_users
WHERE username = 'FARMACIAS_BD3';
