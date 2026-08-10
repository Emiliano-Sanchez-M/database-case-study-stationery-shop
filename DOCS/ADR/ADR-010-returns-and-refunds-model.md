# ADR-010: Modelo de devoluciones y reembolsos

## Estado

Aceptado

## Fecha

2026-08-08

## Contexto

El sistema debe permitir gestionar devoluciones de productos vendidos, manteniendo la trazabilidad completa de la operación original y evitando modificar o eliminar la venta histórica.

Durante el análisis de los casos de uso se estableció que una devolución puede ser:

* Total.
* Parcial.
* Aceptada.
* Rechazada.
* Autorizada por un usuario responsable.
* Asociada a una venta previamente realizada.

También se estableció que una devolución no debe eliminar ni modificar destructivamente la venta original.

Por ejemplo, si una venta contiene:

```text
4 cuadernos
2 plumas
1 mochila
```

y el cliente devuelve únicamente:

```text
2 cuadernos
```

la venta original debe continuar representando exactamente lo que ocurrió originalmente.

La devolución debe registrarse como una nueva operación relacionada con esa venta.

Además, el método utilizado para realizar el reembolso debe corresponder al método de pago utilizado originalmente, de acuerdo con las reglas definidas para el negocio.

El sistema también debe contemplar situaciones en las que una devolución sea rechazada o aceptada bajo responsabilidad de un usuario autorizado.

Por lo tanto, se requiere un modelo que permita:

1. Conservar la venta original.
2. Registrar una o varias devoluciones.
3. Permitir devoluciones parciales.
4. Identificar qué artículos fueron devueltos.
5. Registrar las cantidades devueltas.
6. Registrar el monto correspondiente.
7. Identificar quién gestionó o autorizó la devolución.
8. Registrar el motivo.
9. Mantener el estado de la devolución.
10. Mantener la trazabilidad del reembolso.
11. Evitar que se devuelva una cantidad superior a la originalmente vendida.

---

## Decisión

Se utilizará un modelo compuesto por:

```text
sale
sale_item
return
return_item
payment
payment_method
```

La devolución será una entidad independiente relacionada con la venta original.

---

## 1. La venta original no se modifica destructivamente

La entidad:

```text
sale
```

representa la operación comercial original.

Una devolución no deberá eliminar la venta ni eliminar sus detalles.

Por ejemplo:

```text
Venta #1001

4 × Cuaderno
2 × Pluma
1 × Mochila
```

Si el cliente devuelve:

```text
2 × Cuaderno
```

la venta continuará almacenando:

```text
4 × Cuaderno
2 × Pluma
1 × Mochila
```

y existirá una devolución asociada:

```text
Devolución #35

2 × Cuaderno
```

Esto permite reconstruir posteriormente tanto la venta original como las devoluciones realizadas.

---

## 2. Una venta puede tener múltiples devoluciones

Se establece la relación:

```text
sale 1:N return
```

Una misma venta puede tener más de una devolución.

Por ejemplo:

```text
Venta #1001

Devolución #20
2 cuadernos

Devolución #24
1 mochila
```

Esto permite soportar devoluciones parciales realizadas en diferentes momentos.

---

## 3. La devolución tendrá sus propios detalles

La entidad:

```text
return
```

representará la operación de devolución.

La entidad:

```text
return_item
```

representará los productos específicos que forman parte de dicha devolución.

La relación será:

```text
return 1:N return_item
```

Cada `return_item` deberá referenciar el `sale_item` correspondiente.

Esto permite determinar exactamente qué artículo de la venta original está siendo devuelto.

---

## 4. No se podrá devolver una cantidad superior a la vendida

El sistema deberá controlar la cantidad ya devuelta de cada `sale_item`.

Conceptualmente:

```text
cantidad máxima devuelta
=
cantidad originalmente vendida
-
cantidad previamente devuelta
```

Por ejemplo:

```text
Venta:
5 unidades

Primera devolución:
2 unidades

Cantidad restante para devolución:
3 unidades
```

Una segunda devolución de:

```text
3 unidades
```

sería válida.

Una devolución de:

```text
4 unidades
```

debería ser rechazada.

Esta validación deberá realizarse dentro de una transacción para evitar inconsistencias cuando existan operaciones concurrentes.

---

## 5. Devoluciones parciales

El sistema soportará devoluciones parciales como comportamiento normal.

Una devolución parcial no modifica la cantidad original almacenada en `sale_item`.

La cantidad devuelta se registra exclusivamente en:

```text
return_item.quantity
```

Esto mantiene una separación clara entre:

```text
Venta original
```

y:

```text
Devolución
```

---

## 6. Estado de la devolución

La entidad `return` tendrá un estado que permita representar el ciclo de vida de la operación.

Entre los estados posibles se contemplan:

```text
PENDING
APPROVED
REJECTED
COMPLETED
CANCELLED
```

Los valores definitivos podrán establecerse durante la implementación.

El objetivo es evitar que una devolución rechazada se interprete como una devolución completada.

---

## 7. Usuario responsable

La devolución deberá registrar al usuario que la gestionó.

La relación será:

```text
user 1:N return
```

Esto permite conocer:

* Quién solicitó o registró la devolución.
* Quién la gestionó.
* Cuándo ocurrió.
* Qué motivo se proporcionó.
* Cuál fue el resultado.

Si el negocio requiere posteriormente separar:

```text
solicitado_por
autorizado_por
```

se podrá ampliar el modelo sin modificar el concepto principal.

---

## 8. Devoluciones rechazadas

Una devolución puede ser rechazada.

En ese caso:

```text
return.status = REJECTED
```

y deberá conservarse el motivo correspondiente.

La devolución rechazada no deberá generar:

* Reembolso.
* Movimiento de inventario de entrada.
* Movimiento de caja asociado al reembolso.

Esto permite conservar evidencia de que la devolución fue solicitada y posteriormente rechazada.

---

## 9. Devoluciones aceptadas bajo responsabilidad

De acuerdo con las reglas del negocio, puede existir una situación en la que una devolución no cumpla completamente con las condiciones normales, pero un usuario autorizado decida aceptarla bajo su responsabilidad.

El sistema deberá conservar esta circunstancia.

El registro deberá permitir identificar:

* Usuario responsable.
* Motivo.
* Fecha.
* Devolución asociada.

La implementación concreta del mecanismo de autorización podrá apoyarse posteriormente en roles y permisos.

Cuando corresponda, la acción también deberá generar un registro en:

```text
audit_record
```

---

## 10. Reembolso

El reembolso deberá quedar asociado a la devolución y al método de pago correspondiente.

El sistema deberá evitar que una devolución se considere completamente procesada si el reembolso correspondiente no ha sido registrado cuando éste sea requerido.

La forma exacta de representar el reembolso podrá evolucionar durante la implementación.

La decisión fundamental es que el reembolso debe mantener trazabilidad respecto de:

```text
return
    ↓
payment original
    ↓
payment_method
```

---

## 11. Mismo método de pago

Como regla de negocio, el método de devolución debe corresponder al método utilizado originalmente para realizar el pago.

Por ejemplo:

```text
Venta:
Tarjeta

Devolución:
Tarjeta
```

o:

```text
Venta:
Transferencia

Devolución:
Transferencia
```

No se deberá asumir que una venta pagada mediante un determinado método puede ser reembolsada arbitrariamente mediante otro.

Esta regla deberá contemplar posteriormente casos en los que una venta tenga múltiples pagos.

---

## 12. Ventas con múltiples métodos de pago

Una venta puede tener múltiples pagos:

```text
Venta = $500

Efectivo = $200
Tarjeta  = $300
```

Por lo tanto, una futura implementación de devoluciones deberá poder determinar correctamente cómo distribuir un reembolso cuando la venta original haya utilizado más de un método de pago.

No se utilizará una única columna en `sale` para almacenar el método de pago.

La relación:

```text
sale 1:N payment
```

se conserva para permitir este escenario.

La estrategia exacta para distribuir reembolsos entre múltiples pagos deberá definirse durante la implementación del módulo de pagos.

---

## 13. Inventario

Una devolución aceptada y completada puede generar un movimiento de inventario.

Por ejemplo:

```text
Venta:
5 unidades

Devolución:
2 unidades

Inventario:
+2 unidades
```

El movimiento deberá registrarse en:

```text
inventory_movement
```

con una referencia hacia la devolución.

Esto mantiene la trazabilidad entre:

```text
return
    ↓
return_item
    ↓
inventory_movement
```

La devolución no modificará directamente el historial de movimientos existentes.

---

## 14. Caja

Cuando una devolución implique un reembolso en efectivo, deberá registrarse el movimiento correspondiente en:

```text
cash_movement
```

Por ejemplo:

```text
Venta
↓
Ingreso de efectivo

Devolución
↓
Egreso de efectivo
```

El movimiento de caja deberá conservar la referencia de la devolución.

Los reembolsos realizados mediante otros métodos de pago deberán seguir el mecanismo correspondiente al proveedor o método utilizado.

---

## 15. Snapshot de información histórica

La devolución deberá conservar los valores necesarios para representar correctamente la operación realizada.

El modelo no deberá depender exclusivamente del estado actual del producto.

Por ejemplo, si el producto originalmente fue vendido a:

```text
$100
```

y posteriormente su precio actual cambia a:

```text
$120
```

la devolución deberá calcularse tomando como referencia la operación original y no el precio actual del producto.

La información histórica deberá permanecer vinculada al `sale_item`.

---

## Consecuencias

### Ventajas

* Las ventas originales permanecen intactas.
* Se soportan devoluciones parciales.
* Una venta puede tener múltiples devoluciones.
* Se conserva el historial completo de devoluciones.
* Se puede determinar exactamente qué producto fue devuelto.
* Se puede controlar la cantidad máxima que puede devolverse.
* Se conserva el usuario responsable.
* Se pueden registrar devoluciones rechazadas.
* Se pueden registrar devoluciones aceptadas bajo responsabilidad.
* Se mantiene trazabilidad con inventario.
* Se mantiene trazabilidad con caja.
* Se facilita la auditoría.
* El modelo soporta ventas con múltiples pagos.
* Se evita reconstruir devoluciones utilizando únicamente información actual del catálogo.

### Desventajas

* El modelo requiere más entidades que una implementación que simplemente modifique la venta.
* Las validaciones de cantidades devueltas requieren lógica adicional.
* Las devoluciones y reembolsos requieren coordinación entre ventas, inventario, pagos y caja.
* Las ventas con múltiples métodos de pago hacen más compleja la distribución de los reembolsos.
* Será necesario controlar cuidadosamente la concurrencia para evitar devoluciones duplicadas.

---

## Alternativas consideradas

### 1. Modificar directamente `sale_item`

Por ejemplo, reducir:

```text
quantity = 5
```

a:

```text
quantity = 3
```

Se descartó porque destruiría la información original de la venta.

No permitiría distinguir entre:

```text
venta original = 5
```

y:

```text
cantidad después de devolución = 3
```

---

### 2. Eliminar el producto de la venta

Se descartó porque impediría conocer qué se vendió originalmente y rompería la trazabilidad histórica.

---

### 3. Cancelar completamente la venta y crear una nueva

Se descartó como mecanismo general de devolución.

Una devolución no representa necesariamente la cancelación completa de una venta.

Además, este enfoque complicaría:

* Devoluciones parciales.
* Historial de pagos.
* Inventario.
* Auditoría.
* Facturación.
* Relación entre operaciones.

Una venta cancelada deberá representar una cancelación, mientras que una devolución deberá representar una devolución.

---

### 4. Crear una nueva venta negativa

Se descartó como modelo principal porque una devolución tiene reglas y significado de negocio diferentes a una venta.

La devolución debe conservar explícitamente su relación con la venta original.

---

### 5. Permitir cualquier método de reembolso

Se descartó debido a la regla de negocio establecida de utilizar el mismo método de pago original.

---

## Impacto en la arquitectura

### Dominio

Se incorporan y relacionan los conceptos:

```text
Devolución
Detalle de devolución
Reembolso
Estado de devolución
```

Además, se establecen reglas de dominio para:

* Devoluciones parciales.
* Cantidades máximas.
* Estados.
* Autorizaciones.
* Métodos de reembolso.

### Aplicación

Los casos de uso afectados incluyen:

* Solicitar devolución.
* Revisar devolución.
* Aceptar devolución.
* Rechazar devolución.
* Aceptar devolución bajo responsabilidad.
* Procesar reembolso.
* Actualizar inventario por devolución.
* Registrar movimiento de caja por reembolso.

Estas operaciones deberán ejecutarse de forma transaccional cuando afecten simultáneamente ventas, pagos, inventario y caja.

### Persistencia

Se utilizan principalmente:

```text
return
return_item
sale
sale_item
payment
payment_method
```

y se relacionan con:

```text
inventory_movement
cash_movement
audit_record
user
```

### Seguridad

Las acciones de aceptación, rechazo y especialmente las devoluciones bajo responsabilidad deberán estar protegidas mediante roles y permisos.

### Auditoría

Las acciones sensibles deberán registrarse en:

```text
audit_record
```

Especialmente:

* Aceptación de devoluciones fuera de las reglas normales.
* Rechazos.
* Autorizaciones.
* Cambios relevantes.
* Reembolsos excepcionales.

### Inventario

Las devoluciones completadas podrán generar movimientos de entrada en:

```text
inventory_movement
```

sin modificar directamente el historial existente.

### Caja

Los reembolsos en efectivo generarán:

```text
cash_movement
```

con referencia a la devolución.

---

## Relación con otros ADR

Este ADR se relaciona directamente con:

* **ADR-003: Historical Data and Snapshots**, debido a la conservación de los valores históricos de las operaciones.
* **ADR-004: Audit Trail Strategy**, debido a la trazabilidad de autorizaciones y acciones sensibles.
* **ADR-005: Logical Deletion Strategy**, debido a la conservación de ventas y devoluciones históricas.
* **ADR-006: Sales and Payment Model**, debido a la relación entre ventas, pagos y devoluciones.
* **ADR-009: Inventory Traceability**, porque una devolución puede generar movimientos de inventario.
* **ADR-010: Returns and Refunds Model**, como definición de la estrategia específica de devoluciones y reembolsos.
