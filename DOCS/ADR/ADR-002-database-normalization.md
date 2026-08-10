# ADR-002: Estrategia de normalización de la base de datos

## Estado

Aceptado

## Fecha

2026-08-07

## Contexto

El sistema de gestión para la papelería requiere una estructura de datos consistente, mantenible y capaz de conservar información histórica sin generar redundancias innecesarias.

Durante el diseño del modelo entidad-relación se identificaron diferentes grupos de información:

* Seguridad y control de acceso.
* Clientes.
* Datos fiscales.
* Catálogo de productos.
* Servicios.
* Inventario.
* Ventas.
* Pagos.
* Devoluciones.
* Apartados.
* Compras.
* Proveedores.
* Caja.
* Facturación.
* Configuraciones.
* Auditoría.
* Intereses por productos.

Debido a la cantidad de relaciones existentes, existe el riesgo de almacenar información repetida dentro de una misma entidad o de mezclar diferentes conceptos en una sola tabla.

Esto podría provocar anomalías de:

* Inserción.
* Actualización.
* Eliminación.

También podría provocar inconsistencias históricas y dificultades para mantener la integridad referencial.

Por ejemplo, almacenar directamente en una venta información repetida de cada producto podría provocar que el nombre, categoría, proveedor o precio de un producto aparecieran múltiples veces.

De igual manera, almacenar múltiples roles dentro de una columna de usuario dificultaría mantener una relación correcta entre usuarios y roles.

Por otro lado, una normalización excesiva podría producir una estructura innecesariamente compleja y dificultar la comprensión o el rendimiento del sistema.

Por estas razones se requiere establecer una estrategia de normalización que permita mantener la integridad de los datos sin introducir complejidad innecesaria.

---

## Decisión

La base de datos utilizará **normalización relacional**, tomando como objetivo principal alcanzar al menos la **Tercera Forma Normal (3FN)** en las entidades donde sea aplicable.

Las relaciones que requieran una estructura adicional se representarán mediante entidades o tablas intermedias.

La normalización se aplicará considerando:

* Dependencias funcionales.
* Atomicidad de los atributos.
* Separación de conceptos.
* Integridad referencial.
* Eliminación de dependencias parciales.
* Eliminación de dependencias transitivas.
* Reducción de redundancia.
* Conservación de información histórica.
* Necesidades reales del dominio.

La normalización no se aplicará de manera mecánica únicamente para aumentar el número de tablas.

La estructura final deberá representar correctamente el negocio y mantener un equilibrio entre integridad, claridad y complejidad.

---

# Formas normales consideradas

## Primera Forma Normal (1FN)

Las entidades deberán contener valores atómicos.

No se almacenarán grupos repetitivos ni múltiples valores independientes dentro de una misma columna.

Por ejemplo, no se utilizará:

```text
user.roles = "Administrador, Cajero, Inventario"
```

En su lugar, se utilizará una relación entre usuarios y roles:

```text
user
user_role
role
```

Esto permite que un usuario tenga múltiples roles sin almacenar una lista dentro de una columna.

---

## Segunda Forma Normal (2FN)

Las entidades con claves compuestas no deberán contener atributos que dependan solamente de una parte de la clave.

Las tablas intermedias se limitarán principalmente a representar la relación entre las entidades involucradas y a almacenar atributos que dependan de la relación completa.

Por ejemplo:

```text
user_role
```

utiliza:

```text
PK(user_id, role_id)
```

La relación depende de ambos identificadores.

De manera similar:

```text
product_supplier
```

utiliza:

```text
PK(product_id, supplier_id)
```

y sus atributos representan información relacionada con esa asociación.

---

## Tercera Forma Normal (3FN)

Los atributos no deberán depender transitivamente de otros atributos que no sean la clave primaria.

Por ejemplo, la información de una categoría no se duplicará en cada producto.

En lugar de:

```text
product
--------------------------------
id
name
category_name
category_description
```

se utilizará:

```text
product
category
```

con:

```text
product.category_id
```

De esta manera:

```text
product → category_id → category
```

y la información propia de la categoría permanece en su entidad correspondiente.

---

# Principios de normalización adoptados

## 1. Una entidad representa un concepto

Las tablas deberán representar conceptos coherentes.

Por ejemplo:

```text
customer
product
supplier
sale
payment
reservation
purchase
```

No se deberán mezclar conceptos independientes únicamente para reducir el número de tablas.

---

## 2. Los atributos pertenecen a la entidad que los determina

Cada atributo deberá almacenarse en la entidad donde tenga significado y dependencia funcional.

Por ejemplo:

```text
product.sale_price
```

representa el precio actual del producto.

Mientras que:

```text
sale_item.unit_price
```

representa el precio utilizado específicamente en una venta.

Estos dos atributos no son redundancia accidental, porque representan conceptos diferentes.

---

## 3. Las relaciones N:M se representan mediante tablas intermedias

Cuando exista una relación muchos-a-muchos, se utilizará una entidad intermedia.

Ejemplo:

```text
user N:M role
```

se representa como:

```text
user
  ↓
user_role
  ↓
role
```

Otro ejemplo:

```text
product N:M supplier
```

se representa como:

```text
product
  ↓
product_supplier
  ↓
supplier
```

---

## 4. Las relaciones operativas se separan de sus detalles

Las operaciones que contienen múltiples elementos utilizarán entidades de detalle.

Por ejemplo:

```text
sale
sale_item
```

Una venta puede contener múltiples productos o servicios.

Por lo tanto, no se almacenarán múltiples productos dentro de una sola fila de `sale`.

---

## 5. Las configuraciones se mantienen separadas de las operaciones

Las configuraciones representan valores modificables.

Las operaciones representan hechos ocurridos.

Por ejemplo:

```text
discount
```

representa la configuración actual de un descuento.

Mientras:

```text
sale_item
```

representa cómo se aplicó ese descuento en una venta específica.

Esta separación evita que una modificación de configuración altere el significado de una operación histórica.

---

# Normalización de usuarios y clientes

Los datos personales se separarán en atributos atómicos.

Para usuarios y empleados se utilizará:

```text
name
paternal_surname
maternal_surname
```

Los tres atributos serán obligatorios para los usuarios/empleados según las reglas establecidas.

Para clientes:

```text
name
paternal_surname
maternal_surname
```

El nombre será obligatorio.

Los apellidos serán opcionales.

No se utilizará:

```text
full_name
```

como sustituto de estos atributos.

Esto permite mantener la información personal estructurada y evita depender de procesos posteriores para intentar separar un nombre completo.

---

# Normalización de productos

La información de los productos se mantiene separada de:

* Categorías.
* Marcas.
* Proveedores.
* Inventario.
* Movimientos de inventario.

Por ejemplo:

```text
product
category
brand
inventory
inventory_movement
supplier
product_supplier
```

Esto evita duplicar información de categoría, marca o proveedor en cada registro de producto.

---

# Normalización de ventas

La venta se separa de sus elementos mediante:

```text
sale
sale_item
```

Los pagos se representan mediante:

```text
payment
payment_method
```

El ticket se representa mediante:

```text
ticket
```

Las devoluciones mediante:

```text
return
return_item
```

Esto evita almacenar múltiples valores repetidos dentro de una sola venta.

---

# Normalización de apartados

Los apartados se separan en:

```text
reservation
reservation_item
reservation_payment
reservation_configuration
```

La configuración actual de las reglas permanece separada de los valores aplicados a cada apartado.

Por ejemplo:

```text
reservation_configuration.minimum_percentage
```

representa la configuración vigente.

Mientras:

```text
reservation.minimum_percentage_applied
```

representa el porcentaje que se utilizó para un apartado específico.

Esta aparente duplicación es intencional y no constituye una violación conceptual de normalización, debido a que los atributos representan hechos diferentes:

```text
Configuración actual
```

vs.

```text
Valor histórico aplicado
```

---

# Normalización de compras

Las compras se separan en:

```text
purchase
purchase_item
```

Los proveedores se mantienen como una entidad independiente:

```text
supplier
```

La relación entre productos y proveedores se representa mediante:

```text
product_supplier
```

Esto permite que:

* Un producto tenga múltiples proveedores.
* Un proveedor suministre múltiples productos.

Los precios históricos se almacenan en:

```text
purchase_item.unit_cost
```

Esto no se considera redundancia innecesaria porque representa el costo utilizado en una operación específica.

---

# Normalización de inventario

El inventario actual se mantiene separado de su historial.

```text
inventory
```

representa el estado actual.

```text
inventory_movement
```

representa los movimientos realizados.

```text
inventory_incident
```

representa diferencias o incidencias detectadas.

Esto permite evitar almacenar múltiples estados históricos dentro de la misma fila de inventario.

---

# Normalización de caja

La caja se separa en:

```text
cash_register
cash_movement
cash_closing
```

Cada entidad representa un concepto diferente:

```text
cash_register
    ↓
sesión de caja

cash_movement
    ↓
movimiento individual

cash_closing
    ↓
resultado de un corte
```

Esto permite mantener un historial completo sin sobrecargar la entidad principal de caja.

---

# Normalización de descuentos

Los descuentos se mantienen como entidades independientes:

```text
discount
```

Una venta referencia el descuento aplicado mediante:

```text
sale_item.discount_id
```

Sin embargo, el detalle de venta también conserva:

```text
discount_type
discount_value
discount_amount
```

Estos valores representan el resultado histórico de la aplicación del descuento.

Por lo tanto, no se consideran una duplicación accidental.

La estructura distingue:

```text
discount
    ↓
Configuración actual

sale_item
    ↓
Aplicación histórica

audit_record
    ↓
Cambios de configuración
```

---

# Normalización de auditoría

La auditoría utiliza una entidad independiente:

```text
audit_record
```

Esta entidad contiene información como:

```text
user_id
action
entity_type
entity_id
old_value
new_value
reason
created_at
```

Los valores anteriores y nuevos se almacenan en `JSONB`.

Esto permite registrar cambios de diferentes entidades sin crear una tabla de auditoría independiente para cada tipo de entidad.

El uso de `JSONB` en este caso es intencional y representa una decisión de flexibilidad para una estructura transversal de auditoría.

No se considera apropiado normalizar cada propiedad auditada en columnas independientes porque el propósito de `audit_record` es registrar cambios heterogéneos sobre diferentes entidades.

---

# Normalización y datos históricos

La normalización no significa que todos los valores históricos deban eliminarse para evitar duplicación.

El sistema distingue entre:

### Datos derivados de configuración actual

Ejemplo:

```text
discount.value
```

### Datos utilizados durante una operación

Ejemplo:

```text
sale_item.discount_value
```

### Historial de modificaciones

Ejemplo:

```text
audit_record.old_value
audit_record.new_value
```

La repetición de un valor histórico está justificada cuando es necesaria para conservar el estado de una operación.

Por ejemplo:

```text
discount.value = 18
```

y:

```text
sale_item.discount_value = 15
```

pueden coexistir correctamente.

El primer valor representa la configuración actual.

El segundo representa el valor aplicado históricamente.

---

# Desnormalización controlada

No se realizará desnormalización de manera prematura.

Sin embargo, podrán existir atributos derivados o snapshots cuando exista una justificación funcional o histórica.

Ejemplos:

```text
sale.subtotal
sale.discount_total
sale.tax_total
sale.total
```

Estos valores pueden derivarse de los detalles de venta, pero se conservan para representar el resultado de la operación y facilitar su reconstrucción histórica.

De igual manera:

```text
reservation.paid_amount
reservation.due_amount
```

pueden derivarse de los pagos asociados, pero representan el estado financiero de la operación.

Cualquier desnormalización deberá estar justificada y, cuando tenga impacto arquitectónico, deberá documentarse mediante ADR.

---

# Anomalías que se busca evitar

La estrategia de normalización busca evitar principalmente:

## Anomalía de inserción

No debería ser necesario crear una venta ficticia para registrar un nuevo producto.

El producto puede existir independientemente:

```text
product
```

---

## Anomalía de actualización

Modificar el nombre de una categoría no debería requerir modificar múltiples productos.

La información se mantiene en:

```text
category
```

y los productos la referencian mediante:

```text
category_id
```

---

## Anomalía de eliminación

Eliminar una relación o registro operativo no debería provocar accidentalmente la pérdida de información independiente.

Por ejemplo, eliminar una venta no debe eliminar:

* El producto.
* El cliente.
* El método de pago.
* El usuario.

Además, las operaciones históricas no deben eliminarse físicamente como mecanismo normal de corrección.

---

# Integridad referencial

La normalización se complementará con restricciones de integridad referencial.

Las claves foráneas deberán garantizar que las referencias existentes correspondan a registros válidos.

Ejemplos:

```text
sale.customer_id → customer.id
sale.user_id → user.id
sale_item.sale_id → sale.id
sale_item.product_id → product.id
payment.sale_id → sale.id
payment.payment_method_id → payment_method.id
reservation.customer_id → customer.id
reservation_item.product_id → product.id
purchase.supplier_id → supplier.id
purchase_item.product_id → product.id
```

Las reglas de `ON DELETE` y `ON UPDATE` se definirán durante la implementación considerando la naturaleza histórica de cada relación.

---

# Normalización y eliminación lógica

La normalización no sustituye la estrategia de conservación histórica.

Para entidades que requieran conservación, se utilizarán mecanismos como:

```text
active
status
deleted_at
```

cuando corresponda.

Esto evita que una eliminación física provoque la pérdida de información necesaria para reconstruir operaciones históricas.

---

# Nivel de normalización objetivo

El objetivo general será:

```text
1FN
 ↓
2FN
 ↓
3FN
```

como nivel mínimo de normalización para las entidades relacionales convencionales.

No se buscará alcanzar formas normales superiores cuando esto:

* Aumente innecesariamente la complejidad.
* Dificulte la comprensión.
* No aporte un beneficio real.
* Interfiera con necesidades históricas.
* No sea coherente con el dominio.

La normalización se evaluará por entidad y por dependencia funcional.

---

# Excepciones justificadas

Existen estructuras que no siguen una interpretación estrictamente académica de normalización debido a necesidades específicas del sistema.

Estas excepciones deberán distinguirse claramente de errores de diseño.

## Snapshots históricos

Ejemplo:

```text
sale_item.discount_value
reservation.minimum_percentage_applied
reservation_item.unit_price
purchase_item.unit_cost
```

Se mantienen deliberadamente para conservar el estado utilizado durante una operación.

---

## Valores calculados de operaciones

Ejemplo:

```text
sale.total
sale.subtotal
sale.discount_total
sale.tax_total
```

Se mantienen para conservar el resultado de la operación y evitar depender exclusivamente de cálculos posteriores.

---

## Auditoría JSONB

Ejemplo:

```text
audit_record.old_value
audit_record.new_value
```

Se utiliza `JSONB` debido a que la auditoría debe poder registrar cambios heterogéneos sobre múltiples entidades.

---

# Relación con el modelo ER

La normalización se aplicará sobre el modelo entidad-relación antes de implementar físicamente la base de datos.

El proceso será:

```text
Modelo de dominio
        ↓
Modelo ER
        ↓
Análisis de dependencias
        ↓
Normalización
        ↓
Diccionario de datos
        ↓
Esquema PostgreSQL
```

El modelo ER podrá contener estructuras auxiliares necesarias para representar correctamente las relaciones.

La normalización no tiene como objetivo eliminar estas estructuras, sino asegurar que cada una tenga una responsabilidad clara.

---

# Relación con el diccionario de datos

El `data_dictionary.md` documenta:

* Columnas.
* Tipos de datos.
* Longitudes.
* Nullable.
* Restricciones.
* Descripciones.

La normalización proporciona la justificación conceptual de por qué esos atributos pertenecen a determinadas entidades y no a otras.

Ambos documentos deberán mantenerse consistentes.

Si una modificación estructural altera las dependencias entre atributos o entidades, deberá revisarse tanto:

```text
normalization.md
```

como:

```text
data_dictionary.md
```

y:

```text
er-model.md
```

cuando corresponda.

---

# Consecuencias

## Ventajas

* Reduce la redundancia innecesaria.
* Evita anomalías de inserción, actualización y eliminación.
* Mejora la integridad de los datos.
* Facilita el mantenimiento de la base de datos.
* Facilita la aplicación de restricciones.
* Hace explícitas las relaciones entre entidades.
* Permite representar correctamente relaciones N:M.
* Facilita la trazabilidad de operaciones.
* Permite separar configuración de operaciones históricas.
* Facilita futuras modificaciones del modelo.

## Desventajas

* Incrementa el número de tablas.
* Puede requerir más `JOIN`.
* Algunas consultas pueden ser más complejas.
* El modelo puede resultar más difícil de entender inicialmente.
* Los snapshots y valores históricos introducen cierta redundancia intencional.
* Una normalización excesiva podría perjudicar la simplicidad y el rendimiento.

---

# Alternativas consideradas

## 1. Mantener una estructura altamente desnormalizada

No se adopta.

Aunque podría simplificar determinadas consultas, aumentaría significativamente el riesgo de:

* Datos duplicados.
* Inconsistencias.
* Anomalías de actualización.
* Problemas de integridad.

---

## 2. Normalizar hasta la máxima forma normal posible

No se adopta.

La normalización se considera una herramienta de diseño, no un objetivo absoluto.

Una normalización excesiva podría generar:

* Demasiadas tablas.
* Consultas innecesariamente complejas.
* Mayor cantidad de relaciones.
* Mayor dificultad de mantenimiento.

---

## 3. Normalizar únicamente durante la implementación

No se adopta.

La normalización debe formar parte del diseño previo de la base de datos y quedar documentada antes de la implementación.

---

## 4. Eliminar todos los snapshots para mantener una normalización estricta

No se adopta.

Los snapshots son necesarios para preservar el significado histórico de determinadas operaciones.

Eliminar estos valores obligaría a reconstruir operaciones históricas utilizando configuraciones actuales, lo cual produciría resultados incorrectos.

---

# Impacto en la arquitectura

Esta decisión afecta principalmente a las siguientes capas y componentes:

### Modelo de dominio

Las entidades y relaciones deberán mantener responsabilidades conceptualmente separadas.

### Capa de persistencia

El esquema relacional deberá seguir las dependencias definidas y evitar redundancias innecesarias.

### Base de datos PostgreSQL

La implementación deberá aplicar:

* Foreign keys.
* Unique constraints.
* Check constraints.
* Claves primarias.
* Índices apropiados.
* Restricciones de nulabilidad.

### Capa de aplicación

Los servicios deberán respetar las relaciones existentes y evitar duplicar información que pertenece a otras entidades.

### Auditoría

El sistema deberá distinguir entre:

```text
Configuración actual
```

```text
Valor histórico
```

y:

```text
Cambio registrado
```

### Documentación

La estrategia afecta directamente a:

```text
domain-model.md
er-model.md
data-dictionary.md
normalization.md
```

y cualquier ADR posterior que introduzca una excepción deliberada a la estrategia de normalización.

---

# Resultado esperado

La base de datos deberá:

1. Mantener al menos 3FN donde sea aplicable.
2. Evitar redundancia innecesaria.
3. Mantener atributos atómicos.
4. Representar correctamente relaciones N:M.
5. Separar entidades con responsabilidades diferentes.
6. Evitar dependencias parciales.
7. Evitar dependencias transitivas.
8. Mantener integridad referencial.
9. Conservar snapshots cuando sean necesarios para representar operaciones históricas.
10. Permitir auditoría sin comprometer la estructura principal del modelo.
11. Evitar desnormalización prematura.
12. Permitir desnormalización controlada cuando exista una justificación funcional, histórica o de rendimiento.
13. Mantener coherencia entre dominio, ER, diccionario de datos y esquema físico.

La decisión establece que **la normalización tiene como propósito preservar la integridad y coherencia del modelo, no simplemente minimizar el número de valores repetidos**.

Los valores repetidos que representen deliberadamente un snapshot histórico, un resultado de una operación o información necesaria para auditoría deberán considerarse redundancia controlada y justificada, no un defecto de normalización.
