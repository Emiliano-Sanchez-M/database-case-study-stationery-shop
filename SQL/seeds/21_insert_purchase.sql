sql
-- SEED: PURCHASE
--
-- Los proveedores y usuarios se obtienen por nombre de forma indirecta
-- mediante sus identificadores naturales, evitando depender de IDs fijos.
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

WITH seed_purchases (
    supplier_name,
    username,
    status,
    subtotal,
    total,
    notes,
    ordered_at,
    received_at,
    created_at
) AS (
    VALUES
    (
        'Distribuidora Escolar del Centro',
        'admin',
        'RECEIVED',
        1850.00,
        1850.00,
        'Compra semanal de productos de escritura y material escolar.',
        '2026-06-02 09:15:00'::TIMESTAMP,
        '2026-06-05 14:30:00'::TIMESTAMP,
        '2026-06-02 09:10:00'::TIMESTAMP
    ),
    (
        'Papeles y Utiles Nacionales',
        'mlopez',
        'RECEIVED',
        3420.50,
        3420.50,
        'Reposicion de papel, cartulina y materiales para oficina.',
        '2026-06-08 10:20:00',
        '2026-06-11 12:45:00',
        '2026-06-08 10:15:00'
    ),
    (
        'Distribuciones Escolares del Valle',
        'jrodriguez',
        'PARTIALLY_RECEIVED',
        4275.00,
        4275.00,
        'Pedido recibido parcialmente por falta de algunos productos.',
        '2026-06-18 11:00:00',
        NULL,
        '2026-06-18 10:55:00'
    ),
    (
        'Mayorista Papelero Mexicano',
        'agarcia',
        'ORDERED',
        5680.75,
        5680.75,
        'Pedido de reposicion para temporada escolar.',
        '2026-07-02 09:40:00',
        NULL,
        '2026-07-02 09:35:00'
    ),
    (
        'Comercializadora Escolar Azteca',
        'lhernandez',
        'ORDERED',
        2195.00,
        2195.00,
        'Pedido de materiales para manualidades y pintura.',
        '2026-07-08 13:15:00',
        NULL,
        '2026-07-08 13:10:00'
    ),
    (
        'Suministros para Oficina MX',
        'srojas',
        'DRAFT',
        3120.00,
        3120.00,
        'Borrador de pedido pendiente de autorizacion.',
        NULL,
        NULL,
        '2026-07-15 16:20:00'
    ),
    (
        'Papelera Metropolitana',
        'dcastillo',
        'RECEIVED',
        1275.80,
        1275.80,
        'Compra de articulos para oficina y archivo.',
        '2026-05-20 08:50:00',
        '2026-05-23 11:30:00',
        '2026-05-20 08:45:00'
    ),
    (
        'Distribuidora Escolar del Bajío',
        'pmartinez',
        'PARTIALLY_RECEIVED',
        3890.25,
        3890.25,
        'Parte del pedido quedo pendiente de entrega.',
        '2026-07-20 10:30:00',
        NULL,
        '2026-07-20 10:25:00'
    ),
    (
        'Comercializadora Materiales Educativos',
        'cnavarro',
        'RECEIVED',
        2748.00,
        2748.00,
        'Reposicion de materiales didacticos y escolares.',
        '2026-06-25 14:10:00',
        '2026-06-29 15:20:00',
        '2026-06-25 14:05:00'
    ),
    (
        'Proveedora Integral de Papelería',
        'rortiz',
        'CANCELLED',
        4510.00,
        4510.00,
        'Pedido cancelado por cambio en las condiciones de suministro.',
        '2026-05-12 09:00:00',
        NULL,
        '2026-05-12 08:55:00'
    ),
    (
        'Grupo Escolar del Norte',
        'fernando.silva',
        'RECEIVED',
        6250.90,
        6250.90,
        'Compra de productos de escritura, dibujo y geometria.',
        '2026-04-14 11:45:00',
        '2026-04-18 13:10:00',
        '2026-04-14 11:40:00'
    ),
    (
        'Suministros Creativos',
        'lucia.mendoza',
        'ORDERED',
        1980.00,
        1980.00,
        'Pedido de productos para manualidades y actividades creativas.',
        '2026-07-28 12:30:00',
        NULL,
        '2026-07-28 12:25:00'
    ),
    (
        'Distribuidora Escolar del Pacífico',
        'miguel.torres',
        'DRAFT',
        7350.50,
        7350.50,
        'Pedido grande pendiente de revision antes de enviarse al proveedor.',
        NULL,
        NULL,
        '2026-08-01 15:40:00'
    ),
    (
        'Distribuciones del Centro Histórico',
        'natalia.vargas',
        'RECEIVED',
        945.00,
        945.00,
        'Compra menor de articulos diversos para reposicion.',
        '2026-07-05 10:15:00',
        '2026-07-07 09:50:00',
        '2026-07-05 10:10:00'
    ),
    (
        'Proveedor Regional Educativo',
        'roberto.morales',
        'CANCELLED',
        2850.00,
        2850.00,
        'Pedido cancelado antes de ser recibido.',
        '2026-06-10 13:20:00',
        NULL,
        '2026-06-10 13:15:00'
    ),
    (
        'Comercializadora Escolar del Oriente',
        'elena.jimenez',
        'PARTIALLY_RECEIVED',
        5125.40,
        5125.40,
        'Entrega parcial debido a disponibilidad limitada del proveedor.',
        '2026-08-04 09:30:00',
        NULL,
        '2026-08-04 09:25:00'
    ),
    (
        'Distribuidora Escolar del Centro',
        'andres.ruiz',
        'DRAFT',
        1640.00,
        1640.00,
        NULL,
        NULL,
        NULL,
        '2026-08-08 11:20:00'
    ),
    (
        'Papeles y Utiles Nacionales',
        'gabriela.castro',
        'RECEIVED',
        2985.60,
        2985.60,
        'Compra de papel y materiales para presentacion.',
        '2026-05-28 10:00:00',
        '2026-06-01 16:15:00',
        '2026-05-28 09:55:00'
    ),
    (
        'Papelera Metropolitana',
        'hector.santos',
        'ORDERED',
        1765.00,
        1765.00,
        'Pedido de productos de oficina y organizacion.',
        '2026-08-06 14:00:00',
        NULL,
        '2026-08-06 13:55:00'
    ),
    (
        'Suministros para Oficina MX',
        'monica.ortega',
        'RECEIVED',
        2240.75,
        2240.75,
        'Reposicion de consumibles y accesorios de oficina.',
        '2026-06-15 09:25:00',
        '2026-06-18 10:40:00',
        '2026-06-15 09:20:00'
    )
)
INSERT INTO
    "purchase" (
        "supplier_id",
        "user_id",
        "status",
        "subtotal",
        "total",
        "notes",
        "ordered_at",
        "received_at",
        "created_at"
    )
SELECT
    supplier.id,
    "user".id,
    seed_purchases.status,
    seed_purchases.subtotal,
    seed_purchases.total,
    seed_purchases.notes,
    seed_purchases.ordered_at,
    seed_purchases.received_at,
    seed_purchases.created_at
FROM
    seed_purchases
INNER JOIN
    "supplier" AS supplier
    ON supplier.name = seed_purchases.supplier_name
INNER JOIN
    "user"
    ON "user".username = seed_purchases.username
ON CONFLICT DO NOTHING;
