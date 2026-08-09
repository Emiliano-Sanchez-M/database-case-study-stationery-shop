# Normalización de la Base de Datos

## 1. Propósito

Este documento documenta la revisión de normalización aplicada al modelo de datos del sistema de gestión de la papelería.

El objetivo es verificar que la estructura definida en el modelo entidad-relación (`er-model.md`) y especificada en el diccionario de datos (`data-dictionary.md`) reduzca:

* Redundancia innecesaria.
* Dependencias incorrectas.
* Anomalías de inserción.
* Anomalías de actualización.
* Anomalías de eliminación.
* Duplicación de información.
* Dependencias no relacionadas con la entidad representada.

La normalización se analiza principalmente mediante las primeras tres formas normales:

1. Primera Forma Normal (1FN).
2. Segunda Forma Normal (2FN).
3. Tercera Forma Normal (3FN).

El modelo se considera suficientemente normalizado cuando cumple estas formas normales, salvo casos específicos donde una decisión deliberada por motivos históricos, de auditoría, rendimiento o integridad operacional justifique almacenar información aparentemente redundante.

---

# 2. Fuentes de referencia

La revisión de normalización se basa en:

* Contexto de negocio.
* Reglas de negocio.
* Glosario.
* Actores.
* Requisitos funcionales.
* Requisitos no funcionales.
* Casos de uso.
* Modelo de dominio.
* Modelo entidad-relación.
* Diccionario de datos.

Los documentos principales utilizados como referencia estructural son:

```text
domain-model.md
er-model.md
data-dictionary.md
```

---

# 3. Principios de normalización utilizados

El modelo sigue los siguientes principios:

1. Cada entidad representa un concepto claramente identificable.
2. Cada atributo debe representar un único dato lógico.
3. Los atributos multivaluados deben separarse cuando corresponda.
4. Las relaciones N:M deben resolverse mediante entidades o tablas intermedias.
5. Los datos pertenecientes a conceptos diferentes no deben almacenarse en una misma entidad únicamente por conveniencia.
6. Los datos históricos deben conservarse mediante snapshots cuando sea necesario.
7. La información operativa no debe depender de configuraciones actuales que puedan cambiar posteriormente.
8. La redundancia intencional debe estar justificada y documentada.
9. Las entidades de configuración y las entidades transaccionales deben mantenerse conceptualmente separadas.

---

# 4. Primera Forma Normal (1FN)

Una relación se encuentra en Primera Forma Normal cuando:

* Cada columna contiene valores atómicos.
* No existen grupos repetitivos dentro de una misma fila.
* Cada atributo representa un único valor lógico.
* Los registros pueden identificarse de manera individual.

El modelo cumple estos principios.

---

## 4.1. Datos personales

Los nombres de usuarios y clientes no se almacenan como un único campo compuesto.

En lugar de:

```text
full_name
```

se utilizan:

```text
nombre
apellido_paterno
apellido_materno
```

Esto permite tratar cada componente como un atributo independiente.

### Usuario

```text
nombre
apellido_paterno
apellido_materno
```

Los tres campos son obligatorios para empleados/usuarios.

### Cliente

```text
nombre
apellido_paterno
apellido_materno
```

En clientes:

```text
nombre              obligatorio
apellido_paterno    opcional
apellido_materno    opcional
```

Esto permite representar correctamente situaciones en las que únicamente se dispone del nombre del cliente.

---

# 5. Productos y categorías

Un producto no almacena directamente información repetitiva de sus categorías o marcas.

En lugar de:

```text
product
--------------------------------
category_name
category_description
brand_name
brand_description
```

se utilizan entidades independientes:

```text
category
brand
product
```

con relaciones:

```text
category 1:N product
brand    1:N product
```

Esto evita repetir los mismos datos de categoría o marca en múltiples productos.

---

# 6. Proveedores

Un producto puede tener múltiples proveedores y un proveedor puede comercializar múltiples productos.

Por lo tanto, no se almacenan proveedores directamente dentro de `product`.

Se utiliza:

```text
product
supplier
product_supplier
```

con una relación:

```text
product N:M supplier
```

resuelta mediante:

```text
product_supplier
```

Esto evita estructuras como:

```text
supplier_1
supplier_2
supplier_3
```

dentro de `product`.

También permite almacenar atributos propios de la relación, como:

```text
supplier_code
last_purchase_price
active
```

---

# 7. Roles y permisos

Un usuario puede tener múltiples roles.

Un rol puede pertenecer a múltiples usuarios.

Por lo tanto:

```text
user N:M role
```

se resuelve mediante:

```text
user_role
```

De manera similar:

```text
role N:M permission
```

se resuelve mediante:

```text
role_permission
```

Esto evita almacenar listas de roles o permisos dentro de una sola columna.

No se utilizarían estructuras como:

```text
roles = "ADMIN,CAJERO,INVENTARIO"
```

ni:

```text
permissions = "CREATE_SALE,READ_PRODUCT,UPDATE_STOCK"
```

dentro de una misma columna.

---

# 8. Ventas y detalles de venta

Una venta puede contener múltiples productos o servicios.

No se almacenan múltiples productos directamente dentro de `sale`.

En su lugar se utilizan:

```text
sale
sale_item
```

Relación:

```text
sale 1:N sale_item
```

Por ejemplo:

```text
sale
--------------------------------
id = 100
total = 250
```

y:

```text
sale_item
--------------------------------
sale_id | product_id | quantity
100     | 10         | 2
100     | 15         | 1
100     | 32         | 3
```

Esto evita grupos repetitivos y permite que una venta contenga cualquier cantidad de artículos.

---

# 9. Compras y detalles de compra

Las compras siguen el mismo principio.

Se separan:

```text
purchase
purchase_item
```

Relación:

```text
purchase 1:N purchase_item
```

Esto permite registrar múltiples productos dentro de una compra sin crear columnas repetitivas.

---

# 10. Apartados y detalles

Los apartados también pueden contener múltiples productos.

Se utilizan:

```text
reservation
reservation_item
```

Relación:

```text
reservation 1:N reservation_item
```

Esto permite representar correctamente apartados con uno o múltiples productos.

---

# 11. Pagos

Una venta puede tener múltiples pagos.

Por ejemplo, una operación podría pagarse mediante:

```text
Efectivo
+
Tarjeta
```

Por esta razón, los pagos se almacenan independientemente:

```text
sale
payment
payment_method
```

con:

```text
sale 1:N payment
payment_method 1:N payment
```

Esto evita almacenar información como:

```text
payment_method_1
payment_amount_1
payment_method_2
payment_amount_2
```

dentro de `sale`.

---

# 12. Devoluciones

Las devoluciones se separan de la venta original.

Se utilizan:

```text
return
return_item
```

con:

```text
return 1:N return_item
sale 1:N return
sale_item 1:N return_item
```

Esto permite:

* Devoluciones parciales.
* Múltiples devoluciones sobre una misma venta cuando las reglas lo permitan.
* Identificar exactamente qué artículos fueron devueltos.
* Mantener intacta la venta original.

---

# 13. Inventario

El inventario actual y los movimientos históricos se mantienen separados.

Se utilizan:

```text
product
inventory
inventory_movement
```

La estructura distingue entre:

```text
inventory.quantity
```

que representa el estado actual,

y:

```text
inventory_movement
```

que representa los cambios históricos.

Esto evita almacenar múltiples estados del inventario dentro de `product`.

---

# 14. Incidencias de inventario

Las diferencias entre inventario físico y sistema se almacenan mediante:

```text
inventory_incident
```

en lugar de agregar múltiples columnas de incidencias dentro de `product` o `inventory`.

Esto permite registrar múltiples incidencias a lo largo del tiempo.

---

# 15. Servicios y tarifas

Los servicios y sus tarifas se mantienen separados:

```text
service
service_rate
```

Esto permite que un servicio tenga diferentes configuraciones de precio sin duplicar la información general del servicio.

Por ejemplo:

```text
Servicio:
Impresión

Tarifas:
Blanco y negro
Color
```

La información general del servicio permanece en `service`, mientras que las configuraciones de precio pertenecen a `service_rate`.

---

# 16. Descuentos

Los descuentos se representan mediante:

```text
discount
```

y su aplicación histórica mediante:

```text
sale_item
```

Esto permite distinguir entre:

```text
discount
```

que representa la configuración actual,

y:

```text
sale_item.discount_value
sale_item.discount_amount
```

que representan lo que realmente ocurrió durante una venta.

---

# 17. Primera conclusión de normalización

El modelo cumple la Primera Forma Normal porque:

* Los atributos son atómicos.
* No existen listas almacenadas en columnas.
* Las relaciones N:M se resuelven mediante tablas intermedias.
* Los detalles repetitivos se separan en entidades independientes.
* Los datos personales están divididos en atributos independientes.
* Las operaciones con múltiples elementos utilizan entidades de detalle.

---

# 18. Segunda Forma Normal (2FN)

Una relación se encuentra en Segunda Forma Normal cuando:

1. Cumple 1FN.
2. Todos los atributos no clave dependen de la totalidad de la clave primaria.

Este principio es especialmente relevante para tablas con claves primarias compuestas.

---

# 19. Tablas intermedias

Las principales tablas con claves compuestas son:

```text
user_role
role_permission
product_supplier
```

---

## 19.1. Usuario-Rol

Clave:

```text
PK(user_id, role_id)
```

No existen atributos no clave que dependan solamente de:

```text
user_id
```

o solamente de:

```text
role_id
```

La relación representa exclusivamente la asociación entre ambos.

---

## 19.2. Rol-Permiso

Clave:

```text
PK(role_id, permission_id)
```

La asociación no contiene información que pertenezca exclusivamente al rol o al permiso.

---

## 19.3. Producto-Proveedor

Clave:

```text
PK(product_id, supplier_id)
```

Los atributos propios de la relación, como:

```text
supplier_code
last_purchase_price
active
```

pertenecen a la relación producto-proveedor.

No representan exclusivamente al producto ni exclusivamente al proveedor.

Por lo tanto, se mantienen en `product_supplier`.

---

# 20. Segunda conclusión de normalización

El modelo cumple la Segunda Forma Normal porque:

* Las entidades con claves simples no presentan dependencias parciales.
* Las tablas con claves compuestas no contienen atributos que dependan únicamente de una parte de la clave.
* Los atributos pertenecientes a relaciones N:M se encuentran en las tablas intermedias correspondientes.

---

# 21. Tercera Forma Normal (3FN)

Una relación se encuentra en Tercera Forma Normal cuando:

1. Cumple 2FN.
2. Los atributos no clave no dependen transitivamente de otros atributos no clave.

El modelo evita almacenar información derivada o perteneciente a otras entidades cuando no existe una razón operacional o histórica para hacerlo.

---

# 22. Producto, categoría y marca

No se almacena información de categoría o marca directamente dentro de cada producto.

Por ejemplo, no se utiliza:

```text
product
--------------------------------
category_name
category_description
```

porque esos datos dependen de la categoría y no directamente del producto.

Se utiliza:

```text
product.category_id
```

y:

```text
category
```

De la misma manera ocurre con:

```text
brand
```

---

# 23. Cliente y datos fiscales

Los datos fiscales se mantienen en:

```text
fiscal_data
```

en lugar de incluir todos los datos fiscales directamente dentro de `customer`.

Esto permite mantener separados:

```text
customer
```

como información general del cliente,

y:

```text
fiscal_data
```

como información fiscal.

Además, un cliente puede conservar diferentes registros fiscales cuando el dominio lo requiera.

---

# 24. Proveedor y productos

No se almacenan productos dentro de `supplier`.

Se utiliza:

```text
product_supplier
```

para representar la relación.

Esto evita dependencias transitivas y permite que la información propia de cada relación se almacene en el lugar correcto.

---

# 25. Venta y pagos

Los datos de pago no se almacenan directamente como columnas repetitivas dentro de `sale`.

Se utiliza:

```text
payment
```

Esto permite que una venta tenga uno o varios pagos.

Además, la información del método de pago se mantiene en:

```text
payment_method
```

y `payment` contiene:

```text
payment_method_id
```

en lugar de repetir:

```text
payment_method_name
```

en cada pago.

---

# 26. Compra y proveedor

`purchase` contiene:

```text
supplier_id
```

en lugar de duplicar:

```text
supplier_name
supplier_phone
supplier_email
supplier_address
```

Esto evita que los datos del proveedor se repitan en cada compra.

---

# 27. Caja

La información general de la caja se mantiene en:

```text
cash_register
```

mientras que los movimientos pertenecen a:

```text
cash_movement
```

y los resultados de los cortes a:

```text
cash_closing
```

Esto evita almacenar múltiples movimientos o cierres dentro de la entidad de caja.

---

# 28. Tercera conclusión de normalización

El modelo cumple la Tercera Forma Normal porque:

* Los datos pertenecientes a otras entidades se referencian mediante claves foráneas.
* Se evita duplicar atributos descriptivos de otras entidades.
* Las relaciones se encuentran separadas.
* Los datos transaccionales se encuentran separados de los catálogos.
* Los datos de configuración se encuentran separados de las operaciones.

---

# 29. Redundancia intencional por razones históricas

La normalización no significa que absolutamente ningún dato pueda repetirse.

En este sistema existen algunos casos donde se conserva deliberadamente información redundante.

La razón es que el sistema necesita preservar el estado histórico de una operación.

Estos casos no representan errores de normalización, sino decisiones de diseño orientadas a:

* Auditoría.
* Trazabilidad.
* Integridad histórica.
* Reproducción de operaciones.
* Independencia respecto a cambios posteriores.

---

# 30. Snapshot de precios

En `product` existe:

```text
sale_price
```

que representa el precio actual.

Sin embargo, `sale_item` contiene:

```text
unit_price
```

Esto parece redundante, pero tiene una finalidad histórica.

Ejemplo:

```text
Precio actual:
$120
```

Venta histórica:

```text
unit_price = $100
```

Si el precio cambia posteriormente a $120, la venta histórica debe seguir representando correctamente la operación original.

Por lo tanto:

```text
product.sale_price
```

representa el valor actual.

Mientras:

```text
sale_item.unit_price
```

representa el valor histórico utilizado.

---

# 31. Snapshot de descuentos

El descuento actual se encuentra en:

```text
discount
```

Mientras que una venta conserva:

```text
discount_id
discount_type
discount_value
discount_amount
```

Esto permite responder:

> ¿Qué descuento se aplicó?

y:

> ¿Cuál era el valor exacto del descuento en ese momento?

Aunque posteriormente la configuración cambie.

Ejemplo:

```text
Configuración inicial:
Estudiantes = 15%
```

Venta:

```text
discount_value = 15
```

Posteriormente:

```text
Estudiantes = 18%
```

La venta continúa mostrando:

```text
15%
```

---

# 32. Snapshot de apartados

La configuración actual se encuentra en:

```text
reservation_configuration
```

Pero un apartado conserva:

```text
minimum_percentage_applied
cancellation_retention_percentage_applied
expiration_retention_percentage_applied
```

Esto es una redundancia intencional.

Su finalidad es impedir que una modificación posterior de la configuración cambie retroactivamente las condiciones de un apartado existente.

---

# 33. Snapshot de precios de compra

`product_supplier.last_purchase_price` representa información actual o de referencia.

Sin embargo:

```text
purchase_item.unit_cost
```

conserva el costo utilizado en una compra específica.

Ejemplo:

```text
Compra 1:
unit_cost = $8

Compra 2:
unit_cost = $9

Compra 3:
unit_cost = $11
```

El sistema puede reconstruir el costo histórico sin depender del precio actual del proveedor.

---

# 34. Auditoría y normalización

La entidad:

```text
audit_record
```

mantiene información histórica adicional:

```text
old_value
new_value
```

Estos valores pueden contener estructuras `JSONB`.

Esto no se considera una violación de normalización para el modelo operacional porque `audit_record` tiene una finalidad específica:

> Registrar cambios históricos de entidades y configuraciones.

No se utiliza como sustituto de las entidades normales del sistema.

Por ejemplo, no se debe consultar `audit_record` para obtener el precio actual de un producto.

El precio actual debe obtenerse desde:

```text
product.sale_price
```

La auditoría solamente explica cómo llegó a ese valor.

---

# 35. Configuración y operaciones

El modelo separa:

## Configuración

```text
product
service_rate
discount
reservation_configuration
payment_method
business_configuration
```

## Operaciones

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
```

Esta separación evita que las operaciones dependan directamente del estado actual de una configuración.

---

# 36. Datos derivados

El modelo evita almacenar información que pueda obtenerse directamente de otros datos cuando no sea necesaria.

Por ejemplo, el subtotal de una línea puede calcularse conceptualmente como:

```text
quantity × unit_price
```

Sin embargo, algunos valores derivados se conservan deliberadamente en operaciones históricas cuando es importante conservar exactamente el resultado utilizado en la transacción.

Esto incluye valores como:

```text
subtotal
discount_amount
total
```

La razón es garantizar que una operación histórica pueda reconstruirse exactamente aunque cambien posteriormente reglas de cálculo, descuentos, impuestos o precios.

---

# 37. Normalización y auditoría

La normalización y la auditoría cumplen funciones diferentes.

### Normalización

Busca principalmente:

```text
Reducir redundancia innecesaria
+
Evitar anomalías
+
Organizar dependencias
```

### Auditoría

Busca:

```text
Conservar cambios
+
Identificar responsables
+
Mantener trazabilidad
```

### Snapshot

Busca:

```text
Conservar el valor utilizado durante una operación
```

Los tres mecanismos trabajan conjuntamente.

---

# 38. Ejemplo completo

Supongamos que un producto actualmente cuesta:

```text
$120
```

y tiene un descuento para estudiantes del:

```text
15%
```

Un cliente realiza una compra.

La venta puede almacenar:

```text
sale
    total = 102
```

y:

```text
sale_item
    unit_price = 120
    discount_id = 2
    discount_value = 15
    discount_amount = 18
```

Posteriormente:

```text
product.sale_price = 130
discount.value = 18
```

La venta anterior continúa mostrando:

```text
unit_price = 120
discount_value = 15
discount_amount = 18
```

Mientras que una nueva venta utilizará:

```text
unit_price = 130
discount_value = 18
```

La modificación del descuento queda registrada además en:

```text
audit_record
```

De esta manera se mantienen simultáneamente:

```text
Estado actual
Historial de operación
Historial de configuración
```

---

# 39. Casos donde no se debe aplicar una desnormalización arbitraria

No se deben agregar campos duplicados únicamente para facilitar consultas.

Por ejemplo, no se recomienda almacenar en `sale`:

```text
customer_name
customer_phone
customer_email
```

si estos datos pueden obtenerse correctamente mediante:

```text
sale.customer_id
→ customer
```

Tampoco se debe almacenar en `purchase`:

```text
supplier_name
supplier_phone
```

únicamente para evitar una consulta adicional.

Si algún dato debe conservarse como snapshot por una razón histórica o legal, debe documentarse explícitamente.

---

# 40. Criterio para futuras modificaciones

Antes de agregar un nuevo atributo duplicado, debe determinarse si corresponde a:

### A. Información actual

Debe almacenarse en la entidad correspondiente.

### B. Información histórica

Puede almacenarse como snapshot dentro de la operación.

### C. Información de auditoría

Debe almacenarse mediante:

```text
audit_record
```

### D. Información derivada

Debe evaluarse si realmente necesita persistirse.

### E. Información perteneciente a otra entidad

Debe considerarse crear una relación o referencia mediante clave foránea.

Este criterio evita que el modelo se desnormalice progresivamente durante la implementación.

---

# 41. Resultado de la revisión

El modelo actual cumple conceptualmente con:

```text
1FN
✓

2FN
✓

3FN
✓
```

La estructura evita las principales formas de redundancia innecesaria y mantiene separadas las entidades de acuerdo con sus responsabilidades.

Las redundancias existentes están justificadas principalmente por:

* Historial de operaciones.
* Snapshots.
* Auditoría.
* Integridad histórica.
* Conservación exacta de valores utilizados en transacciones.

---

# 42. Conclusión

El modelo de datos se considera suficientemente normalizado para avanzar hacia la especificación técnica e implementación.

La normalización no debe interpretarse como una regla que prohíba cualquier dato repetido.

En este proyecto se distingue entre:

```text
Redundancia innecesaria
```

y:

```text
Redundancia intencional con propósito histórico
```

La primera debe evitarse.

La segunda puede utilizarse cuando sea necesaria para garantizar:

* Auditoría.
* Trazabilidad.
* Integridad histórica.
* Reproducción de operaciones.
* Independencia respecto a cambios futuros.

Por lo tanto, el modelo mantiene una estructura normalizada como base y utiliza snapshots y registros de auditoría de manera deliberada para cubrir los requisitos específicos del negocio.

---

# 43. Documentos relacionados

```text
docs/
├── functional-requirements.md
├── non-functional-requirements.md
├── use-cases.md
├── domain-model.md
├── er-model.md
├── data-dictionary.md
└── normalization.md
```

Los documentos se complementan entre sí:

```text
Requisitos
    ↓
Casos de uso
    ↓
Modelo de dominio
    ↓
Modelo ER
    ↓
Diccionario de datos
    ↓
Normalización
    ↓
Implementación física
```

El presente documento valida la estructura desde la perspectiva de normalización y sirve como referencia para futuras modificaciones del modelo de datos.
