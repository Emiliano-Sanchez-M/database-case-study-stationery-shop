# ADR-008 — Reglas de apartados y snapshots

## Estado

Aceptado

## Fecha

2026-08-08

## Contexto

El sistema debe permitir que la papelería gestione apartados de productos realizados por clientes registrados.

Un apartado representa una operación distinta de una venta inmediata, ya que el cliente puede entregar uno o varios pagos durante un periodo determinado antes de liquidar el total.

Las reglas del apartado deben ser configurables por cada negocio.

Entre ellas se encuentran:

* Porcentaje mínimo requerido para realizar un apartado.
* Número de días disponibles para liquidarlo.
* Porcentaje que se conserva cuando el cliente cancela dentro del plazo.
* Porcentaje que se conserva cuando el apartado vence.
* Monto que debe devolverse al cliente cuando corresponda.

Los porcentajes utilizados en los ejemplos de negocio no deben considerarse valores fijos del sistema.

Por ejemplo, una papelería podría establecer:

```text
Anticipo mínimo: 30%
Cancelación dentro del plazo: 15%
Retención por vencimiento: 30%
Plazo: 7 días
```

Mientras que otra podría establecer:

```text
Anticipo mínimo: 40%
Cancelación dentro del plazo: 5%
Retención por vencimiento: 25%
Plazo: 10 días
```

Por lo tanto, estas reglas no deben estar hard-coded.

Además, las reglas pueden cambiar con el tiempo.

Por ejemplo:

```text
Configuración anterior:

Anticipo mínimo: 30%
Cancelación: 15%
Vencimiento: 30%
```

Posteriormente:

```text
Anticipo mínimo: 40%
Cancelación: 10%
Vencimiento: 25%
```

El cambio debe afectar a los nuevos apartados, pero no debe modificar retrospectivamente los apartados creados bajo las reglas anteriores.

Por esta razón, no es suficiente consultar `reservation_configuration` al momento de liquidar o cancelar un apartado histórico.

El apartado debe conservar un snapshot de las reglas que fueron aplicadas cuando se creó.

---

## Decisión

Se establece que las reglas de apartados estarán representadas mediante una configuración independiente:

```text
reservation_configuration
```

y que cada apartado conservará un snapshot de las reglas aplicadas:

```text
reservation
```

La arquitectura utilizará:

```text
reservation_configuration
        ↓
Configuración actual

reservation
        ↓
Snapshot de las reglas utilizadas

audit_record
        ↓
Historial de cambios de configuración
```

---

# 1. Configuración de apartados

La entidad:

```text
reservation_configuration
```

representará las reglas actualmente vigentes para la creación de nuevos apartados.

Contendrá, como mínimo:

```text
minimum_percentage
expiration_days
cancellation_retention_percentage
expiration_retention_percentage
active
created_at
updated_at
```

Ejemplo:

```text
minimum_percentage = 30
expiration_days = 7
cancellation_retention_percentage = 15
expiration_retention_percentage = 30
```

Estos valores son configurables.

---

# 2. Creación de un apartado

Para crear un apartado, el cliente debe estar registrado.

Por lo tanto:

```text
reservation.customer_id
```

es obligatorio.

Al momento de crear el apartado, el sistema consultará la configuración vigente.

Por ejemplo:

```text
Configuración actual:

minimum_percentage = 30
expiration_days = 7
cancellation_retention_percentage = 15
expiration_retention_percentage = 30
```

Si el apartado tiene un valor total de:

```text
$100
```

el sistema determinará que el anticipo mínimo requerido es:

```text
$30
```

El cliente puede realizar posteriormente pagos adicionales.

---

# 3. Pagos múltiples

Un apartado puede recibir múltiples pagos.

La relación será:

```text
reservation 1:N reservation_payment
```

Por ejemplo:

```text
Apartado:
$100

Primer pago:
$30

Segundo pago:
$20

Tercer pago:
$50
```

El apartado deberá conservar:

```text
total
paid_amount
due_amount
```

permitiendo conocer en todo momento el estado financiero de la operación.

---

# 4. Snapshot de las reglas

Cuando se crea un apartado, el sistema copiará las reglas vigentes dentro de la entidad `reservation`.

Se conservarán:

```text
minimum_percentage_applied
cancellation_retention_percentage_applied
expiration_retention_percentage_applied
```

Además, se conservará:

```text
expires_at
```

para representar la fecha concreta de vencimiento calculada al momento de crear el apartado.

Esto es importante porque el plazo configurado puede cambiar posteriormente.

---

# 5. Ejemplo de snapshot

Supongamos que la configuración actual es:

```text
minimum_percentage = 30
expiration_days = 7
cancellation_retention_percentage = 15
expiration_retention_percentage = 30
```

Se crea un apartado por:

```text
$100
```

El apartado almacena:

```text
minimum_percentage_applied = 30
cancellation_retention_percentage_applied = 15
expiration_retention_percentage_applied = 30
```

y una fecha:

```text
expires_at = fecha de creación + 7 días
```

Posteriormente la administración modifica la configuración a:

```text
minimum_percentage = 40
expiration_days = 10
cancellation_retention_percentage = 5
expiration_retention_percentage = 25
```

El apartado anterior continúa utilizando:

```text
30%
15%
30%
7 días
```

Los nuevos apartados utilizarán:

```text
40%
5%
25%
10 días
```

---

# 6. Cancelación dentro del plazo

Si el cliente cancela el apartado antes de que expire, se aplicará:

```text
cancellation_retention_percentage_applied
```

sobre el total del apartado, de acuerdo con la regla configurada.

Ejemplo:

```text
Total: $100
Pagado: $50
Retención por cancelación: 15%
```

La papelería conserva:

```text
$15
```

y el cliente recibe:

```text
$35
```

El hecho de haber pagado más del anticipo mínimo no modifica la base de cálculo de la retención.

La retención se calcula sobre el total del apartado.

---

# 7. Vencimiento del apartado

Si el cliente no liquida el apartado dentro del plazo establecido, se aplicará:

```text
expiration_retention_percentage_applied
```

sobre el total del apartado.

Ejemplo:

```text
Total: $100
Pagado: $50
Retención por vencimiento: 30%
```

La papelería conserva:

```text
$30
```

y el cliente podrá recuperar:

```text
$20
```

cuando corresponda de acuerdo con las reglas del negocio.

Si el cliente hubiera pagado únicamente:

```text
$30
```

la papelería conservaría:

```text
$30
```

y no existiría un monto adicional que devolver.

---

# 8. Cancelación dentro del plazo vs. vencimiento

El sistema deberá distinguir ambos escenarios.

### Cancelación voluntaria

El cliente solicita cancelar el apartado antes de su vencimiento.

Se utiliza:

```text
cancellation_retention_percentage_applied
```

### Vencimiento

El plazo termina sin que el cliente haya liquidado.

Se utiliza:

```text
expiration_retention_percentage_applied
```

Esto permite que el negocio tenga reglas diferentes para ambos escenarios.

---

# 9. Liquidación dentro del plazo

Si el cliente regresa dentro del plazo y liquida el apartado:

```text
paid_amount = total
```

no se aplica ninguna penalización.

El apartado pasa a un estado de completado.

Por ejemplo:

```text
Total: $100
Primer pago: $30
Segundo pago: $70
```

Resultado:

```text
Total pagado: $100
Penalización: $0
```

---

# 10. Productos apartados

Los productos incluidos en el apartado estarán representados mediante:

```text
reservation_item
```

Cada detalle conservará:

```text
product_id
quantity
unit_price
subtotal
```

El `unit_price` representa el precio utilizado al crear el apartado.

Por lo tanto, si posteriormente el precio del producto cambia, el apartado no deberá cambiar de precio automáticamente.

Ejemplo:

```text
Precio al apartar:
$100

Precio actual:
$120

Precio del apartado:
$100
```

---

# 11. Reserva de inventario

Los productos apartados deberán reflejarse en el inventario mediante:

```text
inventory.reserved_quantity
```

La existencia disponible conceptualmente será:

```text
quantity - reserved_quantity
```

Esto evita que el sistema venda como disponible una cantidad que ya se encuentra comprometida mediante apartados.

Los movimientos correspondientes deberán conservarse mediante:

```text
inventory_movement
```

---

# 12. Configuración histórica

Los cambios realizados sobre `reservation_configuration` deberán registrarse mediante:

```text
audit_record
```

La auditoría deberá permitir conocer:

* Quién modificó la configuración.
* Cuándo ocurrió.
* Qué valor tenía antes.
* Qué valor tiene después.
* Qué motivo tuvo el cambio, cuando corresponda.

Ejemplo:

```text
old_value:

{
    "minimum_percentage": 30,
    "expiration_days": 7,
    "cancellation_retention_percentage": 15,
    "expiration_retention_percentage": 30
}
```

Nuevo valor:

```text
{
    "minimum_percentage": 40,
    "expiration_days": 10,
    "cancellation_retention_percentage": 5,
    "expiration_retention_percentage": 25
}
```

---

# 13. Independencia histórica

El sistema no deberá consultar la configuración actual para determinar las reglas de un apartado histórico.

Incorrecto:

```text
reservation
      ↓
reservation_configuration actual
```

Correcto:

```text
reservation
      ↓
reglas aplicadas al momento de creación
```

La configuración actual únicamente se utiliza para nuevos apartados.

---

# 14. Identificación de la configuración utilizada

Inicialmente, el sistema no requiere que cada apartado mantenga una relación directa con una versión de `reservation_configuration`.

En su lugar, el apartado conservará directamente los valores aplicados.

Esto evita que un cambio posterior en la configuración altere el significado histórico del apartado.

La combinación será:

```text
reservation_configuration
        ↓
Regla vigente al momento de crear

reservation
        ↓
Snapshot de los valores utilizados

audit_record
        ↓
Historial de cambios de configuración
```

---

# 15. Plazo de vencimiento

El plazo no se conservará únicamente como número de días.

Además de:

```text
expiration_days
```

en la configuración, el apartado conservará:

```text
expires_at
```

Esto permite conocer exactamente cuándo vencía un apartado determinado.

Por ejemplo:

```text
Creación:
2026-08-11 10:00

Configuración:
7 días

Vencimiento:
2026-08-18 10:00
```

Si posteriormente el negocio cambia el plazo a 10 días, el apartado anterior continuará venciendo en la fecha originalmente calculada.

---

# 16. Estados del apartado

El apartado deberá manejar un estado que permita representar su ciclo de vida.

Como mínimo se contemplan estados conceptuales como:

```text
ACTIVE
COMPLETED
CANCELLED
EXPIRED
```

La implementación podrá agregar estados adicionales si posteriormente son necesarios.

---

# 17. Cancelación y devolución

Cuando el apartado sea cancelado y corresponda devolver dinero al cliente, el sistema deberá registrar la operación de devolución de manera trazable.

La devolución deberá conservar:

* Apartado relacionado.
* Monto retenido.
* Monto devuelto.
* Usuario responsable.
* Fecha.
* Motivo.
* Estado de la operación.

La operación no deberá eliminar los pagos originales del apartado.

---

# 18. Cambios posteriores en las reglas

Una modificación de:

```text
minimum_percentage
expiration_days
cancellation_retention_percentage
expiration_retention_percentage
```

afecta únicamente a apartados creados posteriormente.

No deberá modificar:

* Apartados activos existentes.
* Apartados completados.
* Apartados cancelados.
* Apartados vencidos.

Cada apartado conserva sus propias reglas aplicadas.

---

# 19. Consecuencias

## Ventajas

* Las reglas de apartados son configurables.
* El negocio puede definir diferentes porcentajes.
* Los valores no están hard-coded.
* Los apartados históricos permanecen consistentes.
* Los cambios futuros no alteran operaciones anteriores.
* Se conserva la fecha exacta de vencimiento.
* Se permiten múltiples pagos.
* Se pueden distinguir cancelaciones de vencimientos.
* Se pueden realizar cálculos de penalización de manera determinista.
* Los cambios administrativos pueden auditarse.
* El modelo permite adaptar las reglas a diferentes negocios.
* Los precios históricos de los productos apartados se conservan.
* El inventario puede distinguir existencia disponible de existencia reservada.

## Desventajas

* Se duplican algunos valores de configuración dentro de `reservation`.
* La lógica de creación del apartado debe generar correctamente el snapshot.
* Los cambios de configuración requieren auditoría.
* Se necesita lógica adicional para controlar vencimientos.
* La cancelación y el vencimiento requieren cálculos diferentes.
* La gestión de inventario reservado añade complejidad.

---

# 20. Alternativas consideradas

## 1. Consultar siempre la configuración actual

Se consideró que `reservation` no almacenara los porcentajes utilizados y que el sistema consultara:

```text
reservation_configuration
```

cada vez que necesitara calcular una penalización.

Se descartó porque permitiría que una modificación administrativa cambiara retroactivamente las reglas de un apartado existente.

---

## 2. Guardar únicamente el número de días

Se consideró almacenar solamente:

```text
expiration_days
```

y calcular el vencimiento posteriormente.

Se descartó porque el plazo podría cambiar y porque la fecha exacta de vencimiento debe quedar determinada desde la creación del apartado.

Por ello se conserva:

```text
expires_at
```

---

## 3. Crear una versión de configuración por cada apartado

Se consideró crear una entidad como:

```text
reservation_configuration_version
```

y relacionar cada apartado con una versión.

Aunque este modelo permitiría un versionado explícito, se decidió inicialmente conservar directamente los valores aplicados en `reservation`.

La auditoría mantiene el historial de modificaciones administrativas.

Si posteriormente se requiere consultar las configuraciones como versiones formales independientes, podrá revisarse esta decisión mediante un nuevo ADR.

---

## 4. Aplicar siempre la misma penalización

Se descartó utilizar una única regla de penalización para cualquier cancelación.

El negocio requiere distinguir:

```text
Cancelación dentro del plazo
```

de:

```text
Vencimiento
```

Por ello se mantienen:

```text
cancellation_retention_percentage
expiration_retention_percentage
```

como reglas independientes.

---

## 5. Establecer porcentajes fijos en el sistema

Se descartó establecer permanentemente valores como:

```text
30% anticipo
15% cancelación
30% vencimiento
7 días
```

porque estos valores son ejemplos de una configuración posible y no reglas universales del sistema.

Los valores deben ser configurables.

---

## Impacto en la arquitectura

### Dominio

Se definen principalmente:

```text
Reservation
ReservationItem
ReservationPayment
ReservationConfiguration
```

junto con las reglas relacionadas con:

* Creación.
* Pagos.
* Liquidación.
* Cancelación.
* Vencimiento.
* Retenciones.
* Devoluciones.

### Persistencia

Se requieren principalmente:

```text
reservation
reservation_item
reservation_payment
reservation_configuration
```

además de las entidades relacionadas con clientes, productos, inventario y auditoría.

### Aplicación

Los casos de uso deberán coordinar:

```text
Crear apartado
    ↓
Validar cliente
    ↓
Consultar configuración vigente
    ↓
Validar anticipo mínimo
    ↓
Guardar snapshot
    ↓
Reservar inventario
    ↓
Registrar pago
```

Y posteriormente:

```text
Liquidar apartado
Cancelar apartado
Procesar apartado vencido
Registrar pago adicional
Consultar apartado
```

### Inventario

La creación y modificación de un apartado afecta:

```text
inventory.reserved_quantity
```

y deberá generar la trazabilidad correspondiente en:

```text
inventory_movement
```

### Auditoría

Los cambios administrativos sobre `reservation_configuration` deberán registrarse en:

```text
audit_record
```

permitiendo conocer la evolución de las reglas.

### Base de datos

Se deberán establecer restricciones para evitar configuraciones inválidas, incluyendo:

```text
minimum_percentage >= 0
minimum_percentage <= 100

cancellation_retention_percentage >= 0
cancellation_retention_percentage <= 100

expiration_retention_percentage >= 0
expiration_retention_percentage <= 100

expiration_days > 0
```

Además, el modelo deberá garantizar que los valores snapshot almacenados en `reservation` representen las reglas realmente aplicadas a esa operación.

### Historial

La estrategia definitiva queda establecida como:

```text
Configuración actual
        ↓
reservation_configuration

Reglas aplicadas
        ↓
reservation

Historial de modificaciones
        ↓
audit_record
```

De esta manera, una modificación futura de las reglas nunca altera retrospectivamente el significado de un apartado ya creado.
