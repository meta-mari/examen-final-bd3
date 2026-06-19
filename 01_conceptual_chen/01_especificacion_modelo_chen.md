# Especificación del modelo conceptual Chen

## Propósito

El modelo conceptual representa las entidades principales, atributos y relaciones del dominio de datos, independientemente del motor físico. Se usa notación Chen mediante diagrams.net.

El modelo se basa en el esquema Oracle 19c implementado para los procesos de registro de pacientes, atención odontológica, odontograma, pagos, compras e inventario.

## Convenciones de diagramación

- Entidades: rectángulos.
- Relaciones: rombos.
- Atributos: elipses.
- Identificadores: atributos subrayados.
- Participación total: línea doble.
- Participación parcial: línea simple.
- Cardinalidad: notación mínima-máxima junto a cada conector, por ejemplo `(0,1)`, `(1,1)`, `(0,N)`, `(1,N)`.

## Entidades y atributos

### ASISTENTE

Atributos:

- id_asistente, identificador.
- ci_dni.
- nombres.
- apellidos.
- telefono.
- turno.
- fecha_contratacion.
- estado.

### FOLDER

Atributos:

- id_folder, identificador.
- codigo_archivo.
- estante.
- seccion.
- observaciones.

### DOCTOR

Atributos:

- id_doctor, identificador.
- ci_dni.
- nombres.
- apellidos.
- especialidad.
- telefono.
- correo.
- estado.

### TRATAMIENTO

Atributos:

- id_tratamiento, identificador.
- nombre.
- descripcion.
- costo_referencial.
- estado.

### PROVEEDOR

Atributos:

- id_proveedor, identificador.
- nit_ruc.
- razon_social.
- nombre_contacto.
- telefono.
- direccion.
- correo.

### SUMINISTRO

Atributos:

- id_suministro, identificador.
- codigo_barras.
- nombre.
- categoria.
- unidad_medida.
- stock_minimo.
- estado.

### PACIENTE

Atributos:

- id_paciente, identificador.
- ci_dni.
- nombres.
- apellidos.
- fecha_nacimiento.
- sexo.
- telefono.
- direccion.
- antecedentes_medicos.
- fecha_registro.

### CITA

Atributos:

- id_cita, identificador.
- fecha_hora.
- motivo.
- estado.
- fecha_creacion.

### ODONTOGRAMA

Atributos:

- id_odontograma, identificador.
- fecha_evaluacion.
- observaciones_generales.

### DETALLE_ODONTOGRAMA

Atributos:

- id_detalle, identificador.
- pieza_dental.
- cara.
- diagnostico.
- estado.

### PLAN_PAGO

Atributos:

- id_plan_pago, identificador.
- fecha_creacion.
- costo_total.
- saldo_pendiente.
- estado.

### PAGO

Atributos:

- id_pago, identificador.
- fecha_pago.
- monto_abonado.
- metodo_pago.
- nro_comprobante.

### COMPRA

Atributos:

- id_compra, identificador.
- fecha_compra.
- nro_factura.
- total_compra.
- estado.

### DETALLE_COMPRA

Atributos:

- id_detalle_compra, identificador.
- cantidad.
- precio_unitario.
- subtotal.

### ALMACEN_INVENTARIO

Atributos:

- id_inventario, identificador.
- stock_actual.
- ultima_actualizacion.

## Relaciones conceptuales

### ARCHIVA

Relaciona `FOLDER` con `PACIENTE`.

- Un paciente puede tener cero o un folder asignado: `PACIENTE (0,1)`.
- Un folder puede estar asociado a cero o varios pacientes según el diseño físico actual: `FOLDER (0,N)`.

### PROGRAMA

Relaciona `PACIENTE`, `DOCTOR`, `ASISTENTE` y `CITA`.

- Un paciente puede tener una o varias citas: `PACIENTE (1,N)`.
- Una cita pertenece a un solo paciente: `CITA (1,1)`.
- Un doctor puede atender varias citas: `DOCTOR (1,N)`.
- Una cita tiene un solo doctor: `CITA (1,1)`.
- Un asistente puede apoyar cero o varias citas: `ASISTENTE (0,N)`.
- Una cita puede tener cero o un asistente: `CITA (0,1)`.

### REGISTRA_ODONTOGRAMA

Relaciona `PACIENTE`, `DOCTOR` y `ODONTOGRAMA`.

- Un paciente puede tener uno o varios odontogramas: `PACIENTE (1,N)`.
- Un odontograma pertenece a un solo paciente: `ODONTOGRAMA (1,1)`.
- Un doctor puede registrar varios odontogramas: `DOCTOR (1,N)`.
- Un odontograma es registrado por un solo doctor: `ODONTOGRAMA (1,1)`.

### DETALLA_ODONTOGRAMA

Relaciona `ODONTOGRAMA`, `DETALLE_ODONTOGRAMA` y `TRATAMIENTO`.

- Un odontograma tiene uno o varios detalles: `ODONTOGRAMA (1,N)`.
- Un detalle pertenece a un solo odontograma: `DETALLE_ODONTOGRAMA (1,1)`.
- Un tratamiento puede aparecer en cero o varios detalles: `TRATAMIENTO (0,N)`.
- Un detalle puede tener cero o un tratamiento asociado: `DETALLE_ODONTOGRAMA (0,1)`.

### GENERA_PLAN_PAGO

Relaciona `PACIENTE`, `ODONTOGRAMA` y `PLAN_PAGO`.

- Un paciente puede tener cero o varios planes de pago: `PACIENTE (0,N)`.
- Un plan de pago pertenece a un solo paciente: `PLAN_PAGO (1,1)`.
- Un odontograma puede tener cero o varios planes de pago: `ODONTOGRAMA (0,N)`.
- Un plan de pago corresponde a un solo odontograma: `PLAN_PAGO (1,1)`.

### REGISTRA_PAGO

Relaciona `PLAN_PAGO`, `ASISTENTE` y `PAGO`.

- Un plan de pago puede tener cero o varios pagos: `PLAN_PAGO (0,N)`.
- Un pago pertenece a un solo plan de pago: `PAGO (1,1)`.
- Un asistente puede registrar cero o varios pagos: `ASISTENTE (0,N)`.
- Un pago puede ser registrado por cero o un asistente: `PAGO (0,1)`.

### REALIZA_COMPRA

Relaciona `PROVEEDOR`, `ASISTENTE` y `COMPRA`.

- Un proveedor puede tener una o varias compras registradas: `PROVEEDOR (1,N)`.
- Una compra pertenece a un solo proveedor: `COMPRA (1,1)`.
- Un asistente puede registrar cero o varias compras: `ASISTENTE (0,N)`.
- Una compra puede estar asociada a cero o un asistente: `COMPRA (0,1)`.

### DETALLA_COMPRA

Relaciona `COMPRA`, `DETALLE_COMPRA` y `SUMINISTRO`.

- Una compra tiene uno o varios detalles: `COMPRA (1,N)`.
- Un detalle pertenece a una sola compra: `DETALLE_COMPRA (1,1)`.
- Un suministro puede aparecer en cero o varios detalles de compra: `SUMINISTRO (0,N)`.
- Un detalle de compra corresponde a un solo suministro: `DETALLE_COMPRA (1,1)`.

### CONTROLA_INVENTARIO

Relaciona `SUMINISTRO` con `ALMACEN_INVENTARIO`.

- Un suministro puede tener cero o un registro de inventario: `SUMINISTRO (0,1)`.
- Un registro de inventario pertenece a un solo suministro: `ALMACEN_INVENTARIO (1,1)`.

## Observaciones de diseño conceptual

No se definieron entidades débiles, porque cada tabla principal cuenta con identificador propio. Las relaciones que en el modelo físico se resuelven mediante claves foráneas se representan conceptualmente como rombos. Las entidades operativas principales son `PACIENTE`, `CITA`, `ODONTOGRAMA`, `PLAN_PAGO`, `PAGO`, `COMPRA` e `INVENTARIO`. Las entidades de referencia o soporte son `DOCTOR`, `ASISTENTE`, `TRATAMIENTO`, `PROVEEDOR`, `SUMINISTRO` y `FOLDER`.
