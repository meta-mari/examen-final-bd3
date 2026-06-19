# Scripts Oracle 19c

Esta carpeta contiene los scripts SQL y PL/SQL usados para crear, implementar y validar el esquema de base de datos del proyecto.

## Orden de ejecución

1. `00_admin_crear_schema.sql`
2. Conectarse como `FARMACIAS_BD3`
3. `01_limpieza_esquema.sql`
4. `02_tablas.sql`
5. `03_vistas.sql`
6. `04_triggers.sql`
7. `05_procedimientos.sql`
8. Validaciones ubicadas en `../10_validaciones/`

## Nota sobre la barra `/` en bloques PL/SQL

En Oracle, los bloques PL/SQL anónimos, procedimientos y triggers suelen terminarse con `/` cuando se ejecutan desde herramientas como SQL*Plus, SQLcl o SQL Developer. La barra indica que el bloque almacenado en el buffer debe enviarse al motor de base de datos.

En DBeaver, dependiendo del modo de ejecución utilizado, la barra puede causar error si se ejecuta como una sentencia SQL normal. Por ese motivo, durante las pruebas en DBeaver puede ejecutarse el bloque sin la barra final o usando el modo de ejecución de script cuando corresponda.

Se mantiene la barra en los archivos del repositorio para conservar compatibilidad con herramientas Oracle oficiales y para que los scripts sean claros como scripts SQL/PLSQL completos.
