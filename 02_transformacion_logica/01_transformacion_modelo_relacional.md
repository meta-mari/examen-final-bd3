# Transformación del modelo conceptual al modelo relacional

## Propósito

Este documento describe la transformación desde el modelo conceptual en notación Chen hacia el modelo relacional implementado en Oracle Database 19c.

## Reglas aplicadas

1. Cada entidad fuerte del modelo conceptual se transformó en una tabla.
2. Cada identificador conceptual se transformó en clave primaria.
3. Las relaciones uno a muchos se resolvieron colocando una clave foránea en el lado muchos.
4. Las relaciones opcionales se representaron mediante claves foráneas que aceptan valores nulos.
5. Las relaciones obligatorias se representaron mediante claves foráneas `NOT NULL`.
6. Los atributos de control, como estados y fechas, se conservaron como columnas de las tablas correspondientes.
7. Las reglas simples de dominio se implementaron mediante restricciones `CHECK`.
8. Las reglas operacionales se implementaron mediante triggers y procedimientos almacenados.

## Esquema relacional resultante

### ASISTENTE

ASISTENTE(
id_asistente PK,
ci_dni UK NOT NULL,
nombres NOT NULL,
apellidos NOT NULL,
telefono,
turno,
fecha_contratacion,
estado NOT NULL
)

### FOLDER

FOLDER(
id_folder PK,
codigo_archivo UK NOT NULL,
estante,
seccion,
observaciones
)

### TRATAMIENTO

TRATAMIENTO(
id_tratamiento PK,
nombre NOT NULL,
descripcion,
costo_referencial NOT NULL,
estado NOT NULL
)

### DOCTOR

DOCTOR(
id_doctor PK,
ci_dni UK NOT NULL,
nombres NOT NULL,
apellidos NOT NULL,
especialidad,
telefono,
correo UK,
estado NOT NULL
)

### PROVEEDOR

PROVEEDOR(
id_proveedor PK,
nit_ruc UK NOT NULL,
razon_social NOT NULL,
nombre_contacto,
telefono,
direccion,
correo
)

### SUMINISTRO

SUMINISTRO(
id_suministro PK,
codigo_barras UK,
nombre NOT NULL,
categoria,
unidad_medida,
stock_minimo NOT NULL,
estado NOT NULL
)

### PACIENTE

PACIENTE(
id_paciente PK,
id_folder FK NULL,
ci_dni UK NOT NULL,
nombres NOT NULL,
apellidos NOT NULL,
fecha_nacimiento NOT NULL,
sexo,
telefono,
direccion,
antecedentes_medicos,
fecha_registro
)

Relación transformada:
PACIENTE.id_folder referencia FOLDER.id_folder.

### CITA

CITA(
id_cita PK,
id_paciente FK NOT NULL,
id_doctor FK NOT NULL,
id_asistente FK NULL,
fecha_hora NOT NULL,
motivo NOT NULL,
estado NOT NULL,
fecha_creacion
)

Relaciones transformadas:
CITA.id_paciente referencia PACIENTE.id_paciente.
CITA.id_doctor referencia DOCTOR.id_doctor.
CITA.id_asistente referencia ASISTENTE.id_asistente.

### ODONTOGRAMA

ODONTOGRAMA(
id_odontograma PK,
id_paciente FK NOT NULL,
id_doctor FK NOT NULL,
fecha_evaluacion NOT NULL,
observaciones_generales
)

Relaciones transformadas:
ODONTOGRAMA.id_paciente referencia PACIENTE.id_paciente.
ODONTOGRAMA.id_doctor referencia DOCTOR.id_doctor.

### DETALLE_ODONTOGRAMA

DETALLE_ODONTOGRAMA(
id_detalle PK,
id_odontograma FK NOT NULL,
id_tratamiento FK NULL,
pieza_dental NOT NULL,
cara NOT NULL,
diagnostico NOT NULL,
estado
)

Relaciones transformadas:
DETALLE_ODONTOGRAMA.id_odontograma referencia ODONTOGRAMA.id_odontograma.
DETALLE_ODONTOGRAMA.id_tratamiento referencia TRATAMIENTO.id_tratamiento.

### PLAN_PAGO

PLAN_PAGO(
id_plan_pago PK,
id_paciente FK NOT NULL,
id_odontograma FK NOT NULL,
fecha_creacion,
costo_total NOT NULL,
saldo_pendiente NOT NULL,
estado
)

Relaciones transformadas:
PLAN_PAGO.id_paciente referencia PACIENTE.id_paciente.
PLAN_PAGO.id_odontograma referencia ODONTOGRAMA.id_odontograma.

### PAGO

PAGO(
id_pago PK,
id_plan_pago FK NOT NULL,
id_asistente FK NULL,
fecha_pago NOT NULL,
monto_abonado NOT NULL,
metodo_pago NOT NULL,
nro_comprobante
)

Relaciones transformadas:
PAGO.id_plan_pago referencia PLAN_PAGO.id_plan_pago.
PAGO.id_asistente referencia ASISTENTE.id_asistente.

### COMPRA

COMPRA(
id_compra PK,
id_proveedor FK NOT NULL,
id_asistente FK NULL,
fecha_compra NOT NULL,
nro_factura,
total_compra NOT NULL,
estado
)

Relaciones transformadas:
COMPRA.id_proveedor referencia PROVEEDOR.id_proveedor.
COMPRA.id_asistente referencia ASISTENTE.id_asistente.

### DETALLE_COMPRA

DETALLE_COMPRA(
id_detalle_compra PK,
id_compra FK NOT NULL,
id_suministro FK NOT NULL,
cantidad NOT NULL,
precio_unitario NOT NULL,
subtotal NOT NULL
)

Relaciones transformadas:
DETALLE_COMPRA.id_compra referencia COMPRA.id_compra.
DETALLE_COMPRA.id_suministro referencia SUMINISTRO.id_suministro.

### ALMACEN_INVENTARIO

ALMACEN_INVENTARIO(
id_inventario PK,
id_suministro FK UK NOT NULL,
stock_actual NOT NULL,
ultima_actualizacion
)

Relación transformada:
ALMACEN_INVENTARIO.id_suministro referencia SUMINISTRO.id_suministro.

## Reglas adicionales implementadas

### Restricciones de unicidad

Se definieron restricciones únicas para datos que no deben repetirse, como documentos de identidad, correos, códigos de archivo, códigos de barra y el suministro asociado a inventario.

### Restricciones de dominio

La tabla `CITA` controla sus estados mediante una restricción `CHECK`. La tabla `PAGO` impide montos menores o iguales a cero mediante una restricción `CHECK`.

### Automatización

La transformación no se limita a tablas. También incluye objetos programables:

- `TRG_ACTUALIZAR_STOCK_COMPRA`, para mantener el inventario.
- `TRG_AUDITAR_PLAN_PAGO`, para controlar saldos.
- `SP_REGISTRAR_PAGO`, para encapsular la operación de pago.
- `VW_HISTORIAL_CLINICO`, para consultar información clínica integrada.
