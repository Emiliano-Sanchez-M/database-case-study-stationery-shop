-- SEED: INVENTORY MOVEMENT
--
-- Genera movimientos de inventario representativos para
-- desarrollo local y pruebas de base de datos.
--
-- Los productos y usuarios se obtienen por SKU y username
-- para evitar depender de IDs generados por la base de datos.
--
-- Las referencias representan operaciones ficticias de venta,
-- compra, devolucion o reservacion.

WITH seed_movements (
    sku,
    type,
    quantity,
    reference_type,
    reference_id,
    username,
    reason,
    notes,
    created_at
) AS (
    VALUES
    -- COMPRAS
    (
        'PAP-BIC-001',
        'PURCHASE',
        60,
        'PURCHASE',
        1001,
        'admin',
        'Reposicion de inventario.',
        'Compra de boligrafos BIC Cristal Negro.',
        NOW() - INTERVAL '90 days'
    ),
    (
        'PAP-DIX-001',
        'PURCHASE',
        40,
        'PURCHASE',
        1002,
        'mlopez',
        'Reposicion de producto.',
        'Compra de lapices Dixon No. 2.',
        NOW() - INTERVAL '75 days'
    ),
    (
        'PAP-SCR-001',
        'PURCHASE',
        50,
        'PURCHASE',
        1003,
        'jrodriguez',
        'Compra de temporada escolar.',
        'Reposicion de cuadernos profesionales.',
        NOW() - INTERVAL '60 days'
    ),
    (
        'PAP-COP-001',
        'PURCHASE',
        30,
        'PURCHASE',
        1004,
        'agarcia',
        'Reposicion de papel.',
        'Compra de paquetes de papel bond.',
        NOW() - INTERVAL '45 days'
    ),
    -- VENTAS
    (
        'PAP-BIC-001',
        'SALE',
        5,
        'SALE',
        2001,
        'lhernandez',
        'Venta de producto.',
        'Venta mostrador.',
        NOW() - INTERVAL '40 days'
    ),
    (
        'PAP-PIL-001',
        'SALE',
        3,
        'SALE',
        2002,
        'srojas',
        'Venta de producto.',
        'Venta de boligrafos Pilot.',
        NOW() - INTERVAL '35 days'
    ),
    (
        'PAP-SCR-001',
        'SALE',
        8,
        'SALE',
        2003,
        'dcastillo',
        'Venta de producto.',
        'Venta de cuadernos escolares.',
        NOW() - INTERVAL '28 days'
    ),
    (
        'PAP-MAE-001',
        'SALE',
        12,
        'SALE',
        2004,
        'pmartinez',
        'Venta de cartulina.',
        'Venta para trabajos escolares.',
        NOW() - INTERVAL '20 days'
    ),
    (
        'PAP-GEN-003',
        'SALE',
        6,
        'SALE',
        2005,
        'cnavarro',
        'Venta de material para manualidades.',
        'Venta de laminas de foamy.',
        NOW() - INTERVAL '12 days'
    ),
    -- DEVOLUCIONES
    (
        'PAP-BIC-001',
        'RETURN',
        2,
        'RETURN',
        3001,
        'rortiz',
        'Devolucion de producto.',
        'Producto devuelto por el cliente en condiciones de venta.',
        NOW() - INTERVAL '18 days'
    ),
    (
        'PAP-SCR-001',
        'RETURN',
        1,
        'RETURN',
        3002,
        'fernando.silva',
        'Devolucion por producto defectuoso.',
        'Cuaderno devuelto por defecto de fabricacion.',
        NOW() - INTERVAL '14 days'
    ),
    (
        'PAP-RES-001',
        'RETURN',
        2,
        'RETURN',
        3003,
        'lucia.mendoza',
        'Devolucion de producto.',
        'Adhesivos devueltos sin utilizar.',
        NOW() - INTERVAL '7 days'
    ),
    -- AJUSTES POSITIVOS
    (
        'PAP-DIX-001',
        'ADJUSTMENT',
        4,
        'INVENTORY_INCIDENT',
        4001,
        'miguel.torres',
        'Sobrante encontrado durante conteo.',
        'Se localizaron cuatro unidades adicionales.',
        NOW() - INTERVAL '16 days'
    ),
    (
        'PAP-MAP-001',
        'ADJUSTMENT',
        3,
        'INVENTORY_INCIDENT',
        4002,
        'natalia.vargas',
        'Correccion de inventario.',
        'Unidades localizadas en otra zona del almacen.',
        NOW() - INTERVAL '9 days'
    ),
    -- AJUSTES NEGATIVOS
    (
        'PAP-FAB-001',
        'ADJUSTMENT',
        5,
        'INVENTORY_INCIDENT',
        4003,
        'admin',
        'Merma detectada.',
        'Ajuste por faltante confirmado.',
        NOW() - INTERVAL '5 days'
    ),
    (
        'PAP-BAR-021',
        'ADJUSTMENT',
        2,
        'INVENTORY_INCIDENT',
        4004,
        'roberto.morales',
        'Producto faltante.',
        'Ajuste realizado despues de validar la incidencia.',
        NOW() - INTERVAL '3 days'
    ),
    -- RESERVAS
    (
        'PAP-BIC-002',
        'RESERVE',
        5,
        'RESERVATION',
        5001,
        'elena.jimenez',
        'Apartado de productos.',
        'Productos reservados para cliente.',
        NOW() - INTERVAL '10 days'
    ),
    (
        'PAP-MAE-001',
        'RESERVE',
        10,
        'RESERVATION',
        5002,
        'andres.ruiz',
        'Reserva para pedido.',
        'Material apartado para reservacion.',
        NOW() - INTERVAL '6 days'
    ),
    (
        'PAP-PIL-011',
        'RESERVE',
        3,
        'RESERVATION',
        5003,
        'gabriela.castro',
        'Apartado de productos.',
        'Productos reservados para cliente.',
        NOW() - INTERVAL '2 days'
    ),
    -- LIBERACION DE RESERVAS
    (
        'PAP-BIC-002',
        'RELEASE',
        2,
        'RESERVATION',
        5001,
        'elena.jimenez',
        'Liberacion parcial de reserva.',
        'El cliente redujo la cantidad solicitada.',
        NOW() - INTERVAL '8 days'
    ),
    (
        'PAP-MAE-001',
        'RELEASE',
        10,
        'RESERVATION',
        5002,
        'admin',
        'Reserva cancelada.',
        'La reservacion fue cancelada por el cliente.',
        NOW() - INTERVAL '1 day'
    )
)
INSERT INTO
    "inventory_movement" (
        "product_id",
        "type",
        "quantity",
        "reference_type",
        "reference_id",
        "user_id",
        "reason",
        "notes",
        "created_at"
    )
SELECT
    product.id,
    seed_movements.type,
    seed_movements.quantity,
    seed_movements.reference_type,
    seed_movements.reference_id,
    "user".id,
    seed_movements.reason,
    seed_movements.notes,
    seed_movements.created_at
FROM
    seed_movements
INNER JOIN
    "product" AS product
    ON product.sku = seed_movements.sku
INNER JOIN
    "user"
    ON "user".username = seed_movements.username
ON CONFLICT DO NOTHING;