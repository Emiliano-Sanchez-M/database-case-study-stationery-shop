# ADR-001: Enfoque para el modelado de dominio

## Estado

Aceptado

## Fecha

2026-08-07

## Contexto

El sistema de gestión para la papelería requiere representar de manera estructurada las entidades, conceptos y reglas que forman parte del negocio.

Durante el análisis del sistema se identificaron diferentes fuentes de información:

* Contexto del negocio.
* Reglas de negocio.
* Glosario.
* Actores.
* Requisitos funcionales.
* Requisitos no funcionales.
* Casos de uso.

A partir de estas fuentes se definió un modelo de dominio que posteriormente sirve como referencia para construir el modelo entidad-relación y, finalmente, la estructura de persistencia de la base de datos.

El sistema contiene conceptos que representan tanto elementos relativamente estables del negocio como operaciones que generan información histórica.

Entre ellos se encuentran:

* Usuarios.
* Roles.
* Permisos.
* Clientes.
* Productos.
* Categorías.
* Marcas.
* Servicios.
* Proveedores.
* Inventario.
* Ventas.
* Pagos.
* Devoluciones.
* Apartados.
* Compras.
* Caja.
* Facturación.
* Descuentos.
* Configuraciones.
* Auditoría.
* Intereses por productos.

Existe el riesgo de diseñar directamente la base de datos a partir de las tablas identificadas inicialmente, sin establecer primero claramente los conceptos del dominio.

Esto podría provocar:

* Acoplamiento prematuro entre el negocio y la estructura de persistencia.
* Entidades definidas únicamente por necesidades técnicas.
* Relaciones incorrectas entre conceptos.
* Pérdida de reglas de negocio.
* Dificultad para representar operaciones históricas.
* Dificultad para evolucionar el sistema.
* Confusión entre entidades de configuración y entidades operativas.

Por lo tanto, se requiere establecer un enfoque formal para el modelado del dominio antes de finalizar el diseño de la base de datos.

---

## Decisión

Se utilizará un **modelo de dominio orientado al negocio**, independiente de la implementación específica de la base de datos.

El modelo de dominio será utilizado como una representación conceptual de los principales elementos del negocio, sus responsabilidades, relaciones y reglas.

El proceso de modelado seguirá la siguiente secuencia:

```text
Contexto del negocio
        ↓
Reglas de negocio
        ↓
Glosario
        ↓
Actores
        ↓
Requisitos funcionales
        ↓
Requisitos no funcionales
        ↓
Casos de uso
        ↓
Modelo de dominio
        ↓
Modelo entidad-relación
        ↓
Diccionario de datos
        ↓
Normalización
        ↓
Implementación de la base de datos
```

El modelo de dominio no tendrá como objetivo definir directamente:

* Tipos de datos de PostgreSQL.
* Longitudes exactas de columnas.
* Índices.
* Foreign keys.
* Constraints específicos del motor.
* Estrategias de almacenamiento.
* Detalles de implementación.

Estos aspectos serán definidos posteriormente en el modelo entidad-relación, diccionario de datos y etapa de implementación.

### Separación entre dominio y persistencia

Una entidad del dominio no necesariamente debe convertirse de manera directa en una tabla.

La existencia de una entidad en el modelo de dominio se determina principalmente por su significado dentro del negocio.

Posteriormente se analizará cómo debe representarse persistentemente.

Por ejemplo:

```text
Modelo de dominio:

Venta
 ├── Cliente
 ├── Usuario
 ├── Productos
 ├── Pagos
 └── Descuento
```

Posteriormente, el modelo entidad-relación puede requerir entidades adicionales para representar correctamente:

* Detalles de venta.
* Métodos de pago.
* Relaciones N:M.
* Snapshots históricos.
* Auditoría.
* Configuraciones.
* Relaciones auxiliares.

Por lo tanto:

```text
Entidad de dominio ≠ necesariamente tabla
```

y:

```text
Tabla de base de datos ≠ necesariamente entidad de dominio
```

---

## Principios utilizados

El modelado de dominio seguirá los siguientes principios.

### 1. El negocio precede a la persistencia

Las entidades y relaciones se identificarán primero a partir del comportamiento y las reglas del negocio.

La estructura de la base de datos no debe determinar artificialmente los conceptos del dominio.

---

### 2. Lenguaje común

La documentación utilizará los términos definidos en el glosario y en el análisis del negocio.

Los nombres deberán representar conceptos reconocibles para las personas involucradas en el sistema.

Por ejemplo:

```text
Cliente
Producto
Venta
Apartado
Devolución
Proveedor
Descuento
```

La documentación del dominio utilizará español.

Cuando sea necesario establecer el nombre técnico utilizado posteriormente en la implementación, se incluirá su equivalente en inglés.

Ejemplo:

```text
Cliente (customer)
Producto (product)
Venta (sale)
Apartado (reservation)
```

---

### 3. Las reglas de negocio pertenecen al dominio

Las reglas que determinan el comportamiento del negocio deberán estar representadas conceptualmente en el modelo.

Por ejemplo, un apartado puede tener:

* Un porcentaje mínimo de anticipo.
* Un plazo de vencimiento.
* Una penalización por cancelación.
* Una penalización por vencimiento.

Estas reglas forman parte del dominio independientemente de cómo sean almacenadas posteriormente.

---

### 4. Separación entre configuración y operación

El dominio distingue entre conceptos configurables y operaciones ejecutadas.

Por ejemplo:

```text
Configuración:

Descuento
Configuración de apartados
Tarifa de servicio
Configuración general
```

y:

```text
Operaciones:

Venta
Pago
Devolución
Apartado
Compra
Movimiento de inventario
Movimiento de caja
```

Esta separación permite que las configuraciones puedan cambiar sin alterar el significado de operaciones históricas.

---

### 5. Las operaciones históricas son parte del dominio

Las operaciones que representan hechos ocurridos en el negocio deben conservar su significado histórico.

Por ejemplo:

> Una venta fue realizada cuando el producto tenía un precio de $100.

Si posteriormente el producto cambia a $120, la venta continúa representando una operación realizada a $100.

El modelo de dominio debe contemplar esta diferencia entre:

```text
Estado actual
```

y:

```text
Valor utilizado durante una operación
```

---

### 6. El dominio debe permitir trazabilidad

Las operaciones relevantes deben permitir determinar:

* Quién realizó la operación.
* Qué ocurrió.
* Sobre qué elemento ocurrió.
* Cuándo ocurrió.
* Cuál fue el resultado.

La implementación concreta de auditoría e historial se definirá posteriormente, pero la necesidad de trazabilidad forma parte de los requisitos del dominio.

---

## Alcance del modelo de dominio

El modelo de dominio contempla, como mínimo, los siguientes grupos conceptuales.

### Seguridad

```text
Usuario
Rol
Permiso
```

### Clientes

```text
Cliente
Datos fiscales
```

### Catálogo

```text
Producto
Categoría
Marca
Servicio
Tarifa de servicio
Descuento
```

### Inventario

```text
Inventario
Movimiento de inventario
Incidencia de inventario
```

### Ventas

```text
Venta
Detalle de venta
Pago
Método de pago
Ticket
Devolución
Detalle de devolución
```

### Apartados

```text
Apartado
Detalle de apartado
Pago de apartado
Configuración de apartados
```

### Compras

```text
Proveedor
Producto-Proveedor
Compra
Detalle de compra
Incidencia de compra
```

### Caja

```text
Caja
Movimiento de caja
Corte de caja
```

### Facturación

```text
Factura
```

### Intereses

```text
Interés por producto
```

### Configuración

```text
Configuración general del negocio
```

### Auditoría

```text
Registro de auditoría
```

---

## Relación con el modelo entidad-relación

El modelo de dominio será la principal referencia conceptual para construir el modelo entidad-relación.

Sin embargo, durante la transformación podrán aparecer entidades adicionales necesarias para resolver aspectos de persistencia.

Por ejemplo:

```text
Modelo de dominio
        ↓
      Venta
        ↓
Modelo ER
        ↓
sale
sale_item
payment
ticket
```

También podrán aparecer tablas intermedias para relaciones muchos-a-muchos:

```text
Usuario ↔ Rol

user_role
```

o:

```text
Producto ↔ Proveedor

product_supplier
```

Estas estructuras no representan necesariamente nuevos conceptos del negocio, sino mecanismos para representar correctamente las relaciones en la persistencia.

---

## Relación con los casos de uso

Los casos de uso constituyen una de las principales fuentes para identificar las responsabilidades y relaciones del dominio.

Por ejemplo, el proceso de venta establece que:

1. El cliente solicita productos.
2. El cajero busca los productos.
3. El cajero agrega los productos encontrados.
4. El sistema verifica el stock.
5. El sistema alerta cuando existe una cantidad insuficiente.
6. El cajero informa al cliente.
7. El cliente decide qué cantidad adquirir.
8. El cajero continúa con la venta.
9. El cliente selecciona el método de pago.
10. Se registra el pago.
11. Se genera el ticket.

Este flujo permite identificar conceptos como:

```text
Venta
Producto
Inventario
Usuario
Pago
Método de pago
Ticket
```

Por lo tanto, los casos de uso y el modelo de dominio se consideran artefactos relacionados.

---

## Relación con los requisitos

El modelo de dominio deberá ser consistente con los requisitos funcionales y no funcionales.

Los requisitos funcionales determinan comportamientos que el dominio debe poder representar.

Los requisitos no funcionales pueden imponer características que afecten la forma en que determinadas entidades deberán manejar:

* Historial.
* Auditoría.
* Integridad.
* Seguridad.
* Disponibilidad.
* Consistencia.

No obstante, los detalles técnicos derivados de estos requisitos se definirán en los artefactos correspondientes.

---

## Consecuencias

### Ventajas

* El modelo representa primero el negocio y posteriormente la persistencia.
* Reduce el acoplamiento entre reglas de negocio y PostgreSQL.
* Facilita la comprensión del sistema.
* Permite detectar entidades y relaciones antes de implementar.
* Facilita la construcción del modelo ER.
* Facilita la normalización posterior.
* Permite identificar claramente configuraciones y operaciones.
* Facilita la representación de información histórica.
* Facilita la trazabilidad y auditoría.
* Proporciona una referencia común para desarrollo y documentación.
* Permite que futuras modificaciones de la base de datos no necesariamente impliquen modificar el modelo conceptual.

### Desventajas

* Requiere una etapa adicional de análisis antes de implementar.
* Puede existir cierta diferencia entre las entidades del dominio y las tablas finales.
* Algunas decisiones de persistencia deberán documentarse posteriormente.
* Mantener consistencia entre los diferentes artefactos de documentación requiere disciplina.
* Los cambios importantes en el negocio pueden requerir actualizar varios documentos.

---

## Alternativas consideradas

### 1. Diseñar directamente la base de datos

No se adopta.

Diseñar directamente las tablas a partir de los requisitos podría provocar que las necesidades de persistencia determinen incorrectamente el modelo del negocio.

Además, dificultaría distinguir entre:

* Entidades del negocio.
* Entidades operativas.
* Tablas auxiliares.
* Configuraciones.
* Estructuras necesarias para auditoría.

---

### 2. Utilizar únicamente diagramas ER

No se adopta.

El modelo ER describe principalmente la estructura de persistencia.

No es suficiente para representar de manera independiente todos los conceptos, responsabilidades y reglas del dominio.

---

### 3. Utilizar únicamente los casos de uso

No se adopta.

Los casos de uso describen interacciones y comportamientos, pero no proporcionan por sí mismos una representación completa y estructurada de los conceptos del negocio.

---

### 4. Crear un modelo de dominio basado directamente en las tablas

No se adopta.

Esto produciría un modelo altamente dependiente de la implementación y dificultaría la evolución futura del sistema.

---

## Impacto en la arquitectura

Esta decisión afecta principalmente a las siguientes capas y componentes:

### Capa de dominio

Es la capa directamente afectada.

Las entidades y conceptos del negocio deben derivarse del modelo de dominio y no de la estructura de persistencia.

### Capa de aplicación

Los casos de uso y servicios de aplicación deberán trabajar con conceptos definidos por el dominio.

### Capa de persistencia

El modelo ER y el esquema PostgreSQL se derivarán posteriormente del modelo de dominio.

La persistencia podrá introducir estructuras adicionales necesarias para representar:

* Relaciones.
* Snapshots.
* Auditoría.
* Historial.
* Integridad referencial.

### Capa de infraestructura

Las implementaciones específicas de PostgreSQL, migraciones, índices y mecanismos técnicos deberán respetar el modelo conceptual sin convertirlo en dependiente de la infraestructura.

### Documentación

Los siguientes artefactos deberán mantenerse alineados:

```text
business_context
business_rules
glossary
actors
functional_requirements
non_functional_requirements
use_cases
domain_model
er_model
data_dictionary
normalization
ADR
```

El `domain_model` actúa como puente conceptual entre el análisis del negocio y el diseño de persistencia.

---

## Resultado esperado

El sistema contará con un modelo de dominio que:

1. Representa los conceptos principales del negocio.
2. Mantiene independencia conceptual respecto a PostgreSQL.
3. Sirve como base para el modelo entidad-relación.
4. Permite representar las reglas principales del negocio.
5. Diferencia configuración de operación.
6. Considera desde el diseño la necesidad de conservar información histórica.
7. Permite posteriormente implementar auditoría y trazabilidad.
8. Mantiene un lenguaje común entre documentación y sistema.
9. Permite que las decisiones de implementación sean documentadas de forma independiente.
10. Facilita la evolución futura del sistema.

Este enfoque establece que **el modelo de dominio representa cómo funciona el negocio, mientras que el modelo entidad-relación representa cómo se persistirá la información necesaria para soportarlo**.
