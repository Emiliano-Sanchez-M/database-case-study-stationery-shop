# ADR-012: Preparación para soporte futuro de múltiples sucursales

## Estado

Aceptado

## Fecha

2026-08-09

## Contexto

Actualmente, el sistema está diseñado para operar una sola sucursal de la papelería.

Durante el diseño del modelo de dominio, modelo entidad-relación, diccionario de datos y reglas de negocio se identificó que el sistema podría evolucionar posteriormente hacia un escenario con múltiples sucursales.

Una futura versión del sistema podría permitir que una misma empresa tenga, por ejemplo:

```text
Sucursal Centro
Sucursal Norte
Sucursal Sur
```

Cada sucursal podría tener:

* Inventario independiente.
* Caja independiente.
* Usuarios asignados.
* Configuraciones particulares.
* Ventas.
* Compras.
* Apartados.
* Movimientos de inventario.
* Cortes de caja.
* Operaciones propias.

Sin embargo, incorporar desde el inicio una entidad `branch` y agregar `branch_id` a todas las tablas podría introducir complejidad innecesaria en una primera versión del sistema.

Por otro lado, ignorar completamente la posibilidad de crecimiento podría provocar un fuerte acoplamiento con el modelo de una sola sucursal y dificultar posteriormente la migración hacia un modelo multi-sucursal.

Por lo tanto, se requiere establecer una estrategia que permita mantener el modelo actual simple, pero que no cierre la posibilidad de incorporar múltiples sucursales posteriormente.

---

## Decisión

El sistema se implementará inicialmente bajo un modelo de **una sola sucursal**, pero la arquitectura y el modelo de datos deberán evitar decisiones que hagan imposible una futura evolución hacia múltiples sucursales.

No se agregará una entidad `branch` al modelo actual únicamente como mecanismo preventivo.

La incorporación de múltiples sucursales se realizará posteriormente mediante una evolución explícita del modelo, acompañada de los ADR y migraciones correspondientes.

---

## Principios de diseño

### 1. No introducir `branch_id` artificialmente

No todas las entidades necesitan actualmente una relación con una sucursal.

Agregar:

```text
branch_id
```

a todas las tablas desde el inicio produciría:

* Relaciones innecesarias.
* Claves foráneas adicionales.
* Mayor complejidad en consultas.
* Mayor complejidad en validaciones.
* Mayor superficie de configuración.
* Mayor complejidad para una aplicación que actualmente opera una sola sucursal.

Por lo tanto, `branch_id` no se incorporará hasta que exista un requerimiento real de multi-sucursal.

---

### 2. Mantener separación entre configuración y operación

Las configuraciones actuales deberán mantenerse separadas de las operaciones.

Por ejemplo:

```text
reservation_configuration
discount
service_rate
business_configuration
```

no deben diseñarse de manera que imposibiliten posteriormente definir configuraciones por sucursal.

Cuando llegue el momento de soportar múltiples sucursales, se podrá evolucionar el modelo hacia una relación como:

```text
branch
    │
    ├── reservation_configuration
    ├── business_configuration
    ├── service_rate
    └── discount
```

si los requisitos del negocio determinan que estas configuraciones deben ser independientes por sucursal.

---

### 3. Las operaciones deberán poder asociarse posteriormente a una sucursal

Las operaciones actuales incluyen entidades como:

```text
sale
purchase
reservation
cash_register
inventory
inventory_movement
cash_movement
```

En un modelo multi-sucursal, estas entidades probablemente necesitarán identificar la sucursal responsable de la operación.

Por ejemplo:

```text
sale
 └── branch_id
```

o:

```text
cash_register
 └── branch_id
```

La incorporación de estas relaciones deberá realizarse cuando el requisito multi-sucursal sea formalmente adoptado.

---

### 4. El inventario será una de las principales áreas afectadas

Actualmente:

```text
product
    │
    └── inventory
```

representa la existencia de un producto.

En un escenario multi-sucursal, un mismo producto podría tener diferentes existencias:

```text
Producto A

Sucursal Centro → 20
Sucursal Norte  → 5
Sucursal Sur    → 12
```

Por lo tanto, el modelo futuro deberá evolucionar hacia una estructura similar a:

```text
product
    │
    └── branch_inventory
            ├── branch_id
            ├── product_id
            └── quantity
```

La existencia dejaría de ser exclusivamente una propiedad global del producto.

---

### 5. Caja deberá ser independiente por sucursal

Una caja pertenece conceptualmente a una ubicación física.

En un modelo multi-sucursal:

```text
Sucursal Centro
 ├── Caja 1
 └── Caja 2

Sucursal Norte
 └── Caja 1
```

Por lo tanto, `cash_register` deberá asociarse a `branch`.

Esto permitirá mantener independientes:

* Aperturas.
* Movimientos.
* Cortes.
* Diferencias.
* Usuarios responsables.

---

### 6. Los usuarios podrán tener alcance por sucursal

Actualmente un usuario puede tener roles y permisos.

En un escenario multi-sucursal será necesario determinar si un usuario:

* Pertenece a una única sucursal.
* Puede trabajar en varias sucursales.
* Es administrador de todas las sucursales.
* Tiene permisos diferentes dependiendo de la sucursal.

Por lo tanto, la relación futura podría evolucionar hacia algo como:

```text
user
  │
  └── user_branch
          ├── user_id
          └── branch_id
```

La estructura definitiva dependerá de los requisitos de autorización del sistema.

---

## Consecuencias

### Ventajas

* El MVP mantiene una estructura sencilla.
* Se evita introducir complejidad antes de necesitarla.
* No se agregan relaciones artificiales.
* Se mantiene abierta la posibilidad de crecimiento.
* Las futuras modificaciones pueden realizarse mediante migraciones controladas.
* El modelo actual continúa siendo coherente con el alcance del sistema.
* Se evita diseñar una arquitectura multi-sucursal basada únicamente en especulación.
* Las áreas que probablemente necesitarán evolución quedan identificadas.

### Desventajas

* La migración a múltiples sucursales requerirá cambios en el modelo de datos.
* Algunas tablas necesitarán nuevas relaciones.
* Será necesario adaptar consultas y casos de uso.
* Las configuraciones deberán evaluarse para determinar si son globales o específicas por sucursal.
* El inventario requerirá una modificación estructural importante.
* La autorización de usuarios deberá evolucionar para contemplar el contexto de sucursal.
* Será necesario realizar migraciones y pruebas antes de habilitar multi-sucursal.

---

## Alternativas consideradas

### 1. Implementar multi-sucursal desde el inicio

No se seleccionó.

Aunque permitiría disponer desde el principio de una arquitectura multi-sucursal, aumentaría considerablemente la complejidad del MVP.

El sistema actualmente no necesita:

* Gestión de múltiples sucursales.
* Transferencias entre sucursales.
* Inventario por sucursal.
* Configuración independiente por sucursal.
* Usuarios con alcance por sucursal.

Implementarlo sin un requerimiento real supondría diseñar funcionalidades que todavía no forman parte del alcance.

---

### 2. Ignorar completamente la posibilidad de múltiples sucursales

No se seleccionó.

Aunque simplificaría inicialmente el desarrollo, podría generar acoplamientos que dificulten posteriormente la evolución.

El sistema, por lo tanto, no implementará multi-sucursal ahora, pero sí evitará decisiones que hagan imposible su incorporación.

---

### 3. Agregar `branch_id` a todas las tablas desde el inicio

No se seleccionó.

No todas las entidades necesariamente pertenecerán directamente a una sucursal.

Por ejemplo:

```text
permission
role
```

pueden continuar siendo entidades globales.

Agregar una relación indiscriminadamente produciría un modelo menos normalizado conceptualmente y con relaciones innecesarias.

---

### 4. Crear una abstracción genérica de "ubicación"

No se seleccionó.

Una abstracción demasiado genérica podría intentar resolver desde el inicio escenarios como:

```text
Sucursal
Almacén
Punto de venta
Oficina
Bodega
```

sin que exista todavía un requerimiento para ello.

Esto introduciría conceptos que no forman parte del dominio actual.

---

## Evolución prevista

Cuando el soporte multi-sucursal se convierta en un requisito real, se deberá evaluar una evolución similar a:

```text
branch
```

con atributos como:

```text
id
name
code
address
phone
active
created_at
updated_at
```

A partir de ahí se determinarán las relaciones necesarias.

Una posible evolución conceptual sería:

```text
                    ┌──────────────┐
                    │    branch    │
                    └──────┬───────┘
                           │
          ┌────────────────┼─────────────────┐
          │                │                 │
          ▼                ▼                 ▼
      inventory       cash_register        user
          │                │
          ▼                ▼
 inventory_movement   cash_movement
          │
          ▼
        sale
```

Sin embargo, este diagrama representa una posible evolución y **no forma parte del modelo actual**.

---

## Áreas que deberán evaluarse al implementar multi-sucursal

Cuando se adopte formalmente el soporte multi-sucursal, deberán analizarse al menos:

### Inventario

Determinar existencias por sucursal.

### Ventas

Identificar la sucursal donde se realizó cada venta.

### Compras

Determinar si las compras pertenecen a una sucursal o a la empresa completa.

### Apartados

Determinar dónde se realiza y administra cada apartado.

### Caja

Asociar cajas y movimientos a una sucursal.

### Usuarios

Determinar el alcance de los usuarios.

### Configuraciones

Determinar cuáles son:

* Globales.
* Por sucursal.
* Por tipo de operación.

### Descuentos

Determinar si una promoción aplica:

* A toda la empresa.
* A determinadas sucursales.
* A determinados productos.
* A determinados periodos.

### Servicios

Determinar si las tarifas son globales o específicas por sucursal.

### Auditoría

La auditoría deberá conservar el contexto de la sucursal cuando la operación sea específica de una sucursal.

---

## Migración futura

La incorporación de múltiples sucursales deberá realizarse mediante una migración controlada.

Una posible estrategia sería:

### Paso 1

Crear:

```text
branch
```

### Paso 2

Crear una sucursal inicial que represente la operación existente.

Por ejemplo:

```text
Sucursal principal
```

### Paso 3

Agregar las relaciones necesarias a las entidades que requieran contexto de sucursal.

### Paso 4

Asignar los registros históricos existentes a la sucursal inicial.

### Paso 5

Actualizar casos de uso, servicios y consultas.

### Paso 6

Actualizar permisos y reglas de acceso.

### Paso 7

Agregar pruebas específicas para aislamiento entre sucursales.

La estrategia definitiva deberá documentarse mediante un nuevo ADR cuando el requisito sea aprobado.

---

## Impacto en la arquitectura

Esta decisión afecta principalmente las siguientes capas y componentes:

### Dominio

El dominio actual continuará representando una sola sucursal.

La futura entidad `Branch` deberá incorporarse únicamente cuando el requerimiento sea adoptado.

### Aplicación

Los casos de uso futuros deberán considerar el contexto de sucursal cuando corresponda.

Especialmente:

* Ventas.
* Inventario.
* Compras.
* Apartados.
* Caja.
* Configuración.

### Persistencia

La futura evolución requerirá nuevas relaciones y posiblemente nuevas entidades, principalmente:

```text
branch
user_branch
branch_inventory
```

dependiendo del diseño definitivo.

### Seguridad

El sistema de autorización deberá evolucionar para determinar qué usuarios pueden operar sobre qué sucursales.

### Auditoría

Los eventos específicos de una sucursal deberán poder identificarse correctamente.

### Configuración

Será necesario distinguir entre:

```text
Configuración global
```

y:

```text
Configuración por sucursal
```

cuando el negocio lo requiera.

### Inventario

Será una de las áreas con mayor impacto, debido a que las existencias deberán gestionarse por sucursal.

### Caja

Cada sucursal deberá poder mantener sus propias cajas, movimientos y cortes.

---

## Relación con otros ADR

Este ADR se relaciona principalmente con:

* **ADR-001: Domain Modeling Approach** — establece la evolución del modelo de dominio.
* **ADR-003: Historical Data and Snapshots** — deberá conservarse el contexto histórico de las operaciones al incorporar sucursales.
* **ADR-004: Audit Trail Strategy** — la auditoría deberá poder identificar el contexto de sucursal.
* **ADR-005: Logical Deletion Strategy** — las sucursales deberán conservar su historial aunque sean desactivadas.
* **ADR-009: Inventory Traceability** — el inventario deberá evolucionar hacia un modelo por sucursal.
* **ADR-011: Configurable Business Rules** — será necesario determinar qué configuraciones son globales y cuáles pertenecen a una sucursal.

---

## Resultado esperado

El sistema actual continuará funcionando bajo el modelo:

```text
Empresa
   │
   └── Operación actual
```

sin introducir complejidad multi-sucursal innecesaria.

Sin embargo, las decisiones arquitectónicas deberán permitir una evolución posterior hacia:

```text
Empresa
   │
   ├── Sucursal Centro
   │     ├── Inventario
   │     ├── Caja
   │     ├── Ventas
   │     ├── Compras
   │     └── Apartados
   │
   ├── Sucursal Norte
   │     ├── Inventario
   │     ├── Caja
   │     ├── Ventas
   │     ├── Compras
   │     └── Apartados
   │
   └── Sucursal Sur
         ├── Inventario
         ├── Caja
         ├── Ventas
         ├── Compras
         └── Apartados
```

La incorporación de múltiples sucursales no se considera parte del alcance actual.

Se mantiene como una capacidad futura que deberá ser analizada y documentada formalmente cuando exista una necesidad real de negocio.

---

## Decisión final

El sistema se desarrollará inicialmente para una sola sucursal.

No se implementará `branch` ni se agregarán relaciones de sucursal de manera preventiva.

La arquitectura deberá, sin embargo, evitar acoplamientos que imposibiliten una futura evolución hacia múltiples sucursales.

Cuando el requerimiento sea aprobado, se realizará un nuevo análisis arquitectónico y se definirán las entidades, relaciones, migraciones y reglas necesarias mediante nuevos ADR.
