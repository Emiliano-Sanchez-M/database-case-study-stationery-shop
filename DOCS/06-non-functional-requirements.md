# Non-Functional Requirements

## Propósito

Definir las características de calidad, restricciones y condiciones bajo las cuales deberá operar el sistema para garantizar que sea confiable, seguro, mantenible, escalable y adecuado para las necesidades operativas del negocio.

Los requerimientos no funcionales describen cómo deberá comportarse el sistema y las condiciones que deberá cumplir, sin establecer una tecnología específica para su implementación.

---

# Prioridades críticas

Las siguientes características son consideradas críticas para la operación del negocio y deberán recibir prioridad durante el diseño, implementación y pruebas del sistema:

1. Las ventas no deberán perderse.
2. El inventario deberá mantenerse confiable y consistente.
3. Los ingresos y egresos deberán registrarse de forma confiable.
4. Las operaciones relevantes deberán mantener trazabilidad sobre el usuario que las realizó.

---

# Disponibilidad

### NFR-DIS-001 - Horario de operación

El sistema deberá estar disponible durante el horario habitual de operación del negocio, establecido actualmente de **06:30 a 22:30 horas**.

---

### NFR-DIS-002 - Disponibilidad durante la jornada

El sistema deberá mantener una alta disponibilidad durante el horario de operación, debido a que las ventas, consultas de precios y consultas de existencias dependen de su funcionamiento.

---

### NFR-DIS-003 - Mantenimiento programado

El sistema podrá permanecer temporalmente fuera de servicio durante períodos de mantenimiento programado.

Los mantenimientos deberán realizarse preferentemente fuera del horario habitual de operación.

---

### NFR-DIS-004 - Continuidad operativa

Una interrupción temporal de la conexión a Internet no deberá impedir la continuidad de las operaciones esenciales del negocio.

---

### NFR-DIS-005 - Recuperación ante interrupciones

Ante una interrupción inesperada, el sistema deberá conservar las operaciones confirmadas hasta el último estado consistente disponible.

---

# Operación Offline

### NFR-OFF-001 - Operación sin conexión

El sistema deberá permitir continuar con las operaciones esenciales cuando no exista conexión con los servicios remotos.

Como mínimo, deberán poder realizarse sin conexión las operaciones necesarias para continuar con la atención habitual de los clientes.

---

### NFR-OFF-002 - Registro local

Las operaciones realizadas durante un período sin conexión deberán almacenarse localmente hasta que puedan ser sincronizadas.

---

### NFR-OFF-003 - Persistencia de operaciones offline

Las operaciones almacenadas localmente deberán conservar toda la información necesaria para ser procesadas posteriormente sin perder datos relevantes de la operación original.

---

### NFR-OFF-004 - Sincronización automática

Cuando se restablezca la conexión, el sistema deberá sincronizar automáticamente las operaciones pendientes con el sistema central.

---

### NFR-OFF-005 - Prevención de duplicados

El mecanismo de sincronización deberá evitar que una misma operación sea registrada más de una vez como consecuencia de reintentos, interrupciones o errores de comunicación.

---

### NFR-OFF-006 - Integridad de sincronización

Las operaciones sincronizadas deberán conservar su fecha, hora, usuario responsable, productos, cantidades, precios, forma de pago y demás información relevante registrada originalmente.

---

### NFR-OFF-007 - Gestión de conflictos

El sistema deberá detectar y manejar los conflictos que puedan producirse cuando existan modificaciones realizadas localmente mientras el sistema se encontraba sin conexión.

---

# Rendimiento

### NFR-PER-001 - Registro de ventas

El registro de una venta deberá proporcionar confirmación al usuario en un tiempo objetivo de **1 a 3 segundos** bajo condiciones normales de operación.

---

### NFR-PER-002 - Registro de clientes

El registro de clientes deberá completarse rápidamente para no interrumpir el flujo normal de atención.

---

### NFR-PER-003 - Consulta de productos

La búsqueda de productos deberá proporcionar una respuesta prácticamente inmediata durante la operación habitual.

---

### NFR-PER-004 - Consulta de existencias

La consulta de existencias deberá proporcionar una respuesta rápida y mostrar el estado conocido del inventario.

---

### NFR-PER-005 - Operaciones críticas

Las operaciones de registro de clientes, registro de ventas y consulta de existencias deberán recibir prioridad de rendimiento.

---

### NFR-PER-006 - Capacidad operativa

El sistema deberá soportar aproximadamente **600 ventas diarias** y al menos **5 usuarios concurrentes** sin degradaciones significativas en las operaciones habituales.

---

### NFR-PER-007 - Crecimiento del rendimiento

El rendimiento de las operaciones habituales deberá mantenerse adecuado conforme aumente el volumen de productos, clientes y operaciones históricas.

---

# Escalabilidad

### NFR-ESC-001 - Crecimiento del catálogo

El sistema deberá soportar el crecimiento del catálogo desde el volumen actual aproximado de **5,000 productos**.

---

### NFR-ESC-002 - Crecimiento de clientes

El sistema deberá permitir el crecimiento progresivo del número de clientes registrados sin establecer límites artificiales que impidan la operación normal.

---

### NFR-ESC-003 - Crecimiento de operaciones

El sistema deberá soportar el crecimiento progresivo de ventas, compras, movimientos de inventario, pagos, apartados y demás información histórica.

---

### NFR-ESC-004 - Crecimiento de usuarios

El sistema deberá permitir incorporar nuevos usuarios y empleados conforme aumente el tamaño del negocio.

---

### NFR-ESC-005 - Expansión a sucursales

Aunque inicialmente el sistema operará para una sola sucursal, su diseño deberá permitir incorporar múltiples sucursales en el futuro sin requerir una reestructuración completa de la solución.

---

# Integridad y consistencia de datos

### NFR-DAT-001 - Integridad de operaciones

Las operaciones que involucren múltiples modificaciones relacionadas deberán ejecutarse de forma íntegra.

Si una operación no puede completarse correctamente, no deberá quedar almacenada en un estado parcialmente aplicado.

---

### NFR-DAT-002 - Integridad referencial

El sistema deberá impedir que existan relaciones entre registros que hagan referencia a entidades inexistentes.

---

### NFR-DAT-003 - Integridad de ventas

Una venta confirmada deberá conservar toda la información necesaria para reconstruir la operación, incluyendo productos o servicios, cantidades, precios, forma de pago, fecha, hora y usuario responsable.

---

### NFR-DAT-004 - Consistencia del inventario

Las existencias deberán mantenerse consistentes con los movimientos de inventario que las originaron.

---

### NFR-DAT-005 - Integridad de ingresos y egresos

Los ingresos y egresos registrados deberán conservar información suficiente para determinar su origen, importe, fecha, forma de pago y usuario responsable cuando corresponda.

---

### NFR-DAT-006 - Persistencia

Una operación confirmada deberá permanecer almacenada incluso después de cerrar la aplicación, reiniciar el sistema o experimentar una interrupción normal de los servicios.

---

### NFR-DAT-007 - Consistencia histórica

Las modificaciones realizadas sobre información actual no deberán alterar los datos históricos necesarios para reconstruir operaciones anteriores.

---

# Seguridad

### NFR-SEC-001 - Autenticación

Los usuarios internos deberán autenticarse antes de acceder a las funcionalidades administrativas del sistema.

---

### NFR-SEC-002 - Identidad de usuario

Cada empleado deberá contar con una identidad que permita asociar sus operaciones con su usuario.

Las cuentas compartidas no deberán utilizarse cuando impidan identificar al responsable de una operación.

---

### NFR-SEC-003 - Autorización

El sistema deberá restringir las funcionalidades de acuerdo con los permisos y responsabilidades asignados a cada usuario.

---

### NFR-SEC-004 - Separación de responsabilidades

El sistema deberá permitir restringir operaciones sensibles a los usuarios autorizados.

Entre estas operaciones se encuentran, como mínimo:

* Modificación de precios.
* Administración de información sensible.
* Configuración del sistema.
* Operaciones administrativas.
* Gestión de información financiera.

---

### NFR-SEC-005 - Protección de credenciales

Las credenciales de acceso no deberán almacenarse en texto plano.

---

### NFR-SEC-006 - Desactivación de usuarios

Los usuarios de empleados que dejen de trabajar en el negocio deberán poder ser desactivados sin eliminar su historial de operaciones.

---

### NFR-SEC-007 - Reactivación de usuarios

Un usuario previamente desactivado deberá poder ser reactivado cuando vuelva a trabajar en el negocio, conservando su historial anterior.

---

### NFR-SEC-008 - Protección de información sensible

El sistema deberá restringir el acceso a información sensible, incluyendo:

* Datos fiscales de clientes.
* Información de ingresos.
* Información de egresos.
* Información financiera.
* Información administrativa.
* Información operativa sensible.

---

# Auditoría y trazabilidad

### NFR-AUD-001 - Identificación del usuario

Las operaciones relevantes deberán conservar información que permita identificar al usuario que las realizó.

---

### NFR-AUD-002 - Fecha y hora

Las operaciones relevantes deberán registrar la fecha y hora en que fueron realizadas.

---

### NFR-AUD-003 - Registro de modificaciones

Las modificaciones relevantes sobre información crítica deberán conservar información suficiente para conocer:

* Valor anterior.
* Nuevo valor.
* Usuario responsable.
* Fecha y hora de modificación.

---

### NFR-AUD-004 - Historial de inventario

Los movimientos de inventario deberán conservarse como historial para permitir reconstruir la evolución de las existencias.

---

### NFR-AUD-005 - Historial de precios

Los cambios de precios deberán conservar su historial para permitir identificar qué precio estaba vigente durante una operación determinada.

---

### NFR-AUD-006 - Historial de operaciones

Las operaciones relevantes deberán conservarse como historial para permitir su consulta y auditoría posterior.

---

### NFR-AUD-007 - Trazabilidad

El sistema deberá permitir relacionar las operaciones relevantes con el usuario, fecha, hora y entidades afectadas.

---

# Eliminación y recuperación de información

### NFR-DEL-001 - Conservación de operaciones

Las ventas, pagos, movimientos de inventario, cortes de caja y demás operaciones relevantes no deberán eliminarse físicamente cuando dicha eliminación implique pérdida de trazabilidad.

---

### NFR-DEL-002 - Eliminación lógica

Cuando una operación deba dejar de considerarse válida, deberá conservarse su registro histórico y reflejarse su estado correspondiente.

---

### NFR-DEL-003 - Recuperación de información

El sistema deberá proporcionar mecanismos para recuperar información que haya sido modificada o desactivada accidentalmente cuando dicha información se encuentre dentro del historial conservado.

---

### NFR-DEL-004 - Recuperación de valores anteriores

Cuando una modificación relevante pueda revertirse, el sistema deberá permitir recuperar el valor anterior sin eliminar el historial de la modificación.

---

# Usabilidad

### NFR-USA-001 - Facilidad de uso

El sistema deberá poder ser utilizado por personas con conocimientos mínimos de sistemas administrativos.

---

### NFR-USA-002 - Flujo de ventas

Las operaciones frecuentes, especialmente el registro de ventas, deberán requerir la menor cantidad razonable de pasos para completarse.

---

### NFR-USA-003 - Interfaz clara

La interfaz deberá presentar la información de forma clara, consistente y comprensible para usuarios no especializados.

---

### NFR-USA-004 - Mensajes de error

Cuando una operación no pueda completarse, el sistema deberá informar claramente qué ocurrió y, cuando sea posible, cómo corregirlo.

---

### NFR-USA-005 - Validación de información

El sistema deberá validar la información proporcionada por los usuarios antes de completar operaciones que puedan afectar los datos del negocio.

---

### NFR-USA-006 - Prevención de errores

El sistema deberá prevenir errores comunes mediante validaciones, restricciones y confirmaciones.

---

### NFR-USA-007 - Confirmación de operaciones críticas

Las operaciones que puedan provocar cambios significativos o difíciles de revertir deberán solicitar confirmación antes de completarse.

---

# Configurabilidad

### NFR-CFG-001 - Configuración desde el sistema

Los parámetros que dependan de las necesidades del negocio deberán poder configurarse desde el sistema sin requerir modificaciones al código fuente.

---

### NFR-CFG-002 - Parámetros por producto

Los parámetros relacionados con productos deberán poder configurarse individualmente cuando las necesidades del negocio lo requieran.

---

### NFR-CFG-003 - Existencia mínima

El nivel mínimo de existencias deberá poder configurarse individualmente para cada producto.

---

### NFR-CFG-004 - Tarifas de servicios

Las tarifas de los servicios deberán poder modificarse desde el sistema.

---

### NFR-CFG-005 - Parámetros de servicios

Los parámetros utilizados para calcular precios de servicios deberán poder configurarse desde el sistema.

---

### NFR-CFG-006 - Descuentos

Las condiciones y valores relacionados con descuentos deberán poder configurarse de acuerdo con las políticas comerciales del negocio.

---

### NFR-CFG-007 - Formas de pago

Las formas de pago aceptadas por el negocio deberán poder configurarse desde el sistema.

---

### NFR-CFG-008 - Categorías

Las categorías utilizadas para organizar los productos deberán poder administrarse desde el sistema.

---

### NFR-CFG-009 - Nuevos servicios

El sistema deberá permitir registrar nuevos servicios y configurar sus parámetros y tarifas sin requerir modificaciones al código fuente.

---

# Mantenibilidad

### NFR-MAN-001 - Separación de responsabilidades

La solución deberá mantener separadas las responsabilidades relacionadas con presentación, lógica de negocio, persistencia, integraciones y demás componentes relevantes.

---

### NFR-MAN-002 - Código mantenible

La implementación deberá seguir prácticas que faciliten su comprensión, modificación, prueba y mantenimiento.

---

### NFR-MAN-003 - Extensibilidad

La solución deberá permitir incorporar nuevos productos, servicios, proveedores, usuarios, formas de pago y configuraciones sin requerir modificaciones estructurales innecesarias.

---

### NFR-MAN-004 - Documentación

Las decisiones relevantes de diseño y arquitectura deberán mantenerse documentadas.

---

### NFR-MAN-005 - Configuración independiente del código

Los valores que puedan cambiar por decisión del negocio no deberán estar definidos de forma rígida en el código fuente cuando puedan ser administrados como configuración.

---

# Respaldo y recuperación

### NFR-REC-001 - Respaldo periódico

La información crítica del negocio deberá contar con respaldos automáticos con una frecuencia mínima diaria.

---

### NFR-REC-002 - Almacenamiento externo

Los respaldos deberán conservarse en una ubicación independiente del equipo principal donde opera el sistema.

---

### NFR-REC-003 - Protección de respaldos

Los respaldos deberán contar con controles adecuados para evitar accesos o modificaciones no autorizadas.

---

### NFR-REC-004 - Exportación de información

El sistema deberá permitir exportar información relevante del negocio a formatos apropiados para consulta y análisis, incluyendo Excel cuando corresponda.

---

### NFR-REC-005 - Excel como exportación

La exportación a Excel deberá considerarse un mecanismo de consulta e intercambio de información y no el mecanismo principal de recuperación de la base de datos.

---

### NFR-REC-006 - Restauración

Deberá existir un mecanismo que permita restaurar la información a partir de los respaldos disponibles.

---

### NFR-REC-007 - Minimización de pérdida de información

Los mecanismos de respaldo y sincronización deberán diseñarse para minimizar la cantidad de información que podría perderse ante una falla.

---

### NFR-REC-008 - Recuperación del servicio

Ante una falla grave, el sistema deberá poder ser restaurado en el menor tiempo razonablemente posible para reducir el impacto sobre la operación del negocio.

---

# Integraciones externas

### NFR-INT-001 - Facturación electrónica

La integración con el servicio externo de facturación deberá manejar correctamente respuestas exitosas, errores, indisponibilidad y tiempos de espera.

---

### NFR-INT-002 - Continuidad ante fallos de facturación

La indisponibilidad temporal del servicio de facturación no deberá impedir registrar una venta.

---

### NFR-INT-003 - Facturación posterior

Cuando el servicio de facturación no se encuentre disponible, la solicitud deberá poder quedar pendiente para ser procesada posteriormente.

---

### NFR-INT-004 - Notificación de facturación

Una factura procesada posteriormente deberá poder ser enviada al cliente por el medio configurado para la operación.

---

### NFR-INT-005 - Integración con pagos

El sistema deberá permitir incorporar mecanismos de integración con servicios utilizados para procesar o validar pagos mediante tarjeta y transferencia.

---

### NFR-INT-006 - Fallos en servicios de pago

Una falla o indisponibilidad de un servicio externo de pagos deberá manejarse de manera controlada sin generar registros de pago incorrectos o duplicados.

---

### NFR-INT-007 - Estados de operaciones externas

Las operaciones que dependan de servicios externos deberán conservar un estado que permita identificar si fueron procesadas, están pendientes o requieren atención.

---

# Privacidad y cumplimiento

### NFR-PRI-001 - Protección de datos personales

La información personal de los clientes deberá manejarse de acuerdo con las obligaciones legales aplicables.

---

### NFR-PRI-002 - Conservación de información fiscal

Los datos fiscales de los clientes deberán conservarse únicamente cuando corresponda y de acuerdo con las condiciones de autorización aplicables.

---

### NFR-PRI-003 - Acceso a información fiscal

El acceso a información fiscal deberá limitarse a los usuarios que necesiten utilizarla para realizar sus funciones.

---

### NFR-PRI-004 - Información financiera

La información relacionada con ingresos y egresos deberá contar con controles de acceso adecuados para reducir el riesgo de exposición no autorizada.

---

### NFR-PRI-005 - Minimización de datos

El sistema deberá evitar almacenar información personal que no sea necesaria para las operaciones del negocio.

---

# Observabilidad y diagnóstico

### NFR-OBS-001 - Registro de errores

El sistema deberá registrar los errores técnicos relevantes para facilitar su diagnóstico y resolución.

---

### NFR-OBS-002 - Registro de sincronización

El sistema deberá proporcionar información suficiente para identificar operaciones pendientes, sincronizadas o que hayan presentado errores durante la sincronización.

---

### NFR-OBS-003 - Detección de inconsistencias

El sistema deberá proporcionar mecanismos que permitan detectar inconsistencias relevantes entre las operaciones registradas y el estado actual de la información.

---

### NFR-OBS-004 - Diagnóstico de integraciones

Los errores relacionados con servicios externos deberán conservar información suficiente para identificar el origen del problema y facilitar su resolución.

---

# Compatibilidad

### NFR-COM-001 - Computadoras

El sistema deberá funcionar correctamente en los equipos de escritorio utilizados actualmente por el negocio.

---

### NFR-COM-002 - Laptops

El sistema deberá funcionar correctamente en computadoras portátiles utilizadas para la administración y operación del negocio.

---

### NFR-COM-003 - Interfaz adaptable

La solución deberá mantener una interfaz que pueda adaptarse a diferentes tamaños de pantalla cuando se incorporen nuevos dispositivos.

---

### NFR-COM-004 - Dispositivos futuros

La arquitectura deberá permitir incorporar posteriormente dispositivos como tablets y teléfonos sin requerir una reestructuración completa de la solución.

---

# Calidad de la información

### NFR-QUA-001 - Información consistente

El sistema deberá mantener información consistente entre las diferentes operaciones y módulos que hagan referencia a los mismos datos.

---

### NFR-QUA-002 - Información histórica

La información histórica deberá conservarse de forma que permita reconstruir las operaciones realizadas anteriormente.

---

### NFR-QUA-003 - Información verificable

Las operaciones críticas deberán conservar información suficiente para verificar su origen, contenido y resultado.

---

### NFR-QUA-004 - Prevención de datos inválidos

El sistema deberá validar los datos antes de almacenarlos para reducir la posibilidad de registrar información incompleta, inválida o inconsistente.

---

# Criterios generales

Los requerimientos no funcionales deberán considerarse durante:

* Diseño.
* Implementación.
* Pruebas.
* Despliegue.
* Operación.
* Mantenimiento.

Los requisitos que establezcan valores cuantificables deberán poder verificarse mediante pruebas o mecanismos objetivos.

Las características críticas del sistema deberán recibir prioridad durante las decisiones de arquitectura y diseño.

Los parámetros definidos por el negocio deberán mantenerse configurables cuando su naturaleza permita que cambien con el tiempo.

Las decisiones técnicas derivadas de estos requerimientos deberán documentarse mediante los mecanismos de documentación de arquitectura correspondientes.
