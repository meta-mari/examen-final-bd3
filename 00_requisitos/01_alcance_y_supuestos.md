# Alcance y supuestos del proyecto

## Alcance general

El proyecto desarrolla la documentación técnica de una base de datos para un sistema de registro de farmacias. La documentación se concentra en la base de datos como producto principal del examen final, sin centrar el informe en la interfaz web ni en la lógica de frontend.

## Alcance específico

El informe final cubrirá:

1. Análisis de requisitos de datos.
2. Modelo conceptual en notación Chen.
3. Transformación del modelo conceptual al modelo relacional.
4. Modelo lógico en notación Crow's Foot.
5. Diseño físico e implementación en Oracle Database 19c.
6. Diccionario de datos completo.
7. Restricciones de integridad.
8. Catálogos, tablas maestras, tablas asociativas e históricos.
9. Procedimientos, validaciones y consultas de control.
10. Evidencias de ejecución.
11. Comparación directa entre el enfoque MySQL/Laravel descrito en la tesis base y la transformación realizada a Oracle 19c.

## Fuente para comparación MySQL/Laravel

La comparación con MySQL y Laravel se realizará tomando como referencia documental la tesis adjunta sobre el sistema web LALYSDENT. No se usará un DDL MySQL original separado, por lo que la comparación será conceptual, técnica y documental, basada en lo indicado en la tesis.

## Entorno de trabajo

- Sistema operativo: Fedora KDE 44 Wayland x86_64.
- Terminal: Konsole con zsh.
- Editor: VSCodium.
- Modelado conceptual: Draw.io / diagrams.net.
- Modelado lógico: ER/Studio 2003 ejecutado mediante Bottles en Fedora.
- Base de datos: Oracle Database 19c levantado con Docker.
- Cliente SQL: DBeaver.
- Documento final: LuaLaTeX + Biber con formato APA 7.

## Criterio documental

Cada actividad importante tendrá evidencia visual o textual. Las capturas se guardarán en `06_evidencias/` y serán referenciadas en el informe final.
