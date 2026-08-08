# Functional Requirements

## Propósito

Definir las funcionalidades que deberá proporcionar el sistema para soportar los procesos operativos de la papelería y cumplir con las reglas de negocio establecidas.

Los requerimientos funcionales describen **qué deberá hacer el sistema**, sin establecer decisiones de implementación tecnológica.

Los valores, límites, tarifas, condiciones comerciales y demás parámetros que dependan de las necesidades del negocio deberán ser configurables cuando corresponda.

---

# Gestión de Productos

### FR-PRO-001 - Registrar productos

El sistema deberá permitir registrar nuevos productos y almacenar la información necesaria para su identificación, clasificación, comercialización e inventario.

**Actores relacionados:**

* Administrador

---

### FR-PRO-002 - Consultar productos

El sistema deberá permitir consultar los productos registrados y visualizar su información relevante, incluyendo su disponibilidad actual.

**Actores relacionados:**

* Administrador
* Cajero
* Encargado de Inventario
* Responsable de Compras

---

### FR-PRO-003 - Actualizar productos

El sistema deberá permitir modificar la información configurable de los productos registrados, manteniendo la integridad de las operaciones históricas relacionadas.

**Actores relacionados:**

* Administrador

---

### FR-PRO-004 - Configurar parámetros de inventario por producto

El sistema deberá permitir establecer y modificar los parámetros de inventario correspondientes a cada producto, incluyendo su nivel mínimo de existencias.

Los valores deberán poder variar entre productos.

**Actores relacionados:**

* Administrador
* Encargado de Inventario

**Reglas relacionadas:**

* BR-INV-001

---

# Gestión de Categorías

### FR-CAT-001 - Registrar categorías

El sistema deberá permitir registrar categorías para clasificar los productos del negocio.

**Actores relacionados:**

* Administrador

---

### FR-CAT-002 - Actualizar categorías

El sistema deberá permitir modificar la información de las categorías existentes.

**Actores relacionados:**

* Administrador

---

### FR-CAT-003 - Consultar categorías

El sistema deberá permitir consultar las categorías disponibles para la clasificación de productos.

**Actores relacionados:**

* Administrador
* Cajero
* Encargado de Inventario
* Responsable de Compras

---

# Gestión de Clientes

### FR-CLI-001 - Registrar clientes

El sistema deberá permitir registrar clientes y almacenar la información necesaria para su identificación y seguimiento comercial.

**Actores relacionados:**

* Administrador
* Cajero

---

### FR-CLI-002 - Identificar clientes frecuentes

El sistema deberá permitir identificar y actualizar el estado de cliente frecuente de acuerdo con las políticas comerciales definidas por el negocio.

**Actores relacionados:**

* Administrador

**Reglas relacionadas:**

* BR-CLI-001

---

### FR-CLI-003 - Consultar clientes

El sistema deberá permitir consultar la información de los clientes registrados.

**Actores relacionados:**

* Administrador
* Cajero

---

### FR-CLI-004 - Consultar historial comercial

El sistema deberá permitir consultar las operaciones comerciales asociadas a un cliente registrado.

**Actores relacionados:**

* Administrador
* Cajero

**Reglas relacionadas:**

* BR-CLI-002

---

# Gestión de Proveedores

### FR-PROV-001 - Registrar proveedores

El sistema deberá permitir registrar y mantener la información de los proveedores que abastecen al negocio.

**Actores relacionados:**

* Administrador
* Responsable de Compras

---

### FR-PROV-002 - Consultar proveedores

El sistema deberá permitir consultar la información de los proveedores registrados.

**Actores relacionados:**

* Administrador
* Responsable de Compras

---

### FR-PROV-003 - Consultar historial de compras por proveedor

El sistema deberá permitir consultar las compras realizadas a cada proveedor, incluyendo productos, cantidades, precios y fechas.

**Actores relacionados:**

* Administrador
* Responsable de Compras

---

### FR-PROV-004 - Consultar historial de precios

El sistema deberá permitir consultar el historial de precios de adquisición de un producto por proveedor.

**Actores relacionados:**

* Administrador
* Responsable de Compras

---

# Gestión de Inventario

### FR-INV-001 - Consultar existencias

El sistema deberá permitir consultar las existencias actuales de cada producto.

**Actores relacionados:**

* Administrador
* Cajero
* Encargado de Inventario
* Responsable de Compras

---

### FR-INV-002 - Registrar movimientos de inventario

El sistema deberá registrar los movimientos que modifiquen las existencias de los productos, identificando como mínimo el producto, cantidad, tipo de movimiento, fecha y operación relacionada.

**Actores relacionados:**

* Encargado de Inventario

**Reglas relacionadas:**

* BR-INV-004
* BR-INF-001
* BR-INF-003

---

### FR-INV-003 - Consultar movimientos de inventario

El sistema deberá permitir consultar el historial de movimientos de inventario de un producto.

**Actores relacionados:**

* Administrador
* Encargado de Inventario
* Responsable de Compras

---

### FR-INV-004 - Identificar productos con bajo stock

El sistema deberá identificar los productos cuyas existencias sean iguales o inferiores al nivel mínimo configurado para cada producto.

**Actores relacionados:**

* Administrador
* Encargado de Inventario
* Responsable de Compras

**Reglas relacionadas:**

* BR-INV-001

---

### FR-INV-005 - Notificar bajo stock

El sistema deberá generar una alerta cuando las existencias de un producto alcancen o se encuentren por debajo del nivel mínimo configurado para dicho producto.

**Actores relacionados:**

* Administrador
* Encargado de Inventario
* Responsable de Compras

**Reglas relacionadas:**

* BR-INV-001

---

### FR-INV-006 - Ajustar existencias

El sistema deberá permitir realizar ajustes de inventario cuando exista una diferencia entre las existencias registradas y las existencias físicas.

Cada ajuste deberá registrar la cantidad modificada, la fecha y el motivo correspondiente.

**Actores relacionados:**

* Encargado de Inventario
* Administrador

---

# Gestión de Compras

### FR-COM-001 - Registrar compras

El sistema deberá permitir registrar las compras realizadas a los proveedores, incluyendo los productos adquiridos, cantidades, precios y fecha de operación.

**Actores relacionados:**

* Responsable de Compras
* Administrador

**Reglas relacionadas:**

* BR-COM-001

---

### FR-COM-002 - Registrar recepción de mercancía

El sistema deberá permitir registrar la recepción de mercancía asociada a una compra.

**Actores relacionados:**

* Responsable de Compras
* Encargado de Inventario

**Reglas relacionadas:**

* BR-COM-002

---

### FR-COM-003 - Actualizar inventario mediante recepción

El sistema deberá actualizar las existencias correspondientes cuando una recepción de mercancía sea registrada.

**Actores relacionados:**

* Responsable de Compras
* Encargado de Inventario

**Reglas relacionadas:**

* BR-INV-003
* BR-INV-004

---

### FR-COM-004 - Registrar incidencias de recepción

El sistema deberá permitir registrar incidencias relacionadas con mercancía dañada, faltante, incorrecta o diferente a la solicitada.

**Actores relacionados:**

* Responsable de Compras
* Encargado de Inventario

**Reglas relacionadas:**

* BR-COM-002
* BR-COM-003

---

### FR-COM-005 - Consultar precios históricos

El sistema deberá permitir comparar los precios históricos de adquisición de un producto entre los proveedores registrados.

**Actores relacionados:**

* Administrador
* Responsable de Compras

---

# Gestión de Ventas

### FR-VEN-001 - Registrar ventas

El sistema deberá permitir registrar ventas de uno o más productos y/o servicios, incluyendo cantidades, precios y forma de pago.

**Actores relacionados:**

* Cajero

**Reglas relacionadas:**

* BR-VEN-001

---

### FR-VEN-002 - Validar disponibilidad de productos

Antes de registrar una venta, el sistema deberá validar que exista disponibilidad suficiente de cada producto solicitado.

**Actores relacionados:**

* Cajero

**Reglas relacionadas:**

* BR-INV-002

---

### FR-VEN-003 - Calcular importe de venta

El sistema deberá calcular el importe correspondiente a los productos y servicios incluidos en una venta y determinar el total de la operación.

**Actores relacionados:**

* Cajero

---

### FR-VEN-004 - Aplicar descuentos

El sistema deberá permitir aplicar descuentos conforme a las políticas comerciales configuradas para el negocio.

**Actores relacionados:**

* Cajero
* Administrador

**Reglas relacionadas:**

* BR-VEN-004

---

### FR-VEN-005 - Registrar forma de pago

El sistema deberá permitir registrar la forma de pago utilizada para cada venta.

Las formas de pago disponibles deberán ser configurables de acuerdo con los medios aceptados por el negocio.

**Actores relacionados:**

* Cajero

**Reglas relacionadas:**

* BR-CAJ-002

---

### FR-VEN-006 - Emitir ticket o nota de venta

El sistema deberá generar un comprobante de venta con el detalle de los productos y/o servicios, cantidades, precios, forma de pago, fecha y hora de la operación.

**Actores relacionados:**

* Cajero

**Reglas relacionadas:**

* BR-VEN-001

---

# Facturación

### FR-FAC-001 - Registrar información fiscal del cliente

El sistema deberá permitir registrar la información fiscal necesaria para la emisión de una factura.

**Actores relacionados:**

* Cajero
* Administrador

**Reglas relacionadas:**

* BR-VEN-002

---

### FR-FAC-002 - Solicitar factura

El sistema deberá permitir solicitar la facturación de una venta cuando el cliente requiera un comprobante fiscal.

**Actores relacionados:**

* Cajero
* Administrador

**Reglas relacionadas:**

* BR-VEN-002

---

### FR-FAC-003 - Emitir factura

El sistema deberá permitir gestionar la emisión de la factura mediante el servicio de facturación electrónica correspondiente.

**Actores relacionados:**

* Cajero
* Administrador
* Servicio de Facturación Electrónica

---

### FR-FAC-004 - Registrar resultado de facturación

El sistema deberá registrar el resultado de la solicitud de facturación y asociarlo con la venta correspondiente.

**Actores relacionados:**

* Cajero
* Administrador
* Servicio de Facturación Electrónica

---

# Gestión de Apartados

### FR-APT-001 - Registrar apartado

El sistema deberá permitir registrar un apartado asociándolo con un cliente, los productos reservados, la fecha límite y las condiciones de pago acordadas.

**Actores relacionados:**

* Cajero

**Reglas relacionadas:**

* BR-VEN-003

---

### FR-APT-002 - Consultar apartados

El sistema deberá permitir consultar los apartados registrados y su información correspondiente.

**Actores relacionados:**

* Cajero
* Administrador

---

### FR-APT-003 - Registrar pago de apartado

El sistema deberá permitir registrar los pagos realizados para liquidar un apartado.

**Actores relacionados:**

* Cajero

---

### FR-APT-004 - Consultar estado de apartado

El sistema deberá permitir consultar el estado actual de un apartado y la información relacionada con su liquidación.

**Actores relacionados:**

* Cajero
* Administrador

---

# Gestión de Servicios

### FR-SER-001 - Registrar servicios

El sistema deberá permitir registrar los servicios ofrecidos por la papelería.

**Actores relacionados:**

* Administrador

**Reglas relacionadas:**

* BR-SER-001

---

### FR-SER-002 - Configurar tarifas de servicios

El sistema deberá permitir establecer y modificar las tarifas correspondientes a los servicios ofrecidos.

Las tarifas deberán poder variar de acuerdo con las necesidades del negocio.

**Actores relacionados:**

* Administrador

**Reglas relacionadas:**

* BR-SER-002

---

### FR-SER-003 - Configurar parámetros de servicios

El sistema deberá permitir configurar los parámetros utilizados para determinar el precio de aquellos servicios cuyo importe dependa de diferentes características.

**Actores relacionados:**

* Administrador

---

### FR-SER-004 - Calcular precio de impresiones

El sistema deberá calcular el precio de las impresiones utilizando los parámetros y tarifas configurados para el servicio.

**Actores relacionados:**

* Cajero

**Reglas relacionadas:**

* BR-SER-003

---

# Gestión de Caja

### FR-CAJ-001 - Registrar pagos

El sistema deberá registrar los pagos asociados a las ventas realizadas.

**Actores relacionados:**

* Cajero

---

### FR-CAJ-002 - Registrar pagos con tarjeta

El sistema deberá permitir registrar los pagos realizados mediante tarjeta bancaria.

**Actores relacionados:**

* Cajero
* Institución Financiera

---

### FR-CAJ-003 - Registrar pagos mediante transferencia

El sistema deberá permitir registrar los pagos realizados mediante transferencia electrónica.

**Actores relacionados:**

* Cajero
* Institución Financiera

---

### FR-CAJ-004 - Realizar corte de caja

El sistema deberá permitir realizar el corte de caja al finalizar la jornada, agrupando las operaciones por forma de pago.

**Actores relacionados:**

* Cajero
* Administrador

**Reglas relacionadas:**

* BR-CAJ-001
* BR-CAJ-002

---

### FR-CAJ-005 - Registrar diferencias de caja

El sistema deberá permitir registrar las diferencias detectadas durante el corte de caja y asociarlas con las observaciones correspondientes.

**Actores relacionados:**

* Cajero
* Administrador

**Reglas relacionadas:**

* BR-CAJ-003

---

# Reportes

### FR-REP-001 - Consultar ventas

El sistema deberá permitir consultar las ventas realizadas durante un período determinado.

**Actores relacionados:**

* Administrador

---

### FR-REP-002 - Consultar inventario

El sistema deberá permitir consultar información consolidada sobre las existencias y movimientos de inventario.

**Actores relacionados:**

* Administrador
* Encargado de Inventario

---

### FR-REP-003 - Consultar productos más vendidos

El sistema deberá permitir identificar los productos con mayor cantidad de ventas durante un período determinado.

**Actores relacionados:**

* Administrador

---

### FR-REP-004 - Consultar clientes frecuentes

El sistema deberá permitir consultar información sobre la frecuencia de compra de los clientes registrados.

**Actores relacionados:**

* Administrador

---

### FR-REP-005 - Consultar información de caja

El sistema deberá permitir consultar información histórica de los cortes de caja y de los ingresos registrados por forma de pago.

**Actores relacionados:**

* Administrador

---

### FR-REP-006 - Comparar precios de proveedores

El sistema deberá permitir comparar los precios históricos de adquisición de un producto entre los diferentes proveedores registrados.

**Actores relacionados:**

* Administrador
* Responsable de Compras
