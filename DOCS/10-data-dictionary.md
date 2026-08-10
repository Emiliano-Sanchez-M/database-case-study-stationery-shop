# Data Dictionary

## 1. Propósito

Este documento define el diccionario de datos del sistema de gestión de la papelería.

Su objetivo es especificar de manera detallada la estructura de los datos que serán persistidos, incluyendo:

* Tablas.
* Columnas.
* Tipos de datos.
* Longitudes.
* Nullable.
* Claves primarias.
* Claves foráneas.
* Restricciones `UNIQUE`.
* Restricciones `CHECK`.
* Valores permitidos.
* Valores por defecto.
* Descripción funcional de cada campo.

El Data Dictionary se deriva de los siguientes documentos:

* Contexto de negocio.
* Reglas de negocio.
* Glosario.
* Actores.
* Requisitos funcionales.
* Requisitos no funcionales.
* Casos de uso.
* Modelo de dominio.
* Modelo entidad-relación.

Este documento constituye la especificación detallada de los datos antes de su implementación física en PostgreSQL.

---

# 2. Convenciones

## 2.1. Nombres

La documentación utiliza nombres en español para facilitar su comprensión.

Los nombres técnicos de tablas y columnas utilizan inglés en `snake_case`.

Ejemplo:

```text
Empleado → user
Nombre → first_name
Apellido paterno → paternal_last_name
Apellido materno → maternal_last_name
```

---

## 2.2. Identificadores

Las entidades utilizan:

```text
BIGINT
```

como identificador principal.

La columna:

```text
id
```

es:

* `PRIMARY KEY`
* `NOT NULL`

---

## 2.3. Convención de nullable

Se utilizará:

| Nullable | Significado               |
| -------- | ------------------------- |
| `NO`     | El valor es obligatorio   |
| `YES`    | El valor puede ser `NULL` |

Un campo que forma parte de una `PRIMARY KEY` siempre será `NOT NULL`.

Una clave foránea será nullable únicamente cuando el modelo de negocio permita que la relación no exista.

---

## 2.4. Longitudes

Las longitudes se definen desde este documento para evitar dejar decisiones importantes para la etapa de implementación.

Cuando un campo utiliza `VARCHAR`, se establece explícitamente su longitud.

Ejemplo:

```text
VARCHAR(100)
```

---

# 3. Seguridad y usuarios

## 3.1. Usuario (`user`)

Representa a un empleado que utiliza directamente el sistema.

| Columna            | Tipo      | Longitud | Nullable | Restricciones | Descripción                           |
| ------------------ | --------- | -------: | :------: | ------------- | ------------------------------------- |
| id                 | BIGINT    |        — |    NO    | PK            | Identificador                         |
| username           | VARCHAR   |       50 |    NO    | UNIQUE        | Nombre de usuario                     |
| password_hash      | VARCHAR   |      255 |    NO    | —             | Contraseña almacenada de forma segura |
| first_name         | VARCHAR   |      100 |    NO    | —             | Nombre                                |
| paternal_last_name | VARCHAR   |      100 |    NO    | —             | Apellido paterno                      |
| maternal_last_name | VARCHAR   |      100 |    NO    | —             | Apellido materno                      |
| status             | VARCHAR   |       20 |    NO    | CHECK         | Estado del usuario                    |
| created_at         | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha de creación                     |
| updated_at         | TIMESTAMP |        — |    NO    | DEFAULT       | Última modificación                   |

### Restricciones

```text
username UNIQUE
```

```text
status IN (
    'ACTIVE',
    'INACTIVE',
    'BLOCKED'
)
```

El usuario no se elimina físicamente cuando deja de trabajar en el negocio.

Su estado cambia a:

```text
INACTIVE
```

Esto permite conservar su historial.

---

# 4. Roles

## 4.1. Rol (`role`)

| Columna     | Tipo    | Longitud | Nullable | Restricciones | Descripción    |
| ----------- | ------- | -------: | :------: | ------------- | -------------- |
| id          | BIGINT  |        — |    NO    | PK            | Identificador  |
| name        | VARCHAR |       50 |    NO    | UNIQUE        | Nombre del rol |
| description | VARCHAR |      255 |    YES   | —             | Descripción    |
| active      | BOOLEAN |        — |    NO    | DEFAULT TRUE  | Estado         |

---

## 4.2. Permiso (`permission`)

| Columna     | Tipo    | Longitud | Nullable | Restricciones | Descripción        |
| ----------- | ------- | -------: | :------: | ------------- | ------------------ |
| id          | BIGINT  |        — |    NO    | PK            | Identificador      |
| name        | VARCHAR |      100 |    NO    | UNIQUE        | Nombre del permiso |
| description | VARCHAR |      255 |    YES   | —             | Descripción        |
| active      | BOOLEAN |        — |    NO    | DEFAULT TRUE  | Estado             |

---

## 4.3. Usuario-Rol (`user_role`)

| Columna | Tipo   | Longitud | Nullable | Restricciones | Descripción |
| ------- | ------ | -------: | :------: | ------------- | ----------- |
| user_id | BIGINT |        — |    NO    | PK, FK        | Usuario     |
| role_id | BIGINT |        — |    NO    | PK, FK        | Rol         |

### Clave primaria

```text
PK(user_id, role_id)
```

---

## 4.4. Rol-Permiso (`role_permission`)

| Columna       | Tipo   | Longitud | Nullable | Restricciones | Descripción |
| ------------- | ------ | -------: | :------: | ------------- | ----------- |
| role_id       | BIGINT |        — |    NO    | PK, FK        | Rol         |
| permission_id | BIGINT |        — |    NO    | PK, FK        | Permiso     |

### Clave primaria

```text
PK(role_id, permission_id)
```

---

# 5. Clientes

## 5.1. Cliente (`customer`)

Representa a una persona que compra productos o servicios.

El cliente puede estar registrado o no durante una venta.

| Columna            | Tipo      | Longitud | Nullable | Restricciones | Descripción         |
| ------------------ | --------- | -------: | :------: | ------------- | ------------------- |
| id                 | BIGINT    |        — |    NO    | PK            | Identificador       |
| first_name         | VARCHAR   |      100 |    NO    | —             | Nombre              |
| paternal_last_name | VARCHAR   |      100 |    YES   | —             | Apellido paterno    |
| maternal_last_name | VARCHAR   |      100 |    YES   | —             | Apellido materno    |
| phone              | VARCHAR   |       20 |    YES   | —             | Teléfono            |
| email              | VARCHAR   |      254 |    YES   | —             | Correo electrónico  |
| active             | BOOLEAN   |        — |    NO    | DEFAULT TRUE  | Estado              |
| created_at         | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha de registro   |
| updated_at         | TIMESTAMP |        — |    NO    | DEFAULT       | Última modificación |

### Reglas

`first_name` es obligatorio.

Los apellidos son opcionales porque el sistema debe permitir registrar clientes aunque solamente proporcionen su nombre.

---

# 6. Datos fiscales

## 6.1. Datos fiscales (`fiscal_data`)

Contiene la información fiscal proporcionada voluntariamente por el cliente.

| Columna     | Tipo      | Longitud | Nullable | Restricciones | Descripción                  |
| ----------- | --------- | -------: | :------: | ------------- | ---------------------------- |
| id          | BIGINT    |        — |    NO    | PK            | Identificador                |
| customer_id | BIGINT    |        — |    NO    | FK            | Cliente                      |
| tax_id      | VARCHAR   |       20 |    NO    | —             | Identificador fiscal         |
| legal_name  | VARCHAR   |      255 |    NO    | —             | Nombre o razón social fiscal |
| tax_regime  | VARCHAR   |       10 |    NO    | —             | Régimen fiscal               |
| postal_code | VARCHAR   |        5 |    NO    | —             | Código postal fiscal         |
| fiscal_use  | VARCHAR   |       10 |    NO    | —             | Uso fiscal                   |
| created_at  | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha de creación            |
| updated_at  | TIMESTAMP |        — |    NO    | DEFAULT       | Última modificación          |

### Restricciones

```text
customer_id → customer.id
```

Los datos fiscales solamente deben almacenarse cuando el cliente haya aceptado proporcionar dicha información.

El acceso está restringido a los usuarios autorizados.

---

# 7. Categorías

## 7.1. Categoría (`category`)

| Columna     | Tipo    | Longitud | Nullable | Restricciones | Descripción   |
| ----------- | ------- | -------: | :------: | ------------- | ------------- |
| id          | BIGINT  |        — |    NO    | PK            | Identificador |
| name        | VARCHAR |      100 |    NO    | UNIQUE        | Nombre        |
| description | VARCHAR |      255 |    YES   | —             | Descripción   |
| active      | BOOLEAN |        — |    NO    | DEFAULT TRUE  | Estado        |

---

# 8. Marcas

## 8.1. Marca (`brand`)

| Columna     | Tipo    | Longitud | Nullable | Restricciones | Descripción   |
| ----------- | ------- | -------: | :------: | ------------- | ------------- |
| id          | BIGINT  |        — |    NO    | PK            | Identificador |
| name        | VARCHAR |      100 |    NO    | UNIQUE        | Nombre        |
| description | VARCHAR |      255 |    YES   | —             | Descripción   |
| active      | BOOLEAN |        — |    NO    | DEFAULT TRUE  | Estado        |

---

# 9. Productos

## 9.1. Producto (`product`)

| Columna           | Tipo      | Longitud | Nullable | Restricciones | Descripción      |
| ----------------- | --------- | -------: | :------: | ------------- | ---------------- |
| id                | BIGINT    |        — |    NO    | PK            | Identificador    |
| sku               | VARCHAR   |       50 |    NO    | UNIQUE        | Código interno   |
| barcode           | VARCHAR   |       50 |    YES   | UNIQUE        | Código de barras |
| name              | VARCHAR   |      150 |    NO    | —             | Nombre           |
| description       | TEXT      |        — |    YES   | —             | Descripción      |
| category_id       | BIGINT    |        — |    NO    | FK            | Categoría        |
| brand_id          | BIGINT    |        — |    YES   | FK            | Marca            |
| sale_price        | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Precio de venta  |
| cost_price        | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Costo            |
| stock_alert_level | INTEGER   |        — |    NO    | CHECK >= 0    | Nivel de alerta  |
| active            | BOOLEAN   |        — |    NO    | DEFAULT TRUE  | Estado           |
| created_at        | TIMESTAMP |        — |    NO    | DEFAULT       | Creación         |
| updated_at        | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización    |

### Restricciones

```text
sku UNIQUE
```

```text
barcode UNIQUE
```

El código de barras puede ser `NULL` porque no todos los productos necesariamente tienen código de barras.

```text
sale_price >= 0
cost_price >= 0
stock_alert_level >= 0
```

El nivel de alerta es configurable individualmente por producto.

---

# 10. Servicios

## 10.1. Servicio (`service`)

| Columna     | Tipo      | Longitud | Nullable | Restricciones | Descripción   |
| ----------- | --------- | -------: | :------: | ------------- | ------------- |
| id          | BIGINT    |        — |    NO    | PK            | Identificador |
| name        | VARCHAR   |      100 |    NO    | —             | Nombre        |
| description | TEXT      |        — |    YES   | —             | Descripción   |
| active      | BOOLEAN   |        — |    NO    | DEFAULT TRUE  | Estado        |
| created_at  | TIMESTAMP |        — |    NO    | DEFAULT       | Creación      |
| updated_at  | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización |

---

# 11. Tarifas de servicios

## 11.1. Tarifa de servicio (`service_rate`)

| Columna       | Tipo      | Longitud | Nullable | Restricciones | Descripción             |
| ------------- | --------- | -------: | :------: | ------------- | ----------------------- |
| id            | BIGINT    |        — |    NO    | PK            | Identificador           |
| service_id    | BIGINT    |        — |    NO    | FK            | Servicio                |
| name          | VARCHAR   |      100 |    NO    | —             | Nombre de tarifa        |
| unit_price    | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Precio unitario         |
| configuration | JSONB     |        — |    YES   | —             | Configuración adicional |
| active        | BOOLEAN   |        — |    NO    | DEFAULT TRUE  | Estado                  |
| created_at    | TIMESTAMP |        — |    NO    | DEFAULT       | Creación                |
| updated_at    | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización           |

---

# 12. Inventario

## 12.1. Inventario (`inventory`)

| Columna           | Tipo      | Longitud | Nullable | Restricciones | Descripción       |
| ----------------- | --------- | -------: | :------: | ------------- | ----------------- |
| id                | BIGINT    |        — |    NO    | PK            | Identificador     |
| product_id        | BIGINT    |        — |    NO    | UNIQUE, FK    | Producto          |
| quantity          | INTEGER   |        — |    NO    | CHECK >= 0    | Existencia        |
| reserved_quantity | INTEGER   |        — |    NO    | CHECK >= 0    | Cantidad apartada |
| updated_at        | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización     |

### Restricción

```text
reserved_quantity <= quantity
```

---

# 13. Movimientos de inventario

## 13.1. Movimiento de inventario (`inventory_movement`)

| Columna        | Tipo      | Longitud | Nullable | Restricciones | Descripción                 |
| -------------- | --------- | -------: | :------: | ------------- | --------------------------- |
| id             | BIGINT    |        — |    NO    | PK            | Identificador               |
| product_id     | BIGINT    |        — |    NO    | FK            | Producto                    |
| type           | VARCHAR   |       30 |    NO    | CHECK         | Tipo de movimiento          |
| quantity       | INTEGER   |        — |    NO    | CHECK > 0     | Cantidad                    |
| reference_type | VARCHAR   |       30 |    YES   | —             | Tipo de referencia          |
| reference_id   | BIGINT    |        — |    YES   | —             | Identificador de referencia |
| user_id        | BIGINT    |        — |    NO    | FK            | Usuario responsable         |
| reason         | VARCHAR   |      255 |    YES   | —             | Motivo                      |
| notes          | TEXT      |        — |    YES   | —             | Notas                       |
| created_at     | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha                       |

Los movimientos de inventario no se eliminan físicamente.

---

# 14. Incidencias de inventario

## 14.1. Incidencia de inventario (`inventory_incident`)

| Columna           | Tipo      | Longitud | Nullable | Restricciones | Descripción          |
| ----------------- | --------- | -------: | :------: | ------------- | -------------------- |
| id                | BIGINT    |        — |    NO    | PK            | Identificador        |
| product_id        | BIGINT    |        — |    NO    | FK            | Producto             |
| system_quantity   | INTEGER   |        — |    NO    | CHECK >= 0    | Cantidad registrada  |
| physical_quantity | INTEGER   |        — |    NO    | CHECK >= 0    | Cantidad física      |
| difference        | INTEGER   |        — |    NO    | —             | Diferencia           |
| reason            | VARCHAR   |      255 |    NO    | —             | Motivo               |
| status            | VARCHAR   |       20 |    NO    | CHECK         | Estado               |
| reported_by       | BIGINT    |        — |    NO    | FK            | Usuario que reporta  |
| resolved_by       | BIGINT    |        — |    YES   | FK            | Usuario que resuelve |
| notes             | TEXT      |        — |    YES   | —             | Notas                |
| created_at        | TIMESTAMP |        — |    NO    | DEFAULT       | Creación             |
| resolved_at       | TIMESTAMP |        — |    YES   | —             | Resolución           |

`resolved_by` y `resolved_at` pueden ser `NULL` mientras la incidencia permanezca abierta.

---

# 15. Ventas

## 15.1. Venta (`sale`)

| Columna        | Tipo      | Longitud | Nullable | Restricciones | Descripción     |
| -------------- | --------- | -------: | :------: | ------------- | --------------- |
| id             | BIGINT    |        — |    NO    | PK            | Identificador   |
| customer_id    | BIGINT    |        — |    YES   | FK            | Cliente         |
| user_id        | BIGINT    |        — |    NO    | FK            | Cajero          |
| status         | VARCHAR   |       20 |    NO    | CHECK         | Estado          |
| subtotal       | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Subtotal        |
| discount_total | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Descuento total |
| tax_total      | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Impuestos       |
| total          | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Total           |
| created_at     | TIMESTAMP |        — |    NO    | DEFAULT       | Creación        |
| completed_at   | TIMESTAMP |        — |    YES   | —             | Finalización    |
| cancelled_at   | TIMESTAMP |        — |    YES   | —             | Cancelación     |

### Nullable importante

```text
customer_id → YES
```

Una venta puede realizarse sin que exista un cliente registrado.

---

# 16. Detalles de venta

## 16.1. Detalle de venta (`sale_item`)

| Columna         | Tipo    | Longitud | Nullable | Restricciones | Descripción           |
| --------------- | ------- | -------: | :------: | ------------- | --------------------- |
| id              | BIGINT  |        — |    NO    | PK            | Identificador         |
| sale_id         | BIGINT  |        — |    NO    | FK            | Venta                 |
| product_id      | BIGINT  |        — |    YES   | FK            | Producto              |
| service_id      | BIGINT  |        — |    YES   | FK            | Servicio              |
| description     | VARCHAR |      255 |    NO    | —             | Descripción histórica |
| quantity        | DECIMAL |     12,3 |    NO    | CHECK > 0     | Cantidad              |
| unit_price      | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Precio histórico      |
| discount_id     | BIGINT  |        — |    YES   | FK            | Descuento             |
| discount_type   | VARCHAR |       30 |    YES   | —             | Tipo aplicado         |
| discount_value  | DECIMAL |     12,2 |    YES   | CHECK >= 0    | Valor aplicado        |
| discount_amount | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Monto descontado      |
| tax             | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Impuesto              |
| subtotal        | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Subtotal              |

### Restricción

Debe existir exactamente uno de:

```text
product_id
```

o:

```text
service_id
```

pero no ambos.

Conceptualmente:

```text
(product_id IS NOT NULL AND service_id IS NULL)
OR
(product_id IS NULL AND service_id IS NOT NULL)
```

---

# 17. Métodos de pago

## 17.1. Método de pago (`payment_method`)

| Columna | Tipo    | Longitud | Nullable | Restricciones | Descripción   |
| ------- | ------- | -------: | :------: | ------------- | ------------- |
| id      | BIGINT  |        — |    NO    | PK            | Identificador |
| name    | VARCHAR |       50 |    NO    | UNIQUE        | Nombre        |
| type    | VARCHAR |       30 |    NO    | CHECK         | Tipo          |
| active  | BOOLEAN |        — |    NO    | DEFAULT TRUE  | Estado        |

---

# 18. Pagos

## 18.1. Pago (`payment`)

| Columna           | Tipo      | Longitud | Nullable | Restricciones | Descripción        |
| ----------------- | --------- | -------: | :------: | ------------- | ------------------ |
| id                | BIGINT    |        — |    NO    | PK            | Identificador      |
| sale_id           | BIGINT    |        — |    NO    | FK            | Venta              |
| payment_method_id | BIGINT    |        — |    NO    | FK            | Método             |
| amount            | DECIMAL   |     12,2 |    NO    | CHECK > 0     | Monto              |
| status            | VARCHAR   |       20 |    NO    | CHECK         | Estado             |
| reference         | VARCHAR   |      100 |    YES   | —             | Referencia externa |
| user_id           | BIGINT    |        — |    NO    | FK            | Usuario            |
| created_at        | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha              |

---

# 19. Tickets

## 19.1. Ticket (`ticket`)

| Columna       | Tipo      | Longitud | Nullable | Restricciones | Descripción      |
| ------------- | --------- | -------: | :------: | ------------- | ---------------- |
| id            | BIGINT    |        — |    NO    | PK            | Identificador    |
| sale_id       | BIGINT    |        — |    NO    | UNIQUE, FK    | Venta            |
| ticket_number | VARCHAR   |       50 |    NO    | UNIQUE        | Número           |
| issued_at     | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha de emisión |

---

# 20. Descuentos

## 20.1. Descuento (`discount`)

| Columna    | Tipo      | Longitud | Nullable | Restricciones | Descripción   |
| ---------- | --------- | -------: | :------: | ------------- | ------------- |
| id         | BIGINT    |        — |    NO    | PK            | Identificador |
| name       | VARCHAR   |      100 |    NO    | —             | Nombre        |
| type       | VARCHAR   |       30 |    NO    | CHECK         | Tipo          |
| value      | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Valor         |
| conditions | JSONB     |        — |    YES   | —             | Condiciones   |
| starts_at  | TIMESTAMP |        — |    NO    | —             | Inicio        |
| ends_at    | TIMESTAMP |        — |    YES   | —             | Fin           |
| active     | BOOLEAN   |        — |    NO    | DEFAULT TRUE  | Estado        |
| created_at | TIMESTAMP |        — |    NO    | DEFAULT       | Creación      |
| updated_at | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización |

### Regla

Dos descuentos pueden tener el mismo porcentaje y seguir siendo descuentos diferentes.

Ejemplo:

```text
Estudiante → 15%
Tercera edad → 15%
```

La identificación se realiza mediante `discount.id`, no mediante el porcentaje.

---

# 21. Devoluciones

## 21.1. Devolución (`return`)

| Columna    | Tipo      | Longitud | Nullable | Restricciones | Descripción         |
| ---------- | --------- | -------: | :------: | ------------- | ------------------- |
| id         | BIGINT    |        — |    NO    | PK            | Identificador       |
| sale_id    | BIGINT    |        — |    NO    | FK            | Venta original      |
| user_id    | BIGINT    |        — |    NO    | FK            | Usuario responsable |
| type       | VARCHAR   |       30 |    NO    | CHECK         | Tipo                |
| reason     | TEXT      |        — |    NO    | —             | Motivo              |
| total      | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Total               |
| status     | VARCHAR   |       20 |    NO    | CHECK         | Estado              |
| created_at | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha               |

---

# 22. Detalles de devolución

## 22.1. Detalle de devolución (`return_item`)

| Columna      | Tipo    | Longitud | Nullable | Restricciones | Descripción     |
| ------------ | ------- | -------: | :------: | ------------- | --------------- |
| id           | BIGINT  |        — |    NO    | PK            | Identificador   |
| return_id    | BIGINT  |        — |    NO    | FK            | Devolución      |
| sale_item_id | BIGINT  |        — |    NO    | FK            | Detalle vendido |
| quantity     | DECIMAL |     12,3 |    NO    | CHECK > 0     | Cantidad        |
| amount       | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Monto           |

La cantidad devuelta no puede superar la cantidad originalmente vendida.

---

# 23. Apartados

## 23.1. Apartado (`reservation`)

| Columna                                   | Tipo      | Longitud | Nullable | Restricciones | Descripción               |
| ----------------------------------------- | --------- | -------: | :------: | ------------- | ------------------------- |
| id                                        | BIGINT    |        — |    NO    | PK            | Identificador             |
| customer_id                               | BIGINT    |        — |    NO    | FK            | Cliente                   |
| user_id                                   | BIGINT    |        — |    NO    | FK            | Usuario                   |
| status                                    | VARCHAR   |       20 |    NO    | CHECK         | Estado                    |
| total                                     | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Total                     |
| paid_amount                               | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Pagado                    |
| due_amount                                | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Pendiente                 |
| minimum_percentage_applied                | DECIMAL   |      5,2 |    NO    | CHECK 0-100   | Anticipo aplicado         |
| cancellation_retention_percentage_applied | DECIMAL   |      5,2 |    NO    | CHECK 0-100   | Retención por cancelación |
| expiration_retention_percentage_applied   | DECIMAL   |      5,2 |    NO    | CHECK 0-100   | Retención por vencimiento |
| reserved_at                               | TIMESTAMP |        — |    NO    | DEFAULT       | Creación                  |
| expires_at                                | TIMESTAMP |        — |    NO    | —             | Vencimiento               |
| completed_at                              | TIMESTAMP |        — |    YES   | —             | Liquidación               |
| cancelled_at                              | TIMESTAMP |        — |    YES   | —             | Cancelación               |

### Nullable

`completed_at` y `cancelled_at` son opcionales porque dependen del estado final del apartado.

---

# 24. Detalles de apartado

## 24.1. Detalle de apartado (`reservation_item`)

| Columna        | Tipo    | Longitud | Nullable | Restricciones | Descripción      |
| -------------- | ------- | -------: | :------: | ------------- | ---------------- |
| id             | BIGINT  |        — |    NO    | PK            | Identificador    |
| reservation_id | BIGINT  |        — |    NO    | FK            | Apartado         |
| product_id     | BIGINT  |        — |    NO    | FK            | Producto         |
| quantity       | INTEGER |        — |    NO    | CHECK > 0     | Cantidad         |
| unit_price     | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Precio histórico |
| subtotal       | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Subtotal         |

---

# 25. Pagos de apartados

## 25.1. Pago de apartado (`reservation_payment`)

| Columna           | Tipo      | Longitud | Nullable | Restricciones | Descripción    |
| ----------------- | --------- | -------: | :------: | ------------- | -------------- |
| id                | BIGINT    |        — |    NO    | PK            | Identificador  |
| reservation_id    | BIGINT    |        — |    NO    | FK            | Apartado       |
| payment_method_id | BIGINT    |        — |    NO    | FK            | Método de pago |
| amount            | DECIMAL   |     12,2 |    NO    | CHECK > 0     | Monto          |
| status            | VARCHAR   |       20 |    NO    | CHECK         | Estado         |
| reference         | VARCHAR   |      100 |    YES   | —             | Referencia     |
| user_id           | BIGINT    |        — |    NO    | FK            | Usuario        |
| created_at        | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha          |

---

# 26. Configuración de apartados

## 26.1. Configuración de apartados (`reservation_configuration`)

| Columna                           | Tipo      | Longitud | Nullable | Restricciones | Descripción               |
| --------------------------------- | --------- | -------: | :------: | ------------- | ------------------------- |
| id                                | BIGINT    |        — |    NO    | PK            | Identificador             |
| minimum_percentage                | DECIMAL   |      5,2 |    NO    | CHECK 0-100   | Anticipo mínimo           |
| expiration_days                   | INTEGER   |        — |    NO    | CHECK > 0     | Días de vigencia          |
| cancellation_retention_percentage | DECIMAL   |      5,2 |    NO    | CHECK 0-100   | Retención por cancelación |
| expiration_retention_percentage   | DECIMAL   |      5,2 |    NO    | CHECK 0-100   | Retención por vencimiento |
| active                            | BOOLEAN   |        — |    NO    | DEFAULT TRUE  | Estado                    |
| created_at                        | TIMESTAMP |        — |    NO    | DEFAULT       | Creación                  |
| updated_at                        | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización             |

Los valores históricos utilizados por cada apartado no dependen de esta tabla, sino de los snapshots almacenados en `reservation`.

---

# 27. Proveedores

## 27.1. Proveedor (`supplier`)

| Columna    | Tipo      | Longitud | Nullable | Restricciones | Descripción   |
| ---------- | --------- | -------: | :------: | ------------- | ------------- |
| id         | BIGINT    |        — |    NO    | PK            | Identificador |
| name       | VARCHAR   |      150 |    NO    | —             | Nombre        |
| phone      | VARCHAR   |       20 |    YES   | —             | Teléfono      |
| email      | VARCHAR   |      254 |    YES   | —             | Correo        |
| address    | VARCHAR   |      255 |    YES   | —             | Dirección     |
| active     | BOOLEAN   |        — |    NO    | DEFAULT TRUE  | Estado        |
| created_at | TIMESTAMP |        — |    NO    | DEFAULT       | Creación      |
| updated_at | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización |

---

# 28. Producto-Proveedor

## 28.1. Relación producto-proveedor (`product_supplier`)

| Columna             | Tipo    | Longitud | Nullable | Restricciones | Descripción           |
| ------------------- | ------- | -------: | :------: | ------------- | --------------------- |
| product_id          | BIGINT  |        — |    NO    | PK, FK        | Producto              |
| supplier_id         | BIGINT  |        — |    NO    | PK, FK        | Proveedor             |
| supplier_code       | VARCHAR |       50 |    YES   | —             | Código del proveedor  |
| last_purchase_price | DECIMAL |     12,2 |    YES   | CHECK >= 0    | Último costo conocido |
| active              | BOOLEAN |        — |    NO    | DEFAULT TRUE  | Estado                |

### Clave primaria

```text
PK(product_id, supplier_id)
```

---

# 29. Compras

## 29.1. Compra (`purchase`)

| Columna     | Tipo      | Longitud | Nullable | Restricciones | Descripción         |
| ----------- | --------- | -------: | :------: | ------------- | ------------------- |
| id          | BIGINT    |        — |    NO    | PK            | Identificador       |
| supplier_id | BIGINT    |        — |    NO    | FK            | Proveedor           |
| user_id     | BIGINT    |        — |    NO    | FK            | Usuario responsable |
| status      | VARCHAR   |       20 |    NO    | CHECK         | Estado              |
| subtotal    | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Subtotal            |
| total       | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Total               |
| ordered_at  | TIMESTAMP |        — |    YES   | —             | Fecha de pedido     |
| received_at | TIMESTAMP |        — |    YES   | —             | Fecha de recepción  |
| created_at  | TIMESTAMP |        — |    NO    | DEFAULT       | Creación            |

---

# 30. Detalles de compra

## 30.1. Detalle de compra (`purchase_item`)

| Columna           | Tipo    | Longitud | Nullable | Restricciones | Descripción         |
| ----------------- | ------- | -------: | :------: | ------------- | ------------------- |
| id                | BIGINT  |        — |    NO    | PK            | Identificador       |
| purchase_id       | BIGINT  |        — |    NO    | FK            | Compra              |
| product_id        | BIGINT  |        — |    NO    | FK            | Producto            |
| quantity_ordered  | INTEGER |        — |    NO    | CHECK > 0     | Cantidad solicitada |
| quantity_received | INTEGER |        — |    NO    | CHECK >= 0    | Cantidad recibida   |
| unit_cost         | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Costo histórico     |
| subtotal          | DECIMAL |     12,2 |    NO    | CHECK >= 0    | Subtotal            |

---

# 31. Incidencias de compra

## 31.1. Incidencia de compra (`purchase_incident`)

| Columna          | Tipo      | Longitud | Nullable | Restricciones | Descripción       |
| ---------------- | --------- | -------: | :------: | ------------- | ----------------- |
| id               | BIGINT    |        — |    NO    | PK            | Identificador     |
| purchase_id      | BIGINT    |        — |    NO    | FK            | Compra            |
| purchase_item_id | BIGINT    |        — |    NO    | FK            | Detalle           |
| type             | VARCHAR   |       30 |    NO    | CHECK         | Tipo              |
| quantity         | INTEGER   |        — |    NO    | CHECK > 0     | Cantidad afectada |
| description      | TEXT      |        — |    NO    | —             | Descripción       |
| resolution       | VARCHAR   |      255 |    YES   | —             | Resolución        |
| status           | VARCHAR   |       20 |    NO    | CHECK         | Estado            |
| created_at       | TIMESTAMP |        — |    NO    | DEFAULT       | Creación          |
| resolved_at      | TIMESTAMP |        — |    YES   | —             | Resolución        |

---

# 32. Caja

## 32.1. Caja (`cash_register`)

| Columna        | Tipo      | Longitud | Nullable | Restricciones | Descripción   |
| -------------- | --------- | -------: | :------: | ------------- | ------------- |
| id             | BIGINT    |        — |    NO    | PK            | Identificador |
| user_id        | BIGINT    |        — |    NO    | FK            | Usuario       |
| status         | VARCHAR   |       20 |    NO    | CHECK         | Estado        |
| opening_amount | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Monto inicial |
| opened_at      | TIMESTAMP |        — |    NO    | DEFAULT       | Apertura      |
| closed_at      | TIMESTAMP |        — |    YES   | —             | Cierre        |

---

# 33. Movimientos de caja

## 33.1. Movimiento de caja (`cash_movement`)

| Columna          | Tipo      | Longitud | Nullable | Restricciones | Descripción        |
| ---------------- | --------- | -------: | :------: | ------------- | ------------------ |
| id               | BIGINT    |        — |    NO    | PK            | Identificador      |
| cash_register_id | BIGINT    |        — |    NO    | FK            | Caja               |
| type             | VARCHAR   |       30 |    NO    | CHECK         | Tipo               |
| amount           | DECIMAL   |     12,2 |    NO    | CHECK > 0     | Monto              |
| reference_type   | VARCHAR   |       30 |    YES   | —             | Tipo de referencia |
| reference_id     | BIGINT    |        — |    YES   | —             | Referencia         |
| user_id          | BIGINT    |        — |    NO    | FK            | Usuario            |
| description      | TEXT      |        — |    YES   | —             | Descripción        |
| created_at       | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha              |

Los movimientos no se eliminan físicamente.

---

# 34. Cortes de caja

## 34.1. Corte de caja (`cash_closing`)

| Columna          | Tipo      | Longitud | Nullable | Restricciones | Descripción    |
| ---------------- | --------- | -------: | :------: | ------------- | -------------- |
| id               | BIGINT    |        — |    NO    | PK            | Identificador  |
| cash_register_id | BIGINT    |        — |    NO    | FK            | Caja           |
| user_id          | BIGINT    |        — |    NO    | FK            | Usuario        |
| expected_amount  | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Monto esperado |
| actual_amount    | DECIMAL   |     12,2 |    NO    | CHECK >= 0    | Monto contado  |
| difference       | DECIMAL   |     12,2 |    NO    | —             | Diferencia     |
| observations     | TEXT      |        — |    YES   | —             | Observaciones  |
| created_at       | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha          |

---

# 35. Facturación

## 35.1. Factura (`invoice`)

| Columna        | Tipo      | Longitud | Nullable | Restricciones | Descripción           |
| -------------- | --------- | -------: | :------: | ------------- | --------------------- |
| id             | BIGINT    |        — |    NO    | PK            | Identificador         |
| sale_id        | BIGINT    |        — |    NO    | FK UNIQUE     | Venta                 |
| fiscal_data_id | BIGINT    |        — |    NO    | FK            | Datos fiscales        |
| provider       | VARCHAR   |       50 |    NO    | —             | Proveedor             |
| external_id    | VARCHAR   |      100 |    YES   | —             | Identificador externo |
| status         | VARCHAR   |       20 |    NO    | CHECK         | Estado                |
| issued_at      | TIMESTAMP |        — |    YES   | —             | Fecha de emisión      |
| error_message  | TEXT      |        — |    YES   | —             | Error                 |
| created_at     | TIMESTAMP |        — |    NO    | DEFAULT       | Creación              |
| updated_at     | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización         |

La factura puede permanecer pendiente si el proveedor externo no está disponible.

---

# 36. Interés por productos

## 36.1. Interés de producto (`product_interest`)

| Columna        | Tipo      | Longitud | Nullable | Restricciones | Descripción       |
| -------------- | --------- | -------: | :------: | ------------- | ----------------- |
| id             | BIGINT    |        — |    NO    | PK            | Identificador     |
| customer_id    | BIGINT    |        — |    YES   | FK            | Cliente           |
| product_id     | BIGINT    |        — |    YES   | FK            | Producto          |
| requested_name | VARCHAR   |      150 |    NO    | —             | Nombre solicitado |
| notes          | TEXT      |        — |    YES   | —             | Notas             |
| status         | VARCHAR   |       20 |    NO    | CHECK         | Estado            |
| created_at     | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha             |

### Regla importante

`customer_id` puede ser `NULL` porque una persona puede preguntar por un producto sin estar registrada.

`product_id` puede ser `NULL` porque la persona puede preguntar por un producto que todavía no existe en el catálogo.

Por lo tanto, ambos campos pueden ser `NULL` simultáneamente.

---

# 37. Configuración general

## 37.1. Configuración del negocio (`business_configuration`)

| Columna     | Tipo      | Longitud | Nullable | Restricciones | Descripción   |
| ----------- | --------- | -------: | :------: | ------------- | ------------- |
| id          | BIGINT    |        — |    NO    | PK            | Identificador |
| key         | VARCHAR   |      100 |    NO    | UNIQUE        | Clave         |
| value       | TEXT      |        — |    NO    | —             | Valor         |
| data_type   | VARCHAR   |       20 |    NO    | CHECK         | Tipo de dato  |
| description | VARCHAR   |      255 |    YES   | —             | Descripción   |
| updated_by  | BIGINT    |        — |    NO    | FK            | Usuario       |
| updated_at  | TIMESTAMP |        — |    NO    | DEFAULT       | Actualización |

No debe utilizarse esta tabla para sustituir entidades que requieran relaciones propias.

---

# 38. Auditoría

## 38.1. Registro de auditoría (`audit_record`)

| Columna     | Tipo      | Longitud | Nullable | Restricciones | Descripción         |
| ----------- | --------- | -------: | :------: | ------------- | ------------------- |
| id          | BIGINT    |        — |    NO    | PK            | Identificador       |
| user_id     | BIGINT    |        — |    NO    | FK            | Usuario responsable |
| action      | VARCHAR   |       30 |    NO    | CHECK         | Acción              |
| entity_type | VARCHAR   |       50 |    NO    | —             | Tipo de entidad     |
| entity_id   | BIGINT    |       NO |    NO    | —             | Registro afectado   |
| old_value   | JSONB     |        — |    YES   | —             | Valor anterior      |
| new_value   | JSONB     |        — |    YES   | —             | Valor nuevo         |
| reason      | TEXT      |        — |    YES   | —             | Motivo              |
| created_at  | TIMESTAMP |        — |    NO    | DEFAULT       | Fecha               |

### Nota

`old_value` puede ser `NULL` en operaciones donde no exista un valor anterior.

`new_value` puede ser `NULL` cuando la operación únicamente represente una eliminación lógica u otro evento donde no corresponda almacenar un nuevo estado.

Los registros de auditoría no deben eliminarse físicamente.

---

# 39. Resumen de reglas de nullable

Las siguientes relaciones y campos tienen una razón explícita para aceptar `NULL`.

| Tabla                       | Columna               | Nullable | Motivo                                                    |
| --------------------------- | --------------------- | :------: | --------------------------------------------------------- |
| `customer`                  | `paternal_last_name`  |    Sí    | Apellido opcional                                         |
| `customer`                  | `maternal_last_name`  |    Sí    | Apellido opcional                                         |
| `customer`                  | `phone`               |    Sí    | Dato no obligatorio                                       |
| `customer`                  | `email`               |    Sí    | Dato no obligatorio                                       |
| `fiscal_data`               | —                     |     —    | Sus campos son obligatorios cuando existe registro fiscal |
| `product`                   | `barcode`             |    Sí    | Puede no existir código de barras                         |
| `product`                   | `description`         |    Sí    | Descripción opcional                                      |
| `product`                   | `brand_id`            |    Sí    | Un producto puede no tener marca registrada               |
| `service`                   | `description`         |    Sí    | Descripción opcional                                      |
| `service_rate`              | `configuration`       |    Sí    | No todas las tarifas requieren configuración adicional    |
| `inventory_incident`        | `resolved_by`         |    Sí    | Puede estar pendiente                                     |
| `inventory_incident`        | `resolved_at`         |    Sí    | Puede estar pendiente                                     |
| `sale`                      | `customer_id`         |    Sí    | Se permiten ventas sin cliente registrado                 |
| `sale`                      | `completed_at`        |    Sí    | Una venta puede estar pendiente/cancelada                 |
| `sale`                      | `cancelled_at`        |    Sí    | Solo aplica a ventas canceladas                           |
| `sale_item`                 | `product_id`          |    Sí    | Puede ser un servicio                                     |
| `sale_item`                 | `service_id`          |    Sí    | Puede ser un producto                                     |
| `sale_item`                 | `discount_id`         |    Sí    | Una venta puede no tener descuento                        |
| `sale_item`                 | `discount_type`       |    Sí    | No existe si no hay descuento                             |
| `sale_item`                 | `discount_value`      |    Sí    | No existe si no hay descuento                             |
| `payment`                   | `reference`           |    Sí    | Efectivo puede no tener referencia                        |
| `discount`                  | `conditions`          |    Sí    | No todos requieren condiciones adicionales                |
| `discount`                  | `ends_at`             |    Sí    | Puede no tener fecha de finalización                      |
| `return`                    | —                     |     —    | Datos principales obligatorios                            |
| `reservation`               | `completed_at`        |    Sí    | Solo aplica al liquidarse                                 |
| `reservation`               | `cancelled_at`        |    Sí    | Solo aplica al cancelarse                                 |
| `reservation_payment`       | `reference`           |    Sí    | Puede no existir referencia externa                       |
| `reservation_configuration` | —                     |     —    | Configuración requerida                                   |
| `supplier`                  | `phone`               |    Sí    | Dato no obligatorio                                       |
| `supplier`                  | `email`               |    Sí    | Dato no obligatorio                                       |
| `supplier`                  | `address`             |    Sí    | Dato no obligatorio                                       |
| `product_supplier`          | `supplier_code`       |    Sí    | El proveedor puede no tener código                        |
| `product_supplier`          | `last_purchase_price` |    Sí    | Puede no existir compra previa                            |
| `purchase`                  | `received_at`         |    Sí    | La compra puede no haber sido recibida                    |
| `purchase_incident`         | `resolution`          |    Sí    | Puede estar pendiente                                     |
| `purchase_incident`         | `resolved_at`         |    Sí    | Puede estar pendiente                                     |
| `cash_register`             | `closed_at`           |    Sí    | Puede permanecer abierta                                  |
| `cash_movement`             | `reference_type`      |    Sí    | No todo movimiento tiene referencia                       |
| `cash_movement`             | `reference_id`        |    Sí    | No todo movimiento tiene referencia                       |
| `cash_movement`             | `description`         |    Sí    | Descripción opcional                                      |
| `cash_closing`              | `observations`        |    Sí    | Observaciones opcionales                                  |
| `invoice`                   | `external_id`         |    Sí    | Puede estar pendiente                                     |
| `invoice`                   | `issued_at`           |    Sí    | Puede no haberse emitido todavía                          |
| `invoice`                   | `error_message`       |    Sí    | Solo aplica cuando existe error                           |
| `product_interest`          | `customer_id`         |    Sí    | Persona no registrada                                     |
| `product_interest`          | `product_id`          |    Sí    | Producto aún inexistente                                  |
| `product_interest`          | `notes`               |    Sí    | Notas opcionales                                          |
| `business_configuration`    | `description`         |    Sí    | Descripción opcional                                      |
| `audit_record`              | `old_value`           |    Sí    | Puede no existir estado anterior                          |
| `audit_record`              | `new_value`           |    Sí    | Puede no aplicar                                          |
| `audit_record`              | `reason`              |    Sí    | No todas las acciones requieren motivo                    |

---

# 40. Reglas generales de restricciones

## 40.1. Identificadores

Todas las tablas principales:

```text
id BIGINT PRIMARY KEY NOT NULL
```

---

## 40.2. Valores monetarios

Los valores monetarios utilizarán:

```text
DECIMAL(12,2)
```

salvo porcentajes u otros campos donde se especifique una precisión diferente.

Los valores monetarios que representen precios, costos o montos no deben ser negativos.

---

## 40.3. Porcentajes

Los porcentajes utilizarán:

```text
DECIMAL(5,2)
```

permitiendo valores entre:

```text
0.00
```

y:

```text
100.00
```

cuando representen porcentajes completos.

---

## 40.4. Cantidades

Las cantidades enteras utilizarán:

```text
INTEGER
```

Las cantidades que puedan requerir fracciones utilizarán:

```text
DECIMAL(12,3)
```

Esto permite representar, por ejemplo:

```text
1.250
```

unidades cuando el servicio o producto lo requiera.

---

# 41. Auditoría e información histórica

El Data Dictionary mantiene la separación entre:

### Configuración actual

Ejemplos:

```text
product.sale_price
product.stock_alert_level
discount.value
reservation_configuration.minimum_percentage
service_rate.unit_price
```

### Valores utilizados en operaciones

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

### Historial de cambios

```text
audit_record
```

De esta forma, el sistema puede conocer:

```text
Configuración actual
        +
Valor utilizado históricamente
        +
Quién modificó la configuración
        +
Valor anterior
        +
Valor posterior
```

---

# 42. Integridad histórica

Una modificación posterior de una configuración no debe modificar los datos históricos.

Por ejemplo:

```text
discount.value
```

puede pasar de:

```text
15%
```

a:

```text
18%
```

pero una venta anterior conserva:

```text
sale_item.discount_value = 15
```

De igual forma, si:

```text
reservation_configuration.minimum_percentage
```

cambia de:

```text
30%
```

a:

```text
40%
```

un apartado existente conserva:

```text
reservation.minimum_percentage_applied = 30
```

---

# 43. Eliminación física

Las entidades operativas e históricas no deben eliminarse físicamente como mecanismo normal de corrección.

Se utilizarán estados o eliminación lógica cuando corresponda.

Particularmente:

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
audit_record
```

deben conservarse.

Las entidades configurables podrán utilizar:

```text
active
```

para dejar de utilizarlas sin perder su existencia histórica.

---

# 44. Consideraciones de implementación

Este documento define la estructura lógica y las restricciones de datos antes de la implementación.

Durante la implementación en PostgreSQL se deberán convertir estas definiciones en:

* `CREATE TABLE`.
* `PRIMARY KEY`.
* `FOREIGN KEY`.
* `UNIQUE`.
* `CHECK`.
* `DEFAULT`.
* Índices.
* Estrategias de eliminación lógica.
* Índices para búsquedas.
* Migraciones.

Las decisiones que impliquen cambios arquitectónicos deberán documentarse mediante ADR.

---

# 45. Objetivo del Data Dictionary

El objetivo final es que antes de implementar la base de datos podamos responder de forma precisa:

* Qué tablas existen.
* Qué representa cada tabla.
* Qué columnas contiene.
* Qué tipo de dato utiliza cada columna.
* Cuántos caracteres puede almacenar.
* Si el dato es obligatorio.
* Si puede ser `NULL`.
* Qué restricciones posee.
* Qué relaciones tiene.
* Qué información es histórica.
* Qué información puede modificarse.
* Qué información debe auditarse.

De esta manera, el Data Dictionary funciona como el puente entre el **modelo conceptual/ER** y la futura **implementación física de PostgreSQL**.
