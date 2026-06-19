# Diccionario de datos

## Descripción general

El presente diccionario de datos documenta las tablas, columnas, tipos de datos, claves, restricciones y propósito funcional del esquema implementado en Oracle Database 19c. El modelo físico corresponde a una base de datos orientada a la administración de procesos de registro, atención clínica odontológica, inventario y pagos.

Aunque el schema del proyecto se denomina `FARMACIAS_BD3` por convención del repositorio y del entorno académico, las entidades implementadas corresponden al dominio del sistema odontológico analizado a partir de la tesis base.

---

## Tabla: ASISTENTE

**Propósito:** almacena los datos del personal asistente que participa en la gestión de citas, compras y pagos.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_asistente | NUMBER | No | PK | Identificador único generado automáticamente. |
| ci_dni | VARCHAR2(20) | No | UK | Documento de identidad del asistente. |
| nombres | VARCHAR2(80) | No |  | Nombres del asistente. |
| apellidos | VARCHAR2(80) | No |  | Apellidos del asistente. |
| telefono | VARCHAR2(15) | Sí |  | Número telefónico de contacto. |
| turno | VARCHAR2(20) | Sí |  | Turno asignado al asistente. |
| fecha_contratacion | DATE | Sí |  | Fecha de contratación. |
| estado | NUMBER(1) | No |  | Estado lógico del registro. Valor por defecto: 1. |

---

## Tabla: FOLDER

**Propósito:** representa el archivador o carpeta física/digital donde se ubica la documentación clínica del paciente.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_folder | NUMBER | No | PK | Identificador único generado automáticamente. |
| codigo_archivo | VARCHAR2(20) | No | UK | Código único del archivador o carpeta. |
| estante | VARCHAR2(20) | Sí |  | Estante donde se ubica el archivo. |
| seccion | VARCHAR2(20) | Sí |  | Sección dentro del estante. |
| observaciones | VARCHAR2(255) | Sí |  | Notas adicionales sobre el archivo. |

---

## Tabla: TRATAMIENTO

**Propósito:** catálogo de tratamientos odontológicos disponibles.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_tratamiento | NUMBER | No | PK | Identificador único generado automáticamente. |
| nombre | VARCHAR2(100) | No |  | Nombre del tratamiento. |
| descripcion | VARCHAR2(255) | Sí |  | Descripción breve del tratamiento. |
| costo_referencial | NUMBER(10,2) | No |  | Costo referencial del tratamiento. |
| estado | NUMBER(1) | No |  | Estado lógico del tratamiento. Valor por defecto: 1. |

---

## Tabla: DOCTOR

**Propósito:** almacena los datos de los doctores u odontólogos que atienden pacientes y registran odontogramas.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_doctor | NUMBER | No | PK | Identificador único generado automáticamente. |
| ci_dni | VARCHAR2(20) | No | UK | Documento de identidad del doctor. |
| nombres | VARCHAR2(80) | No |  | Nombres del doctor. |
| apellidos | VARCHAR2(80) | No |  | Apellidos del doctor. |
| especialidad | VARCHAR2(100) | Sí |  | Especialidad odontológica. |
| telefono | VARCHAR2(15) | Sí |  | Teléfono de contacto. |
| correo | VARCHAR2(100) | Sí | UK | Correo electrónico único. |
| estado | NUMBER(1) | No |  | Estado lógico del registro. Valor por defecto: 1. |

---

## Tabla: PROVEEDOR

**Propósito:** almacena proveedores de suministros, materiales e insumos.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_proveedor | NUMBER | No | PK | Identificador único generado automáticamente. |
| nit_ruc | VARCHAR2(20) | No | UK | Número de identificación tributaria del proveedor. |
| razon_social | VARCHAR2(100) | No |  | Razón social del proveedor. |
| nombre_contacto | VARCHAR2(80) | Sí |  | Nombre de la persona de contacto. |
| telefono | VARCHAR2(15) | Sí |  | Teléfono de contacto. |
| direccion | VARCHAR2(255) | Sí |  | Dirección del proveedor. |
| correo | VARCHAR2(100) | Sí |  | Correo electrónico del proveedor. |

---

## Tabla: SUMINISTRO

**Propósito:** catálogo de suministros utilizados en la atención odontológica y administración del inventario.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_suministro | NUMBER | No | PK | Identificador único generado automáticamente. |
| codigo_barras | VARCHAR2(50) | Sí | UK | Código de barras o código interno del suministro. |
| nombre | VARCHAR2(100) | No |  | Nombre del suministro. |
| categoria | VARCHAR2(50) | Sí |  | Categoría del suministro. |
| unidad_medida | VARCHAR2(20) | Sí |  | Unidad de medida usada para controlar stock. |
| stock_minimo | NUMBER(5) | No |  | Cantidad mínima recomendada en inventario. |
| estado | NUMBER(1) | No |  | Estado lógico del suministro. Valor por defecto: 1. |

---

## Tabla: PACIENTE

**Propósito:** registra los datos personales y antecedentes clínicos básicos de los pacientes.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_paciente | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_folder | NUMBER | Sí | FK | Referencia al archivador físico o digital del paciente. |
| ci_dni | VARCHAR2(20) | No | UK | Documento de identidad del paciente. |
| nombres | VARCHAR2(80) | No |  | Nombres del paciente. |
| apellidos | VARCHAR2(80) | No |  | Apellidos del paciente. |
| fecha_nacimiento | DATE | No |  | Fecha de nacimiento. |
| sexo | CHAR(1) | Sí |  | Sexo registrado del paciente. |
| telefono | VARCHAR2(15) | Sí |  | Teléfono de contacto. |
| direccion | VARCHAR2(255) | Sí |  | Dirección del paciente. |
| antecedentes_medicos | VARCHAR2(500) | Sí |  | Antecedentes médicos declarados. |
| fecha_registro | DATE | Sí |  | Fecha de registro del paciente. Valor por defecto: SYSDATE. |

**Relaciones:**  
`PACIENTE.id_folder` referencia `FOLDER.id_folder` con `ON DELETE SET NULL`.

---

## Tabla: CITA

**Propósito:** registra la programación de atenciones odontológicas.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_cita | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_paciente | NUMBER | No | FK | Paciente citado. |
| id_doctor | NUMBER | No | FK | Doctor asignado. |
| id_asistente | NUMBER | Sí | FK | Asistente relacionado con la cita. |
| fecha_hora | TIMESTAMP | No |  | Fecha y hora programada. |
| motivo | VARCHAR2(255) | No |  | Motivo de la cita. |
| estado | VARCHAR2(20) | No | CHECK | Estado de la cita. |
| fecha_creacion | DATE | Sí |  | Fecha de creación del registro. Valor por defecto: SYSDATE. |

**Valores permitidos para estado:** `Pendiente`, `Confirmada`, `Atendida`, `Cancelada`, `Reprogramada`.

**Relaciones:**  
`CITA.id_paciente` referencia `PACIENTE.id_paciente`.  
`CITA.id_doctor` referencia `DOCTOR.id_doctor`.  
`CITA.id_asistente` referencia `ASISTENTE.id_asistente`.

---

## Tabla: ODONTOGRAMA

**Propósito:** representa la evaluación odontológica general de un paciente.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_odontograma | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_paciente | NUMBER | No | FK | Paciente evaluado. |
| id_doctor | NUMBER | No | FK | Doctor que registra la evaluación. |
| fecha_evaluacion | DATE | No |  | Fecha de evaluación. Valor por defecto: SYSDATE. |
| observaciones_generales | VARCHAR2(500) | Sí |  | Observaciones clínicas generales. |

**Relaciones:**  
`ODONTOGRAMA.id_paciente` referencia `PACIENTE.id_paciente`.  
`ODONTOGRAMA.id_doctor` referencia `DOCTOR.id_doctor`.

---

## Tabla: DETALLE_ODONTOGRAMA

**Propósito:** registra el detalle clínico por pieza dental, cara, diagnóstico y tratamiento asociado.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_detalle | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_odontograma | NUMBER | No | FK | Odontograma al que pertenece el detalle. |
| id_tratamiento | NUMBER | Sí | FK | Tratamiento asociado, si corresponde. |
| pieza_dental | VARCHAR2(10) | No |  | Código o número de pieza dental. |
| cara | VARCHAR2(20) | No |  | Cara dental evaluada. |
| diagnostico | VARCHAR2(100) | No |  | Diagnóstico registrado. |
| estado | VARCHAR2(20) | Sí |  | Estado del tratamiento o atención. Valor por defecto: Por tratar. |

**Relaciones:**  
`DETALLE_ODONTOGRAMA.id_odontograma` referencia `ODONTOGRAMA.id_odontograma` con `ON DELETE CASCADE`.  
`DETALLE_ODONTOGRAMA.id_tratamiento` referencia `TRATAMIENTO.id_tratamiento`.

---

## Tabla: PLAN_PAGO

**Propósito:** registra el costo total y saldo pendiente de los tratamientos asociados a un odontograma.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_plan_pago | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_paciente | NUMBER | No | FK | Paciente asociado al plan. |
| id_odontograma | NUMBER | No | FK | Odontograma relacionado. |
| fecha_creacion | DATE | Sí |  | Fecha de creación del plan. Valor por defecto: SYSDATE. |
| costo_total | NUMBER(10,2) | No |  | Costo total del plan. |
| saldo_pendiente | NUMBER(10,2) | No |  | Saldo pendiente de pago. |
| estado | VARCHAR2(20) | Sí |  | Estado del plan. Valor por defecto: Vigente. |

**Relaciones:**  
`PLAN_PAGO.id_paciente` referencia `PACIENTE.id_paciente`.  
`PLAN_PAGO.id_odontograma` referencia `ODONTOGRAMA.id_odontograma`.

**Regla automatizada:**  
El trigger `TRG_AUDITAR_PLAN_PAGO` impide que el saldo pendiente sea negativo y cambia el estado a `Pagado` cuando el saldo llega a cero.

---

## Tabla: PAGO

**Propósito:** registra los pagos efectuados por los pacientes sobre un plan de pago.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_pago | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_plan_pago | NUMBER | No | FK | Plan de pago asociado. |
| id_asistente | NUMBER | Sí | FK | Asistente que registra el pago. |
| fecha_pago | TIMESTAMP | No |  | Fecha y hora del pago. Valor por defecto: SYSTIMESTAMP. |
| monto_abonado | NUMBER(10,2) | No | CHECK | Monto abonado. Debe ser mayor a cero. |
| metodo_pago | VARCHAR2(30) | No |  | Método de pago utilizado. |
| nro_comprobante | VARCHAR2(50) | Sí |  | Número de recibo o comprobante. |

**Relaciones:**  
`PAGO.id_plan_pago` referencia `PLAN_PAGO.id_plan_pago`.  
`PAGO.id_asistente` referencia `ASISTENTE.id_asistente`.

**Regla:**  
`CHK_MONTO_PAGO` exige que `monto_abonado > 0`.

---

## Tabla: COMPRA

**Propósito:** registra compras de suministros realizadas a proveedores.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_compra | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_proveedor | NUMBER | No | FK | Proveedor de la compra. |
| id_asistente | NUMBER | Sí | FK | Asistente que registra la compra. |
| fecha_compra | DATE | No |  | Fecha de la compra. |
| nro_factura | VARCHAR2(50) | Sí |  | Número de factura. |
| total_compra | NUMBER(10,2) | No |  | Total monetario de la compra. |
| estado | VARCHAR2(20) | Sí |  | Estado de la compra. Valor por defecto: Completada. |

**Relaciones:**  
`COMPRA.id_proveedor` referencia `PROVEEDOR.id_proveedor`.  
`COMPRA.id_asistente` referencia `ASISTENTE.id_asistente`.

---

## Tabla: DETALLE_COMPRA

**Propósito:** registra los suministros incluidos en cada compra.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_detalle_compra | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_compra | NUMBER | No | FK | Compra a la que pertenece el detalle. |
| id_suministro | NUMBER | No | FK | Suministro comprado. |
| cantidad | NUMBER(8,2) | No |  | Cantidad comprada. |
| precio_unitario | NUMBER(10,2) | No |  | Precio unitario del suministro. |
| subtotal | NUMBER(10,2) | No |  | Subtotal del detalle. |

**Relaciones:**  
`DETALLE_COMPRA.id_compra` referencia `COMPRA.id_compra` con `ON DELETE CASCADE`.  
`DETALLE_COMPRA.id_suministro` referencia `SUMINISTRO.id_suministro`.

**Regla automatizada:**  
El trigger `TRG_ACTUALIZAR_STOCK_COMPRA` actualiza o crea el registro correspondiente en `ALMACEN_INVENTARIO` después de insertar un detalle de compra.

---

## Tabla: ALMACEN_INVENTARIO

**Propósito:** controla el stock actual por suministro.

| Campo | Tipo Oracle | Nulo | Clave | Descripción |
|---|---:|:---:|:---:|---|
| id_inventario | NUMBER | No | PK | Identificador único generado automáticamente. |
| id_suministro | NUMBER | No | FK / UK | Suministro inventariado. Debe ser único en inventario. |
| stock_actual | NUMBER(8,2) | No |  | Stock disponible actual. |
| ultima_actualizacion | TIMESTAMP | Sí |  | Fecha y hora de última actualización. Valor por defecto: SYSTIMESTAMP. |

**Relaciones:**  
`ALMACEN_INVENTARIO.id_suministro` referencia `SUMINISTRO.id_suministro`.

---

## Vista: VW_HISTORIAL_CLINICO

**Propósito:** integra información de pacientes, doctores, odontogramas, detalles clínicos y tratamientos para consultar el historial clínico odontológico.

| Columna | Descripción |
|---|---|
| dni_paciente | Documento de identidad del paciente. |
| nombre_paciente | Nombre completo del paciente. |
| doctor_tratante | Nombre completo del doctor tratante. |
| fecha_evaluacion | Fecha de evaluación del odontograma. |
| pieza_dental | Pieza dental evaluada. |
| diagnostico | Diagnóstico registrado. |
| tratamiento_aplicado | Tratamiento asociado al diagnóstico. |
| estado_tratamiento | Estado del tratamiento en el detalle del odontograma. |

---

## Triggers

| Trigger | Tabla | Evento | Propósito |
|---|---|---|---|
| TRG_ACTUALIZAR_STOCK_COMPRA | DETALLE_COMPRA | AFTER INSERT | Actualiza o crea el stock del suministro comprado en `ALMACEN_INVENTARIO`. |
| TRG_AUDITAR_PLAN_PAGO | PLAN_PAGO | BEFORE UPDATE OF saldo_pendiente | Evita saldos negativos y cambia el estado del plan a `Pagado` cuando el saldo llega a cero. |

---

## Procedimientos almacenados

| Procedimiento | Propósito |
|---|---|
| SP_REGISTRAR_PAGO | Registra un pago, valida que el monto sea positivo, valida que no exceda el saldo pendiente, inserta el registro en `PAGO` y actualiza el saldo del `PLAN_PAGO`. |

---

## Resumen de integridad referencial

| Tabla hija | Columna FK | Tabla padre | Columna PK | Acción |
|---|---|---|---|---|
| PACIENTE | id_folder | FOLDER | id_folder | ON DELETE SET NULL |
| CITA | id_paciente | PACIENTE | id_paciente | Restrictiva |
| CITA | id_doctor | DOCTOR | id_doctor | Restrictiva |
| CITA | id_asistente | ASISTENTE | id_asistente | Restrictiva |
| ODONTOGRAMA | id_paciente | PACIENTE | id_paciente | Restrictiva |
| ODONTOGRAMA | id_doctor | DOCTOR | id_doctor | Restrictiva |
| DETALLE_ODONTOGRAMA | id_odontograma | ODONTOGRAMA | id_odontograma | ON DELETE CASCADE |
| DETALLE_ODONTOGRAMA | id_tratamiento | TRATAMIENTO | id_tratamiento | Restrictiva |
| PLAN_PAGO | id_paciente | PACIENTE | id_paciente | Restrictiva |
| PLAN_PAGO | id_odontograma | ODONTOGRAMA | id_odontograma | Restrictiva |
| PAGO | id_plan_pago | PLAN_PAGO | id_plan_pago | Restrictiva |
| PAGO | id_asistente | ASISTENTE | id_asistente | Restrictiva |
| COMPRA | id_proveedor | PROVEEDOR | id_proveedor | Restrictiva |
| COMPRA | id_asistente | ASISTENTE | id_asistente | Restrictiva |
| DETALLE_COMPRA | id_compra | COMPRA | id_compra | ON DELETE CASCADE |
| DETALLE_COMPRA | id_suministro | SUMINISTRO | id_suministro | Restrictiva |
| ALMACEN_INVENTARIO | id_suministro | SUMINISTRO | id_suministro | Restrictiva |
