# ADR-006 — Modelo de ventas y pagos

## Estado

Aceptado

## Fecha

2026-08-07

## Contexto

El sistema debe permitir gestionar las ventas realizadas en la papelería de forma consistente, manteniendo la trazabilidad de cada operación y permitiendo posteriormente consultar su información histórica.

El flujo de venta definido para el sistema contempla que:

1. El cliente solicita uno o varios productos.
2. El cajero busca los productos en el sistema.
3. Conforme encuentra cada producto, lo agrega a la venta.
4. El sistema verifica la disponibilidad de inventario.
5. Si existe una alerta de stock, el sistema informa al cajero antes de agregar el producto.
6. El cajero informa al cliente sobre la situación.
7. El cliente decide si continúa con la cantidad solicitada, reduce la cantidad o elimina el producto.
8. Una vez agregados todos los productos, se calcula el total.
9. El cliente selecciona el método de pago.
10. El cajero registra el pago.
11. Una vez confirmado el pago, se genera el ticket correspondiente.

El sistema debe permitir que una venta se realice sin registrar al cliente, ya que no todas las operaciones requieren identificación.

Sin embargo, cuando el cliente se encuentre registrado, la venta podrá asociarse con su registro.

Además, el modelo debe permitir múltiples métodos de pago dentro de una misma venta cuando sea necesario, así como conservar la información de cada pago individual.

La arquitectura también debe permitir una futura integración con terminales de pago sin modificar fundamentalmente el modelo de ventas existente.

Otro aspecto importante es que una venta no debe eliminarse físicamente. Las cancelaciones y operaciones posteriores, como devoluciones, deben conservar la referencia a la operación original.

Finalmente, los valores utilizados durante la venta deben conservarse como información histórica. El precio actual de un producto, por ejemplo, no debe utilizarse posteriormente para reconstruir una venta realizada meses atrás.

---

## Decisión

Se establece que el sistema utilizará una entidad central **Venta (`sale`)**, relacionada con sus correspondientes detalles, pagos y ticket.

El modelo estará compuesto principalmente por:

```text
sale
 ├── sale_item
 ├── payment
 └── ticket
```

Las devoluciones estarán relacionadas posteriormente con la venta original:

```text
sale
 └── return
      └── return_item
```

### 1. Venta

La entidad `sale` representará la operación comercial completa.

Contendrá información como:

* Cliente asociado, cuando exista.
* Usuario que realizó la operación.
* Estado de la venta.
* Subtotal.
* Descuentos.
* Impuestos.
* Total.
* Fechas relevantes.

El cliente será opcional:

```text
sale.customer_id → nullable
```

Esto permite realizar ventas a clientes no registrados.

---

### 2. Detalle de venta

Cada producto o servicio vendido será representado mediante `sale_item`.

El detalle conservará, entre otros:

```text
quantity
unit_price
discount_value
discount_amount
tax
subtotal
```

El `unit_price` será un **snapshot del precio utilizado durante la operación**.

Por lo tanto, el sistema no deberá reconstruir una venta histórica consultando:

```text
product.sale_price
```

Ejemplo:

```text
Precio actual:
$120

Precio utilizado en una venta histórica:
$100

sale_item.unit_price = 100
```

Aunque posteriormente el producto tenga un precio de $120, la venta histórica continuará mostrando $100.

---

### 3. Pagos

Los pagos se representarán mediante una entidad independiente:

```text
payment
```

Una venta podrá tener uno o varios pagos:

```text
sale 1:N payment
```

Cada pago conservará:

* Método de pago.
* Monto.
* Estado.
* Referencia.
* Usuario que lo registró.
* Fecha de registro.

Esto permite soportar escenarios como:

```text
Venta: $500

Pago 1:
Efectivo → $200

Pago 2:
Tarjeta → $300
```

El modelo no limita la venta a un único registro de pago.

---

### 4. Métodos de pago

Los métodos de pago se gestionarán mediante:

```text
payment_method
```

Esto permite configurar métodos como:

* Efectivo.
* Tarjeta.
* Transferencia.

Los métodos podrán activarse o desactivarse sin eliminar el historial de pagos realizados anteriormente.

---

### 5. Ticket

El ticket se representará mediante:

```text
ticket
```

y tendrá una relación:

```text
sale 1:1 ticket
```

El ticket se generará **después de registrar y confirmar el pago**.

Por lo tanto, una venta en proceso todavía no tendrá necesariamente un ticket emitido.

---

### 6. Estado de la venta

La venta tendrá un estado que permita distinguir, como mínimo, entre operaciones en diferentes etapas de su ciclo de vida.

Por ejemplo:

```text
PENDING
COMPLETED
CANCELLED
```

La implementación final podrá definir estados adicionales si son necesarios.

Una venta completada deberá cumplir las condiciones necesarias para considerarse pagada.

Una venta cancelada permanecerá almacenada para conservar la trazabilidad de la operación.

---

### 7. Cancelaciones

Las ventas no se eliminarán físicamente.

Cuando sea necesario cancelar una venta, se modificará su estado y se conservará información suficiente para identificar:

* Que fue cancelada.
* Cuándo fue cancelada.
* Qué usuario realizó la acción.

Cuando una venta ya haya sido completada y sea necesario corregirla posteriormente, no se modificará destructivamente la operación histórica.

Se utilizarán los mecanismos correspondientes, como devoluciones o nuevas operaciones relacionadas.

---

### 8. Devoluciones

Las devoluciones se modelarán como operaciones independientes relacionadas con la venta original.

```text
sale 1:N return
```

Esto permite realizar devoluciones parciales.

Por ejemplo:

```text
Venta:
4 cuadernos

Devolución:
1 cuaderno
```

La venta original continúa registrando los cuatro productos vendidos y la devolución registra que uno de ellos fue devuelto.

El detalle de devolución utilizará:

```text
return_item.sale_item_id
```

para identificar exactamente qué producto de la venta original está siendo devuelto.

---

### 9. Método de devolución

Cuando una devolución implique un reembolso, el método utilizado deberá corresponder al método de pago original, de acuerdo con las reglas de negocio establecidas.

El modelo conserva la información necesaria de los pagos originales para poder determinar el origen del importe a devolver.

---

### 10. Integración futura con terminales

El modelo de pagos se diseñará para permitir una futura integración con terminales de pago.

La entidad:

```text
payment
```

contará con información como:

```text
payment_method_id
status
reference
```

La `reference` podrá utilizarse para almacenar el identificador de una operación externa cuando el pago sea procesado mediante un proveedor o terminal.

Esto permite mantener una separación entre:

```text
Venta
    ↓
Pago
    ↓
Método de pago
    ↓
Proveedor / terminal externo
```

La integración con una terminal no deberá modificar la estructura fundamental de `sale`.

---

## Consecuencias

### Ventajas

* Permite realizar ventas con o sin cliente registrado.
* Permite múltiples productos y servicios en una misma venta.
* Permite múltiples pagos por venta.
* Mantiene los precios históricos utilizados.
* Permite identificar el método de pago utilizado.
* Permite generar el ticket después de confirmar el pago.
* Permite realizar devoluciones parciales.
* Conserva la venta original cuando existe una devolución.
* Evita eliminar información histórica.
* Facilita la auditoría de operaciones.
* Permite integrar posteriormente terminales de pago.
* Mantiene separadas las responsabilidades entre venta, pago y ticket.
* Facilita futuras integraciones con proveedores externos de pago.

### Desventajas

* El modelo requiere más entidades que un diseño donde el pago estuviera directamente dentro de `sale`.
* Las ventas con múltiples pagos requieren lógica adicional para validar que los importes sean correctos.
* Las devoluciones requieren controles adicionales para impedir devolver una cantidad superior a la vendida.
* La integración con terminales requerirá lógica específica para manejar estados y referencias externas.
* La conservación histórica implica mayor volumen de información en la base de datos.

---

## Alternativas consideradas

### 1. Mantener el pago directamente dentro de `sale`

Se consideró almacenar información como:

```text
payment_method
paid_amount
```

directamente en la venta.

Se descartó porque limita el sistema a un único pago por operación y dificulta escenarios como:

```text
$300 efectivo
+
$200 tarjeta
```

Además, reduce la flexibilidad para futuras integraciones.

---

### 2. Crear una sola entidad genérica para ventas y pagos

Se consideró utilizar una estructura donde la venta y el pago fueran tratados como una única operación.

Se descartó porque una venta y un pago representan conceptos diferentes.

Una venta puede existir antes de ser pagada y puede tener múltiples pagos.

Por lo tanto, deben mantenerse como entidades independientes.

---

### 3. Eliminar la venta cuando se cancela

Se descartó debido a los requisitos de trazabilidad y auditoría.

Eliminar la venta impediría determinar posteriormente:

* Qué se vendió.
* Quién realizó la operación.
* Cuándo ocurrió.
* Qué pago se registró.
* Por qué fue cancelada.

Por ello, las cancelaciones se manejarán mediante estados y registros históricos.

---

### 4. Modificar directamente una venta después de completarla

También se descartó como mecanismo principal para corregir operaciones históricas.

Una modificación destructiva podría alterar información que originalmente ocurrió de otra manera.

Para operaciones posteriores se utilizarán mecanismos específicos, como:

* Devoluciones.
* Cancelaciones.
* Nuevas ventas relacionadas cuando corresponda.
* Registros de auditoría.

---

### 5. Limitar la venta a un único método de pago

Se descartó porque no representa adecuadamente todos los escenarios comerciales posibles.

El sistema permitirá:

```text
sale 1:N payment
```

permitiendo dividir un pago entre diferentes métodos.

---

## Impacto en la arquitectura

Esta decisión afecta principalmente las siguientes capas:

### Dominio

Se definen los conceptos principales:

```text
Sale
SaleItem
Payment
PaymentMethod
Ticket
Return
ReturnItem
```

y sus reglas de negocio.

### Persistencia

Se requieren las tablas:

```text
sale
sale_item
payment
payment_method
ticket
return
return_item
```

junto con sus claves foráneas, restricciones e índices.

### Aplicación

Los casos de uso relacionados con ventas deberán coordinar:

```text
Creación de venta
→ Agregado de productos
→ Validación de inventario
→ Cálculo de totales
→ Registro de pago
→ Confirmación
→ Generación de ticket
```

Además, deberán existir casos de uso para:

```text
Cancelar venta
Procesar devolución
Registrar pago
Consultar venta
```

### Infraestructura

La arquitectura deberá permitir integrar posteriormente proveedores externos o terminales de pago sin acoplar la lógica de dominio directamente al proveedor.

### Auditoría

Las operaciones sensibles deberán generar los registros correspondientes en:

```text
audit_record
```

especialmente aquellas relacionadas con:

* Cancelaciones.
* Devoluciones.
* Ajustes.
* Pagos.
* Cambios administrativos.

### Integridad de datos

La base de datos deberá garantizar:

* Una venta con al menos un detalle.
* Pagos asociados a una venta válida.
* Métodos de pago válidos.
* Cantidades de devolución no superiores a las vendidas.
* Conservación de los registros históricos.
* Integridad referencial entre las operaciones relacionadas.
