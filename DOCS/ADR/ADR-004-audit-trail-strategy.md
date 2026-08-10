# ADR-004 — Audit Trail Strategy

## Estado

Aceptado

## Fecha

2026-08-07

## Contexto

El sistema administra información comercial, operativa y de configuración que puede afectar directamente el funcionamiento del negocio.

Existen datos cuyo cambio debe poder rastrearse posteriormente, especialmente aquellos relacionados con:

* Precios.
* Descuentos.
* Reglas de apartados.
* Configuración general.
* Productos.
* Inventario.
* Usuarios.
* Roles y permisos.
* Servicios y tarifas.
* Proveedores.
* Clientes.
* Información fiscal.
* Operaciones sensibles.

El sistema debe permitir responder preguntas como:

* ¿Quién modificó un descuento?
* ¿Cuándo se modificó?
* ¿Cuál era su valor anterior?
* ¿Cuál es su valor nuevo?
* ¿Quién modificó el precio de un producto?
* ¿Quién cambió una regla de apartado?
* ¿Qué usuario realizó un ajuste de inventario?
* ¿Quién autorizó una operación sensible?
* ¿Qué información tenía un registro antes de ser modificado?

El modelo también debe distinguir entre:

1. **Estado actual**, representado por las entidades operativas o de configuración.
2. **Snapshot histórico**, utilizado para conservar los valores aplicados a una operación.
3. **Auditoría**, utilizada para registrar modificaciones realizadas sobre información relevante.

El snapshot definido en el ADR-003 permite conocer qué valores fueron utilizados por una operación, pero no responde por sí mismo quién modificó una configuración ni cuándo ocurrió dicho cambio.

Por lo tanto, es necesario establecer una estrategia centralizada de auditoría.

---

## Decisión

Se utilizará una entidad centralizada denominada:

```text
audit_record
```

para registrar cambios relevantes realizados dentro del sistema.

Cada registro de auditoría deberá identificar como mínimo:

* Usuario responsable.
* Acción realizada.
* Entidad afectada.
* Registro afectado.
* Valor anterior.
* Valor nuevo.
* Motivo, cuando corresponda.
* Fecha y hora.

La auditoría será complementaria a los snapshots y no los sustituirá.

---

# 1. Modelo de auditoría

La entidad `audit_record` tendrá conceptualmente la siguiente estructura:

| Campo       | Descripción                         |
| ----------- | ----------------------------------- |
| id          | Identificador del registro          |
| user_id     | Usuario que realizó la acción       |
| action      | Acción realizada                    |
| entity_type | Tipo de entidad afectada            |
| entity_id   | Identificador del registro afectado |
| old_value   | Estado anterior                     |
| new_value   | Estado posterior                    |
| reason      | Motivo del cambio                   |
| created_at  | Fecha y hora                        |

Los valores anteriores y posteriores se almacenarán utilizando `JSONB`.

Esto permite registrar diferentes estructuras de datos sin tener que crear una tabla de auditoría específica para cada entidad.

---

# 2. Acciones auditables

El campo `action` deberá permitir identificar el tipo de operación realizada.

Como mínimo se contemplan:

```text
CREATE
UPDATE
DELETE
ACTIVATE
DEACTIVATE
CANCEL
AUTHORIZE
REJECT
ADJUST
```

La lista definitiva podrá evolucionar conforme se implementen nuevos procesos.

Las acciones deberán representar eventos relevantes para la trazabilidad del sistema y no únicamente operaciones técnicas internas.

---

# 3. Entidad afectada

El registro deberá identificar qué tipo de entidad fue modificada mediante:

```text
entity_type
```

Y qué registro concreto mediante:

```text
entity_id
```

Por ejemplo:

```text
entity_type = "discount"
entity_id = 2
```

significa que el descuento con identificador `2` fue afectado.

Este diseño permite centralizar la auditoría sin crear relaciones físicas con todas las entidades auditables.

---

# 4. Valores anteriores y nuevos

Para modificaciones de información, se conservarán ambos estados cuando sea posible.

Ejemplo:

```text
old_value:
{
    "value": 15,
    "active": true
}
```

Después:

```text
new_value:
{
    "value": 18,
    "active": true
}
```

Esto permite conocer exactamente qué cambió.

La estructura JSON no pretende sustituir la estructura relacional de las entidades originales.

Su propósito es conservar una representación histórica del cambio.

---

# 5. Auditoría de creación

Cuando una entidad importante sea creada, podrá registrarse:

```text
action = CREATE
```

En este caso:

```text
old_value = null
```

y:

```text
new_value = { ... }
```

Por ejemplo, al crear un nuevo descuento:

```text
entity_type = "discount"
entity_id = 5
action = "CREATE"
```

El `new_value` contendrá la información relevante con la que fue creado.

---

# 6. Auditoría de actualización

Cuando una entidad sea modificada:

```text
action = UPDATE
```

deberá registrarse el estado anterior y posterior cuando sea posible.

Ejemplo:

```text
old_value:
{
    "value": 15
}
```

```text
new_value:
{
    "value": 18
}
```

Esto permite conocer tanto el cambio como su dirección.

---

# 7. Auditoría de eliminación

La eliminación física de información operativa o histórica estará restringida.

Cuando una entidad permita eliminación lógica, la acción podrá registrarse como:

```text
action = DEACTIVATE
```

o:

```text
action = DELETE
```

según corresponda al comportamiento de la entidad.

La auditoría deberá conservar el estado anterior.

Por ejemplo:

```text
old_value:
{
    "active": true
}
```

```text
new_value:
{
    "active": false
}
```

---

# 8. Auditoría de operaciones sensibles

No todas las acciones auditables son simples modificaciones de atributos.

También deberán registrarse determinadas acciones operativas sensibles.

Entre ellas:

* Cancelación de ventas.
* Devoluciones.
* Ajustes de inventario.
* Ajustes de caja.
* Cancelación de apartados.
* Aplicación de penalizaciones.
* Cambios de configuración.
* Cambios de permisos.
* Activación o desactivación de usuarios.
* Autorizaciones especiales.

En estos casos, `action` podrá representar la operación específica.

Por ejemplo:

```text
action = "CANCEL"
entity_type = "sale"
entity_id = 152
```

---

# 9. Motivo de la acción

Cuando una acción requiera justificación, se utilizará:

```text
reason
```

Ejemplo:

```text
reason = "Diferencia detectada durante inventario físico"
```

No todas las acciones requerirán un motivo.

Sin embargo, aquellas consideradas sensibles deberán exigirlo desde la capa de aplicación.

---

# 10. Usuario responsable

Cada registro de auditoría deberá identificar al usuario que realizó la acción mediante:

```text
user_id
```

Esto permite conocer quién realizó el cambio.

La relación será:

```text
user 1:N audit_record
```

Un usuario puede generar múltiples registros de auditoría.

Cada registro deberá pertenecer a un usuario cuando la acción haya sido realizada por una persona autenticada.

---

# 11. Operaciones automáticas

El sistema puede ejecutar determinadas acciones automáticamente.

Por ejemplo:

* Vencimiento de un apartado.
* Actualización automática de estados.
* Procesamiento de facturación pendiente.
* Generación de movimientos derivados.
* Procesos programados.

En estos casos deberá existir una estrategia consistente para identificar al ejecutor.

Cuando corresponda, podrá utilizarse un usuario técnico o mecanismo equivalente definido durante la implementación.

La implementación concreta deberá evitar atribuir falsamente una acción automática a un usuario humano.

---

# 12. Qué información debe auditarse

Como mínimo, deberán ser auditables las modificaciones importantes realizadas sobre:

## Seguridad

* Usuarios.
* Roles.
* Permisos.
* Asignaciones de roles.

## Catálogo

* Productos.
* Categorías.
* Marcas.
* Servicios.
* Tarifas.

## Configuración comercial

* Descuentos.
* Métodos de pago.
* Configuración de apartados.
* Configuración general.

## Inventario

* Ajustes de inventario.
* Incidencias.
* Cambios relevantes sobre existencias.

## Compras

* Proveedores.
* Compras sensibles.
* Incidencias de compra.

## Clientes

* Información relevante del cliente.
* Información fiscal cuando corresponda.

## Operaciones sensibles

* Cancelaciones.
* Devoluciones.
* Ajustes.
* Autorizaciones.
* Rechazos.

---

# 13. Qué no debe depender exclusivamente de auditoría

La auditoría no debe utilizarse para reconstruir operaciones comerciales completas.

Por ejemplo, una venta debe conservar directamente:

```text
sale
sale_item
payment
ticket
```

La auditoría puede registrar acciones importantes relacionadas con la venta, pero no debe sustituir los registros operativos.

De igual manera:

```text
reservation
reservation_item
reservation_payment
```

deben conservar la operación independientemente de los registros de auditoría.

---

# 14. Relación con snapshots

El sistema utilizará ambos mecanismos.

### Snapshot

Conserva:

> El valor que realmente utilizó una operación.

### Auditoría

Conserva:

> El cambio administrativo u operativo que ocurrió sobre un registro.

Ejemplo:

Un descuento pasa de:

```text
15%
```

a:

```text
18%
```

La auditoría registra:

```text
old_value = 15
new_value = 18
```

Una venta realizada antes del cambio conserva:

```text
discount_value = 15
```

Por lo tanto:

```text
Configuración
     ↓
     18%

Auditoría
     ↓
     15% → 18%

Venta histórica
     ↓
     15%
```

Los tres datos tienen propósitos diferentes.

---

# 15. Inmutabilidad de la auditoría

Los registros de:

```text
audit_record
```

deberán considerarse inmutables.

Una vez registrado un evento:

* No deberá modificarse como parte de la operación normal.
* No deberá eliminarse como parte de la operación normal.
* No deberá reutilizarse para representar otro evento.

Si existe un error en un registro de auditoría, deberá evaluarse un mecanismo explícito de corrección que conserve la trazabilidad del cambio.

La implementación concreta de mecanismos administrativos para corregir registros de auditoría deberá documentarse mediante un ADR adicional si resulta necesaria.

---

# 16. Auditoría y eliminación lógica

La eliminación lógica no sustituye a la auditoría.

Por ejemplo:

Un producto puede pasar de:

```text
active = true
```

a:

```text
active = false
```

El producto conserva su registro.

Además, la auditoría registra:

```text
action = DEACTIVATE
```

con:

```text
old_value:
{
    "active": true
}
```

y:

```text
new_value:
{
    "active": false
}
```

De esta manera pueden conocerse tanto el estado actual como el momento y responsable del cambio.

---

# 17. Auditoría de configuración

Las configuraciones que puedan modificar el comportamiento comercial deberán ser auditables.

Entre ellas:

```text
discount
reservation_configuration
business_configuration
service_rate
```

Por ejemplo:

```text
reservation_configuration.minimum_percentage
```

puede cambiar de:

```text
30
```

a:

```text
40
```

La auditoría deberá conservar:

```text
old_value = 30
new_value = 40
```

Además, los nuevos apartados utilizarán el nuevo valor, mientras que los apartados existentes conservarán su snapshot.

---

# 18. Ejemplo completo

Supongamos:

```text
Descuento estudiante = 15%
```

El usuario:

```text
user_id = 4
```

modifica el descuento.

La configuración pasa a:

```text
18%
```

Se genera:

```text
audit_record
```

con:

```text
user_id = 4
action = UPDATE
entity_type = discount
entity_id = 2

old_value:
{
    "value": 15
}

new_value:
{
    "value": 18
}

reason:
"Actualización del beneficio para estudiantes"
```

Posteriormente, una venta histórica puede mostrar:

```text
sale_item.discount_id = 2
sale_item.discount_value = 15
```

Mientras que una venta nueva puede utilizar:

```text
sale_item.discount_value = 18
```

Esto permite mantener la coherencia entre:

* Configuración actual.
* Historial de cambios.
* Operaciones históricas.

---

# 19. Ejemplo de auditoría de inventario

Supongamos que el sistema indica:

```text
quantity = 50
```

Durante un conteo físico se encuentran:

```text
quantity = 47
```

Un usuario realiza un ajuste.

La operación genera:

```text
inventory_movement
```

y, al tratarse de una acción sensible, también:

```text
audit_record
```

El registro de auditoría puede conservar:

```text
old_value:
{
    "quantity": 50
}
```

```text
new_value:
{
    "quantity": 47
}
```

junto con:

```text
reason:
"Diferencia detectada durante conteo físico"
```

Esto permite conocer:

* Qué cantidad tenía el sistema.
* Qué cantidad se estableció.
* Quién realizó el ajuste.
* Cuándo ocurrió.
* Por qué se realizó.

---

# 20. Auditoría de devoluciones

Las devoluciones deben conservar su propia información operativa:

```text
return
return_item
```

La auditoría complementará esta información registrando acciones sensibles como:

```text
CREATE
AUTHORIZE
CANCEL
```

cuando corresponda.

Esto permite identificar al usuario responsable de una devolución o autorización sin utilizar `audit_record` como sustituto de `return`.

---

# 21. Auditoría de cancelaciones

Las operaciones canceladas no deberán eliminarse.

Por ejemplo:

```text
sale.status = CANCELLED
```

Además, puede registrarse:

```text
audit_record
```

con:

```text
action = CANCEL
entity_type = sale
entity_id = 152
reason = "Error en captura de productos"
```

Esto permite distinguir:

```text
Estado actual:
Venta cancelada
```

de:

```text
Historial:
Usuario X canceló la venta
Motivo: Error en captura
Fecha: ...
```

---

# 22. Auditoría de permisos

Los cambios relacionados con seguridad deberán ser auditables.

Por ejemplo:

```text
user_role
role_permission
```

pueden generar registros cuando:

* Se asigna un rol.
* Se retira un rol.
* Se asigna un permiso.
* Se retira un permiso.
* Se desactiva un usuario.
* Se modifica información crítica de seguridad.

Esto permite conocer quién modificó los privilegios de un usuario.

---

# 23. Consistencia transaccional

Cuando una modificación crítica y su registro de auditoría formen parte de una misma operación, deberán ejecutarse dentro de la misma transacción.

Conceptualmente:

```text
BEGIN TRANSACTION

Modificar entidad

Registrar audit_record

COMMIT
```

Si la modificación falla:

```text
ROLLBACK
```

De esta forma se evita tener:

```text
Cambio realizado
+
Auditoría inexistente
```

o:

```text
Auditoría registrada
+
Cambio no realizado
```

cuando ambas operaciones formen parte del mismo proceso transaccional.

---

# 24. Consultas históricas

La información de auditoría deberá permitir realizar consultas como:

```text
¿Qué cambios realizó un usuario?
```

```text
¿Qué cambios sufrió un descuento?
```

```text
¿Cuándo cambió una configuración?
```

```text
¿Cuál era el valor anterior?
```

```text
¿Quién desactivó un producto?
```

```text
¿Quién realizó un ajuste de inventario?
```

```text
¿Qué configuraciones fueron modificadas durante un periodo determinado?
```

Por ello, deberán evaluarse índices sobre campos utilizados frecuentemente para consultas de auditoría.

Como mínimo:

```text
user_id
entity_type
entity_id
created_at
action
```

La estrategia exacta de índices se definirá durante la implementación de PostgreSQL.

---

# 25. Retención

Los registros de auditoría deberán conservarse durante un periodo definido por las necesidades del negocio y las obligaciones aplicables.

La eliminación automática de registros de auditoría no formará parte del comportamiento inicial.

Si posteriormente se requiere una política de retención, deberá definirse explícitamente mediante una decisión arquitectónica.

---

# 26. Privacidad y datos sensibles

No toda la información de una entidad debe almacenarse necesariamente en `old_value` y `new_value`.

Los datos sensibles deberán evaluarse antes de incorporarlos a los registros de auditoría.

Especialmente:

* Contraseñas.
* Credenciales.
* Tokens.
* Información de autenticación.
* Información sensible innecesaria.

Nunca deberán registrarse contraseñas en texto plano.

La estrategia concreta para anonimización o exclusión de campos sensibles deberá definirse durante la implementación.

---

# 27. Consecuencias

## Ventajas

* Permite conocer quién realizó cambios importantes.
* Permite conocer cuándo ocurrieron.
* Permite conocer el estado anterior y posterior.
* Centraliza la trazabilidad.
* Facilita auditorías internas.
* Facilita investigación de errores.
* Complementa los snapshots históricos.
* Permite investigar modificaciones de configuración.
* Permite rastrear acciones sensibles.
* Mejora la responsabilidad sobre operaciones críticas.
* Facilita futuras capacidades de reportes administrativos.

## Desventajas

* Incrementa el volumen de información almacenada.
* Requiere implementar mecanismos de generación de auditoría.
* Aumenta la complejidad de determinadas operaciones.
* Requiere definir qué acciones deben auditarse.
* Puede almacenar información sensible si no se controla adecuadamente.
* Las consultas históricas pueden requerir índices específicos.
* Se requiere una política clara para proteger los registros de auditoría.

---

# 28. Alternativas consideradas

## 1. No utilizar auditoría

No se adopta.

La ausencia de auditoría dificultaría determinar quién realizó cambios importantes y cuándo ocurrieron.

---

## 2. Crear una tabla de auditoría para cada entidad

No se adopta como estrategia general.

Esto provocaría una gran cantidad de tablas y lógica duplicada.

Por ejemplo:

```text
product_history
discount_history
reservation_configuration_history
user_history
...
```

Aunque existen casos donde una entidad específica podría requerir un historial especializado, la estrategia general será centralizar la auditoría mediante `audit_record`.

---

## 3. Utilizar únicamente logs de aplicación

No se adopta como mecanismo principal.

Los logs son útiles para diagnóstico técnico, pero no constituyen una estructura de auditoría empresarial confiable.

Pueden rotarse, agregarse o perderse y no están diseñados para representar formalmente el historial de una entidad.

---

## 4. Utilizar únicamente snapshots

No se adopta.

Los snapshots indican qué valor utilizó una operación, pero no necesariamente quién cambió la configuración que produjo ese valor.

Por ello se mantiene la combinación:

```text
Snapshot + Auditoría
```

---

# 29. Reglas derivadas

A partir de esta decisión:

1. `audit_record` será la entidad central de auditoría.
2. Los registros de auditoría serán considerados inmutables.
3. Las acciones críticas deberán generar auditoría.
4. Las modificaciones de configuraciones importantes deberán auditarse.
5. Las acciones sensibles deberán identificar al usuario responsable.
6. Las modificaciones y su auditoría deberán ser transaccionalmente consistentes cuando corresponda.
7. La auditoría no sustituirá las entidades operativas.
8. La auditoría no sustituirá los snapshots.
9. Los datos sensibles deberán excluirse o protegerse adecuadamente.
10. Las consultas frecuentes sobre auditoría deberán contar con índices apropiados.
11. Las operaciones automáticas deberán distinguirse de las realizadas por usuarios humanos.
12. Las políticas futuras de retención deberán documentarse explícitamente.

---

# 30. Impacto en la arquitectura

### Dominio

Las operaciones sensibles deberán representar claramente las acciones que requieren trazabilidad.

### Aplicación

Los servicios deberán generar registros de auditoría cuando ejecuten acciones auditables.

### Persistencia

Se deberá implementar:

```text
audit_record
```

y las relaciones correspondientes con `user`.

### Base de datos

Se deberán definir:

* Tabla de auditoría.
* Índices.
* Restricciones.
* Tipos JSONB.
* Foreign key hacia `user`.
* Estrategia de integridad transaccional.

### Seguridad

Los registros de auditoría deberán contar con controles de acceso adecuados.

No todos los usuarios deberán poder consultar información de auditoría.

### Reportes

La información de auditoría podrá utilizarse posteriormente para:

* Reportes administrativos.
* Investigación de incidentes.
* Historial de configuraciones.
* Supervisión de operaciones.
* Auditorías internas.

---

## Referencias

Este ADR se fundamenta en:

* Requerimientos funcionales.
* Requerimientos no funcionales.
* Casos de uso.
* Modelo de dominio.
* Modelo entidad-relación.
* Diccionario de datos.
* Modelo de normalización.

Está directamente relacionado con:

* **ADR-003 — Historical Data and Snapshots**
* **ADR-005 — Logical Deletion Strategy**
* **ADR-007 — Product Discount Model**
* **ADR-008 — Reservation Rules and Snapshots**
* **ADR-009 — Inventory Traceability**
* **ADR-011 — Configurable Business Rules**
