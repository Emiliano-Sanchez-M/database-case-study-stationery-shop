-- SEED: PERMISOS
-- Inserta los permisos predeterminados del sistema
--
-- Los valores son ficticios, y estan destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
    "permission" ("name", "description")
VALUES (
        'USER_CREATE',
        'Crear usuarios del sistema.'
    ),
    (
        'USER_READ',
        'Consultar usuarios del sistema.'
    ),
    (
        'USER_UPDATE',
        'Actualizar la informacion de los usuarios del sistema.'
    ),
    (
        'USER_DEACTIVATE',
        'Desactivar usuarios del sistema.'
    ),
    (
        'USER_BLOCK',
        'Bloquear usuarios del sistema.'
    ),
    -- Gestion de roles
    (
        'ROLE_CREATE',
        'Crear roles del sistema.'
    ),
    (
        'ROLE_READ',
        'Consultar los roles del sistema.'
    ),
    (
        'ROLE_UPDATE',
        'Actualizar los roles del sistema.'
    ),
    (
        'ROLE_DEACTIVATE',
        'Desactivar roles del sistema.'
    ),
    -- Gestion de permisos
    (
        'PERMISSION_READ',
        'Consultar los permisos del sistema.'
    ),
    (
        'PERMISSION_ASSIGN',
        'Asignar permisos a los roles del sistema.'
    ),
        (
        'PERMISSION_DEACTIVATE',
        'Desactivar permisos del sistema.'
    ),
    -- Gestion de clientes
    (
        'CUSTOMER_CREATE',
        'Registrar clientes.'
    ),
    (
        'CUSTOMER_READ',
        'Consultar la informacion de los clientes.'
    ),
    (
        'CUSTOMER_UPDATE',
        'Actualizar la informacion de los clientes.'
    ),
    (
        'CUSTOMER_DEACTIVATE',
        'Desactivar clientes.'
    ),
    -- Datos fiscales
    (
        'FISCAL_DATA_CREATE',
        'Registrar los datos fiscales de los clientes.'
    ),
    (
        'FISCAL_DATA_READ',
        'Consultar los datos fiscales de los clientes.'
    ),
    (
        'FISCAL_DATA_UPDATE',
        'Actualizar los datos fiscales de los clientes.'
    ),
    -- Categorias y marcas
    (
        'CATEGORY_CREATE',
        'Crear categorias de productos.'
    ),
    (
        'CATEGORY_READ',
        'Consultar las categorias de productos.'
    ),
    (
        'CATEGORY_UPDATE',
        'Actualizar las categorias de productos.'
    ),
    (
        'CATEGORY_DEACTIVATE',
        'Desactivar categorias de productos.'
    ),
    (
        'BRAND_CREATE',
        'Crear marcas de productos.'
    ),
    (
        'BRAND_READ',
        'Consultar las marcas de productos.'
    ),
    (
        'BRAND_UPDATE',
        'Actualizar las marcas de productos.'
    ),
    (
        'BRAND_DEACTIVATE',
        'Desactivar marcas de productos.'
    ),
    -- Gestion de productos
    (
        'PRODUCT_CREATE',
        'Crear productos.'
    ),
    (
        'PRODUCT_READ',
        'Consultar productos.'
    ),
    (
        'PRODUCT_UPDATE',
        'Actualizar la informacion de los productos.'
    ),
    (
        'PRODUCT_DEACTIVATE',
        'Desactivar productos.'
    ),
    -- Descuentos
    (
        'DISCOUNT_CREATE',
        'Crear descuentos.'
    ),
    (
        'DISCOUNT_READ',
        'Consultar descuentos.'
    ),
    (
        'DISCOUNT_UPDATE',
        'Actualizar descuentos.'
    ),
    (
        'DISCOUNT_DEACTIVATE',
        'Desactivar descuentos.'
    ),
    -- Servicios
    (
        'SERVICE_CREATE',
        'Crear servicios.'
    ),
    (
        'SERVICE_READ',
        'Consultar servicios.'
    ),
    (
        'SERVICE_UPDATE',
        'Actualizar servicios.'
    ),
    (
        'SERVICE_DEACTIVATE',
        'Desactivar servicios.'
    ),
    (
        'SERVICE_RATE_CREATE',
        'Crear tarifas de servicios.'
    ),
    (
        'SERVICE_RATE_READ',
        'Consultar las tarifas de servicios.'
    ),
    (
        'SERVICE_RATE_UPDATE',
        'Actualizar las tarifas de servicios.'
    ),
    (
        'SERVICE_RATE_DEACTIVATE',
        'Desactivar tarifas de servicios.'
    ),
    -- Inventario
    (
        'INVENTORY_READ',
        'Consultar las existencias de productos.'
    ),
    (
        'INVENTORY_ADJUST',
        'Ajustar las cantidades de inventario.'
    ),
    (
        'INVENTORY_RESERVE',
        'Reservar existencias de productos.'
    ),
    (
        'INVENTORY_RELEASE',
        'Liberar existencias previamente reservadas.'
    ),
    (
        'INVENTORY_MOVEMENT_READ',
        'Consultar los movimientos de inventario.'
    ),
    (
        'INVENTORY_INCIDENT_CREATE',
        'Registrar incidencias de inventario.'
    ),
    (
        'INVENTORY_INCIDENT_READ',
        'Consultar las incidencias de inventario.'
    ),
    (
        'INVENTORY_INCIDENT_RESOLVE',
        'Resolver incidencias de inventario.'
    ),
    -- Ventas
    (
        'SALE_CREATE',
        'Registrar ventas.'
    ),
    (
        'SALE_READ',
        'Consultar ventas.'
    ),
    (
        'SALE_CANCEL',
        'Cancelar ventas.'
    ),
    (
        'SALE_ITEM_READ',
        'Consultar el detalle de las ventas.'
    ),
    -- Pagos
    (
        'PAYMENT_CREATE',
        'Registrar pagos.'
    ),
    (
        'PAYMENT_READ',
        'Consultar la informacion de los pagos.'
    ),
    (
        'PAYMENT_REFUND',
        'Realizar reembolsos de pagos.'
    ),
    (
        'PAYMENT_METHOD_READ',
        'Consultar los metodos de pago disponibles.'
    ),
    (
        'PAYMENT_METHOD_MANAGE',
        'Gestionar los metodos de pago.'
    ),
    -- Tickets
    (
        'TICKET_CREATE',
        'Emitir tickets de venta.'
    ),
    (
        'TICKET_READ',
        'Consultar tickets de venta.'
    ),
    -- ========================================================
    -- Devoluciones
    -- ========================================================
    (
        'RETURN_CREATE',
        'Registrar devoluciones de productos.'
    ),
    (
        'RETURN_READ',
        'Consultar devoluciones de productos.'
    ),
    (
        'RETURN_APPROVE',
        'Aprobar devoluciones de productos.'
    ),
    (
        'RETURN_REJECT',
        'Rechazar devoluciones de productos.'
    ),
    (
        'RETURN_COMPLETE',
        'Completar devoluciones aprobadas.'
    ),
    (
        'RETURN_CANCEL',
        'Cancelar devoluciones pendientes.'
    ),
    -- Reservaciones
    (
        'RESERVATION_CREATE',
        'Crear reservaciones de productos.'
    ),
    (
        'RESERVATION_READ',
        'Consultar reservaciones de productos.'
    ),
    (
        'RESERVATION_UPDATE',
        'Actualizar reservaciones de productos.'
    ),
    (
        'RESERVATION_CANCEL',
        'Cancelar reservaciones de productos.'
    ),
    (
        'RESERVATION_COMPLETE',
        'Completar reservaciones de productos.'
    ),
    (
        'RESERVATION_PAYMENT_CREATE',
        'Registrar pagos de reservaciones.'
    ),
    (
        'RESERVATION_PAYMENT_READ',
        'Consultar los pagos de reservaciones.'
    ),
    (
        'RESERVATION_PAYMENT_REFUND',
        'Realizar reembolsos de pagos de reservaciones.'
    ),
    (
        'RESERVATION_CONFIGURATION_READ',
        'Consultar la configuracion de reservaciones.'
    ),
    (
        'RESERVATION_CONFIGURATION_UPDATE',
        'Actualizar la configuracion de reservaciones.'
    ),
    -- Proveedores
    (
        'SUPPLIER_CREATE',
        'Registrar proveedores.'
    ),
    (
        'SUPPLIER_READ',
        'Consultar proveedores.'
    ),
    (
        'SUPPLIER_UPDATE',
        'Actualizar la informacion de los proveedores.'
    ),
    (
        'SUPPLIER_DEACTIVATE',
        'Desactivar proveedores.'
    ),
    (
        'PRODUCT_SUPPLIER_CREATE',
        'Asociar productos con proveedores.'
    ),
    (
        'PRODUCT_SUPPLIER_READ',
        'Consultar las relaciones entre productos y proveedores.'
    ),
    (
        'PRODUCT_SUPPLIER_UPDATE',
        'Actualizar la informacion de las relaciones entre productos y proveedores.'
    ),
    -- Compras
    (
        'PURCHASE_CREATE',
        'Crear ordenes de compra.'
    ),
    (
        'PURCHASE_READ',
        'Consultar ordenes de compra.'
    ),
    (
        'PURCHASE_UPDATE',
        'Actualizar ordenes de compra.'
    ),
    (
        'PURCHASE_CANCEL',
        'Cancelar ordenes de compra.'
    ),
    (
        'PURCHASE_RECEIVE',
        'Registrar la recepcion de productos comprados.'
    ),
    (
        'PURCHASE_ITEM_READ',
        'Consultar el detalle de las compras.'
    ),
    (
        'PURCHASE_INCIDENT_CREATE',
        'Registrar incidencias relacionadas con compras.'
    ),
    (
        'PURCHASE_INCIDENT_READ',
        'Consultar incidencias relacionadas con compras.'
    ),
    (
        'PURCHASE_INCIDENT_RESOLVE',
        'Resolver incidencias relacionadas con compras.'
    ),
    -- Caja
    (
        'CASH_REGISTER_OPEN',
        'Abrir una caja registradora.'
    ),
    (
        'CASH_REGISTER_READ',
        'Consultar la informacion de una caja registradora.'
    ),
    (
        'CASH_REGISTER_CLOSE',
        'Cerrar una caja registradora.'
    ),
    (
        'CASH_MOVEMENT_CREATE',
        'Registrar movimientos de efectivo.'
    ),
    (
        'CASH_MOVEMENT_READ',
        'Consultar movimientos de efectivo.'
    ),
    (
        'CASH_CLOSING_CREATE',
        'Registrar cierres de caja.'
    ),
    (
        'CASH_CLOSING_READ',
        'Consultar cierres de caja.'
    ),
    -- Facturacion
    (
        'INVOICE_CREATE',
        'Generar facturas.'
    ),
    (
        'INVOICE_READ',
        'Consultar facturas.'
    ),
    (
        'INVOICE_CANCEL',
        'Cancelar facturas.'
    ),
    -- Intereses de productos
    (
        'PRODUCT_INTEREST_CREATE',
        'Registrar solicitudes de productos.'
    ),
    (
        'PRODUCT_INTEREST_READ',
        'Consultar solicitudes de productos.'
    ),
    (
        'PRODUCT_INTEREST_UPDATE',
        'Actualizar la informacion de las solicitudes de productos.'
    ),
    (
        'PRODUCT_INTEREST_RESOLVE',
        'Resolver solicitudes de productos.'
    ),
    -- Configuracion del negocio
    (
        'BUSINESS_CONFIGURATION_READ',
        'Consultar la configuracion del negocio.'
    ),
    (
        'BUSINESS_CONFIGURATION_UPDATE',
        'Actualizar la configuracion del negocio.'
    ),
    -- Auditoria
    (
        'AUDIT_READ',
        'Consultar los registros de auditoria.'
    )
ON CONFLICT ("name") DO NOTHING;