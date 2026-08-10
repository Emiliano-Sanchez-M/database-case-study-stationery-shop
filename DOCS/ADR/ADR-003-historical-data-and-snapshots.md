# ADR-003 — Historical Data and Snapshots

## Estado

Aceptado

## Fecha

2026-08-07

## Contexto

El sistema administra información que puede cambiar con el tiempo, especialmente configuraciones comerciales, precios, descuentos y reglas de operación.

Algunas entidades representan la **configuración actual** del negocio, mientras que otras representan **operaciones que ocurrieron en un momento determinado**.

Por ejemplo, un producto puede tener actualmente un precio de `$120`, pero una venta realizada anteriormente pudo haberse efectuado cuando el precio era de `$100`.

De igual manera, un descuento puede haber sido del `15%` al momento de realizar una venta y posteriormente cambiar al `18%`.

Los apartados presentan una situación similar. Las reglas configurables pueden establecer, por ejemplo:

* 30% de anticipo mínimo.
* 7 días de vigencia.
* 15% de retención por cancelación.
* 30% de retención por vencimiento.

Estas reglas pueden modificarse posteriormente.

Si las operaciones históricas dependieran exclusivamente de los valores actuales almacenados en las entidades de configuración, sería imposible determinar con precisión qué reglas, precios o descuentos fueron utilizados cuando ocurrió una operación.

Por lo tanto, es necesario establecer una estrategia que permita conservar los valores relevantes utilizados en el momento de ejecutar una operación.

---

## Decisión

Se utilizará una estrategia de **snapshots históricos** para conservar dentro de las operaciones los valores relevantes que fueron utilizados en el momento de su ejecución.

Las entidades de configuración conservarán los **valores actuales**, mientras que las entidades operativas conservarán una copia de los valores necesarios para reconstruir correctamente el contexto histórico de la operación.

La información histórica no deberá reconstruirse consultando únicamente el estado actual de las entidades de configuración.

### Principio general

> Una operación histórica debe conservar los valores que realmente utilizó, independientemente de los cambios posteriores realizados en la configuración.

---

## Aplicación del patrón Snapshot

### Ventas

El detalle de venta (`sale_item`) conservará:

```text
unit_price
discount_type
discount_value
discount_amount
```

El precio utilizado en una venta será independiente del precio actual del producto.

Por ejemplo:

```text
Precio actual:
product.sale_price = 120
```

Una venta histórica puede conservar:

```text
sale_item.unit_price = 100
```

Si posteriormente el producto cambia a `$120`, la venta continuará representando correctamente el precio de `$100`.

---

### Descuentos

El descuento utilizado en una venta se identificará mediante:

```text
discount_id
```

Sin embargo, la operación también conservará:

```text
discount_type
discount_value
discount_amount
```

Esto permite distinguir entre:

* El descuento configurado actualmente.
* El descuento que realmente fue aplicado.

Por ejemplo:

```text
Configuración original:
Descuento estudiante = 15%
```

Una venta puede conservar:

```text
discount_id = 2
discount_value = 15
```

Posteriormente:

```text
discount.value = 18
```

La venta histórica continuará indicando:

```text
15%
```

---

### Apartados

Los apartados conservarán las reglas aplicadas al momento de su creación:

```text
minimum_percentage_applied
cancellation_retention_percentage_applied
expiration_retention_percentage_applied
```

También conservarán:

```text
reservation_item.unit_price
```

para preservar el precio utilizado al crear el apartado.

Por ejemplo, si al crear un apartado las reglas eran:

```text
Anticipo mínimo: 30%
Cancelación: 15%
Vencimiento: 30%
```

el registro conservará esos valores aunque posteriormente la configuración cambie.

Si la configuración pasa a:

```text
Anticipo mínimo: 40%
Cancelación: 10%
Vencimiento: 25%
```

los apartados existentes continuarán utilizando los valores originales.

Los nuevos apartados utilizarán la nueva configuración.

---

### Compras

Los detalles de compra (`purchase_item`) conservarán:

```text
unit_cost
```

Esto permite conocer cuánto costó realmente un producto en una compra determinada.

Por ejemplo:

```text
Compra de enero:
unit_cost = 8

Compra de marzo:
unit_cost = 9

Compra de junio:
unit_cost = 11
```

Aunque el proveedor tenga actualmente otro precio, cada compra conserva su propio costo histórico.

---

## Configuración actual vs. Snapshot

El modelo diferencia explícitamente ambos conceptos.

### Configuración actual

Representa el valor vigente en el sistema.

Ejemplos:

```text
product.sale_price
product.stock_alert_level

discount.value

reservation_configuration.minimum_percentage

service_rate.unit_price
```

### Snapshot

Representa el valor utilizado en una operación concreta.

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

La configuración actual puede cambiar.

El snapshot histórico no debe modificarse como consecuencia de esos cambios.

---

## Alcance del Snapshot

No todos los atributos de una entidad deben copiarse automáticamente.

Se almacenarán como snapshot únicamente los valores cuyo cambio posterior pueda alterar la interpretación histórica de una operación.

Principalmente:

* Precios.
* Costos.
* Porcentajes.
* Montos.
* Reglas aplicadas.
* Condiciones comerciales.
* Valores derivados relevantes para la operación.

Esto evita duplicación innecesaria de información sin sacrificar trazabilidad histórica.

---

## Relación con Auditoría

El snapshot y la auditoría cumplen funciones diferentes y complementarias.

### Snapshot

Responde:

> ¿Qué valor utilizó la operación?

### Auditoría

Responde:

> ¿Quién cambió la configuración y qué valores tenía antes y después?

Por ejemplo:

```text
discount.value
```

puede cambiar de:

```text
15 → 18
```

El `audit_record` conservará el cambio:

```text
old_value = 15
new_value = 18
```

Mientras que una venta realizada antes del cambio conservará:

```text
sale_item.discount_value = 15
```

De esta forma, ambos mecanismos permiten reconstruir correctamente la historia.

---

## Consecuencias

### Ventajas

* Las operaciones históricas permanecen inmutables respecto a cambios posteriores de configuración.
* Es posible reconstruir las condiciones bajo las cuales ocurrió una operación.
* Se evita depender del estado actual para interpretar información histórica.
* Se facilita la auditoría.
* Se conserva el precio real utilizado en ventas, compras y apartados.
* Se conserva el descuento realmente aplicado.
* Se preservan las reglas utilizadas para crear un apartado.
* Se evita que cambios administrativos alteren retroactivamente operaciones anteriores.
* El sistema puede responder preguntas históricas con mayor precisión.

### Desventajas

* Existe cierta duplicación de información.
* Las entidades operativas contienen datos que también existen en entidades de configuración.
* Se requiere definir cuidadosamente qué atributos deben almacenarse como snapshot.
* Los cambios en el modelo pueden requerir mantener consistencia entre la configuración y los valores almacenados en las operaciones.
* El tamaño de las tablas operativas puede incrementarse ligeramente.

---

## Alternativas consideradas

### 1. Consultar siempre la configuración actual

No se adopta.

Esta estrategia provocaría que una operación histórica pudiera cambiar de significado después de una modificación administrativa.

Por ejemplo, una venta que recibió un descuento del 15% podría aparecer posteriormente como una venta con descuento del 18%.

Esto no es aceptable para operaciones históricas.

---

### 2. Conservar únicamente registros de auditoría

No se adopta como mecanismo único.

La auditoría permite conocer que una configuración cambió, pero no necesariamente proporciona de forma sencilla y directa el valor utilizado por cada operación.

Además, reconstruir una operación histórica mediante múltiples registros de auditoría sería innecesariamente complejo y propenso a errores.

---

### 3. Crear versiones completas de todas las entidades

No se adopta como estrategia general.

Crear una versión completa de cada entidad ante cada modificación incrementaría considerablemente la complejidad del modelo y no es necesario para todos los datos.

Se considera más apropiado conservar snapshots únicamente en las operaciones donde los valores históricos sean relevantes.

---

### 4. Utilizar exclusivamente timestamps para reconstruir valores

No se adopta como mecanismo principal.

Aunque las fechas permiten determinar cuándo ocurrió una operación, no garantizan por sí mismas que sea posible reconstruir exactamente qué configuración estaba vigente, especialmente cuando existen múltiples cambios, correcciones o configuraciones concurrentes.

---

## Ejemplo completo

Supongamos que inicialmente existe la siguiente configuración:

```text
Producto:
Precio = $100

Descuento estudiante:
15%

Apartados:
Anticipo mínimo = 30%
Cancelación = 15%
Vencimiento = 30%
```

Se realiza una venta.

El sistema almacena:

```text
sale_item.unit_price = 100
sale_item.discount_value = 15
sale_item.discount_amount = 15
```

Posteriormente el administrador cambia:

```text
Precio = $120
Descuento estudiante = 18%
```

Y modifica las reglas de apartados:

```text
Anticipo mínimo = 40%
Cancelación = 10%
Vencimiento = 25%
```

La venta anterior continúa conservando:

```text
Precio utilizado = $100
Descuento aplicado = 15%
```

Un apartado creado antes del cambio continúa conservando:

```text
Anticipo mínimo aplicado = 30%
Cancelación aplicada = 15%
Vencimiento aplicado = 30%
```

Mientras que un nuevo apartado utilizará:

```text
Anticipo mínimo = 40%
Cancelación = 10%
Vencimiento = 25%
```

De esta manera, las nuevas configuraciones afectan únicamente a las operaciones que se creen posteriormente.

---

## Reglas derivadas

A partir de esta decisión:

1. Las operaciones históricas no deberán depender exclusivamente de configuraciones actuales.
2. Los precios utilizados en operaciones deberán almacenarse como snapshot cuando puedan cambiar.
3. Los descuentos aplicados deberán conservar sus valores históricos.
4. Las reglas configurables aplicadas a apartados deberán conservarse dentro del apartado.
5. Los costos históricos de compra deberán conservarse en `purchase_item`.
6. Los valores snapshot no deberán modificarse automáticamente cuando cambie la configuración actual.
7. La auditoría deberá utilizarse adicionalmente para registrar cambios administrativos relevantes.
8. El snapshot no sustituye al registro de auditoría.
9. La configuración actual y los valores históricos deben considerarse conceptos diferentes.
10. Las operaciones canceladas o completadas deberán conservar sus valores históricos.

---

## Impacto en la arquitectura

Esta decisión afecta principalmente las siguientes capas y componentes:

### Capa de dominio

Se deberán distinguir claramente:

* Valores configurables.
* Valores aplicados a una operación.
* Información histórica.

Las entidades de dominio deberán representar explícitamente los valores snapshot cuando sean necesarios.

### Capa de persistencia

Las tablas operativas deberán contener las columnas necesarias para conservar los valores históricos.

Principalmente:

```text
sale_item
reservation
reservation_item
purchase_item
```

### Base de datos

Se deberán definir:

* Columnas snapshot.
* Tipos numéricos apropiados.
* Restricciones de integridad.
* Relaciones con las configuraciones originales cuando corresponda.

### Capa de aplicación

Los servicios responsables de crear operaciones deberán copiar los valores vigentes de configuración al momento de crear la operación.

Por ejemplo:

```text
Configuración actual
        ↓
Creación de operación
        ↓
Snapshot
        ↓
Persistencia
```

### Auditoría

El mecanismo de auditoría deberá funcionar de manera complementaria al snapshot para registrar modificaciones de las configuraciones.

### Reportes

Los reportes históricos deberán utilizar los valores snapshot de las operaciones y no recalcular información utilizando exclusivamente la configuración actual.

---

## Referencias

Este ADR se fundamenta en:

* Modelo de dominio.
* Modelo entidad-relación.
* Diccionario de datos.
* Requerimientos funcionales.
* Requerimientos no funcionales.
* Casos de uso.
* Reglas de negocio.

Este ADR se relaciona directamente con:

* **ADR-002 — Database Normalization**
* **ADR-004 — Audit Trail Strategy**
* **ADR-007 — Product Discount Model**
* **ADR-008 — Reservation Rules and Snapshots**
* **ADR-011 — Configurable Business Rules**
