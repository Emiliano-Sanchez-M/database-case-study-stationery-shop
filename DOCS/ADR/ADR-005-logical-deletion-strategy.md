# ADR-005: Estrategia de eliminación lógica

## Estado

Aceptado

## Fecha

2026-08-07

## Contexto

El sistema de gestión de la papelería maneja información operativa, administrativa e histórica que debe conservarse para garantizar la trazabilidad de las operaciones y permitir auditorías posteriores.

En un sistema de este tipo, eliminar físicamente un registro mediante `DELETE` puede provocar pérdida de información relevante.

Por ejemplo:

* Un usuario puede dejar de trabajar en la papelería, pero sus ventas históricas deben continuar asociadas a él.
* Un producto puede dejar de comercializarse, pero sus ventas y compras históricas deben conservarse.
* Un descuento puede dejar de estar vigente, pero las ventas anteriores deben continuar identificando el descuento utilizado.
* Un proveedor puede dejar de trabajar con la empresa, pero las compras históricas deben conservar su relación.
* Un método de pago puede dejar de estar disponible, pero los pagos históricos deben continuar identificando el método utilizado.
* Una venta cancelada debe conservarse para poder conocer que existió y posteriormente fue cancelada.
* Un apartado vencido o cancelado debe conservarse como parte del historial comercial.
* Los registros de auditoría deben permanecer disponibles para conocer qué cambios fueron realizados.

Además, el sistema requiere distinguir entre:

1. Información que deja de estar disponible para nuevas operaciones.
2. Información que debe conservarse porque forma parte del historial.
3. Operaciones que deben permanecer registradas aunque hayan sido canceladas.

Por lo tanto, eliminar físicamente información no debe ser el mecanismo normal para desactivar o cancelar registros.

---

## Decisión

Se utilizará una **estrategia de eliminación lógica** para las entidades que representen información reutilizable, configurable, administrativa o que pueda ser necesaria para mantener referencias históricas.

La eliminación lógica permitirá que un registro deje de participar en operaciones nuevas sin desaparecer físicamente de la base de datos.

Dependiendo de la naturaleza de la entidad, se utilizarán mecanismos como:

```text
active
status
deleted_at
cancelled_at
```

No todas las entidades utilizarán necesariamente el mismo mecanismo.

La estrategia se determinará de acuerdo con el significado del registro dentro del dominio.

---

# Entidades configurables

Las entidades configurables o de catálogo utilizarán preferentemente un campo:

```text
active
```

Ejemplos:

* `product`
* `service`
* `category`
* `brand`
* `supplier`
* `payment_method`
* `discount`
* `service_rate`

Cuando:

```text
active = true
```

la entidad puede utilizarse en nuevas operaciones, siempre que las demás reglas del sistema lo permitan.

Cuando:

```text
active = false
```

la entidad deja de estar disponible para nuevas operaciones, pero permanece almacenada.

### Ejemplo

Un producto puede pasar de:

```text
active = true
```

a:

```text
active = false
```

El producto ya no aparecerá como disponible para nuevas ventas, pero continuarán existiendo sus:

```text
sale_item
purchase_item
reservation_item
inventory_movement
product_interest
```

y demás registros históricos relacionados.

---

# Entidades administrativas

Los usuarios, roles y permisos también deben conservarse.

Por ejemplo, un usuario que deja de trabajar en la empresa puede ser desactivado:

```text
status = INACTIVE
```

pero no debe eliminarse físicamente.

Esto permite conservar correctamente relaciones como:

```text
user
  ↓
sale

user
  ↓
payment

user
  ↓
inventory_movement

user
  ↓
cash_movement

user
  ↓
audit_record
```

De esta manera, una operación histórica continúa indicando quién la realizó.

---

# Operaciones históricas

Las entidades que representan operaciones comerciales o movimientos históricos no utilizarán la eliminación física como mecanismo normal de corrección.

Entre ellas:

```text
sale
payment
return
reservation
reservation_payment
purchase
inventory_movement
cash_movement
cash_closing
invoice
audit_record
```

Estas entidades deberán conservarse.

Cuando una operación deje de ser válida, se utilizará el estado correspondiente.

Por ejemplo:

```text
sale.status = CANCELLED
```

en lugar de:

```sql
DELETE FROM sale;
```

---

# Ventas canceladas

Una venta cancelada debe continuar existiendo.

Por ejemplo:

```text
Venta #1045
Estado: CANCELLED
```

La información asociada continúa disponible:

```text
sale
sale_item
payment
ticket
```

cuando corresponda.

Esto permite determinar posteriormente:

* Qué venta existió.
* Quién la realizó.
* Qué productos contenía.
* Qué importe tenía.
* Si tuvo pagos.
* Cuándo fue cancelada.
* Quién realizó la cancelación, cuando la operación lo requiera.
* Qué movimientos de inventario o caja estuvieron relacionados.

La cancelación representa un cambio de estado, no la desaparición de la operación.

---

# Apartados cancelados o vencidos

Los apartados tampoco deben eliminarse físicamente.

Un apartado puede cambiar de estado, por ejemplo:

```text
ACTIVE
COMPLETED
CANCELLED
EXPIRED
```

La información original debe conservarse.

Esto es especialmente importante porque el apartado contiene snapshots de las reglas utilizadas en el momento de su creación:

```text
minimum_percentage_applied
cancellation_retention_percentage_applied
expiration_retention_percentage_applied
```

Eliminar el apartado impediría reconstruir correctamente las condiciones bajo las cuales fue creado.

---

# Descuentos desactivados

Un descuento que deje de utilizarse no debe eliminarse físicamente.

Debe pasar, por ejemplo, a:

```text
active = false
```

Esto permite conservar:

```text
discount_id
```

en los `sale_item` históricos.

Además, `sale_item` conserva los valores aplicados:

```text
discount_type
discount_value
discount_amount
```

Por lo tanto, aunque el descuento deje de estar activo o cambie posteriormente, las ventas históricas continúan siendo interpretables.

---

# Productos descontinuados

Cuando un producto deje de venderse, no debe eliminarse físicamente.

Se utilizará:

```text
active = false
```

El producto dejará de estar disponible para nuevas operaciones, pero continuará relacionado con:

```text
sale_item
purchase_item
reservation_item
inventory_movement
inventory_incident
product_interest
product_supplier
```

Esto permite mantener la integridad referencial y el historial comercial.

---

# Proveedores inactivos

Un proveedor que deje de utilizarse puede pasar a:

```text
active = false
```

Esto evita que aparezca como proveedor disponible para nuevas compras, pero conserva sus relaciones históricas:

```text
purchase
product_supplier
```

---

# Métodos de pago inactivos

Un método de pago puede dejar de estar disponible para nuevas operaciones sin eliminarse.

Por ejemplo:

```text
payment_method

name = "Transferencia"
active = false
```

Los pagos históricos continúan conservando:

```text
payment_method_id
```

Esto permite saber cómo se realizó una operación histórica incluso si dicho método ya no está habilitado.

---

# Auditoría

Los registros de:

```text
audit_record
```

no deben eliminarse físicamente.

La auditoría representa evidencia histórica de modificaciones realizadas sobre el sistema.

Por lo tanto, eliminar registros de auditoría destruiría precisamente la información que el mecanismo de auditoría pretende conservar.

La información auditada debe permanecer disponible para responder preguntas como:

* ¿Quién realizó el cambio?
* ¿Qué entidad modificó?
* ¿Qué registro modificó?
* ¿Cuándo ocurrió?
* ¿Cuál era el valor anterior?
* ¿Cuál es el valor nuevo?
* ¿Cuál fue el motivo?

---

# Diferencia entre desactivación y cancelación

No todas las situaciones representan una eliminación lógica con el mismo significado.

## Desactivación

Indica que una entidad ya no debe utilizarse en nuevas operaciones.

Ejemplo:

```text
product.active = false
```

El producto deja de venderse, pero continúa existiendo.

## Cancelación

Indica que una operación previamente creada dejó de ser válida.

Ejemplo:

```text
sale.status = CANCELLED
```

La venta existió, pero posteriormente fue cancelada.

## Vencimiento

Indica que una operación alcanzó una condición temporal definida por el negocio.

Ejemplo:

```text
reservation.status = EXPIRED
```

El apartado continúa existiendo como registro histórico.

---

# Eliminación física

La eliminación física podrá utilizarse únicamente cuando exista una razón técnica o de negocio claramente justificada y cuando no comprometa:

* Integridad referencial.
* Historial operativo.
* Auditoría.
* Trazabilidad.
* Información financiera.
* Información fiscal.
* Evidencia de operaciones anteriores.

Las eliminaciones físicas no deberán utilizarse como mecanismo habitual para corregir errores operativos.

Cuando exista información incorrecta en una operación histórica, se deberá evaluar la creación de una nueva operación de corrección, cancelación, devolución, ajuste o mecanismo equivalente, según corresponda al dominio.

---

# Restricciones de integridad

La estrategia de eliminación lógica no debe utilizarse para ignorar las relaciones entre entidades.

Por ejemplo, desactivar un producto no significa eliminar sus relaciones históricas.

Debe mantenerse:

```text
product
    ↓
sale_item
```

aunque:

```text
product.active = false
```

Esto permite que las claves foráneas continúen siendo válidas.

---

# Consultas de información activa

Las operaciones destinadas a crear nuevas transacciones deberán considerar el estado de las entidades.

Por ejemplo, una búsqueda de productos disponibles deberá filtrar:

```text
active = true
```

mientras que una consulta histórica podrá incluir productos:

```text
active = false
```

Esto establece una diferencia importante entre:

```text
disponibilidad actual
```

y:

```text
existencia histórica
```

---

# Impacto en la arquitectura

Esta decisión afecta principalmente a las siguientes capas y componentes:

### Modelo de dominio

Las entidades deberán representar correctamente estados como:

```text
ACTIVE
INACTIVE
CANCELLED
EXPIRED
COMPLETED
```

según corresponda.

### Persistencia

Las entidades deberán contar con los campos necesarios para representar su estado, por ejemplo:

```text
active
status
deleted_at
cancelled_at
```

cuando corresponda.

Los repositorios deberán distinguir entre registros activos y registros históricos.

### Aplicación

Los casos de uso deberán impedir operaciones sobre entidades que no se encuentren disponibles para nuevas operaciones.

Por ejemplo:

* No vender productos inactivos.
* No utilizar descuentos inactivos en nuevas ventas.
* No realizar nuevas compras con proveedores inactivos cuando la regla lo impida.
* No utilizar métodos de pago inactivos.

### Base de datos

Las foreign keys deberán mantenerse para conservar las relaciones históricas.

Los constraints deberán impedir estados inválidos.

### Auditoría

Las operaciones de desactivación, cancelación y cambios de estado relevantes deberán poder registrarse mediante `audit_record`.

### Reportes

Los reportes históricos deberán poder incluir entidades que actualmente se encuentren inactivas.

---

## Consecuencias

### Ventajas

* Conservación del historial.
* Integridad referencial.
* Mayor trazabilidad.
* Mejor capacidad de auditoría.
* Permite conocer quién participó en operaciones históricas.
* Evita perder información al desactivar entidades.
* Permite reconstruir operaciones anteriores.
* Facilita reportes históricos.
* Evita que cambios administrativos alteren la interpretación de operaciones anteriores.
* Permite diferenciar entre información actualmente disponible e información históricamente existente.

### Desventajas

* La base de datos conservará registros que ya no se utilizan activamente.
* Las consultas deberán considerar correctamente el estado de los registros.
* La lógica de aplicación será ligeramente más compleja.
* Será necesario definir cuidadosamente qué estados puede tener cada entidad.
* El crecimiento de la base de datos será mayor que utilizando eliminación física.

---

## Alternativas consideradas

### 1. Eliminación física mediante `DELETE`

**Descartada.**

Aunque simplifica el almacenamiento de datos actuales, provoca pérdida de información histórica y puede romper relaciones necesarias para auditoría y trazabilidad.

---

### 2. Eliminación lógica universal mediante `deleted_at`

**Descartada como estrategia universal.**

Aunque `deleted_at` puede ser útil para algunas entidades, no representa correctamente todos los conceptos del dominio.

Por ejemplo:

```text
CANCELLED
EXPIRED
INACTIVE
```

tienen significados diferentes.

Por esta razón, se utilizará el mecanismo que mejor represente cada entidad.

---

### 3. Mantener todos los registros siempre activos

**Descartada.**

Mantener registros disponibles para nuevas operaciones después de que hayan dejado de ser válidos permitiría realizar operaciones incorrectas.

Por ejemplo, un descuento descontinuado podría continuar apareciendo como opción para nuevas ventas.

---

### 4. Crear tablas de archivo para registros eliminados

**Descartada como estrategia principal.**

Separar los registros históricos en tablas independientes aumentaría la complejidad de consultas, relaciones y mantenimiento.

Además, muchas entidades históricas continúan necesitando relaciones directas con sus operaciones originales.

---

## Resultado

El sistema utilizará eliminación lógica y estados para evitar la eliminación física de información relevante.

La estrategia se resume de la siguiente manera:

```text
Información configurable
        ↓
active / status
        ↓
deja de utilizarse en nuevas operaciones
        ↓
permanece almacenada


Operación histórica
        ↓
status
        ↓
CANCELLED / EXPIRED / COMPLETED
        ↓
permanece almacenada


Auditoría
        ↓
audit_record
        ↓
nunca se elimina físicamente como operación normal
```

La eliminación física queda reservada para casos excepcionales en los que pueda demostrarse que no existe impacto sobre la integridad, trazabilidad, auditoría o historial del sistema.
