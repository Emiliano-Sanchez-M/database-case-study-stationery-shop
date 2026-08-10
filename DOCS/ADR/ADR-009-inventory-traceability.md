# ADR-009: Estrategia de trazabilidad del inventario

## Estado

Aceptado

## Fecha

2026-08-08

## Contexto

El sistema necesita mantener un control confiable del inventario de productos comercializados por la papelería.

El inventario no debe limitarse a almacenar únicamente la cantidad actual disponible, ya que esto impediría conocer posteriormente cómo se llegó a determinado estado.

Una modificación en la existencia puede originarse por diferentes operaciones, entre ellas:

* Venta de productos.
* Recepción de mercancía.
* Devoluciones de clientes.
* Ajustes de inventario.
* Diferencias detectadas durante una revisión física.
* Correcciones derivadas de incidencias.
* Reservas y liberación de productos apartados.

Además, los requisitos funcionales establecen que, cuando exista una diferencia entre el inventario físico y el registrado por el sistema, debe ser posible generar una incidencia para que sea revisada.

También es necesario conocer quién realizó una modificación y cuándo ocurrió.

Por ejemplo, si el sistema indica que existen 10 unidades de un producto y posteriormente aparecen 7, no es suficiente conocer que actualmente existen 7 unidades. Debe ser posible determinar qué movimientos provocaron el cambio y, cuando corresponda, qué usuario los realizó.

Por esta razón, el modelo distingue entre:

```text
inventory
```

como estado actual del inventario, y:

```text
inventory_movement
```

como historial de movimientos.

Adicionalmente, se utiliza:

```text
inventory_incident
```

para registrar diferencias o situaciones que requieren revisión.

---

## Decisión

Se utilizará un modelo de inventario basado en **estado actual + historial de movimientos + incidencias**.

### 1. Estado actual

La entidad:

```text
inventory
```

representará exclusivamente el estado actual de existencia de cada producto.

Contendrá, entre otros datos:

```text
quantity
reserved_quantity
updated_at
```

La existencia disponible se determinará conceptualmente mediante:

```text
quantity - reserved_quantity
```

La entidad `inventory` tendrá una relación 1:1 con `product`.

---

### 2. Historial de movimientos

Toda modificación relevante de la existencia deberá generar un registro en:

```text
inventory_movement
```

Este registro conservará información como:

* Producto afectado.
* Tipo de movimiento.
* Cantidad.
* Usuario responsable.
* Referencia de la operación que originó el movimiento.
* Motivo.
* Observaciones.
* Fecha y hora.

Entre los tipos de movimiento podrán existir:

```text
SALE
PURCHASE
RETURN
ADJUSTMENT
RESERVATION
RESERVATION_RELEASE
```

Los valores concretos podrán evolucionar durante la implementación.

La información histórica de los movimientos no deberá eliminarse físicamente como mecanismo normal de corrección.

---

### 3. Referencia de origen

Los movimientos podrán almacenar:

```text
reference_type
reference_id
```

para identificar la operación que originó el movimiento.

Por ejemplo:

```text
reference_type = SALE
reference_id = 154
```

Esto permite relacionar conceptualmente el movimiento con una venta específica sin duplicar innecesariamente la información de la operación.

---

### 4. Incidencias de inventario

Cuando exista una diferencia entre la cantidad física y la cantidad registrada por el sistema, se utilizará:

```text
inventory_incident
```

La incidencia conservará, entre otros datos:

```text
system_quantity
physical_quantity
difference
reason
status
reported_by
resolved_by
notes
created_at
resolved_at
```

Esto permite distinguir entre:

```text
Movimiento normal
```

y:

```text
Diferencia que requiere investigación
```

Una incidencia podrá posteriormente generar uno o más movimientos de ajuste cuando corresponda.

---

### 5. Trazabilidad del usuario

Los movimientos e incidencias deberán conservar el usuario relacionado con la acción.

Esto permitirá responder posteriormente preguntas como:

* ¿Quién realizó el ajuste?
* ¿Quién reportó la diferencia?
* ¿Quién resolvió la incidencia?
* ¿Cuándo ocurrió?
* ¿Qué cantidad estaba registrada?
* ¿Qué cantidad se encontró físicamente?

---

### 6. No permitir inventario negativo

El sistema deberá impedir cantidades negativas en:

```text
inventory.quantity
```

y:

```text
inventory.reserved_quantity
```

Además:

```text
reserved_quantity <= quantity
```

deberá mantenerse como restricción de integridad.

La lógica exacta para manejar intentos de venta sin existencia suficiente será definida en la implementación de los casos de uso correspondientes.

---

## Consecuencias

### Ventajas

* Permite conocer el estado actual del inventario.
* Permite reconstruir el historial de movimientos.
* Permite identificar al usuario responsable de una modificación.
* Facilita la investigación de diferencias de inventario.
* Permite relacionar movimientos con operaciones comerciales.
* Evita depender únicamente del valor actual de `inventory`.
* Facilita auditorías posteriores.
* Permite distinguir movimientos normales de incidencias.
* Mantiene trazabilidad de ajustes manuales.
* Facilita futuras funcionalidades de reportes y análisis de inventario.

### Desventajas

* El modelo es más complejo que almacenar únicamente una cantidad.
* El sistema debe generar correctamente los movimientos correspondientes a cada operación.
* El número de registros históricos crecerá con el tiempo.
* Será necesario definir cuidadosamente la consistencia transaccional entre las operaciones y sus movimientos de inventario.
* Las correcciones de inventario requieren procedimientos controlados en lugar de modificar directamente la existencia sin dejar trazabilidad.

---

## Alternativas consideradas

### 1. Almacenar únicamente la cantidad actual

Ejemplo:

```text
product.stock = 10
```

Se descartó porque no permite conocer cómo se llegó a ese valor ni quién realizó las modificaciones.

---

### 2. Mantener únicamente movimientos y calcular siempre el inventario actual

En este enfoque, la existencia se obtendría sumando todos los movimientos históricos.

Se descartó como estrategia principal porque obligaría a reconstruir constantemente el estado actual y podría resultar costoso conforme aumente el volumen de operaciones.

El historial de movimientos se conservará como fuente de trazabilidad, mientras que `inventory` mantendrá el estado actual.

---

### 3. Modificar directamente `inventory` sin generar movimientos para todas las operaciones

Se descartó porque permitiría cambios sin explicación histórica.

Toda modificación relevante de existencia deberá tener una causa trazable.

---

### 4. Registrar únicamente las diferencias detectadas

Se descartó porque una incidencia solamente explica una discrepancia, pero no proporciona el historial completo de operaciones normales que modificaron el inventario.

---

## Impacto en la arquitectura

Esta decisión afecta principalmente las siguientes capas:

### Dominio

Se incorporan conceptos relacionados con:

* Inventario.
* Movimiento de inventario.
* Incidencia de inventario.
* Estados de inventario.
* Reglas de existencia y reserva.

### Aplicación

Los casos de uso que modifiquen inventario deberán generar los movimientos correspondientes.

Entre ellos:

* Registrar venta.
* Registrar compra.
* Registrar devolución.
* Crear apartado.
* Liberar productos de un apartado.
* Ajustar inventario.
* Resolver una incidencia.

### Persistencia

Se requieren las entidades:

```text
inventory
inventory_movement
inventory_incident
```

y sus relaciones con:

```text
product
user
```

### Seguridad

Las operaciones de ajuste y resolución de incidencias deberán estar sujetas al sistema de roles y permisos.

### Auditoría

Los cambios administrativos o sensibles relacionados con inventario deberán poder complementarse mediante:

```text
audit_record
```

La diferencia entre ambos mecanismos será:

```text
inventory_movement
    → historial operativo del inventario

inventory_incident
    → situación que requiere revisión

audit_record
    → trazabilidad de cambios administrativos
```

### Base de datos

Deberán implementarse restricciones que garanticen:

```text
quantity >= 0
reserved_quantity >= 0
reserved_quantity <= quantity
```

Además, deberán definirse índices adecuados para consultar movimientos por:

* Producto.
* Usuario.
* Fecha.
* Tipo de movimiento.
* Referencia de operación.

---

## Relación con otros ADR

Este ADR se relaciona directamente con:

* **ADR-003: Historical Data and Snapshots**, debido a la conservación de información histórica.
* **ADR-004: Audit Trail Strategy**, debido a la trazabilidad de acciones administrativas.
* **ADR-005: Logical Deletion Strategy**, debido a la decisión de conservar información operativa.
* **ADR-006: Sales and Payment Model**, porque las ventas generan movimientos de inventario.
* **ADR-009: Inventory Traceability**, como definición de la estrategia específica de inventario.
* **ADR-010: Returns and Refunds Model**, porque las devoluciones pueden generar movimientos de entrada al inventario.
* **ADR-012: Future Multi-Branch Support**, debido a que una futura expansión a múltiples sucursales requeriría determinar a qué sucursal pertenece cada existencia y movimiento.
