# Casos de Uso

## Propósito

Este documento define los casos de uso funcionales del sistema de gestión para una papelería.

Los casos de uso describen las principales interacciones entre los actores y el sistema, incluyendo los flujos normales, escenarios alternativos, excepciones y resultados esperados.

El documento sirve como referencia para el diseño funcional, el modelado de datos, el diseño de la API, las interfaces de usuario y las pruebas del sistema.

---

# 1. Actores

## 1.1 Cajero

Empleado encargado principalmente de:

* Registrar ventas.
* Buscar productos.
* Consultar existencias.
* Registrar pagos.
* Generar tickets.
* Consultar información necesaria para atender al cliente.
* Registrar clientes cuando corresponda.
* Registrar solicitudes o interés por productos.

Sus permisos están limitados de acuerdo con el rol asignado.

---

## 1.2 Encargado de Inventario

Responsable de las operaciones relacionadas con inventario y mercancía.

Puede:

* Registrar productos.
* Modificar información de productos.
* Registrar entradas y salidas.
* Realizar ajustes autorizados.
* Gestionar incidencias de inventario.
* Registrar y recibir compras.
* Gestionar proveedores.
* Configurar existencias mínimas.
* Consultar movimientos de inventario.

---

## 1.3 Administrador

Responsable de la administración general del sistema.

Puede:

* Gestionar usuarios.
* Gestionar roles y permisos.
* Configurar políticas comerciales.
* Configurar precios.
* Configurar descuentos.
* Configurar servicios.
* Configurar parámetros de inventario.
* Gestionar apartados.
* Autorizar operaciones restringidas.
* Consultar información sensible.
* Consultar auditoría.
* Gestionar configuraciones generales.

---

## 1.4 Gerente / Propietario

Actor con acceso a información administrativa y financiera sensible.

Puede:

* Consultar ingresos y egresos.
* Consultar información fiscal de clientes autorizados.
* Consultar reportes.
* Consultar auditoría.
* Autorizar operaciones especiales.
* Consultar información histórica.
* Supervisar las operaciones del negocio.

---

## 1.5 Cliente

Persona que adquiere productos o servicios.

Puede:

* Solicitar productos.
* Elegir forma de pago.
* Solicitar factura.
* Solicitar registro como cliente.
* Realizar apartados si cumple las condiciones establecidas.
* Solicitar cancelaciones o devoluciones.
* Consultar productos disponibles públicamente.

El registro como cliente no es obligatorio para realizar una compra.

---

## 1.6 Proveedor

Entidad externa que suministra productos a la papelería.

Participa indirectamente en:

* Pedidos.
* Compras.
* Recepción de mercancía.
* Incidencias.
* Devoluciones.
* Comparación histórica de precios.

---

## 1.7 Servicio de Facturación

Sistema externo utilizado para emitir facturas fiscales.

El sistema de la papelería deberá poder comunicarse con este servicio, pero una indisponibilidad temporal del proveedor no deberá impedir registrar la venta.

---

## 1.8 Servicio de Pagos

Servicio externo que podrá integrarse posteriormente para automatizar la confirmación de pagos con tarjeta u otros medios.

Actualmente el sistema puede trabajar con confirmación manual.

---

# 2. Convenciones

Cada caso de uso tendrá un identificador único:

```text
UC-XXX
```

Los casos de uso representan procesos funcionales y no necesariamente una pantalla o botón individual.

Cuando una operación sea parte natural de otro proceso, podrá documentarse como parte del flujo en lugar de convertirse en un caso de uso independiente.

---

# 3. Ventas

## UC-001 — Registrar venta

### Actor principal

Cajero.

### Actores secundarios

Cliente.

### Objetivo

Registrar una venta de productos y/o servicios, asociándola opcionalmente con un cliente y registrando posteriormente el pago correspondiente.

### Precondiciones

* El usuario debe estar autenticado.
* El usuario debe contar con permisos para registrar ventas.
* Los productos deben estar disponibles en el catálogo si se desea agregarlos mediante el sistema.

### Disparador

El cliente solicita uno o varios productos o servicios.

### Flujo principal

1. El cliente solicita un producto o servicio.
2. El cajero busca el producto en el sistema.
3. El sistema muestra las coincidencias disponibles.
4. El cajero selecciona el producto correspondiente.
5. El sistema consulta la existencia disponible.
6. El sistema valida que exista cantidad suficiente.
7. El producto se agrega a la venta.
8. El proceso se repite para los demás productos o servicios.
9. El sistema identifica los descuentos aplicables.
10. El cajero puede aplicar o modificar descuentos cuando tenga permisos suficientes.
11. El sistema calcula el total.
12. El cliente selecciona la forma de pago.
13. El cajero registra la forma de pago.
14. El pago es confirmado manualmente bajo el mecanismo actual.
15. El sistema registra el pago.
16. La venta cambia a estado completado.
17. El sistema actualiza los movimientos de inventario correspondientes.
18. El sistema genera el ticket.
19. La venta queda disponible para consulta histórica y auditoría.

### Flujos alternativos

#### A1 — Cliente registrado

Si el cliente está registrado:

1. El cajero identifica al cliente.
2. El sistema muestra su registro.
3. La venta se asocia al cliente.
4. El sistema aplica los beneficios configurados para dicho cliente.

#### A2 — Cliente no registrado

Si el cliente no está registrado:

1. La venta se registra como venta general.
2. No se requiere crear un registro de cliente.

#### A3 — Cliente desea registrarse

El cliente puede solicitar su registro durante el proceso.

1. El cajero registra los datos requeridos.
2. El sistema crea el cliente.
3. La venta puede asociarse al nuevo registro.

### Excepciones

* El producto no existe.
* La cantidad solicitada supera la existencia disponible.
* El usuario no tiene permisos suficientes.
* El pago no puede ser confirmado.
* Se pierde la conexión con el servidor.
* Se produce un error durante la operación.

### Postcondiciones

* La venta queda registrada.
* El pago queda registrado.
* El inventario refleja la salida correspondiente.
* Se genera el ticket.
* La operación queda auditada.

---

# 4. Búsqueda de productos

## UC-002 — Buscar producto

### Actor principal

Cajero.

### Objetivo

Encontrar productos de forma rápida y flexible durante una operación de venta.

### Flujo principal

1. El cajero introduce uno o más criterios de búsqueda.
2. El sistema busca coincidencias.
3. El sistema prioriza coincidencias exactas.
4. El sistema considera coincidencias parciales.
5. El sistema considera coincidencias aproximadas.
6. El sistema muestra los resultados ordenados por relevancia.
7. El cajero selecciona el producto correspondiente.

### Criterios soportados

La búsqueda podrá utilizar:

* Nombre.
* Código interno / SKU.
* Código de barras.
* Marca.
* Categoría.
* Combinaciones de los criterios anteriores.

### Coincidencias aproximadas

El sistema deberá tolerar errores menores de escritura.

Ejemplo:

```text
"cuadernos"
"cusdernos"
"cudernos"
```

deberán poder producir resultados relacionados cuando la coincidencia sea suficientemente relevante.

---

# 5. Control de disponibilidad

## UC-003 — Consultar disponibilidad

### Actor principal

Cajero.

### Objetivo

Conocer la cantidad disponible de un producto antes de incorporarlo a una venta.

### Flujo principal

1. El cajero selecciona un producto.
2. El sistema consulta la existencia.
3. El sistema determina la cantidad disponible.
4. El sistema muestra la información al cajero.

### Regla

La existencia disponible deberá considerar las cantidades reservadas.

Ejemplo:

```text
Existencia física: 10
Reservado:          3
Disponible:         7
```

---

## UC-004 — Gestionar cantidad insuficiente

### Actor principal

Cajero.

### Objetivo

Gestionar una solicitud de productos cuya cantidad supera la existencia disponible.

### Flujo principal

1. El cliente solicita una cantidad determinada.
2. El cajero busca el producto.
3. El sistema consulta la existencia disponible.
4. El sistema detecta que la cantidad solicitada no puede cubrirse.
5. El sistema informa la cantidad disponible.
6. El cajero comunica la situación al cliente.
7. El cliente decide la cantidad que desea comprar.
8. El cajero registra la cantidad elegida.
9. El sistema continúa con la venta.

### Ejemplo

```text
Cliente solicita: 4 unidades
Disponible:       2 unidades

Cliente decide:
- Comprar 2
- Comprar 0
```

---

# 6. Diferencias de inventario

## UC-005 — Registrar diferencia de inventario

### Actor principal

Cajero.

### Actor secundario

Encargado de Inventario.

### Objetivo

Registrar una diferencia entre la existencia registrada en el sistema y la existencia física encontrada durante una venta.

### Flujo principal

1. El sistema indica una existencia determinada.
2. El cajero busca físicamente el producto.
3. El cajero encuentra una cantidad diferente.
4. El cajero puede continuar con la venta utilizando la cantidad físicamente disponible.
5. El sistema registra la venta.
6. El sistema genera una incidencia de diferencia de inventario.
7. El encargado revisa posteriormente la diferencia.
8. El encargado realiza el ajuste correspondiente mediante el proceso autorizado.

### Regla

El cajero no deberá modificar directamente la existencia registrada para corregir la diferencia.

---

# 7. Productos no disponibles

## UC-006 — Registrar interés por producto

### Actor principal

Cajero.

### Objetivo

Registrar la demanda de un producto que el cliente desea adquirir pero que actualmente no está disponible.

### Escenario A — Producto existente pero agotado

1. El cajero busca el producto.
2. El producto existe en el catálogo.
3. La existencia disponible es cero.
4. El sistema informa que no existe disponibilidad.
5. El cajero informa al cliente.
6. El cliente expresa interés.
7. El cajero registra el interés.
8. El sistema registra fecha, usuario y producto.

### Escenario B — Producto inexistente en catálogo

1. El cajero realiza una búsqueda.
2. No se encuentra el producto.
3. El cajero informa al cliente.
4. El cliente expresa interés.
5. El cajero registra una solicitud de producto.
6. El sistema conserva la descripción proporcionada.

### Regla

Registrar interés no crea automáticamente un producto en el catálogo.

---

# 8. Clientes

## UC-007 — Registrar cliente

### Actor principal

Cajero.

### Objetivo

Crear un registro de cliente para permitir futuras operaciones comerciales y beneficios.

### Flujo principal

1. El cliente solicita registrarse.
2. El cajero captura los datos requeridos.
3. El sistema valida la información.
4. El sistema crea el cliente.
5. El cliente queda disponible para futuras operaciones.

### Regla

El registro de cliente es opcional para realizar compras.

---

## UC-008 — Consultar cliente

### Actores principales

Cajero, Administrador, Gerente / Propietario.

### Objetivo

Consultar la información permitida de un cliente.

### Resultado

El sistema muestra únicamente la información correspondiente a los permisos del usuario.

Los datos fiscales y demás información restringida deberán tener controles de acceso específicos.

---

# 9. Descuentos

## UC-009 — Aplicar descuento

### Actor principal

Cajero.

### Actores secundarios

Administrador / usuario autorizado.

### Objetivo

Aplicar descuentos configurados durante una venta.

### Flujo principal

1. El sistema identifica descuentos aplicables.
2. El sistema calcula automáticamente los descuentos correspondientes.
3. El descuento se incorpora a la venta.
4. El sistema recalcula el total.

### Modificación autorizada

Un usuario con permisos suficientes podrá:

* Modificar un descuento.
* Agregar un descuento especial.
* Eliminar un descuento.

Toda modificación deberá registrar:

* Usuario.
* Fecha y hora.
* Valor anterior.
* Valor nuevo.
* Motivo cuando corresponda.

---

# 10. Pagos

## UC-010 — Registrar pago

### Actor principal

Cajero.

### Objetivo

Registrar el pago correspondiente a una venta.

### Formas de pago

El sistema deberá permitir configurar diferentes formas de pago.

Actualmente se contempla:

* Efectivo.
* Tarjeta.
* Transferencia.

### Flujo principal

1. El sistema muestra el total.
2. El cliente selecciona la forma de pago.
3. El cajero registra el método.
4. El cliente realiza el pago.
5. El cajero verifica manualmente la confirmación.
6. El cajero confirma el pago.
7. El sistema registra el movimiento.
8. La venta puede completarse.

### Integración futura

La arquitectura deberá permitir integrar posteriormente servicios de pago o terminales para automatizar la confirmación.

La venta no deberá depender actualmente de dicha integración.

---

## UC-011 — Gestionar pago pendiente

### Actor principal

Cajero.

### Objetivo

Permitir que una venta permanezca pendiente cuando el pago no ha sido confirmado.

### Flujo

1. El cajero registra el método de pago.
2. El pago no puede confirmarse.
3. La venta pasa a estado pendiente.
4. Los productos quedan reservados.
5. El cliente puede intentar nuevamente el pago.
6. El cliente puede utilizar otro método de pago.
7. Cuando el pago se confirma, la venta se completa.
8. Si la operación se cancela, las reservas se liberan.

### Regla

Una venta pendiente no debe considerarse una venta completada.

---

# 11. Tickets

## UC-012 — Generar ticket

### Actor principal

Sistema.

### Disparador

Confirmación del pago.

### Contenido

El ticket deberá incluir, cuando corresponda:

* Datos de la papelería.
* Número de venta.
* Fecha.
* Hora.
* Cajero.
* Cliente.
* Productos.
* Servicios.
* Cantidades.
* Precio unitario.
* Descuentos.
* Impuestos.
* Total.
* Forma de pago.
* Referencia de pago.
* Información fiscal correspondiente.

### Regla

El ticket se genera después de confirmar el pago.

---

# 12. Cancelaciones

## UC-013 — Cancelar venta

### Actor principal

Usuario autorizado.

### Objetivo

Invalidar una venta previamente completada sin eliminar su registro histórico.

### Flujo principal

1. El usuario solicita cancelar una venta.
2. El sistema localiza la venta.
3. El sistema valida los permisos.
4. El usuario proporciona el motivo.
5. El sistema registra la cancelación.
6. La venta cambia a estado `CANCELADA`.
7. El ticket original se conserva.
8. Se registran los efectos sobre inventario.
9. Se registra la devolución correspondiente.
10. Si es necesario realizar una nueva venta, esta se crea como una nueva operación relacionada con la anterior.

### Regla

Una venta completada no se modifica directamente ni se elimina físicamente.

---

# 13. Devoluciones

## UC-014 — Realizar devolución parcial

### Actor principal

Usuario autorizado.

### Objetivo

Devolver uno o varios productos de una venta sin cancelar necesariamente toda la operación.

### Flujo principal

1. El usuario localiza la venta original.
2. El sistema muestra los productos vendidos.
3. El usuario selecciona los productos a devolver.
4. El sistema valida que sean susceptibles de devolución.
5. El sistema calcula el importe correspondiente.
6. Se registra la devolución.
7. El importe se devuelve mediante el mismo método de pago original.
8. El inventario se actualiza mediante un movimiento de devolución.
9. La venta queda marcada como parcialmente devuelta.

### Regla

La devolución no modifica el contenido histórico de la venta original.

---

## UC-015 — Realizar devolución total

### Actor principal

Usuario autorizado.

### Objetivo

Devolver la totalidad de una venta.

### Flujo principal

1. Se localiza la venta.
2. Se validan las condiciones de devolución.
3. Se registra la devolución total.
4. Se devuelve el importe mediante el mismo método de pago.
5. Se generan los movimientos de inventario correspondientes.
6. La venta queda registrada como devuelta.

---

## UC-016 — Rechazar devolución

### Actor principal

Usuario autorizado.

### Objetivo

Impedir devoluciones que no cumplan las condiciones establecidas.

### Condiciones de rechazo

Podrán incluir:

* Producto usado.
* Producto dañado.
* Producto incompleto.
* Incumplimiento de la política comercial.

### Excepción autorizada

Un usuario autorizado podrá aceptar excepcionalmente una devolución que no cumpla las condiciones.

En ese caso deberá registrarse:

* Usuario responsable.
* Fecha y hora.
* Producto.
* Venta.
* Motivo.
* Importe.
* Condición de excepción.

El sistema deberá conservar esta información para efectos de responsabilidad administrativa.

---

# 14. Apartados

## UC-017 — Crear apartado

### Actor principal

Cajero.

### Actor secundario

Cliente.

### Objetivo

Reservar productos para un cliente registrado mediante un esquema de pagos parciales.

### Precondiciones

* El cliente debe estar registrado.
* Los productos deben estar disponibles.
* El anticipo debe cumplir el porcentaje mínimo configurado.

### Flujo principal

1. El cliente solicita un apartado.
2. El cajero identifica al cliente.
3. Se seleccionan los productos.
4. El sistema calcula el valor total.
5. El sistema consulta las políticas configuradas.
6. El sistema calcula el anticipo mínimo requerido.
7. El cliente realiza el anticipo.
8. El sistema registra el pago.
9. Los productos quedan reservados.
10. El sistema calcula automáticamente la fecha de vencimiento.
11. Se genera la documentación correspondiente.

### Regla

Un cliente puede tener múltiples apartados activos simultáneamente.

---

## UC-018 — Registrar pago de apartado

### Actor principal

Cajero.

### Objetivo

Registrar pagos adicionales realizados por el cliente antes de liquidar el apartado.

### Flujo

1. Se localiza el apartado.
2. Se registra el importe recibido.
3. El sistema actualiza el total pagado.
4. El sistema calcula el saldo restante.
5. Si el importe cubre el total, el apartado queda liquidado.

---

## UC-019 — Liquidar apartado

### Actor principal

Cajero.

### Objetivo

Completar un apartado mediante el pago total del saldo pendiente.

### Flujo

1. Se consulta el apartado.
2. El sistema muestra el saldo pendiente.
3. El cliente realiza el pago.
4. El sistema registra el pago.
5. El apartado cambia a estado `LIQUIDADO`.
6. Los productos dejan de estar reservados.
7. Se genera la operación de venta correspondiente.
8. Se actualiza el inventario.

### Regla

Si el cliente liquida dentro del plazo configurado, no se aplica penalización.

---

## UC-020 — Cancelar apartado

### Actor principal

Cajero / usuario autorizado.

### Objetivo

Cancelar un apartado antes de su vencimiento.

### Flujo

1. Se localiza el apartado.
2. Se valida su estado.
3. Se solicita la cancelación.
4. El sistema calcula la penalización configurada para cancelaciones dentro del plazo.
5. El sistema calcula el importe a devolver.
6. Se liberan los productos reservados.
7. Se registra la devolución correspondiente.
8. El apartado queda cancelado.

### Regla

La penalización se calcula sobre el valor total del apartado, no sobre el importe efectivamente pagado.

---

## UC-021 — Vencer apartado automáticamente

### Actor principal

Sistema.

### Objetivo

Procesar automáticamente los apartados cuyo plazo haya finalizado.

### Flujo

1. El sistema verifica periódicamente los apartados activos.
2. Identifica aquellos cuya fecha de vencimiento ha sido alcanzada.
3. Cambia el apartado a estado `VENCIDO`.
4. Calcula la penalización configurada.
5. Calcula el importe pendiente de devolución.
6. Libera los productos reservados.
7. Registra los movimientos correspondientes.
8. Conserva el importe pendiente de devolución para futuras reclamaciones.

### Regla

El vencimiento no requiere una acción manual del encargado.

### Regla de devolución pendiente

El importe pendiente de devolución no tiene fecha límite.

El cliente podrá solicitarlo posteriormente siempre que pueda acreditarse el apartado y el importe correspondiente.

---

## UC-022 — Procesar devolución de apartado

### Actor principal

Cajero / usuario autorizado.

### Objetivo

Entregar al cliente el importe que corresponda después de la cancelación o vencimiento de un apartado.

### Flujo

1. El cliente presenta la documentación correspondiente.
2. El usuario localiza el apartado.
3. El sistema valida la información.
4. El sistema muestra el importe pendiente.
5. Se realiza la devolución.
6. El sistema registra la operación.
7. El saldo pendiente queda liquidado.

---

# 15. Inventario

## UC-023 — Registrar producto

### Actor principal

Encargado de Inventario / Administrador.

### Objetivo

Registrar un nuevo producto.

### Información configurable

Podrá incluir:

* Nombre.
* SKU.
* Código de barras.
* Marca.
* Categoría.
* Precio.
* Costo.
* Existencia.
* Nivel de alerta de stock.
* Proveedor.
* Información adicional.

### Regla

El nivel de alerta de stock será configurable individualmente por producto.

---

## UC-024 — Configurar alerta de stock

### Actor principal

Encargado de Inventario / Administrador.

### Objetivo

Definir el nivel de existencia que genera una alerta de reposición.

### Regla

Cada producto podrá tener un nivel de alerta diferente.

El valor podrá modificarse desde el sistema sin modificar código.

---

## UC-025 — Registrar movimiento de inventario

### Actor principal

Encargado de Inventario.

### Objetivo

Registrar entradas, salidas o ajustes de inventario.

### Tipos de movimiento

* Entrada por compra.
* Salida por venta.
* Entrada por devolución.
* Salida por devolución a proveedor.
* Ajuste autorizado.
* Otros movimientos configurables cuando corresponda.

Cada movimiento deberá conservar trazabilidad.

---

## UC-026 — Gestionar incidencia de inventario

### Actor principal

Encargado de Inventario.

### Objetivo

Investigar diferencias o problemas relacionados con existencias.

### Información

Una incidencia podrá registrar:

* Producto.
* Existencia registrada.
* Existencia física.
* Diferencia.
* Fecha.
* Usuario que reportó.
* Motivo.
* Observaciones.
* Resolución.
* Usuario que realizó el ajuste.

---

# 16. Compras y proveedores

## UC-027 — Registrar proveedor

### Actor principal

Encargado de Inventario / Administrador.

### Objetivo

Registrar y mantener la información de proveedores.

---

## UC-028 — Registrar compra

### Actor principal

Encargado de Inventario.

### Objetivo

Registrar la adquisición de mercancía a un proveedor.

### Información

* Proveedor.
* Fecha.
* Productos.
* Cantidades.
* Precios.
* Condiciones.
* Información de recepción.

---

## UC-029 — Recibir mercancía

### Actor principal

Encargado de Inventario.

### Objetivo

Registrar la recepción física de productos adquiridos.

### Flujo

1. Se localiza la compra.
2. Se verifica la mercancía recibida.
3. Se comparan cantidades.
4. Se identifican faltantes, daños o errores.
5. Se registra la recepción.
6. El inventario se actualiza con la mercancía aceptada.
7. Se generan incidencias cuando corresponda.

---

## UC-030 — Gestionar incidencia con proveedor

### Actor principal

Encargado de Inventario.

### Objetivo

Gestionar mercancía faltante, dañada o incorrecta.

### Posibles resultados

* Devolución.
* Reposición.
* Nota de crédito.
* Ajuste administrativo.
* Otro resultado definido por el negocio.

La resolución deberá quedar registrada.

---

## UC-031 — Consultar precios históricos de proveedores

### Actor principal

Encargado de Inventario / Administrador.

### Objetivo

Comparar los precios ofrecidos por diferentes proveedores a lo largo del tiempo.

### Resultado

El sistema deberá permitir consultar:

* Producto.
* Proveedor.
* Precio histórico.
* Fecha.
* Condiciones aplicables.

---

# 17. Servicios

## UC-032 — Registrar servicio

### Actor principal

Administrador / Encargado autorizado.

### Objetivo

Registrar un nuevo servicio ofrecido por la papelería.

### Ejemplos

* Copias.
* Impresiones.
* Escaneos.
* Engargolados.
* Enmicados.
* Nuevos servicios.

---

## UC-033 — Configurar tarifa de servicio

### Actor principal

Administrador / usuario autorizado.

### Objetivo

Definir el precio y reglas de cálculo de un servicio.

Las tarifas deberán poder modificarse desde el sistema.

Para servicios como copias e impresiones podrán configurarse variables como:

* Tipo de impresión.
* Color.
* Blanco y negro.
* Tamaño de papel.
* Cantidad.
* Precio por unidad.

---

# 18. Caja

## UC-034 — Registrar ingreso o egreso

### Actor principal

Usuario autorizado.

### Objetivo

Registrar movimientos económicos distintos de las ventas cuando corresponda.

El sistema deberá conservar:

* Tipo de movimiento.
* Importe.
* Fecha.
* Usuario.
* Concepto.
* Observaciones.

---

## UC-035 — Realizar corte de caja

### Actor principal

Cajero / Encargado.

### Objetivo

Conciliar las operaciones de caja al finalizar la jornada.

### Flujo

1. El sistema obtiene las ventas registradas.
2. Agrupa los movimientos por forma de pago.
3. El usuario registra los valores reales disponibles.
4. El sistema compara los valores esperados con los reales.
5. Identifica diferencias.
6. El usuario registra observaciones.
7. El corte queda cerrado.
8. La operación queda registrada para auditoría.

### Regla

No deberán existir ventas completadas sin forma de pago registrada.

---

# 19. Facturación

## UC-036 — Solicitar factura

### Actor principal

Cliente.

### Actor secundario

Cajero.

### Objetivo

Solicitar la emisión de una factura asociada a una venta.

### Flujo

1. El cliente solicita factura.
2. El cajero captura o consulta los datos fiscales.
3. El sistema valida la información requerida.
4. El sistema envía la solicitud al proveedor de facturación.
5. El proveedor procesa la factura.
6. El sistema registra el resultado.
7. La factura se entrega o se envía al cliente.

### Regla

Los datos fiscales podrán conservarse para futuras facturas únicamente cuando el cliente haya autorizado su conservación.

---

## UC-037 — Gestionar facturación pendiente

### Actor principal

Sistema / Cajero.

### Objetivo

Permitir registrar una venta aunque el proveedor externo de facturación no esté disponible.

### Flujo

1. El cliente solicita factura.
2. El servicio externo no está disponible.
3. La venta continúa normalmente.
4. La solicitud de factura queda pendiente.
5. El sistema conserva la información necesaria.
6. Cuando el servicio vuelva a estar disponible, se procesa la factura.
7. La factura se envía posteriormente al cliente.

---

# 20. Usuarios y permisos

## UC-038 — Gestionar usuario

### Actor principal

Administrador.

### Objetivo

Crear, modificar, activar o desactivar usuarios del sistema.

### Regla

Cada empleado podrá contar con su propio usuario.

Un usuario que deje de trabajar deberá ser desactivado en lugar de eliminarse físicamente.

El usuario podrá volver a activarse posteriormente si corresponde.

---

## UC-039 — Gestionar roles y permisos

### Actor principal

Administrador.

### Objetivo

Definir qué operaciones puede realizar cada tipo de usuario.

### Regla

Los permisos deberán controlar operaciones sensibles como:

* Modificación de precios.
* Modificación de productos.
* Ajustes de inventario.
* Descuentos especiales.
* Cancelaciones.
* Devoluciones excepcionales.
* Configuración.
* Información financiera.
* Datos fiscales.
* Auditoría.

---

# 21. Auditoría

## UC-040 — Consultar auditoría

### Actor principal

Administrador / Gerente / Propietario.

### Objetivo

Consultar el historial de operaciones y modificaciones realizadas en el sistema.

### Información registrada

Cuando corresponda:

* Usuario.
* Fecha.
* Hora.
* Operación.
* Entidad afectada.
* Valor anterior.
* Valor nuevo.
* Motivo.
* Referencia de la operación.

### Operaciones críticas

Deberán conservar trazabilidad, entre otras:

* Ventas.
* Pagos.
* Cancelaciones.
* Devoluciones.
* Movimientos de inventario.
* Ajustes.
* Descuentos modificados.
* Cambios de precios.
* Cambios de configuración.
* Operaciones de caja.
* Operaciones relacionadas con información sensible.

---

# 22. Recuperación de información

## UC-041 — Recuperar información

### Actor principal

Administrador.

### Objetivo

Recuperar información que haya sido modificada o eliminada lógicamente de forma accidental.

### Regla

Las operaciones financieras y de auditoría no deberán eliminarse físicamente.

Cuando corresponda, se utilizarán mecanismos de cancelación, reversión, restauración o corrección conservando el historial.

---

# 23. Catálogo público

## UC-042 — Consultar catálogo público

### Actor principal

Cliente.

### Objetivo

Permitir que los clientes consulten los productos ofrecidos por la papelería sin acceder al sistema administrativo.

### Flujo

1. El cliente accede al catálogo.
2. Busca productos.
3. El sistema muestra información pública.
4. El cliente puede consultar disponibilidad cuando dicha información sea publicada.

### Regla

El cliente externo no podrá modificar productos, precios internos, inventario ni información administrativa.

---

# 24. Reglas generales de los casos de uso

## 24.1 Configuración

Las políticas comerciales deberán ser configurables desde el sistema.

No deberán estar definidas permanentemente en el código fuente.

Esto incluye, entre otros:

* Niveles de alerta de stock.
* Tarifas.
* Descuentos.
* Formas de pago.
* Categorías.
* Servicios.
* Políticas de apartados.
* Porcentaje mínimo de anticipo.
* Plazo de apartados.
* Penalización por cancelación.
* Penalización por vencimiento.

---

## 24.2 Integridad histórica

Las operaciones críticas no deberán eliminarse físicamente.

Las correcciones deberán realizarse mediante operaciones explícitas de:

* Cancelación.
* Devolución.
* Reversión.
* Ajuste autorizado.
* Corrección trazable.

---

## 24.3 Trazabilidad

Las operaciones sensibles deberán identificar al usuario responsable y conservar la fecha y hora de ejecución.

---

## 24.4 Inventario

El inventario deberá distinguir entre:

* Existencia física.
* Existencia reservada.
* Existencia disponible.
* Movimientos históricos.

Las ventas, devoluciones, compras y apartados deberán generar movimientos de inventario correspondientes.

---

## 24.5 Pagos

Una venta no se considerará completada hasta que exista confirmación del pago.

Las ventas con pagos pendientes podrán conservar los productos reservados mientras permanezcan abiertas.

---

## 24.6 Devoluciones

Las devoluciones deberán utilizar el mismo método de pago de la operación original.

---

## 24.7 Apartados

Los apartados:

* Requieren cliente registrado.
* Permiten múltiples apartados simultáneos por cliente.
* Reservan temporalmente los productos.
* Utilizan políticas configurables.
* Tienen vencimiento automático.
* Conservan indefinidamente los importes pendientes de devolución hasta que sean reclamados y validados.

---

## 24.8 Disponibilidad

La existencia disponible para venta deberá considerar las cantidades actualmente reservadas.

---

# 25. Relaciones principales entre casos de uso

El flujo principal de una venta puede representarse conceptualmente como:

```text
Buscar producto
      ↓
Consultar disponibilidad
      ↓
Agregar a venta
      ↓
Aplicar descuentos
      ↓
Identificar cliente (opcional)
      ↓
Calcular total
      ↓
Registrar pago
      ↓
¿Pago confirmado?
   ├── No → Venta pendiente
   │          ↓
   │      Reservar productos
   │          ↓
   │      Reintentar / cambiar método / cancelar
   │
   └── Sí
        ↓
    Completar venta
        ↓
    Actualizar inventario
        ↓
    Generar ticket
```

El flujo de apartado:

```text
Registrar cliente
      ↓
Crear apartado
      ↓
Validar anticipo mínimo
      ↓
Registrar pago
      ↓
Reservar productos
      ↓
Calcular vencimiento
      ↓
      ├── Liquidar → Venta
      │
      ├── Cancelar → Penalización
      │                 ↓
      │             Devolución
      │
      └── Vencer automáticamente
                        ↓
                  Penalización
                        ↓
                  Liberar productos
                        ↓
                  Importe pendiente
```

El flujo de devolución:

```text
Localizar venta
      ↓
Seleccionar productos
      ↓
Validar condiciones
      ↓
¿Aceptada?
   ├── No → Rechazar
   │
   └── Sí
        ↓
    Calcular importe
        ↓
    Registrar devolución
        ↓
    Mismo método de pago
        ↓
    Registrar movimiento
        ↓
    Actualizar inventario
```

---

# 26. Prioridades funcionales

De acuerdo con las necesidades expresadas por el cliente, los casos de uso relacionados con las siguientes áreas son críticos:

### Prioridad crítica

* Registrar ventas.
* Registrar pagos.
* Mantener ventas sin pérdida ante interrupciones.
* Mantener inventario confiable.
* Registrar ingresos y egresos.
* Mantener trazabilidad de operaciones.
* Mantener historial de modificaciones.

### Prioridad alta

* Apartados.
* Devoluciones.
* Cancelaciones.
* Compras.
* Recepción de mercancía.
* Gestión de proveedores.
* Facturación.
* Gestión de usuarios y permisos.

### Prioridad operativa

* Servicios.
* Reportes.
* Catálogo público.
* Consultas históricas.
* Configuración comercial.

---

# 27. Consideraciones para implementación

Los casos de uso no representan directamente la estructura de clases, tablas o endpoints del sistema.

La implementación deberá derivarse posteriormente de:

* Modelo de dominio.
* Modelo de datos.
* Arquitectura.
* Reglas de negocio.
* Especificación de API.
* Diseño de interfaces.

Los casos de uso deberán utilizarse como referencia para definir posteriormente los escenarios de prueba y criterios de aceptación.
