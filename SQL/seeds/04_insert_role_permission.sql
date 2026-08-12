-- SEED: ROLES PERMISOS
-- Inserta las relaciones entre roles y permisos predeterminados
--
-- Los valores son ficticios, y estan destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

-- ADMINISTRADOR
-- El administrador cuenta con todos los permisos disponib
INSERT INTO
    "role_permission" ("role_id", "permission_id")
SELECT role."id", permission."id"
FROM "role" role
    CROSS JOIN "permission" permission
WHERE
    role."name" = 'ADMIN';

-- GERENTE
INSERT INTO
    "role_permission" ("role_id", "permission_id")
SELECT role."id", permission."id"
FROM
    "role" role
    JOIN "permission" permission ON permission."name" IN (
        -- Usuarios
        'USER_READ',
        'USER_UPDATE',
        'USER_DEACTIVATE',
        'USER_BLOCK',
        -- Roles y permisos
        'ROLE_READ',
        'PERMISSION_READ',
        -- Clientes
        'CUSTOMER_CREATE',
        'CUSTOMER_READ',
        'CUSTOMER_UPDATE',
        'CUSTOMER_DEACTIVATE',
        -- Datos fiscales
        'FISCAL_DATA_CREATE',
        'FISCAL_DATA_READ',
        'FISCAL_DATA_UPDATE',
        -- Categorias
        'CATEGORY_CREATE',
        'CATEGORY_READ',
        'CATEGORY_UPDATE',
        'CATEGORY_DEACTIVATE',
        -- Marcas
        'BRAND_CREATE',
        'BRAND_READ',
        'BRAND_UPDATE',
        'BRAND_DEACTIVATE',
        -- Productos
        'PRODUCT_CREATE',
        'PRODUCT_READ',
        'PRODUCT_UPDATE',
        'PRODUCT_DEACTIVATE',
        -- Descuentos
        'DISCOUNT_CREATE',
        'DISCOUNT_READ',
        'DISCOUNT_UPDATE',
        'DISCOUNT_DEACTIVATE',
        -- Servicios
        'SERVICE_CREATE',
        'SERVICE_READ',
        'SERVICE_UPDATE',
        'SERVICE_DEACTIVATE',
        'SERVICE_RATE_CREATE',
        'SERVICE_RATE_READ',
        'SERVICE_RATE_UPDATE',
        'SERVICE_RATE_DEACTIVATE',
        -- Inventario
        'INVENTORY_READ',
        'INVENTORY_ADJUST',
        'INVENTORY_RESERVE',
        'INVENTORY_RELEASE',
        'INVENTORY_MOVEMENT_READ',
        'INVENTORY_INCIDENT_CREATE',
        'INVENTORY_INCIDENT_READ',
        'INVENTORY_INCIDENT_RESOLVE',
        -- Ventas
        'SALE_CREATE',
        'SALE_READ',
        'SALE_CANCEL',
        'SALE_ITEM_READ',
        -- Pagos
        'PAYMENT_CREATE',
        'PAYMENT_READ',
        'PAYMENT_REFUND',
        'PAYMENT_METHOD_READ',
        'PAYMENT_METHOD_MANAGE',
        -- Tickets
        'TICKET_CREATE',
        'TICKET_READ',
        -- Devoluciones
        'RETURN_CREATE',
        'RETURN_READ',
        'RETURN_APPROVE',
        'RETURN_REJECT',
        'RETURN_COMPLETE',
        'RETURN_CANCEL',
        -- Reservaciones
        'RESERVATION_CREATE',
        'RESERVATION_READ',
        'RESERVATION_UPDATE',
        'RESERVATION_CANCEL',
        'RESERVATION_COMPLETE',
        'RESERVATION_PAYMENT_CREATE',
        'RESERVATION_PAYMENT_READ',
        'RESERVATION_PAYMENT_REFUND',
        'RESERVATION_CONFIGURATION_READ',
        'RESERVATION_CONFIGURATION_UPDATE',
        -- Proveedores
        'SUPPLIER_CREATE',
        'SUPPLIER_READ',
        'SUPPLIER_UPDATE',
        'SUPPLIER_DEACTIVATE',
        'PRODUCT_SUPPLIER_CREATE',
        'PRODUCT_SUPPLIER_READ',
        'PRODUCT_SUPPLIER_UPDATE',
        -- Compras
        'PURCHASE_CREATE',
        'PURCHASE_READ',
        'PURCHASE_UPDATE',
        'PURCHASE_CANCEL',
        'PURCHASE_RECEIVE',
        'PURCHASE_ITEM_READ',
        'PURCHASE_INCIDENT_CREATE',
        'PURCHASE_INCIDENT_READ',
        'PURCHASE_INCIDENT_RESOLVE',
        -- Caja
        'CASH_REGISTER_OPEN',
        'CASH_REGISTER_READ',
        'CASH_REGISTER_CLOSE',
        'CASH_MOVEMENT_CREATE',
        'CASH_MOVEMENT_READ',
        'CASH_CLOSING_CREATE',
        'CASH_CLOSING_READ',
        -- Facturacion
        'INVOICE_CREATE',
        'INVOICE_READ',
        'INVOICE_CANCEL',
        -- Intereses de productos
        'PRODUCT_INTEREST_CREATE',
        'PRODUCT_INTEREST_READ',
        'PRODUCT_INTEREST_UPDATE',
        'PRODUCT_INTEREST_RESOLVE',
        -- Configuracion
        'BUSINESS_CONFIGURATION_READ',
        'BUSINESS_CONFIGURATION_UPDATE',
        -- Auditoria
        'AUDIT_READ'
    )
WHERE
    role."name" = 'MANAGER';

-- CAJERO
INSERT INTO
    "role_permission" ("role_id", "permission_id")
SELECT role."id", permission."id"
FROM
    "role" role
    JOIN "permission" permission ON permission."name" IN (
        -- Clientes
        'CUSTOMER_CREATE',
        'CUSTOMER_READ',
        'CUSTOMER_UPDATE',
        -- Datos fiscales
        'FISCAL_DATA_CREATE',
        'FISCAL_DATA_READ',
        'FISCAL_DATA_UPDATE',
        -- Productos y servicios
        'PRODUCT_READ',
        'CATEGORY_READ',
        'BRAND_READ',
        'DISCOUNT_READ',
        'SERVICE_READ',
        'SERVICE_RATE_READ',
        -- Inventario
        'INVENTORY_READ',
        'INVENTORY_RESERVE',
        'INVENTORY_RELEASE',
        -- Ventas
        'SALE_CREATE',
        'SALE_READ',
        'SALE_ITEM_READ',
        -- Pagos
        'PAYMENT_CREATE',
        'PAYMENT_READ',
        'PAYMENT_METHOD_READ',
        -- Tickets
        'TICKET_CREATE',
        'TICKET_READ',
        -- Devoluciones
        'RETURN_CREATE',
        'RETURN_READ',
        -- Reservaciones
        'RESERVATION_CREATE',
        'RESERVATION_READ',
        'RESERVATION_UPDATE',
        'RESERVATION_CANCEL',
        'RESERVATION_COMPLETE',
        'RESERVATION_PAYMENT_CREATE',
        'RESERVATION_PAYMENT_READ',
        -- Caja
        'CASH_REGISTER_OPEN',
        'CASH_REGISTER_READ',
        'CASH_REGISTER_CLOSE',
        'CASH_MOVEMENT_CREATE',
        'CASH_MOVEMENT_READ',
        'CASH_CLOSING_CREATE',
        'CASH_CLOSING_READ',
        -- Intereses de productos
        'PRODUCT_INTEREST_CREATE',
        'PRODUCT_INTEREST_READ',
        'PRODUCT_INTEREST_UPDATE'
    )
WHERE
    role."name" = 'CASHIER';

-- ENCARGADO DE INVENTARIO
INSERT INTO
    "role_permission" ("role_id", "permission_id")
SELECT role."id", permission."id"
FROM
    "role" role
    JOIN "permission" permission ON permission."name" IN (
        -- Categorias
        'CATEGORY_CREATE',
        'CATEGORY_READ',
        'CATEGORY_UPDATE',
        'CATEGORY_DEACTIVATE',
        -- Marcas
        'BRAND_CREATE',
        'BRAND_READ',
        'BRAND_UPDATE',
        'BRAND_DEACTIVATE',
        -- Productos
        'PRODUCT_CREATE',
        'PRODUCT_READ',
        'PRODUCT_UPDATE',
        'PRODUCT_DEACTIVATE',
        -- Inventario
        'INVENTORY_READ',
        'INVENTORY_ADJUST',
        'INVENTORY_RESERVE',
        'INVENTORY_RELEASE',
        'INVENTORY_MOVEMENT_READ',
        'INVENTORY_INCIDENT_CREATE',
        'INVENTORY_INCIDENT_READ',
        'INVENTORY_INCIDENT_RESOLVE',
        -- Proveedores
        'SUPPLIER_READ',
        'PRODUCT_SUPPLIER_CREATE',
        'PRODUCT_SUPPLIER_READ',
        'PRODUCT_SUPPLIER_UPDATE',
        -- Compras
        'PURCHASE_READ',
        'PURCHASE_ITEM_READ',
        'PURCHASE_INCIDENT_READ',
        'PURCHASE_INCIDENT_RESOLVE'
    )
WHERE
    role."name" = 'INVENTORY_MANAGER';

-- ENCARGADO DE COMPRAS
INSERT INTO
    "role_permission" ("role_id", "permission_id")
SELECT role."id", permission."id"
FROM
    "role" role
    JOIN "permission" permission ON permission."name" IN (
        -- Productos
        'PRODUCT_READ',
        'CATEGORY_READ',
        'BRAND_READ',
        -- Inventario
        'INVENTORY_READ',
        'INVENTORY_MOVEMENT_READ',
        -- Proveedores
        'SUPPLIER_CREATE',
        'SUPPLIER_READ',
        'SUPPLIER_UPDATE',
        'SUPPLIER_DEACTIVATE',
        'PRODUCT_SUPPLIER_CREATE',
        'PRODUCT_SUPPLIER_READ',
        'PRODUCT_SUPPLIER_UPDATE',
        -- Compras
        'PURCHASE_CREATE',
        'PURCHASE_READ',
        'PURCHASE_UPDATE',
        'PURCHASE_CANCEL',
        'PURCHASE_RECEIVE',
        'PURCHASE_ITEM_READ',
        'PURCHASE_INCIDENT_CREATE',
        'PURCHASE_INCIDENT_READ',
        'PURCHASE_INCIDENT_RESOLVE'
    )
WHERE
    role."name" = 'PURCHASER';

-- VENTAS
INSERT INTO
    "role_permission" ("role_id", "permission_id")
SELECT role."id", permission."id"
FROM
    "role" role
    JOIN "permission" permission ON permission."name" IN (
        -- Clientes
        'CUSTOMER_CREATE',
        'CUSTOMER_READ',
        'CUSTOMER_UPDATE',
        -- Datos fiscales
        'FISCAL_DATA_CREATE',
        'FISCAL_DATA_READ',
        'FISCAL_DATA_UPDATE',
        -- Productos y servicios
        'PRODUCT_READ',
        'CATEGORY_READ',
        'BRAND_READ',
        'DISCOUNT_READ',
        'SERVICE_READ',
        'SERVICE_RATE_READ',
        -- Inventario
        'INVENTORY_READ',
        'INVENTORY_RESERVE',
        'INVENTORY_RELEASE',
        -- Ventas
        'SALE_CREATE',
        'SALE_READ',
        'SALE_ITEM_READ',
        -- Pagos
        'PAYMENT_CREATE',
        'PAYMENT_READ',
        'PAYMENT_METHOD_READ',
        -- Tickets
        'TICKET_CREATE',
        'TICKET_READ',
        -- Reservaciones
        'RESERVATION_CREATE',
        'RESERVATION_READ',
        'RESERVATION_UPDATE',
        'RESERVATION_CANCEL',
        'RESERVATION_COMPLETE',
        'RESERVATION_PAYMENT_CREATE',
        'RESERVATION_PAYMENT_READ',
        -- Intereses de productos
        'PRODUCT_INTEREST_CREATE',
        'PRODUCT_INTEREST_READ',
        'PRODUCT_INTEREST_UPDATE',
        'PRODUCT_INTEREST_RESOLVE'
    )
WHERE
    role."name" = 'SALES'
ON CONFLICT ("role_id", "permission_id") DO NOTHING;