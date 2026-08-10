# ADR-011: Configuración de reglas de negocio

## Estado

Aceptado

## Fecha

2026-08-09

## Contexto

El sistema debe permitir que determinadas reglas de negocio puedan ser modificadas por la papelería sin necesidad de modificar el código fuente de la aplicación.

Durante el análisis de requisitos, casos de uso, modelo de dominio y modelo entidad-relación se identificaron diversas reglas cuyo comportamiento puede variar dependiendo de las necesidades de cada negocio.

Entre ellas se encuentran:

* Porcentaje mínimo requerido para realizar un apartado.
* Días disponibles para liquidar un apartado.
* Porcentaje retenido cuando un apartado es cancelado antes de su vencimiento.
* Porcentaje retenido cuando un apartado vence.
* Nivel de alerta de inventario.
* Tarifas de servicios.
* Descuentos.
* Métodos de pago disponibles.
* Configuraciones generales del negocio.

Estas reglas no deben estar definidas directamente dentro del código fuente mediante valores constantes que requieran una nueva versión del sistema para modificarse.

Además, algunas reglas pueden cambiar con el tiempo, por lo que el sistema debe diferenciar entre:

1. La configuración actualmente vigente.
2. La configuración que fue utilizada por una operación histórica.
3. Los cambios realizados sobre dicha configuración.

Por ejemplo, una papelería podría establecer inicialmente:

```text
Anticipo mínimo: 30%
Plazo: 7 días
Retención por cancelación: 15%
Retención por vencimiento: 30%
```

Posteriormente podría modificar estas reglas a:

```text
Anticipo mínimo: 40%
Plazo: 10 días
Retención por cancelación: 10%
Retención por vencimiento: 25%
```

El cambio no debe modificar retroactivamente los apartados creados bajo las reglas anteriores.

Por lo tanto, se requiere una estrategia que permita configurar las reglas actuales y, al mismo tiempo, conservar las reglas que fueron utilizadas por operaciones anteriores.

---

## Decisión

Las reglas de negocio configurables se almacenarán como datos persistentes y no como valores hard-coded dentro de la lógica de negocio.

El sistema distinguirá entre **configuración vigente**, **snapshot de operación** y **auditoría**.

### 1. Configuración vigente

Las reglas actualmente configurables se almacenarán en entidades específicas.

Por ejemplo:

```text
reservation_configuration
```

almacenará las reglas actuales relacionadas con los apartados.

De manera similar, otras configuraciones tendrán sus propias entidades cuando requieran estructura, relaciones o comportamiento específico.

Para configuraciones generales que no requieran una estructura relacional específica se utilizará:

```text
business_configuration
```

Esta entidad almacenará valores mediante:

```text
key
value
data_type
description
updated_by
updated_at
```

No obstante, `business_configuration` no sustituirá entidades específicas cuando una configuración requiera relaciones, validaciones o estructura propia.

---

### 2. Las operaciones conservarán las reglas aplicadas

Cuando una operación dependa de una configuración que pueda cambiar posteriormente, se almacenarán los valores utilizados en el momento de crear o ejecutar la operación.

Por ejemplo, un apartado conservará:

```text
minimum_percentage_applied
cancellation_retention_percentage_applied
expiration_retention_percentage_applied
```

Esto permite que un apartado creado cuando la configuración era:

```text
30% mínimo
15% de retención por cancelación
30% de retención por vencimiento
```

continúe utilizando esos valores aunque posteriormente la configuración cambie.

---

### 3. Los cambios de configuración serán auditables

Las modificaciones relevantes sobre configuraciones deberán registrarse mediante:

```text
audit_record
```

La auditoría permitirá conocer:

* Usuario que realizó el cambio.
* Entidad modificada.
* Registro afectado.
* Fecha y hora.
* Valor anterior.
* Valor nuevo.
* Motivo del cambio, cuando corresponda.

Por ejemplo:

```text
entity_type = reservation_configuration

old_value:
{
    "minimum_percentage": 30,
    "expiration_days": 7
}

new_value:
{
    "minimum_percentage": 40,
    "expiration_days": 10
}
```

De esta manera, el sistema puede distinguir entre la configuración actual y las configuraciones que fueron utilizadas históricamente.

---

### 4. Las reglas deben ser validadas

Que una regla sea configurable no significa que pueda aceptar cualquier valor.

Las configuraciones deberán cumplir las restricciones correspondientes.

Por ejemplo:

```text
minimum_percentage >= 0
minimum_percentage <= 100
```

De igual forma, las reglas relacionadas con porcentajes, cantidades, días, precios y demás valores configurables deberán contar con validaciones apropiadas.

Las restricciones críticas deberán reforzarse también a nivel de persistencia cuando sea posible.

---

### 5. La configuración no debe contener lógica de negocio ejecutable

El sistema almacenará **datos de configuración**, no código ejecutable.

Por ejemplo, es válido almacenar:

```text
expiration_days = 7
```

o:

```text
cancellation_retention_percentage = 15
```

pero no se almacenarán expresiones o fragmentos de código para determinar el comportamiento del sistema.

La lógica que interpreta estas configuraciones permanecerá implementada en la aplicación.

---

## Consecuencias

### Ventajas

* Las reglas de negocio pueden modificarse sin recompilar la aplicación.
* Cada negocio puede adaptar determinadas reglas a sus necesidades.
* Se evita hard-codear valores que pueden cambiar.
* Las operaciones históricas pueden conservar las reglas con las que fueron creadas.
* Se facilita la auditoría de modificaciones.
* Se reduce el riesgo de alterar información histórica al modificar configuraciones actuales.
* Se facilita la evolución futura del sistema.
* Se mantiene una separación clara entre configuración y lógica de negocio.
* Las configuraciones pueden administrarse mediante permisos adecuados.
* Se facilita la incorporación futura de nuevas reglas configurables.

### Desventajas

* El modelo de datos aumenta en complejidad.
* Es necesario implementar validaciones adicionales.
* Las operaciones deben almacenar snapshots cuando dependan de configuraciones modificables.
* Se requiere un mecanismo de auditoría.
* La administración de configuraciones debe contar con controles de acceso apropiados.
* Cambiar una configuración puede tener consecuencias importantes sobre operaciones futuras, por lo que debe controlarse adecuadamente.

---

## Alternativas consideradas

### 1. Hard-codear las reglas en el código

No se seleccionó.

Ejemplo:

```java
private static final BigDecimal MINIMUM_RESERVATION_PERCENTAGE = 30;
```

Esta alternativa obliga a modificar, probar y desplegar una nueva versión del sistema cada vez que una regla cambia.

Además, dificulta la personalización para diferentes negocios.

---

### 2. Almacenar todas las configuraciones en una única tabla genérica

No se seleccionó como estrategia principal.

Una tabla genérica puede resultar útil para configuraciones simples, pero puede dificultar:

* Integridad referencial.
* Validaciones.
* Relaciones.
* Consultas.
* Mantenimiento.
* Evolución del modelo.

Por esta razón, `business_configuration` se utilizará únicamente para configuraciones generales que no requieran una estructura específica.

---

### 3. Mantener únicamente el valor actual

No se seleccionó.

Si solamente se conserva la configuración actual, no sería posible reconstruir correctamente las condiciones bajo las cuales se realizaron determinadas operaciones.

Por ejemplo, si un descuento pasó de 15% a 18%, una venta histórica podría perder la información del porcentaje que realmente recibió si dependiera exclusivamente de la configuración actual.

---

### 4. Crear una nueva versión de toda la configuración cada vez que cambie

No se seleccionó como mecanismo principal.

Aunque el versionado completo podría resolver algunos problemas históricos, introduciría complejidad innecesaria para configuraciones que solamente requieren conocer:

* El valor actual.
* El valor utilizado por la operación.
* Los cambios realizados.

La combinación de configuración actual, snapshots y auditoría proporciona una solución más adecuada para las necesidades actuales del sistema.

---

## Impacto en la arquitectura

Esta decisión afecta principalmente las siguientes capas y componentes:

### Dominio

Las reglas de negocio deberán representar correctamente el comportamiento configurable sin asumir valores fijos.

### Aplicación

Los casos de uso relacionados con:

* Configuración.
* Ventas.
* Descuentos.
* Apartados.
* Inventario.
* Servicios.

deberán obtener y utilizar las configuraciones correspondientes.

### Persistencia

Se requieren entidades y tablas para almacenar:

```text
reservation_configuration
business_configuration
discount
service_rate
```

así como los snapshots correspondientes dentro de las operaciones.

### Auditoría

Los cambios relevantes deberán generar registros en:

```text
audit_record
```

### Seguridad

El acceso a determinadas configuraciones deberá estar restringido mediante el sistema de roles y permisos.

### Base de datos

Será necesario implementar:

* Constraints.
* Foreign keys.
* Validaciones.
* Índices.
* Persistencia de configuraciones.
* Conservación de snapshots.
* Persistencia de registros de auditoría.

### Evolución futura

La estrategia permite incorporar nuevas reglas configurables sin convertir necesariamente cada regla en un valor hard-coded dentro de la aplicación.

Sin embargo, cada nueva configuración deberá evaluarse individualmente para determinar si corresponde a:

1. Una entidad de configuración específica.
2. `business_configuration`.
3. Un snapshot dentro de una operación.
4. Un dato que además requiere auditoría.

---

## Relación con otros ADR

Este ADR se relaciona directamente con:

* **ADR-003: Historical Data and Snapshots** — define cómo conservar los valores utilizados por operaciones históricas.
* **ADR-004: Audit Trail Strategy** — define cómo registrar modificaciones relevantes.
* **ADR-007: Product Discount Model** — utiliza configuración y snapshots para descuentos.
* **ADR-008: Reservation Rules and Snapshots** — utiliza reglas configurables y snapshots para apartados.
* **ADR-009: Inventory Traceability** — contempla configuraciones relacionadas con inventario.
* **ADR-012: Future Multi-Branch Support** — deberá considerar cómo evolucionarán las configuraciones si el sistema incorpora múltiples sucursales.

---

## Resultado esperado

El sistema deberá permitir modificar reglas configurables sin alterar operaciones históricas.

Por ejemplo:

```text
Configuración actual
        │
        ▼
reservation_configuration
        │
        ├── Apartado A
        │     └── snapshot: 30%
        │
        └── Apartado B
              └── snapshot: 40%
```

Mientras que los cambios administrativos quedarán registrados mediante:

```text
audit_record
```

De esta manera, la configuración actual, el comportamiento histórico y la trazabilidad administrativa permanecen correctamente separados.
