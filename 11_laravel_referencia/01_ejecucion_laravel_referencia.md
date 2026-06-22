# Ejecución del sistema Laravel de referencia

## Propósito

Se clonó y ejecutó el repositorio Laravel del equipo `AlanDevPro/sistema-odontologico` como implementación funcional del sistema del sistema odontológico LALYSDENT. Esta ejecución complementa la tesis base y corresponde a la implementación web propia del sistema y permite observar una aplicación web real relacionada con el dominio odontológico.

La base de datos principal del examen se mantiene en el schema `FARMACIAS_BD3`. El Laravel clonado se ejecutó con un schema separado llamado `LALYSDENT_APP`, para evitar mezclar la implementación académica diseñada en Oracle 19c con la base usada por la aplicación Laravel.

## Repositorios de referencia

Se usaron dos direcciones externas:

| Repositorio o sitio | Dirección | Uso en el informe |
|---|---|---|
| Repositorio académico de tesis Calvo & Cobos | `https://calvocobos.github.io/` | Fuente documental de la tesis base y del contexto LALYSDENT. |
| Repositorio Laravel del proyecto LALYSDENT | `https://github.com/AlanDevPro/sistema-odontologico` | Repositorio propio del proyecto usado para ejecutar y verificar la aplicación Laravel funcional. |

## Separación de alcance

El sistema Laravel funciona con su propia base de datos Oracle mediante migraciones y seeders. No se conectó con el schema `FARMACIAS_BD3`, porque la base de datos diseñada en el examen es el producto principal.

Por tanto, la ejecución Laravel se interpreta como evidencia funcional complementaria y no como sustitución del diseño físico desarrollado en el examen.

## Entorno verificado

Se verificó el entorno de ejecución con:

- PHP 8.5.7.
- Composer 2.9.2.
- Node.js 24.12.0.
- npm 11.6.2.
- Laravel Framework 12.62.0.
- Oracle Instant Client 19.31.
- Extensión PHP OCI8 3.4.1.

## Configuración Oracle del Laravel

El archivo `.env` del Laravel se configuró con conexión Oracle:

- `DB_CONNECTION=oracle`
- `DB_HOST=127.0.0.1`
- `DB_PORT=1521`
- `DB_SERVICE_NAME=ORCLPDB1`
- `DB_USERNAME=LALYSDENT_APP`
- `DB_PASSWORD=Lalysdent_App_2026`

También se agregó la conexión `oracle` en `config/database.php`, usando el driver de `yajra/laravel-oci8`.

## Separación de schemas

| Schema | Uso |
|---|---|
| `FARMACIAS_BD3` | Base de datos diseñada, documentada y validada como producto principal del examen. |
| `LALYSDENT_APP` | Schema usado únicamente para ejecutar las migraciones y seeders del Laravel clonado. |

## Migraciones y seeders

Se ejecutaron las migraciones y seeders del Laravel en `LALYSDENT_APP`. La ejecución creó tablas de autenticación, tablas administrativas y tablas propias del dominio odontológico, incluyendo pacientes, doctores, citas, odontogramas, pagos, compras, proveedores, suministros e inventario.

## Usuarios de prueba

Los seeders generaron usuarios de prueba:

- `c.mendoza@lalysdent.com`
- `c.ibanez@lalysdent.com`
- `a.villarroel@lalysdent.com`
- `l.torrico@lalysdent.com`
- `s.escalante@lalysdent.com`

La contraseña de prueba usada por el seeder es `password`.

## Evidencias

| Evidencia | Descripción |
|---|---|
| `19_laravel_repo_clonado.png` | Repositorio Laravel clonado y estructura inicial. |
| `20_laravel_entorno_php_node.png` | Versiones de PHP, Composer, Node.js, npm y módulos PHP. |
| `21_laravel_instantclient_oci8.png` | Oracle Instant Client y extensión OCI8 funcionando en PHP. |
| `22_laravel_dependencias_ok.png` | Composer, npm, build y requisitos de plataforma correctos. |
| `23_laravel_revision_oracle_config.png` | Revisión de configuración Oracle y comandos Laravel disponibles. |
| `25_laravel_conexion_oci8_lalysdent_app.png` | Conexión OCI8 directa al schema `LALYSDENT_APP`. |
| `26_laravel_env_oracle_configurado.png` | Laravel configurado con conexión `oracle` y servicio `ORCLPDB1`. |
| `27_laravel_migraciones_seeders_ok.png` | Migraciones y seeders ejecutados en Oracle. |
| `28_laravel_usuarios_rutas.png` | Usuarios sembrados y credenciales de prueba. |
| `29_laravel_pantalla_inicio_login.png` | Pantalla pública/login del sistema Laravel. |
| `30_laravel_dashboard_funcionando.png` | Panel principal del sistema funcionando. |
| `31_laravel_modulo_datos_seeders.png` | Módulo de pacientes con datos cargados. |

## Conclusión

La ejecución del Laravel confirma que existe una aplicación funcional relacionada con el dominio odontológico LALYSDENT. Sin embargo, el objetivo central del examen sigue siendo el diseño, transformación, implementación, validación y documentación de la base Oracle 19c en `FARMACIAS_BD3`.
