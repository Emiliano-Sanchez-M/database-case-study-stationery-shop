-- SEED: ROLES

-- Crea roles representativos para desarrollo y pruebas
--
-- Los valores son ficticios, y estan destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO "role" (
    "name",
    "description"
)
VALUES
    (
        'ADMIN',
        'Acceso completo a la administracion del sistema y a las operaciones del negocio.'
    ),
    (
        'MANAGER',
        'Gestiona las operaciones generales del negocio, personal, inventario, ventas, compras y reportes.'
    ),
    (
        'CASHIER',
        'Gestiona ventas, pagos, operaciones de caja y atencion al cliente.'
    ),
    (
        'INVENTORY_MANAGER',
        'Gestiona productos, inventario, movimientos de existencias e incidencias de inventario.'
    ),
    (
        'PURCHASER',
        'Gestiona proveedores, ordenes de compra, recepcion de productos e incidencias de compras.'
    ),
    (
        'SALES',
        'Gestiona ventas, clientes, reservaciones y solicitudes de productos.'
    )
ON CONFLICT ("name") DO NOTHING;