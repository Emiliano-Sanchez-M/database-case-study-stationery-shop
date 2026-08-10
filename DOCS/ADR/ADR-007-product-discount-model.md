# ADR-007 — Modelo de descuentos

## Estado

Aceptado

## Fecha

2026-08-08

## Contexto

El sistema debe permitir que la papelería configure y aplique diferentes tipos de descuentos sobre las ventas.

Los descuentos pueden representar reglas comerciales diferentes aunque tengan exactamente el mismo valor.

Por ejemplo:

```text
Descuento para estudiantes: 15%

Descuento para personas de la tercera edad: 15%
```

Aunque ambos representan actualmente un 15%, no son el mismo descuento, ya que tienen diferentes condiciones y propósitos comerciales.

Además, los descuentos pueden cambiar con el tiempo.

Por ejemplo:

```text
01/08/2026
Descuento estudiante = 15%

15/08/2026
Descuento estudiante = 18%
```

El sistema debe poder distinguir entre:

1. La configuración actual del descuento.
2. El descuento que realmente se aplicó a una venta histórica.
3. Los cambios que se realizaron sobre la configuración del descuento.

No sería suficiente almacenar únicamente el porcentaje utilizado en la venta, ya que también es necesario identificar qué descuento fue aplicado.

Tampoco sería suficiente almacenar únicamente una referencia al descuento, porque si posteriormente cambia su valor, una consulta de la venta podría mostrar incorrectamente el nuevo porcentaje.

Por lo tanto, se requiere combinar una relación con la configuración del descuento, un snapshot de los valores utilizados y un mecanismo de auditoría.

---

## Decisión

Se establece que los descuentos serán entidades independientes representadas mediante:

```text
discount
```

y podrán relacionarse con los detalles de venta mediante:

```text
sale_item.discount_id
```

La relación será:

```text
discount 1:N sale_item
```

Esto permitirá identificar exactamente qué descuento fue aplicado a cada detalle de venta.

---

## 1. Entidad descuento

La entidad `discount` representa la configuración actual de un descuento.

Contendrá información como:

```text
id
name
type
value
conditions
starts_at
ends_at
active
created_at
updated_at
```

Ejemplo:

```text
id = 2
name = "Descuento para estudiantes"
type = "PERCENTAGE"
value = 15
active = true
```

Otro descuento podría ser:

```text
id = 3
name = "Descuento tercera edad"
type = "PERCENTAGE"
value = 15
active = true
```

Aunque ambos tengan:

```text
value = 15
```

son entidades diferentes.

---

## 2. Identificación del descuento aplicado

Cada `sale_item` podrá tener un descuento asociado:

```text
discount_id
```

Por ejemplo:

```text
sale_item.discount_id = 2
```

Esto permite saber que la venta utilizó:

```text
Descuento para estudiantes
```

y no simplemente:

```text
15%
```

De esta manera, dos descuentos con el mismo porcentaje pueden distinguirse correctamente.

---

## 3. Snapshot del descuento

La referencia mediante `discount_id` no será suficiente para reconstruir el estado histórico.

Por esta razón, `sale_item` conservará también:

```text
discount_type
discount_value
discount_amount
```

Por ejemplo:

```text
discount_id = 2
discount_type = "PERCENTAGE"
discount_value = 15
discount_amount = 15
```

Esto representa exactamente lo que ocurrió en esa venta.

---

## 4. Independencia respecto a cambios futuros

Supongamos que inicialmente existe:

```text
Descuento estudiante
15%
```

Se realiza una venta:

```text
sale_item.discount_id = 2
sale_item.discount_value = 15
```

Posteriormente el administrador modifica el descuento:

```text
discount.value = 18
```

La venta histórica debe continuar mostrando:

```text
15%
```

y no:

```text
18%
```

La nueva venta, en cambio, podrá utilizar:

```text
18%
```

Por lo tanto:

```text
discount
    ↓
Configuración actual

sale_item
    ↓
Valor realmente aplicado

audit_record
    ↓
Historial de modificaciones
```

---

## 5. Auditoría de descuentos

Los cambios realizados sobre un descuento deberán registrarse mediante:

```text
audit_record
```

La auditoría deberá conservar, cuando corresponda:

* Usuario que realizó el cambio.
* Fecha y hora.
* Entidad modificada.
* Identificador del descuento.
* Valor anterior.
* Valor nuevo.
* Motivo del cambio.

Ejemplo:

```text
entity_type = "discount"
entity_id = 2
action = "UPDATE"
```

Valor anterior:

```json
{
  "value": 15,
  "active": true
}
```

Valor nuevo:

```json
{
  "value": 18,
  "active": true
}
```

Esto permite determinar posteriormente:

> El descuento para estudiantes era del 15% y fue cambiado al 18%.

---

## 6. Tipos de descuento

El modelo debe permitir diferentes tipos de descuento.

Como mínimo podrá contemplar:

```text
PERCENTAGE
FIXED_AMOUNT
```

Por ejemplo:

### Porcentaje

```text
15%
```

### Monto fijo

```text
$20
```

El campo:

```text
discount.type
```

determinará cómo debe interpretarse:

```text
discount.value
```

La implementación podrá incorporar posteriormente otros tipos si los requisitos del negocio lo justifican.

---

## 7. Condiciones del descuento

Algunos descuentos pueden depender de condiciones específicas.

Ejemplos:

```text
Estudiante
Tercera edad
Cliente frecuente
Promoción especial
```

Por esta razón, la entidad podrá utilizar:

```text
conditions JSONB
```

para almacenar condiciones configurables que no justifiquen inicialmente la creación de múltiples entidades adicionales.

Sin embargo, `conditions` no sustituye relaciones que representen conceptos importantes del dominio.

Si una condición futura requiere una entidad propia debido a su complejidad o importancia en el negocio, deberá evaluarse mediante una nueva decisión arquitectónica.

---

## 8. Vigencia

Los descuentos podrán tener un periodo de vigencia mediante:

```text
starts_at
ends_at
```

Esto permite definir descuentos temporales.

Ejemplo:

```text
starts_at = 2026-08-15
ends_at = 2026-08-31
```

El sistema deberá determinar si un descuento puede aplicarse considerando su estado y periodo de vigencia.

---

## 9. Desactivación

Los descuentos no deberán eliminarse físicamente cuando dejen de utilizarse.

Se utilizará:

```text
active
```

para controlar si el descuento puede utilizarse actualmente.

Esto permite conservar:

* La identidad del descuento.
* Sus relaciones históricas.
* Sus cambios auditados.
* Las ventas donde fue utilizado.

Un descuento inactivo no debe desaparecer del historial.

---

## 10. Aplicación a nivel de detalle

El descuento se asociará al `sale_item` y no exclusivamente a `sale`.

Esto permite que una misma venta contenga diferentes descuentos.

Ejemplo:

```text
Venta
│
├── Cuaderno
│   └── Descuento estudiante: 15%
│
├── Mochila
│   └── Descuento especial: 10%
│
└── Plumas
    └── Sin descuento
```

Por lo tanto:

```text
sale 1:N sale_item
discount 1:N sale_item
```

Esto proporciona mayor flexibilidad que almacenar un único descuento a nivel de venta.

---

## 11. Descuento opcional

No todos los productos o servicios tienen que recibir un descuento.

Por lo tanto:

```text
sale_item.discount_id
```

será nullable.

Cuando no exista descuento:

```text
discount_id = NULL
```

Los valores relacionados con el descuento deberán representar correctamente la ausencia de descuento.

---

## 12. Conservación del importe calculado

Además del porcentaje o valor configurado, el detalle de venta conservará:

```text
discount_amount
```

Este campo representa el importe monetario real descontado en la operación.

Por ejemplo:

```text
Precio:
$100

Descuento:
15%

discount_amount:
$15
```

Esto evita tener que recalcular posteriormente el importe histórico utilizando configuraciones actuales.

---

## 13. Cambios en el descuento

Cuando cambie un descuento, no se deberá modificar retroactivamente la información almacenada en ventas anteriores.

Ejemplo:

### Estado inicial

```text
Descuento estudiante = 15%
```

### Venta A

```text
discount_id = 2
discount_value = 15
discount_amount = 15
```

### Cambio administrativo

```text
15% → 18%
```

### Venta B

```text
discount_id = 2
discount_value = 18
discount_amount = 18
```

Ambas ventas continuarán apuntando al mismo descuento:

```text
discount_id = 2
```

pero cada una conservará el valor que realmente se aplicó.

---

## Consecuencias

### Ventajas

* Permite distinguir descuentos diferentes con el mismo porcentaje.
* Conserva la identidad del descuento aplicado.
* Mantiene el valor histórico utilizado.
* Conserva el importe monetario real del descuento.
* Permite modificar descuentos sin alterar ventas anteriores.
* Permite auditar cambios administrativos.
* Permite descuentos por porcentaje o monto fijo.
* Permite descuentos temporales.
* Permite diferentes descuentos dentro de una misma venta.
* Permite desactivar descuentos sin eliminar su historial.
* Facilita futuras extensiones del modelo.

### Desventajas

* `sale_item` contiene información duplicada respecto a `discount`.
* Se requiere mayor almacenamiento para conservar snapshots.
* La aplicación debe garantizar que el snapshot represente correctamente el descuento utilizado.
* La lógica de validación de descuentos es más compleja que simplemente almacenar un porcentaje.
* El uso de `JSONB` para condiciones requiere controles adicionales sobre su estructura.

---

## Alternativas consideradas

### 1. Almacenar únicamente el porcentaje

Se consideró guardar solamente:

```text
discount_value
```

dentro de `sale_item`.

Se descartó porque no permitiría identificar qué descuento fue aplicado.

Por ejemplo:

```text
15%
```

podría representar:

* Estudiante.
* Tercera edad.
* Promoción.
* Cliente frecuente.

El porcentaje por sí solo no proporciona suficiente información.

---

### 2. Almacenar únicamente `discount_id`

Se consideró guardar solamente:

```text
discount_id
```

en `sale_item`.

Se descartó porque el valor del descuento puede cambiar.

Si:

```text
discount_id = 2
value = 15
```

posteriormente cambia a:

```text
value = 18
```

una consulta basada únicamente en la entidad actual podría mostrar incorrectamente que una venta histórica recibió 18%.

Por ello, se requiere snapshot.

---

### 3. Crear una copia completa del descuento por cada venta

Se consideró duplicar toda la información del descuento dentro de `sale_item`.

Se descartó porque generaría una duplicación innecesaria de información y dificultaría identificar la configuración original del descuento.

Se decidió conservar:

```text
discount_id
```

como referencia y únicamente almacenar como snapshot los valores necesarios para reconstruir la aplicación histórica.

---

### 4. Crear una tabla de versiones de descuentos

Se consideró crear una entidad como:

```text
discount_version
```

para almacenar cada versión del descuento.

Aunque este modelo podría utilizarse en sistemas con requisitos de versionado muy estrictos, se decidió inicialmente utilizar la combinación:

```text
discount
+
sale_item snapshot
+
audit_record
```

Esta solución satisface las necesidades actuales sin introducir una entidad adicional de versionado.

Si los requisitos futuros requieren consultar formalmente todas las versiones de una configuración como entidades independientes, podrá reconsiderarse mediante un nuevo ADR.

---

## Impacto en la arquitectura

### Dominio

Se definen principalmente los conceptos:

```text
Discount
SaleItem
```

y las reglas para determinar cuándo y cómo puede aplicarse un descuento.

### Persistencia

Se requieren principalmente:

```text
discount
sale_item
audit_record
```

con las relaciones correspondientes.

### Aplicación

Los casos de uso relacionados con ventas deberán:

1. Identificar el descuento disponible.
2. Validar sus condiciones.
3. Determinar su vigencia.
4. Calcular el descuento.
5. Registrar el `discount_id`.
6. Guardar el snapshot.
7. Conservar el importe descontado.

### Auditoría

Los cambios administrativos sobre descuentos deberán generar registros en:

```text
audit_record
```

permitiendo reconstruir la evolución de la configuración.

### Base de datos

Se deberán aplicar restricciones para evitar valores inválidos, como:

```text
discount.value >= 0
```

y, cuando corresponda:

```text
discount.value <= 100
```

para descuentos porcentuales.

### Historial

La arquitectura deberá considerar siempre tres niveles:

```text
Configuración actual
        ↓
discount

Valor aplicado
        ↓
sale_item

Historial de cambios
        ↓
audit_record
```

Esta separación garantiza que modificar un descuento en el futuro no altere el significado de las ventas históricas.
