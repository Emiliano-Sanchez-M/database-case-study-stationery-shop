# Modelo de Dominio

## 1. Propósito

Este documento define el modelo de dominio del sistema de gestión para una papelería.

El modelo representa los principales conceptos del negocio, sus responsabilidades, relaciones y reglas de integridad.

Su propósito es servir como puente entre los requisitos y casos de uso definidos previamente y el diseño técnico posterior.

Este documento será utilizado como referencia para:

* Diseño del modelo de datos.
* Diseño de entidades y objetos de dominio.
* Diseño de servicios de aplicación.
* Diseño de API.
* Implementación de casos de uso.
* Definición de reglas de negocio.
* Diseño de auditoría e historial.

El modelo de dominio **no representa todavía tablas de base de datos**. Los nombres en inglés incluidos entre paréntesis representan los nombres técnicos propuestos para su posterior implementación.

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

El modelo deberá mantenerse alineado con estos documentos.

Cuando una decisión posterior modifique una regla o concepto del dominio, deberá actualizarse la documentación correspondiente y, cuando aplique, registrarse mediante un ADR.

---

# 3. Principios del dominio

El sistema deberá preservar principalmente cuatro propiedades:

1. **Las ventas no deben perderse.**
2. **El inventario debe ser confiable.**
3. **Los ingresos y egresos deben ser confiables.**
4. **Debe ser posible identificar quién realizó o modificó una operación.**

A partir de estos principios:

* Las operaciones históricas no deberán eliminarse físicamente.
* Las modificaciones importantes deberán conservar historial.
* Las operaciones críticas deberán identificar al usuario responsable.
* Los precios históricos deberán conservarse.
* Los movimientos de inventario deberán conservarse.
* Las operaciones de caja deberán conservarse.
* Las ventas canceladas deberán conservar su registro.
* Las devoluciones deberán relacionarse con la venta original.
* Las operaciones realizadas sin conexión deberán poder sincronizarse posteriormente.

---

# 4. Vista general del dominio

El dominio se organiza principalmente en los siguientes grupos:

```text
                    NEGOCIO
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
     Usuarios      Catálogo       Clientes
        │              │              │
        │              │              ├── Ventas
        │              │              └── Apartados
        │              │
        │              └── Inventario
        │
        └── Auditoría

     Proveedores
          │
          └── Compras
                │
                └── Inventario

     Ventas
        │
        ├── Productos / Servicios
        ├── Pagos
        ├── Facturación
        └── Devoluciones

     Apartados
        │
        ├── Productos
        ├── Pagos
        └── Devoluciones / Saldos

     Caja
        │
        ├── Ingresos
        ├── Egresos
        └── Corte de caja

     Configuración
        │
        ├── Inventario
        ├── Servicios
        ├── Descuentos
        ├── Pagos
        └── Apartados
```

---

# 5. Negocio (Business)

Representa la papelería que utiliza el sistema.

## Responsabilidad

El negocio es el contexto principal dentro del cual existen:

* Usuarios.
* Clientes.
* Productos.
* Servicios.
* Proveedores.
* Ventas.
* Compras.
* Inventario.
* Cajas.
* Configuraciones.

## Consideraciones

Actualmente el sistema contempla una única sucursal.

Sin embargo, el modelo deberá evitar decisiones que impidan posteriormente incorporar múltiples sucursales.

---

# 6. Usuario (User)

Representa a una persona autorizada para utilizar el sistema administrativo.

## Información conceptual

* Identificador.
* Nombre.
* Nombre de usuario.
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

* Cada trabajador deberá poder tener su propio usuario.
* Un usuario inactivo no podrá realizar nuevas operaciones.
* Un usuario podrá volver a activarse.
* Las operaciones relevantes deberán identificar al usuario que las realizó.

---

# 7. Rol (Role)

Representa un conjunto de permisos asignados a un usuario.

Ejemplos conceptuales:

```text
Cajero
Encargado de inventario
Administrador
Gerente
Propietario
```

Los roles deberán poder adaptarse a las responsabilidades reales del negocio.

---

# 8. Permiso (Permission)

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

Por ejemplo, un cajero podrá registrar ventas sin tener permiso para modificar precios o existencias.

---

# 9. Cliente (Customer)

Representa a una persona o entidad que adquiere productos o servicios.

## Características

Un cliente puede:

* Comprar productos.
* Contratar servicios.
* Solicitar facturas.
* Realizar apartados.
* Realizar múltiples pagos sobre un apartado.
* Tener historial comercial.

## Regla

No es obligatorio registrar al cliente para realizar una venta normal.

Sin embargo, ciertas operaciones requieren que exista un cliente registrado, especialmente los apartados.

---

# 10. Datos fiscales (FiscalData)

Representan la información fiscal proporcionada por un cliente para emitir facturas.

## Información conceptual

Puede incluir:

* Identificador fiscal.
* Nombre o razón social.
* Régimen fiscal.
* Código postal.
* Uso fiscal.
* Información necesaria para facturación.

## Reglas

* El acceso debe estar restringido.
* El cliente debe autorizar su conservación cuando corresponda.
* Los cambios deberán quedar registrados cuando sean relevantes.

---

# 11. Producto (Product)

Representa un artículo físico que la papelería comercializa.

## Información conceptual

* Identificador.
* Nombre.
* Código de producto.
* Código de barras.
* Descripción.
* Marca.
* Categoría.
* Precio de venta.
* Costo.
* Nivel de alerta de existencias.
* Estado.

## Reglas

* Cada producto puede tener un nivel de alerta diferente.
* El nivel de alerta debe poder modificarse desde el sistema.
* El precio debe ser configurable.
* Los cambios de precio deben conservar historial.
* El producto debe estar relacionado con sus movimientos de inventario.

---

# 12. Categoría (Category)

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

Las categorías deberán poder administrarse desde el sistema.

---

# 13. Marca (Brand)

Representa la marca comercial de un producto.

Una marca puede estar asociada a múltiples productos.

---

# 14. Servicio (Service)

Representa una actividad que la papelería ofrece al cliente.

Ejemplos:

```text
Copias
Impresiones
Escaneos
Engargolados
Enmicados
```

## Regla

Los servicios deben poder registrarse y configurarse desde el sistema sin modificar el código fuente.

Por ejemplo, el negocio deberá poder crear posteriormente:

```text
Impresión fotográfica
```

y configurar su precio desde el sistema.

---

# 15. Tarifa de servicio (ServiceRate)

Representa el precio y las condiciones utilizadas para calcular el costo de un servicio.

Por ejemplo, una impresión puede depender de:

```text
Tipo:
- Blanco y negro
- Color

Tamaño:
- Carta
- Oficio

Cantidad:
- Número de páginas
```

Las reglas de cálculo deberán ser configurables.

---

# 16. Inventario (Inventory)

Representa las existencias de los productos.

Para cada producto se deberá poder distinguir conceptualmente:

```text
Existencia física
Existencia reservada
Existencia disponible
```

La existencia disponible deberá considerar las unidades comprometidas en apartados.

## Regla

El inventario debe poder explicar cómo se llegó a una existencia determinada mediante sus movimientos históricos.

---

# 17. Movimiento de inventario (InventoryMovement)

Representa cualquier operación que afecte las existencias de un producto.

## Tipos

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
* Fecha y hora.
* Usuario.
* Operación relacionada.
* Motivo.
* Observaciones.

## Regla

Los movimientos de inventario no deberán eliminarse físicamente.

---

# 18. Incidencia de inventario (InventoryIncident)

Representa una diferencia, anomalía o problema relacionado con las existencias.

### Ejemplo

El sistema indica:

```text
20 unidades
```

pero físicamente existen:

```text
15 unidades
```

La diferencia debe poder registrarse como una incidencia.

## Información

* Producto.
* Existencia registrada.
* Existencia física.
* Diferencia.
* Fecha.
* Usuario que reportó.
* Motivo.
* Observaciones.
* Resolución.
* Usuario que resolvió.

---

# 19. Venta (Sale)

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
* Número de venta.
* Fecha y hora.
* Cliente, si aplica.
* Usuario.
* Conceptos vendidos.
* Descuentos.
* Total.
* Estado.
* Pagos.

## Flujo principal

```text
En proceso
    ↓
Pendiente de pago
    ↓
Completada
```

Una venta completada no deberá eliminarse.

---

# 20. Detalle de venta (SaleItem)

Representa un producto o servicio incluido en una venta.

## Información

* Producto o servicio.
* Descripción.
* Cantidad.
* Precio unitario.
* Descuento.
* Impuestos, cuando correspondan.
* Subtotal.

## Regla de historial

El detalle debe conservar los valores utilizados en el momento de la venta.

Ejemplo:

```text
Producto: Pluma azul

Precio actual: $12

Precio registrado en una venta anterior: $10
```

La venta histórica debe continuar mostrando:

```text
$10
```

aunque posteriormente el producto tenga un precio de $12.

---

# 21. Ticket (Ticket)

Representa el comprobante generado después de registrar correctamente el pago de una venta.

## Información

* Número de ticket.
* Venta asociada.
* Fecha y hora.
* Conceptos.
* Cantidades.
* Precios.
* Descuentos.
* Total.
* Forma de pago.

## Regla

El ticket se genera después de registrar el pago de la venta.

---

# 22. Pago (Payment)

Representa un importe recibido como consecuencia de una operación.

Puede estar relacionado con:

* Una venta.
* Un apartado.

## Información

* Identificador.
* Importe.
* Forma de pago.
* Fecha y hora.
* Usuario.
* Estado.
* Referencia.

## Estados

```text
PENDIENTE (PENDING)
CONFIRMADO (CONFIRMED)
RECHAZADO (REJECTED)
CANCELADO (CANCELLED)
```

---

# 23. Forma de pago (PaymentMethod)

Representa el medio utilizado para realizar un pago.

Actualmente contempla:

```text
Efectivo (CASH)
Tarjeta (CARD)
Transferencia (BANK_TRANSFER)
```

Las formas de pago deberán ser configurables.

## Consideración

La integración con terminales de pago podrá complementar el registro de pagos con tarjeta.

El dominio deberá mantener separado el concepto de:

```text
Forma de pago
```

de:

```text
Integración externa de pago
```

para no depender de un proveedor específico.

---

# 24. Devolución (Return)

Representa la devolución total o parcial de productos pertenecientes a una venta.

## Tipos

```text
Parcial (PARTIAL)
Total (TOTAL)
```

## Reglas

* Debe existir una venta original.
* Puede devolver solamente algunos productos.
* La cantidad devuelta no puede superar la cantidad originalmente vendida menos las cantidades previamente devueltas.
* La devolución no elimina la venta original.
* La devolución debe conservar su relación con la venta.
* El dinero deberá devolverse mediante el mismo método utilizado para el pago original.
* Las devoluciones deben quedar auditadas.

---

# 25. Detalle de devolución (ReturnItem)

Representa un producto específico incluido en una devolución.

## Información

* Producto.
* Venta original.
* Cantidad.
* Importe.
* Motivo.

---

# 26. Apartado (Reservation)

Representa una operación mediante la cual un cliente reserva uno o varios productos para adquirirlos posteriormente.

## Reglas principales

* El cliente debe estar registrado.
* Puede existir más de un apartado simultáneamente.
* El apartado debe tener una fecha de vencimiento.
* Debe existir un anticipo mínimo configurable.
* El cliente puede realizar múltiples pagos.
* Los productos apartados quedan reservados.
* Al liquidar el apartado, los productos se entregan.
* Si el cliente cancela, se aplican las reglas de devolución configuradas.
* Si vence el plazo, se aplican las reglas de vencimiento configuradas.

---

# 27. Configuración de apartados (ReservationConfiguration)

Las políticas de apartados no deberán estar codificadas como valores fijos.

Deberán poder configurarse desde el sistema:

* Porcentaje mínimo para apartar.
* Duración máxima.
* Porcentaje a conservar por cancelación dentro del plazo.
* Porcentaje a conservar por vencimiento.
* Reglas de devolución.

### Ejemplo

Una configuración podría establecer:

```text
Anticipo mínimo: 30%

Cancelación dentro del plazo:
15% del total conservado

Vencimiento:
30% del total conservado
```

Pero otra papelería podría configurar:

```text
Anticipo mínimo: 40%

Cancelación:
5% conservado

Vencimiento:
20% conservado
```

Los porcentajes son configuraciones del negocio, no reglas rígidas del dominio.

---

# 28. Detalle de apartado (ReservationItem)

Representa un producto incluido en un apartado.

## Información

* Producto.
* Cantidad.
* Precio al momento de apartar.
* Subtotal.

El precio deberá conservarse aunque posteriormente cambie el precio del producto.

---

# 29. Pago de apartado (ReservationPayment)

Representa un pago realizado sobre un apartado.

Permite registrar múltiples pagos.

### Ejemplo

```text
Total del apartado: $1,000

Primer pago: $300
Segundo pago: $200
Tercer pago: $500

Total pagado: $1,000
```

El sistema deberá calcular automáticamente:

```text
Total pagado
Saldo pendiente
Importe sujeto a devolución
Importe conservado
```

según el estado y las reglas configuradas.

---

# 30. Interés por producto (ProductInterest)

Representa el interés de un cliente por adquirir un producto que no está disponible o que aún no se encuentra registrado.

## Información

* Producto, si existe.
* Descripción solicitada.
* Cliente, si está registrado.
* Fecha.
* Usuario.
* Observaciones.
* Estado.

## Regla

El registro no deberá depender de que el cliente esté previamente registrado.

Si el cliente está registrado, el interés deberá quedar asociado a su historial.

---

# 31. Proveedor (Supplier)

Representa una persona o empresa que suministra productos a la papelería.

## Información

* Nombre.
* Datos de contacto.
* Estado.
* Condiciones comerciales.
* Observaciones.

Un proveedor puede ofrecer múltiples productos.

Un producto puede adquirirse de múltiples proveedores.

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

## Información

* Proveedor.
* Fecha.
* Productos.
* Cantidades.
* Precios.
* Estado.
* Incidencias.

---

# 33. Detalle de compra (PurchaseItem)

Representa un producto incluido en una compra.

## Información

* Producto.
* Cantidad solicitada.
* Cantidad recibida.
* Precio de compra.
* Subtotal.

Esto permite detectar diferencias entre:

```text
Cantidad solicitada
```

y:

```text
Cantidad recibida
```

---

# 34. Incidencia de compra (PurchaseIncident)

Representa un problema detectado al recibir mercancía.

## Tipos

```text
Faltante (MISSING)
Daño (DAMAGED)
Producto incorrecto (WRONG_PRODUCT)
Cantidad incorrecta (WRONG_QUANTITY)
Otro (OTHER)
```

## Posibles resoluciones

```text
Reposición (REPLACEMENT)
Devolución (RETURN)
Nota de crédito (CREDIT_NOTE)
Ajuste (ADJUSTMENT)
```

La incidencia deberá conservarse como parte del historial de la compra.

---

# 35. Descuento (Discount)

Representa una reducción aplicada al precio de una operación.

## Información

* Tipo.
* Valor.
* Condiciones.
* Vigencia.
* Usuario que lo aplicó.
* Cliente o condición aplicable.

Los descuentos deberán ser configurables.

Las operaciones de descuento relevantes deberán quedar auditadas.

---

# 36. Caja (CashRegister)

Representa una caja utilizada para registrar operaciones económicas durante una jornada.

## Estados

```text
ABIERTA (OPEN)
CERRADA (CLOSED)
```

## Información

* Identificador.
* Usuario responsable.
* Fecha de apertura.
* Fecha de cierre.
* Saldo inicial.
* Estado.

---

# 37. Movimiento de caja (CashMovement)

Representa una entrada o salida económica registrada en una caja.

## Tipos

```text
Venta (SALE)
Devolución (REFUND)
Ingreso (INCOME)
Egreso (EXPENSE)
Ajuste (ADJUSTMENT)
```

## Información

* Caja.
* Tipo.
* Importe.
* Fecha y hora.
* Usuario.
* Concepto.
* Operación relacionada.
* Observaciones.

Los ingresos y egresos deberán conservar historial.

---

# 38. Corte de caja (CashClosing)

Representa el proceso de conciliación de una caja al finalizar una jornada.

## Información

* Caja.
* Usuario.
* Fecha y hora.
* Total esperado.
* Total registrado.
* Diferencia.
* Observaciones.

## Regla

Las diferencias no deberán eliminarse.

Deben conservarse junto con las observaciones y el usuario responsable.

---

# 39. Factura (Invoice)

Representa un documento fiscal asociado a una venta.

La emisión será realizada mediante un proveedor externo de facturación.

## Estados

```text
PENDIENTE (PENDING)
PROCESANDO (PROCESSING)
EMITIDA (ISSUED)
ERROR (FAILED)
CANCELADA (CANCELLED)
```

## Regla importante

Una falla del proveedor de facturación **no debe impedir completar la venta**.

El sistema deberá permitir:

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

El envío de la factura podrá realizarse posteriormente.

---

# 40. Registro de auditoría (AuditRecord)

Representa el historial de una operación o modificación relevante.

## Información

* Usuario.
* Fecha y hora.
* Operación.
* Entidad afectada.
* Identificador de la entidad.
* Valor anterior, cuando corresponda.
* Valor nuevo, cuando corresponda.
* Motivo.
* Información adicional.

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

El modelo deberá permitir ampliar posteriormente las operaciones auditadas.

---

# 41. Configuración del negocio (BusinessConfiguration)

Representa los parámetros configurables de la papelería.

El sistema deberá evitar que las políticas comerciales estén codificadas permanentemente.

## Configuraciones principales

### Inventario

* Nivel de alerta de existencias por producto.

### Servicios

* Servicios disponibles.
* Tarifas.
* Reglas de cálculo.

### Pagos

* Formas de pago disponibles.

### Descuentos

* Porcentajes.
* Importes.
* Condiciones.

### Apartados

* Anticipo mínimo.
* Plazo.
* Penalización por cancelación.
* Penalización por vencimiento.

### Catálogo

* Categorías.
* Marcas.
* Estados de productos.

---

# 42. Relaciones principales del dominio

## Cliente — Venta

```text
Cliente 1 ─────────── 0..* Venta
```

Un cliente puede tener múltiples ventas.

Una venta puede realizarse sin cliente registrado.

---

## Cliente — Apartado

```text
Cliente 1 ─────────── 0..* Apartado
```

Un cliente puede tener múltiples apartados simultáneamente.

---

## Venta — Detalle de venta

```text
Venta 1 ─────────── 1..* Detalle de venta
```

Una venta debe contener al menos un concepto.

---

## Venta — Pago

```text
Venta 1 ─────────── 1..* Pago
```

Una venta puede tener uno o varios pagos según las reglas habilitadas.

---

## Venta — Devolución

```text
Venta 1 ─────────── 0..* Devolución
```

Una venta puede tener múltiples devoluciones parciales.

---

## Devolución — Detalle de devolución

```text
Devolución 1 ─────────── 1..* Detalle de devolución
```

---

## Venta — Factura

```text
Venta 1 ─────────── 0..* Factura
```

La facturación depende de la operación externa y puede existir inicialmente como pendiente.

---

## Producto — Inventario

```text
Producto 1 ─────────── 1 Inventario
```

Cada producto físico administrado debe contar con información de existencias.

---

## Producto — Movimiento de inventario

```text
Producto 1 ─────────── 0..* Movimiento de inventario
```

---

## Producto — Proveedor

```text
Producto 0..* ─────────── 0..* Proveedor
```

Un producto puede tener varios proveedores y un proveedor puede ofrecer varios productos.

---

## Proveedor — Compra

```text
Proveedor 1 ─────────── 0..* Compra
```

---

## Compra — Detalle de compra

```text
Compra 1 ─────────── 1..* Detalle de compra
```

---

## Compra — Incidencia de compra

```text
Compra 1 ─────────── 0..* Incidencia de compra
```

---

## Apartado — Detalle de apartado

```text
Apartado 1 ─────────── 1..* Detalle de apartado
```

---

## Apartado — Pago de apartado

```text
Apartado 1 ─────────── 1..* Pago de apartado
```

---

## Usuario — Rol

```text
Usuario 0..* ─────────── 1..* Rol
```

Un usuario puede tener uno o varios roles.

Un rol puede pertenecer a múltiples usuarios.

---

## Rol — Permiso

```text
Rol 0..* ─────────── 1..* Permiso
```

---

## Usuario — Registro de auditoría

```text
Usuario 1 ─────────── 0..* Registro de auditoría
```

---

# 43. Reglas de integridad del dominio

## 43.1 Venta

Una venta completada debe:

* Contener al menos un concepto.
* Tener un pago registrado y confirmado.
* Conservar sus precios históricos.
* Generar los movimientos correspondientes de inventario.
* Generar los movimientos correspondientes de caja.
* Identificar al usuario responsable.
* Conservar su historial.

---

## 43.2 Inventario

Una venta normal no deberá permitir vender una cantidad superior a la existencia disponible.

Sin embargo, el sistema deberá permitir que un usuario autorizado registre una incidencia cuando exista una discrepancia física.

Por ejemplo:

```text
Sistema: 6 unidades
Existencia física: 5 unidades
```

La discrepancia deberá poder investigarse sin modificar silenciosamente el historial.

---

## 43.3 Alerta de existencias

La alerta deberá generarse utilizando el nivel configurado para cada producto.

Ejemplo:

```text
Producto A → alerta en 20
Producto B → alerta en 5
Producto C → alerta en 50
```

No existe un único valor global obligatorio.

Durante una venta, si el producto alcanza o se encuentra por debajo de su nivel configurado, el sistema deberá informar al cajero antes de agregarlo al ticket.

El cliente podrá decidir si:

* Lleva la cantidad disponible.
* Lleva solamente una parte.
* No lleva el producto.

---

# 44. Reglas de apartados

El apartado deberá calcular automáticamente sus importes.

Conceptualmente:

```text
Total del apartado
        │
        ├── Importe pagado
        │
        └── Saldo pendiente
```

Cuando el cliente cancela:

```text
Importe pagado
        │
        ├── Importe conservado por el negocio
        │
        └── Importe a devolver
```

Cuando el apartado vence:

```text
Total del apartado
        │
        ├── Porcentaje conservado
        │
        └── Importe restante a devolver
```

Los porcentajes deberán provenir de la configuración del negocio.

---

# 45. Historial de precios

El sistema deberá conservar el precio utilizado en cada operación.

Por lo tanto, modificar el precio actual de un producto no deberá modificar:

* Ventas anteriores.
* Apartados existentes.
* Compras anteriores.
* Devoluciones relacionadas con operaciones anteriores.

Ejemplo:

```text
Precio enero: $10
Precio marzo: $12
```

Una venta de enero debe continuar registrando:

```text
$10
```

---

# 46. Integridad de devoluciones

La cantidad total devuelta de un producto deberá cumplir:

```text
Cantidad devuelta acumulada
≤
Cantidad vendida
```

Una devolución parcial no deberá alterar ni eliminar el registro original de la venta.

La devolución deberá crear sus propios registros y movimientos.

---

# 47. Integridad de caja

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

Los ingresos y egresos manuales deberán incluir concepto y usuario responsable.

---

# 48. Auditoría e historial

Las operaciones críticas deberán conservar:

```text
Quién
Qué hizo
Cuándo
Sobre qué entidad
Valor anterior
Valor nuevo
Motivo
```

No deberá utilizarse eliminación física para ocultar operaciones históricas.

---

# 49. Operación sin conexión

El sistema deberá contemplar operaciones locales cuando temporalmente no exista conexión.

Las operaciones realizadas sin conexión deberán conservar:

* Identificador local.
* Fecha y hora.
* Usuario.
* Operación.
* Estado de sincronización.

Estados conceptuales:

```text
PENDIENTE DE SINCRONIZACIÓN
SINCRONIZADA
ERROR DE SINCRONIZACIÓN
```

La estrategia técnica de sincronización se definirá posteriormente.

---

# 50. Integraciones externas

El dominio no deberá depender directamente de proveedores externos.

Las siguientes capacidades podrán integrarse mediante adaptadores:

```text
Facturación
Pagos con tarjeta
Transferencias
Correo electrónico
```

Por ejemplo:

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

# 51. Evolución hacia múltiples sucursales

Actualmente el sistema contempla una única sucursal.

Sin embargo, el modelo deberá evitar que conceptos como:

* Inventario.
* Caja.
* Usuarios.
* Ventas.
* Productos.

queden diseñados de forma que impidan agregar sucursales posteriormente.

La incorporación de sucursales será una decisión arquitectónica posterior y deberá documentarse mediante ADR cuando se diseñe.

---

# 52. Conceptos que deliberadamente no pertenecen todavía al modelo

Los siguientes elementos serán definidos posteriormente:

* Tablas de base de datos.
* Claves primarias físicas.
* Índices.
* Restricciones SQL.
* DTOs.
* Endpoints.
* Controladores.
* Repositorios.
* Frameworks.
* Estructura de paquetes.
* Tecnología de frontend.
* Proveedor específico de facturación.
* Proveedor específico de pagos.
* Estrategia concreta de sincronización offline.

El modelo de dominio define **qué representa el negocio**, no todavía **cómo será implementado técnicamente**.

---

# 53. Trazabilidad

El modelo deberá permitir cubrir los principales procesos definidos en los casos de uso.

| Necesidad                  | Conceptos principales                                  |
| -------------------------- | ------------------------------------------------------ |
| Registrar venta            | Venta, Detalle de venta, Producto, Pago, Ticket        |
| Consultar producto         | Producto, Categoría, Marca, Inventario                 |
| Alertar bajo stock         | Producto, Inventario                                   |
| Registrar interés          | Interés por producto, Cliente                          |
| Registrar cliente          | Cliente, Datos fiscales                                |
| Registrar pago             | Pago, Forma de pago                                    |
| Cancelar venta             | Venta, Auditoría, Movimiento de inventario             |
| Devolver productos         | Devolución, Detalle de devolución, Pago, Inventario    |
| Registrar apartado         | Apartado, Detalle de apartado, Cliente                 |
| Realizar pagos parciales   | Pago de apartado                                       |
| Cancelar apartado          | Apartado, Pago de apartado, Configuración de apartados |
| Vencer apartado            | Apartado, Configuración de apartados                   |
| Registrar compra           | Compra, Detalle de compra, Proveedor                   |
| Recibir mercancía          | Compra, Inventario, Movimiento de inventario           |
| Registrar incidencia       | Incidencia de compra / Incidencia de inventario        |
| Registrar servicios        | Servicio, Tarifa de servicio                           |
| Aplicar descuentos         | Descuento, Venta                                       |
| Registrar ingresos/egresos | Movimiento de caja                                     |
| Realizar corte             | Caja, Corte de caja                                    |
| Facturar                   | Factura, Datos fiscales, Venta                         |
| Gestionar usuarios         | Usuario, Rol, Permiso                                  |
| Auditar operaciones        | Registro de auditoría                                  |
| Trabajar sin conexión      | Operación pendiente de sincronización                  |

---

# 54. Resumen del modelo

Los principales agregados conceptuales del dominio son:

```text
NEGOCIO
│
├── Usuarios
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
│   ├── Categorías
│   ├── Marcas
│   └── Servicios
│       └── Tarifas
│
├── Inventario
│   ├── Movimientos
│   └── Incidencias
│
├── Ventas
│   ├── Detalles
│   ├── Pagos
│   ├── Tickets
│   ├── Devoluciones
│   └── Facturas
│
├── Apartados
│   ├── Detalles
│   ├── Pagos
│   └── Reglas de configuración
│
├── Compras
│   ├── Proveedores
│   ├── Detalles
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

Este modelo constituye la base conceptual para el siguiente nivel de diseño: el **modelo de datos**.
