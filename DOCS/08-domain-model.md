# Modelo de Dominio

## 1. Propósito

Este documento define el modelo de dominio del sistema de gestión para una papelería.

El modelo representa los principales conceptos del negocio, sus responsabilidades, relaciones y reglas de integridad.

Su propósito es servir como puente entre los requisitos, casos de uso y el diseño de datos del sistema.

Este documento será utilizado como referencia para:

* Diseño del modelo de datos.
* Diseño de entidades y objetos de dominio.
* Diseño de servicios de aplicación.
* Diseño de API.
* Implementación de casos de uso.
* Definición de reglas de negocio.
* Diseño de auditoría e historial.

El modelo de dominio **no representa directamente tablas de base de datos**, aunque sus conceptos deben mantener correspondencia con el modelo de datos definido posteriormente.

Los nombres en inglés incluidos entre paréntesis representan los nombres técnicos utilizados para su implementación.

---

# 2. Fuentes del modelo

El modelo de dominio se deriva de los siguientes documentos:

1. `01-business-context.md`
2. `02-business-rules.md`
3. `03-glossary.md`
4. `04-actors.md`
5. `05-functional-requirements.md`
6. `06-non-functional-requirements.md`
7. `07-use-cases.md`
8. `data-dictionary.md`

El Data Dictionary constituye la referencia definitiva para la estructura persistente de los datos.

Cuando una decisión posterior modifique una regla o concepto del dominio, deberá actualizarse la documentación correspondiente y, cuando aplique, registrarse mediante un ADR.

---

# 3. Principios del dominio

El sistema deberá preservar principalmente las siguientes propiedades:

1. **Las ventas no deben perderse.**
2. **El inventario debe ser confiable.**
3. **Los ingresos y egresos deben ser confiables.**
4. **Debe ser posible identificar quién realizó o modificó una operación.**
5. **Los valores utilizados históricamente deben conservarse.**

A partir de estos principios:

* Las operaciones históricas no deberán eliminarse físicamente.
* Las modificaciones administrativas relevantes deberán conservar historial.
* Las operaciones críticas deberán identificar al usuario responsable.
* Los precios utilizados en operaciones deberán conservarse.
* Los descuentos utilizados en operaciones deberán conservarse.
* Los costos históricos de compras deberán conservarse.
* Los movimientos de inventario deberán conservarse.
* Las operaciones de caja deberán conservarse.
* Las ventas canceladas deberán conservar su registro.
* Las devoluciones deberán relacionarse con la venta y el detalle de venta originales.
* Las configuraciones modificadas no deberán alterar operaciones históricas.

El sistema utilizará tres mecanismos complementarios para preservar la información:

1. **Snapshots:** valores utilizados directamente en una operación.
2. **Historial operativo:** conservación de las operaciones realizadas.
3. **Auditoría:** registro de modificaciones administrativas y acciones relevantes.

---

# 4. Contexto del negocio (Business)

El negocio representa el contexto dentro del cual se ejecutan las operaciones de la papelería.

En el modelo actual, el negocio **no se representa mediante una entidad persistente independiente**.

Conceptualmente, todas las operaciones pertenecen al contexto del negocio, incluyendo:

* Usuarios.
* Clientes.
* Catálogo.
* Inventario.
* Ventas.
* Apartados.
* Compras.
* Caja.
* Facturación.
* Configuración.
* Auditoría.

Actualmente el sistema contempla una única papelería y una única sucursal.

El modelo no incorpora todavía una entidad `Branch`, pero deberá evitar decisiones que impidan su incorporación posterior.

---

# 5. Usuario (User)

Representa a un empleado autorizado para utilizar el sistema.

## Información conceptual

* Identificador.
* Nombre de usuario.
* Contraseña almacenada de forma segura.
* Nombre.
* Apellido paterno.
* Apellido materno.
* Estado.
* Roles asignados.
* Fecha de creación.
* Fecha de modificación.

## Estados

```text
ACTIVO (ACTIVE)
INACTIVO (INACTIVE)
BLOQUEADO (BLOCKED)
```

## Reglas

* Cada trabajador podrá tener su propio usuario.
* Un usuario inactivo no podrá realizar nuevas operaciones.
* Un usuario podrá volver a activarse.
* Los usuarios no deberán eliminarse físicamente cuando dejen de trabajar.
* Las operaciones relevantes deberán identificar al usuario responsable.

---

# 6. Rol (Role)

Representa un conjunto de permisos asignables a uno o varios usuarios.

Ejemplos:

```text
Cajero
Encargado de inventario
Administrador
Gerente
Propietario
```

Un rol puede estar asignado a múltiples usuarios.

Un usuario puede tener múltiples roles.

La relación entre usuarios y roles se representa conceptualmente mediante `UserRole`.

---

# 7. Permiso (Permission)

Representa una operación específica que un usuario puede realizar.

Ejemplos:

```text
Crear venta
Cancelar venta
Registrar devolución
Registrar producto
Modificar producto
Modificar precio
Ajustar inventario
Registrar compra
Aplicar descuento
Consultar información financiera
Consultar datos fiscales
Gestionar usuarios
Consultar auditoría
```

Los permisos deberán permitir restringir operaciones sensibles.

La relación entre roles y permisos se representa conceptualmente mediante `RolePermission`.

---

# 8. Cliente (Customer)

Representa a una persona que adquiere productos o servicios.

Un cliente puede:

* Comprar productos.
* Contratar servicios.
* Solicitar facturas.
* Realizar apartados.
* Realizar múltiples pagos sobre un apartado.
* Tener historial comercial.
* Registrar interés por productos.

## Reglas

* No es obligatorio registrar al cliente para realizar una venta normal.
* Una venta puede existir sin cliente registrado.
* Un apartado requiere un cliente registrado.
* Un cliente puede tener múltiples ventas.
* Un cliente puede tener múltiples apartados.
* Un cliente puede tener múltiples registros de interés por productos.

---

# 9. Datos fiscales (FiscalData)

Representan la información fiscal proporcionada por un cliente para fines de facturación.

## Información conceptual

* Identificador fiscal.
* Nombre o razón social.
* Régimen fiscal.
* Código postal.
* Uso fiscal.
* Fecha de creación.
* Fecha de modificación.

## Reglas

* Los datos fiscales pertenecen a un cliente.
* Un cliente puede tener registros fiscales.
* Una factura debe identificar los datos fiscales utilizados.
* El acceso a esta información deberá estar restringido.
* Los datos deberán almacenarse únicamente cuando el cliente haya aceptado proporcionarlos.

Los datos fiscales utilizados para una factura deben conservar su referencia histórica.

---

# 10. Categoría (Category)

Representa una clasificación de productos.

Ejemplos:

```text
Cuadernos
Escritura
Papelería
Material escolar
Oficina
Arte
```

Una categoría puede contener múltiples productos.

Un producto pertenece a una categoría.

Las categorías pueden estar activas o inactivas.

---

# 11. Marca (Brand)

Representa la marca comercial de un producto.

Una marca puede estar asociada a múltiples productos.

Un producto puede no tener una marca registrada.

Las marcas pueden estar activas o inactivas.

---

# 12. Producto (Product)

Representa un artículo físico comercializado por la papelería.

## Información conceptual

* Identificador.
* SKU.
* Código de barras.
* Nombre.
* Descripción.
* Categoría.
* Marca.
* Precio de venta actual.
* Costo actual.
* Nivel de alerta de existencias.
* Estado.
* Fecha de creación.
* Fecha de modificación.

## Reglas

* Cada producto debe pertenecer a una categoría.
* Un producto puede no tener marca.
* El SKU identifica de forma única al producto.
* El código de barras puede no existir.
* El precio actual puede modificarse.
* El costo actual puede modificarse.
* El nivel de alerta puede configurarse individualmente.
* Los valores utilizados en operaciones históricas no deberán depender del precio actual del producto.
* Un producto puede tener múltiples proveedores.

---

# 13. Servicio (Service)

Representa una actividad ofrecida por la papelería.

Ejemplos:

```text
Copias
Impresiones
Escaneos
Engargolados
Enmicados
```

Los servicios pueden configurarse sin modificar el código fuente.

Un servicio puede tener múltiples tarifas.

Los servicios pueden estar activos o inactivos.

---

# 14. Tarifa de servicio (ServiceRate)

Representa una tarifa utilizada para determinar el precio de un servicio.

## Información conceptual

* Servicio.
* Nombre de tarifa.
* Precio unitario.
* Configuración adicional.
* Estado.
* Fecha de creación.
* Fecha de modificación.

La configuración adicional puede representar condiciones específicas del servicio.

Por ejemplo:

```text
Tipo:
- Blanco y negro
- Color

Tamaño:
- Carta
- Oficio
```

Una tarifa pertenece a un servicio.

Un servicio puede tener múltiples tarifas.

---

# 15. Inventario (Inventory)

Representa el estado actual de las existencias de un producto.

Para cada producto se distinguen conceptualmente:

```text
Existencia física registrada
Existencia reservada
Existencia disponible
```

La existencia disponible corresponde a la cantidad registrada menos las unidades reservadas.

## Reglas

* Cada producto debe tener un registro de inventario.
* Un producto tiene un único inventario actual.
* La cantidad registrada no puede ser negativa.
* La cantidad reservada no puede ser negativa.
* La cantidad reservada no puede superar la existencia registrada.
* El inventario actual no sustituye el historial de movimientos.

---

# 16. Movimiento de inventario (InventoryMovement)

Representa una operación que modifica las existencias de un producto.

## Tipos conceptuales

```text
Entrada por compra
Salida por venta
Entrada por devolución
Salida por devolución a proveedor
Ajuste
Reserva
Liberación de reserva
```

## Información conceptual

* Producto.
* Tipo de movimiento.
* Cantidad.
* Referencia de la operación relacionada, cuando exista.
* Usuario responsable.
* Motivo.
* Observaciones.
* Fecha y hora.

Los movimientos de inventario son históricos y no deberán eliminarse físicamente.

Un movimiento puede estar relacionado con una venta, compra, devolución, apartado u otra operación según corresponda.

---

# 17. Incidencia de inventario (InventoryIncident)

Representa una diferencia o anomalía relacionada con las existencias.

Ejemplo:

```text
Existencia registrada: 20
Existencia física: 15
Diferencia: -5
```

## Información conceptual

* Producto.
* Existencia registrada al momento de la incidencia.
* Existencia física.
* Diferencia.
* Motivo.
* Estado.
* Usuario que reportó.
* Usuario que resolvió, cuando corresponda.
* Notas.
* Fecha de creación.
* Fecha de resolución.

## Reglas

* Una incidencia pertenece a un producto.
* Debe identificar al usuario que la reportó.
* Puede permanecer abierta.
* El usuario que resuelve puede ser diferente al usuario que reportó.
* Mientras permanezca abierta, la resolución puede no existir.

La incidencia no debe modificar silenciosamente el historial de movimientos.

---

# 18. Venta (Sale)

Representa una operación comercial mediante la cual se entregan productos y/o servicios a cambio de un pago.

## Estados

```text
EN PROCESO (DRAFT)
PENDIENTE DE PAGO (PENDING_PAYMENT)
COMPLETADA (COMPLETED)
CANCELADA (CANCELLED)
DEVOLUCIÓN PARCIAL (PARTIALLY_RETURNED)
DEVUELTA (RETURNED)
```

## Información conceptual

* Identificador.
* Cliente, si aplica.
* Usuario responsable.
* Estado.
* Subtotal.
* Descuento total.
* Impuestos.
* Total.
* Fecha de creación.
* Fecha de finalización.
* Fecha de cancelación.

## Reglas

* Una venta puede realizarse sin cliente.
* Una venta debe contener uno o más conceptos.
* Una venta puede contener productos y servicios.
* Una venta puede tener uno o varios pagos.
* Una venta completada no debe eliminarse.
* Una venta cancelada conserva su historial.
* Una devolución no elimina la venta original.

---

# 19. Detalle de venta (SaleItem)

Representa un producto o servicio incluido en una venta.

Un detalle de venta debe representar **exactamente uno** de los siguientes conceptos:

```text
Producto
o
Servicio
```

## Información conceptual

* Venta.
* Producto, cuando corresponda.
* Servicio, cuando corresponda.
* Descripción histórica.
* Cantidad.
* Precio unitario histórico.
* Descuento aplicado, cuando corresponda.
* Tipo de descuento.
* Valor del descuento.
* Importe del descuento.
* Impuesto.
* Subtotal.

## Regla

No puede existir simultáneamente un producto y un servicio en el mismo detalle.

```text
Producto → Sí
Servicio → No
```

o:

```text
Producto → No
Servicio → Sí
```

## Historial

El detalle conserva los valores utilizados en el momento de la venta.

Por ejemplo:

```text
Precio actual: $12
Precio utilizado en venta histórica: $10
```

La venta histórica continuará mostrando:

```text
$10
```

---

# 20. Método de pago (PaymentMethod)

Representa el medio mediante el cual se realiza un pago.

Actualmente contempla:

```text
Efectivo (CASH)
Tarjeta (CARD)
Transferencia (BANK_TRANSFER)
```

Los métodos de pago son configurables y pueden activarse o desactivarse.

El método de pago representa el medio utilizado y no la integración tecnológica utilizada para procesarlo.

---

# 21. Pago de venta (Payment)

Representa un importe recibido como consecuencia de una venta.

## Información conceptual

* Venta.
* Método de pago.
* Importe.
* Estado.
* Referencia externa, cuando corresponda.
* Usuario responsable.
* Fecha y hora.

## Estados

```text
PENDIENTE (PENDING)
CONFIRMADO (CONFIRMED)
RECHAZADO (REJECTED)
CANCELADO (CANCELLED)
```

Un pago pertenece a una venta.

Una venta puede tener múltiples pagos.

La referencia externa puede no existir, especialmente en pagos en efectivo.

---

# 22. Ticket (Ticket)

Representa el comprobante generado para una venta.

## Información conceptual

* Venta.
* Número de ticket.
* Fecha y hora de emisión.

Una venta puede tener como máximo un ticket.

Un ticket pertenece exclusivamente a una venta.

El ticket se genera como consecuencia de una venta correctamente registrada según las reglas del sistema.

---

# 23. Descuento (Discount)

Representa una configuración de descuento que puede aplicarse a un detalle de venta.

## Información conceptual

* Nombre.
* Tipo.
* Valor.
* Condiciones.
* Fecha de inicio.
* Fecha de finalización.
* Estado.
* Fecha de creación.
* Fecha de modificación.

## Reglas

* Un descuento puede aplicarse a múltiples detalles de venta.
* Un detalle de venta puede no tener descuento.
* El descuento configurado puede modificarse posteriormente.
* Modificar el descuento no debe alterar ventas históricas.
* El detalle de venta conserva el tipo y valor aplicados.
* Dos descuentos pueden tener el mismo valor y representar reglas diferentes.

Por ejemplo:

```text
Estudiante → 15%
Tercera edad → 15%
```

Son descuentos diferentes aunque compartan el mismo porcentaje.

---

# 24. Devolución (Return)

Representa una devolución total o parcial relacionada con una venta.

## Tipos

```text
Parcial (PARTIAL)
Total (TOTAL)
```

## Información conceptual

* Venta original.
* Usuario responsable.
* Tipo.
* Motivo.
* Total.
* Estado.
* Fecha y hora.

## Reglas

* Debe existir una venta original.
* Puede ser parcial o total.
* Una venta puede tener múltiples devoluciones.
* Una devolución no elimina la venta original.
* Las cantidades devueltas deben estar relacionadas con los detalles de venta originales.
* La devolución debe conservarse históricamente.
* La devolución debe generar los movimientos correspondientes de inventario.
* El reembolso deberá respetar las reglas del método de pago original.

---

# 25. Detalle de devolución (ReturnItem)

Representa una cantidad específica devuelta de un detalle de venta.

## Información conceptual

* Devolución.
* Detalle de venta original.
* Cantidad.
* Importe.

La relación con `SaleItem` permite determinar exactamente qué concepto de la venta está siendo devuelto.

## Regla

La cantidad acumulada devuelta de un detalle no puede superar la cantidad originalmente vendida.

```text
Cantidad devuelta acumulada
≤
Cantidad vendida
```

---

# 26. Apartado (Reservation)

Representa una operación mediante la cual un cliente reserva uno o varios productos para adquirirlos posteriormente.

## Información conceptual

* Cliente.
* Usuario responsable.
* Estado.
* Total.
* Importe pagado.
* Importe pendiente.
* Porcentaje mínimo aplicado.
* Porcentaje de retención por cancelación aplicado.
* Porcentaje de retención por vencimiento aplicado.
* Fecha de creación.
* Fecha de vencimiento.
* Fecha de liquidación.
* Fecha de cancelación.

## Reglas

* El cliente es obligatorio.
* Un cliente puede tener múltiples apartados.
* Un apartado debe tener fecha de vencimiento.
* Los productos apartados quedan reservados.
* Un apartado puede recibir múltiples pagos.
* Al liquidar el apartado, los productos pueden entregarse.
* Si el cliente cancela, se aplican las reglas configuradas.
* Si el apartado vence, se aplican las reglas configuradas.
* Los valores de configuración utilizados deben conservarse dentro del apartado.

---

# 27. Detalle de apartado (ReservationItem)

Representa un producto incluido en un apartado.

## Información conceptual

* Apartado.
* Producto.
* Cantidad.
* Precio unitario histórico.
* Subtotal.

## Reglas

* Un apartado contiene uno o más productos.
* La cantidad debe ser positiva.
* El precio utilizado al crear el apartado debe conservarse.
* Un cambio posterior del precio del producto no modifica el precio del apartado.

---

# 28. Pago de apartado (ReservationPayment)

Representa un pago realizado sobre un apartado.

Es un concepto independiente de `Payment`, debido a que los pagos de ventas y los pagos de apartados pertenecen a operaciones diferentes.

## Información conceptual

* Apartado.
* Método de pago.
* Importe.
* Estado.
* Referencia.
* Usuario responsable.
* Fecha y hora.

## Reglas

* Un apartado puede tener múltiples pagos.
* Cada pago pertenece a un único apartado.
* El importe debe ser positivo.
* Los pagos se conservan históricamente.
* El sistema debe poder determinar el importe total pagado y el saldo pendiente.

---

# 29. Configuración de apartados (ReservationConfiguration)

Representa las políticas vigentes para los apartados.

## Información conceptual

* Porcentaje mínimo.
* Días de vigencia.
* Porcentaje de retención por cancelación.
* Porcentaje de retención por vencimiento.
* Estado.
* Fecha de creación.
* Fecha de modificación.

## Reglas

La configuración es independiente de los apartados existentes.

No debe existir una dependencia histórica directa entre un apartado y la configuración actualmente activa.

Cuando se crea un apartado, los valores utilizados se copian conceptualmente como snapshots:

```text
minimum_percentage_applied
cancellation_retention_percentage_applied
expiration_retention_percentage_applied
```

Por lo tanto, si la configuración cambia:

```text
30% → 40%
```

un apartado existente que utilizó:

```text
30%
```

debe continuar conservando:

```text
30%
```

La configuración actual no modifica operaciones históricas.

---

# 30. Proveedor (Supplier)

Representa una persona o empresa que suministra productos a la papelería.

## Información conceptual

* Nombre.
* Teléfono.
* Correo.
* Dirección.
* Estado.
* Fecha de creación.
* Fecha de modificación.

Un proveedor puede suministrar múltiples productos.

Un producto puede adquirirse de múltiples proveedores.

La relación N:M se representa mediante `ProductSupplier`.

---

# 31. Relación producto-proveedor (ProductSupplier)

Representa la relación comercial entre un producto y un proveedor.

## Información conceptual

* Producto.
* Proveedor.
* Código del producto utilizado por el proveedor.
* Último precio de compra conocido.
* Estado.

## Reglas

* Un producto puede tener múltiples proveedores.
* Un proveedor puede ofrecer múltiples productos.
* La relación puede activarse o desactivarse.
* El último precio conocido no sustituye el costo histórico registrado en las compras.

---

# 32. Compra (Purchase)

Representa una adquisición de mercancía a un proveedor.

## Estados

```text
BORRADOR (DRAFT)
SOLICITADA (ORDERED)
RECIBIDA PARCIALMENTE (PARTIALLY_RECEIVED)
RECIBIDA (RECEIVED)
CANCELADA (CANCELLED)
```

## Información conceptual

* Proveedor.
* Usuario responsable.
* Estado.
* Subtotal.
* Total.
* Fecha de pedido.
* Fecha de recepción.
* Fecha de creación.

## Reglas

* Una compra pertenece a un proveedor.
* Una compra contiene uno o más productos.
* Debe conservarse el costo histórico de cada producto.
* La cantidad solicitada y la cantidad recibida deben distinguirse.
* Las diferencias de recepción pueden generar incidencias.
* Las compras históricas deben conservarse.

---

# 33. Detalle de compra (PurchaseItem)

Representa un producto incluido en una compra.

## Información conceptual

* Compra.
* Producto.
* Cantidad solicitada.
* Cantidad recibida.
* Costo unitario histórico.
* Subtotal.

## Reglas

La cantidad solicitada debe ser positiva.

La cantidad recibida puede ser cero cuando todavía no se haya recibido mercancía.

El costo unitario utilizado en la compra debe conservarse aunque posteriormente cambie el costo actual del producto.

---

# 34. Incidencia de compra (PurchaseIncident)

Representa un problema detectado durante la recepción de mercancía.

## Tipos

```text
Faltante (MISSING)
Daño (DAMAGED)
Producto incorrecto (WRONG_PRODUCT)
Cantidad incorrecta (WRONG_QUANTITY)
Otro (OTHER)
```

## Información conceptual

* Compra.
* Detalle de compra.
* Tipo.
* Cantidad afectada.
* Descripción.
* Resolución.
* Estado.
* Fecha de creación.
* Fecha de resolución.

## Reglas

* Una incidencia pertenece a una compra.
* Una incidencia identifica el detalle de compra afectado.
* Una incidencia puede permanecer pendiente.
* La resolución puede no existir mientras la incidencia esté pendiente.
* Las incidencias forman parte del historial de la compra.

---

# 35. Caja (CashRegister)

Representa una caja utilizada para registrar operaciones económicas.

## Estados

```text
ABIERTA (OPEN)
CERRADA (CLOSED)
```

## Información conceptual

* Usuario responsable.
* Estado.
* Monto inicial.
* Fecha y hora de apertura.
* Fecha y hora de cierre.

Una caja pertenece al usuario que la abrió/responsable de la operación de caja.

Una caja puede tener múltiples movimientos.

Una caja puede tener uno o varios cortes según las reglas operativas definidas.

---

# 36. Movimiento de caja (CashMovement)

Representa una entrada o salida económica registrada en una caja.

## Tipos

```text
Venta (SALE)
Devolución (REFUND)
Ingreso (INCOME)
Egreso (EXPENSE)
Ajuste (ADJUSTMENT)
```

## Información conceptual

* Caja.
* Tipo.
* Importe.
* Referencia de la operación relacionada, cuando exista.
* Usuario responsable.
* Descripción.
* Fecha y hora.

## Reglas

* Los movimientos de caja deben conservarse.
* Los movimientos relacionados con operaciones deben poder identificar su referencia.
* Los ingresos y egresos manuales deben registrar descripción y usuario responsable.

---

# 37. Corte de caja (CashClosing)

Representa la conciliación de una caja.

## Información conceptual

* Caja.
* Usuario responsable.
* Monto esperado.
* Monto contado.
* Diferencia.
* Observaciones.
* Fecha y hora.

## Reglas

* Las diferencias deben conservarse.
* El usuario responsable debe quedar registrado.
* El corte no debe eliminarse físicamente.
* Las observaciones deben conservarse cuando existan.

---

# 38. Factura (Invoice)

Representa un documento fiscal asociado a una venta.

La emisión es realizada mediante un proveedor externo.

## Estados

```text
PENDIENTE (PENDING)
PROCESANDO (PROCESSING)
EMITIDA (ISSUED)
ERROR (FAILED)
CANCELADA (CANCELLED)
```

## Información conceptual

* Venta.
* Datos fiscales utilizados.
* Proveedor de facturación.
* Identificador externo.
* Estado.
* Fecha de emisión.
* Mensaje de error.
* Fecha de creación.
* Fecha de modificación.

## Reglas

* Una factura pertenece a una venta.
* Una factura debe identificar los datos fiscales utilizados.
* La factura puede permanecer pendiente.
* Una falla del proveedor externo no debe impedir completar la venta.
* La factura podrá procesarse posteriormente.
* El proveedor externo específico no pertenece al dominio.

Flujo:

```text
Venta
  ↓
Pago
  ↓
Venta completada
  ↓
Factura pendiente
  ↓
Proveedor disponible
  ↓
Factura emitida
```

---

# 39. Interés por producto (ProductInterest)

Representa el interés de una persona por adquirir un producto.

El interés puede existir aunque:

* La persona no sea un cliente registrado.
* El producto todavía no exista en el catálogo.

## Información conceptual

* Cliente, cuando exista.
* Producto, cuando exista.
* Nombre solicitado.
* Notas.
* Estado.
* Fecha de creación.

## Reglas

`customer` puede no existir.

`product` puede no existir.

Por lo tanto, ambos pueden estar ausentes simultáneamente.

Si el cliente está registrado, el interés deberá formar parte de su historial.

Si el producto existe, el interés podrá relacionarse con él.

---

# 40. Configuración del negocio (BusinessConfiguration)

Representa configuraciones generales del sistema que no requieren una entidad de dominio independiente.

## Información conceptual

* Clave.
* Valor.
* Tipo de dato.
* Descripción.
* Usuario que realizó la última modificación.
* Fecha de modificación.

La configuración se administra mediante pares:

```text
key
value
data_type
```

## Regla importante

`BusinessConfiguration` **no deberá utilizarse para sustituir entidades que requieran relaciones propias**.

Por ejemplo, no deberá utilizarse para almacenar:

```text
Productos
Descuentos
Apartados
Tarifas de servicios
Métodos de pago
```

cuando estos conceptos requieren información estructurada y relaciones propias.

Las configuraciones administrativas relevantes deberán quedar auditadas.

---

# 41. Registro de auditoría (AuditRecord)

Representa el historial de una acción o modificación relevante.

## Información conceptual

* Usuario responsable.
* Acción.
* Tipo de entidad.
* Identificador de la entidad.
* Valor anterior.
* Valor nuevo.
* Motivo.
* Fecha y hora.

## Operaciones auditables

Como mínimo:

* Ventas.
* Cancelaciones.
* Devoluciones.
* Pagos.
* Modificaciones de inventario.
* Cambios de precios.
* Descuentos.
* Compras.
* Incidencias.
* Operaciones de caja.
* Cambios de configuración.
* Gestión de usuarios.
* Acceso o modificación de información sensible.

Los registros de auditoría no deben eliminarse físicamente.

---

# 42. Relaciones principales del dominio

## Seguridad

```text
Usuario 1 ─────────── 0..* Usuario-Rol
Rol 1 ─────────────── 0..* Usuario-Rol

Rol 1 ─────────────── 0..* Rol-Permiso
Permiso 1 ─────────── 0..* Rol-Permiso
```

Estas relaciones permiten implementar:

```text
Usuario N:M Rol
Rol N:M Permiso
```

---

## Clientes

```text
Cliente 1 ─────────── 0..* Datos fiscales
Cliente 1 ─────────── 0..* Venta
Cliente 1 ─────────── 0..* Apartado
Cliente 1 ─────────── 0..* Interés por producto
```

Una venta puede existir sin cliente.

---

## Catálogo

```text
Categoría 1 ───────── 0..* Producto
Marca 1 ───────────── 0..* Producto
Servicio 1 ────────── 0..* Tarifa de servicio
```

Un producto puede no tener marca.

---

## Inventario

```text
Producto 1 ─────────── 1 Inventario
Producto 1 ─────────── 0..* Movimiento de inventario
Producto 1 ─────────── 0..* Incidencia de inventario
```

---

## Ventas

```text
Venta 1 ────────────── 1..* Detalle de venta
Venta 1 ────────────── 0..* Pago
Venta 1 ────────────── 0..1 Ticket
Venta 1 ────────────── 0..* Devolución
Venta 1 ────────────── 0..* Factura
```

---

## Detalle de venta

```text
Producto 1 ─────────── 0..* Detalle de venta
Servicio 1 ─────────── 0..* Detalle de venta
Descuento 1 ────────── 0..* Detalle de venta
```

Cada detalle de venta debe referenciar exactamente un:

```text
Producto
```

o:

```text
Servicio
```

---

## Pagos

```text
Método de pago 1 ──── 0..* Pago
Método de pago 1 ──── 0..* Pago de apartado
```

---

## Devoluciones

```text
Devolución 1 ───────── 1..* Detalle de devolución
Detalle de venta 1 ── 0..* Detalle de devolución
```

---

## Apartados

```text
Apartado 1 ─────────── 1..* Detalle de apartado
Apartado 1 ─────────── 0..* Pago de apartado
Producto 1 ─────────── 0..* Detalle de apartado
```

La configuración de apartados es independiente:

```text
Configuración de apartados
          │
          │ valores aplicados al crear
          ▼
      Apartado
```

Los valores utilizados se conservan como snapshots dentro del apartado.

No existe una relación histórica directa con la configuración actual.

---

## Proveedores y compras

```text
Proveedor 1 ────────── 0..* Compra

Compra 1 ───────────── 1..* Detalle de compra
Compra 1 ───────────── 0..* Incidencia de compra
Detalle de compra 1 ── 0..* Incidencia de compra
```

Relación producto-proveedor:

```text
Producto 0..* ──────── 0..* Proveedor
           mediante
       ProductSupplier
```

---

## Caja

```text
Usuario 1 ──────────── 0..* Caja
Caja 1 ─────────────── 0..* Movimiento de caja
Caja 1 ─────────────── 0..* Corte de caja
Usuario 1 ──────────── 0..* Movimiento de caja
Usuario 1 ──────────── 0..* Corte de caja
```

---

## Facturación

```text
Datos fiscales 1 ───── 0..* Factura
Venta 1 ─────────────── 0..* Factura
```

---

## Auditoría

```text
Usuario 1 ──────────── 0..* Registro de auditoría
```

La entidad auditada se identifica mediante:

```text
entity_type
entity_id
```

por lo que la auditoría puede abarcar múltiples conceptos del dominio.

---

# 43. Reglas de integridad del dominio

## 43.1 Venta

Una venta completada debe:

* Contener al menos un concepto.
* Tener pagos confirmados suficientes según las reglas de pago.
* Conservar sus precios históricos.
* Conservar los descuentos utilizados.
* Generar los movimientos correspondientes de inventario para productos.
* Generar los movimientos correspondientes de caja cuando corresponda.
* Identificar al usuario responsable.
* Conservar su historial.

---

## 43.2 Detalle de venta

Cada detalle debe representar exactamente uno de:

```text
Producto
Servicio
```

Nunca ambos.

Los valores históricos deben conservarse directamente en el detalle:

```text
Descripción
Precio unitario
Descuento
Impuesto
Subtotal
```

---

## 43.3 Inventario

Una venta normal no deberá permitir vender una cantidad superior a la existencia disponible.

La existencia disponible se obtiene conceptualmente de:

```text
Existencia
-
Existencia reservada
```

Cuando exista una discrepancia física, deberá registrarse una incidencia.

El historial de movimientos no deberá modificarse silenciosamente.

---

## 43.4 Devoluciones

La cantidad acumulada devuelta de un detalle de venta no puede superar la cantidad originalmente vendida.

```text
Cantidad devuelta acumulada
≤
Cantidad vendida
```

La devolución genera nuevos registros y no modifica ni elimina la venta original.

---

## 43.5 Apartados

Un apartado debe:

* Tener un cliente registrado.
* Contener uno o más productos.
* Tener fecha de vencimiento.
* Conservar el precio utilizado.
* Conservar los porcentajes de configuración aplicados.
* Permitir múltiples pagos.
* Mantener el saldo pendiente.
* Mantener las unidades reservadas correspondientes.

---

## 43.6 Historial de precios y costos

Los cambios actuales no deben alterar operaciones históricas.

Se conservarán snapshots en:

```text
sale_item.unit_price
sale_item.discount_value
sale_item.discount_amount

reservation.minimum_percentage_applied
reservation.cancellation_retention_percentage_applied
reservation.expiration_retention_percentage_applied

reservation_item.unit_price

purchase_item.unit_cost
```

Por ejemplo:

```text
Precio actual del producto: $12
Precio utilizado en una venta anterior: $10
```

La venta continuará conservando:

```text
$10
```

---

## 43.7 Configuración

Las configuraciones actuales pueden modificarse.

Sin embargo:

```text
Configuración actual
        +
Valor aplicado históricamente
        +
Auditoría de cambios
```

deben mantenerse separados.

Una modificación de:

```text
discount.value
```

no debe modificar:

```text
sale_item.discount_value
```

de ventas anteriores.

De igual forma, modificar:

```text
reservation_configuration.minimum_percentage
```

no modifica:

```text
reservation.minimum_percentage_applied
```

de apartados existentes.

---

## 43.8 Caja

Cada movimiento económico deberá poder relacionarse con su operación correspondiente cuando aplique.

Ejemplo:

```text
Venta
  ↓
Pago
  ↓
Movimiento de caja
```

o:

```text
Devolución
  ↓
Reembolso
  ↓
Movimiento de caja
```

Los ingresos y egresos manuales deberán identificar al usuario responsable y conservar una descripción.

---

## 43.9 Auditoría

Las operaciones críticas deberán conservar:

```text
Quién
Qué hizo
Cuándo
Sobre qué entidad
Qué valor existía antes
Qué valor quedó después
Por qué
```

Los registros de auditoría no deberán eliminarse físicamente.

---

# 44. Historial y persistencia

El dominio distingue tres mecanismos de conservación.

## 44.1 Snapshot

El snapshot conserva el valor que realmente fue utilizado por una operación.

Ejemplos:

```text
sale_item.unit_price
sale_item.discount_value
sale_item.discount_amount

reservation.minimum_percentage_applied
reservation.cancellation_retention_percentage_applied
reservation.expiration_retention_percentage_applied

reservation_item.unit_price

purchase_item.unit_cost
```

---

## 44.2 Historial operativo

Las operaciones realizadas forman parte del historial del negocio.

Entre ellas:

```text
Sale
Payment
Return
Reservation
ReservationPayment
Purchase
InventoryMovement
CashMovement
CashClosing
```

Estas operaciones no deberán eliminarse físicamente como mecanismo normal de corrección.

---

## 44.3 Auditoría

Los cambios administrativos relevantes se registran mediante:

```text
AuditRecord
```

Esto permite responder:

```text
¿Qué ocurrió?
        ↓
Operación histórica

¿Qué valor se utilizó?
        ↓
Snapshot

¿Quién modificó una configuración?
        ↓
Auditoría
```

---

# 45. Integraciones externas

El dominio no deberá depender directamente de proveedores externos.

Las siguientes capacidades pueden integrarse mediante adaptadores:

```text
Facturación
Pagos con tarjeta
Transferencias
Correo electrónico
```

La arquitectura conceptual será:

```text
Dominio
   │
   ▼
Servicio de aplicación
   │
   ▼
Adaptador externo
   │
   ├── Proveedor de facturación
   ├── Terminal de pago
   └── Servicio de correo
```

El proveedor específico será una decisión técnica posterior.

---

# 46. Evolución hacia múltiples sucursales

Actualmente el modelo contempla una única sucursal.

No se incorpora todavía una entidad:

```text
Branch
```

ni se agregan relaciones artificiales para anticipar esta capacidad.

Sin embargo, el diseño deberá evitar acoplamientos que hagan imposible posteriormente incorporar:

* Sucursales.
* Inventarios por sucursal.
* Cajas por sucursal.
* Operaciones por sucursal.
* Usuarios asociados a sucursales.

La incorporación de múltiples sucursales será una decisión arquitectónica posterior y deberá documentarse mediante ADR.

---

# 47. Conceptos deliberadamente fuera del modelo persistente actual

Los siguientes elementos no forman parte de las entidades persistentes actuales:

* Tabla `Business`.
* Tabla `Branch`.
* Entidad persistente de operación offline.
* Proveedor específico de facturación.
* Proveedor específico de pagos.
* Terminal de pago específica.
* DTOs.
* Endpoints.
* Controladores.
* Repositorios.
* Claves primarias físicas.
* Índices físicos.
* Migraciones.
* Frameworks.
* Tecnología de frontend.

El modelo de dominio define los conceptos y reglas del negocio.

El Data Dictionary define posteriormente la estructura persistente de esos conceptos.

---

# 48. Trazabilidad

| Necesidad                  | Conceptos principales                                           |
| -------------------------- | --------------------------------------------------------------- |
| Registrar venta            | Venta, Detalle de venta, Producto, Servicio, Pago, Ticket       |
| Consultar producto         | Producto, Categoría, Marca, Inventario                          |
| Alertar bajo stock         | Producto, Inventario                                            |
| Registrar interés          | Interés por producto, Cliente, Producto                         |
| Registrar cliente          | Cliente, Datos fiscales                                         |
| Registrar pago             | Pago, Método de pago                                            |
| Cancelar venta             | Venta, Auditoría, Movimiento de inventario                      |
| Devolver productos         | Devolución, Detalle de devolución, Detalle de venta, Inventario |
| Registrar apartado         | Apartado, Detalle de apartado, Cliente                          |
| Realizar pagos parciales   | Pago de apartado                                                |
| Cancelar apartado          | Apartado, Pago de apartado, Configuración de apartados          |
| Vencer apartado            | Apartado, Configuración de apartados                            |
| Registrar compra           | Compra, Detalle de compra, Proveedor                            |
| Recibir mercancía          | Compra, Inventario, Movimiento de inventario                    |
| Registrar incidencia       | Incidencia de compra / Incidencia de inventario                 |
| Registrar servicios        | Servicio, Tarifa de servicio                                    |
| Aplicar descuentos         | Descuento, Detalle de venta                                     |
| Registrar ingresos/egresos | Movimiento de caja                                              |
| Realizar corte             | Caja, Corte de caja                                             |
| Facturar                   | Factura, Datos fiscales, Venta                                  |
| Gestionar usuarios         | Usuario, Rol, Permiso                                           |
| Auditar operaciones        | Registro de auditoría                                           |

---

# 49. Correspondencia con el modelo de datos

Los conceptos persistentes principales del dominio corresponden a las siguientes estructuras:

```text
Seguridad
├── user
├── role
├── permission
├── user_role
└── role_permission

Clientes
├── customer
└── fiscal_data

Catálogo
├── category
├── brand
├── product
├── service
├── service_rate
└── discount

Inventario
├── inventory
├── inventory_movement
└── inventory_incident

Ventas
├── sale
├── sale_item
├── payment
├── payment_method
├── ticket
├── return
└── return_item

Apartados
├── reservation
├── reservation_item
├── reservation_payment
└── reservation_configuration

Compras
├── supplier
├── product_supplier
├── purchase
├── purchase_item
└── purchase_incident

Caja
├── cash_register
├── cash_movement
└── cash_closing

Facturación
└── invoice

Intereses y configuración
├── product_interest
└── business_configuration

Auditoría
└── audit_record
```

Esta correspondencia debe mantenerse alineada con el Data Dictionary definitivo.

---

# 50. Resumen del modelo

```text
CONTEXTO DEL NEGOCIO
│
├── Seguridad
│   ├── Usuarios
│   ├── Roles
│   └── Permisos
│
├── Clientes
│   ├── Datos fiscales
│   ├── Ventas
│   ├── Apartados
│   └── Intereses por productos
│
├── Catálogo
│   ├── Productos
│   │   ├── Categoría
│   │   ├── Marca
│   │   ├── Inventario
│   │   └── Proveedores
│   │
│   └── Servicios
│       └── Tarifas
│
├── Ventas
│   ├── Detalles
│   ├── Pagos
│   ├── Tickets
│   ├── Descuentos
│   ├── Devoluciones
│   └── Facturas
│
├── Apartados
│   ├── Detalles
│   ├── Pagos
│   └── Configuración
│
├── Compras
│   ├── Proveedores
│   ├── Detalles
│   └── Incidencias
│
├── Inventario
│   ├── Existencias
│   ├── Movimientos
│   └── Incidencias
│
├── Caja
│   ├── Movimientos
│   └── Cortes
│
├── Configuración
│
└── Auditoría
```

Este modelo constituye la base conceptual para el modelo entidad-relación y mantiene su estructura alineada con el **Data Dictionary definitivo**.

El Data Dictionary será la referencia para determinar las estructuras persistentes, relaciones, restricciones y campos concretos de la base de datos.
