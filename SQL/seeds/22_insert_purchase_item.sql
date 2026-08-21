-- SEED: PURCHASE ITEM
--
-- Los registros de compra se identifican mediante el proveedor y
-- usuario responsable, evitando depender de IDs generados.
--
-- Los productos se identifican mediante su SKU.
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

WITH seed_purchase_items (
    supplier_name,
    username,
    sku,
    quantity_ordered,
    quantity_received,
    unit_cost
) AS (
    VALUES
    -- COMPRA 1 - RECEIVED
    (
        'Distribuidora Escolar del Centro',
        'admin',
        'PAP-DIX-001',
        50,
        50,
        4.20
    ),
    (
        'Distribuidora Escolar del Centro',
        'admin',
        'PAP-BIC-001',
        100,
        100,
        3.20
    ),
    (
        'Distribuidora Escolar del Centro',
        'admin',
        'PAP-FAB-001',
        280,
        280,
        5.00
    ),
    -- COMPRA 2 - RECEIVED
    (
        'Papeles y Utiles Nacionales',
        'mlopez',
        'PAP-COP-001',
        20,
        20,
        82.00
    ),
    (
        'Papeles y Utiles Nacionales',
        'mlopez',
        'PAP-COP-003',
        25,
        25,
        20.00
    ),
    (
        'Papeles y Utiles Nacionales',
        'mlopez',
        'PAP-MAE-001',
        115,
        115,
        4.50
    ),
    -- COMPRA 3 - PARTIALLY_RECEIVED
    (
        'Distribuciones Escolares del Valle',
        'jrodriguez',
        'PAP-SCR-001',
        20,
        15,
        30.00
    ),
    (
        'Distribuciones Escolares del Valle',
        'jrodriguez',
        'PAP-FAB-021',
        10,
        8,
        92.00
    ),
    (
        'Distribuciones Escolares del Valle',
        'jrodriguez',
        'PAP-BAR-012',
        30,
        25,
        47.50
    ),
    -- COMPRA 4 - ORDERED
    (
        'Mayorista Papelero Mexicano',
        'agarcia',
        'PAP-COP-002',
        20,
        0,
        105.00
    ),
    (
        'Mayorista Papelero Mexicano',
        'agarcia',
        'PAP-BAR-012',
        15,
        0,
        45.00
    ),
    (
        'Mayorista Papelero Mexicano',
        'agarcia',
        'PAP-SCR-002',
        15,
        0,
        44.05
    ),
    -- COMPRA 5 - ORDERED
    (
        'Comercializadora Escolar Azteca',
        'lhernandez',
        'PAP-CRA-001',
        20,
        0,
        25.00
    ),
    (
        'Comercializadora Escolar Azteca',
        'lhernandez',
        'PAP-VIN-002',
        15,
        0,
        30.00
    ),
    (
        'Comercializadora Escolar Azteca',
        'lhernandez',
        'PAP-CRA-012',
        10,
        0,
        126.50
    ),
    -- COMPRA 6 - DRAFT
    (
        'Suministros para Oficina MX',
        'srojas',
        'PAP-BAR-021',
        20,
        0,
        35.00
    ),
    (
        'Suministros para Oficina MX',
        'srojas',
        'PAP-SCO-001',
        15,
        0,
        20.00
    ),
    (
        'Suministros para Oficina MX',
        'srojas',
        'PAP-BAR-022',
        10,
        0,
        181.00
    ),
    -- COMPRA 7 - RECEIVED
    (
        'Papelera Metropolitana',
        'dcastillo',
        'PAP-BAR-011',
        30,
        30,
        6.00
    ),
    (
        'Papelera Metropolitana',
        'dcastillo',
        'PAP-PEL-011',
        20,
        20,
        4.00
    ),
    (
        'Papelera Metropolitana',
        'dcastillo',
        'PAP-MAP-001',
        100,
        100,
        6.78
    ),
    -- COMPRA 8 - PARTIALLY_RECEIVED
    (
        'Distribuidora Escolar del Bajío',
        'pmartinez',
        'PAP-JOV-001',
        20,
        15,
        35.00
    ),
    (
        'Distribuidora Escolar del Bajío',
        'pmartinez',
        'PAP-NOR-002',
        15,
        10,
        42.00
    ),
    (
        'Distribuidora Escolar del Bajío',
        'pmartinez',
        'PAP-FAB-012',
        20,
        12,
        89.01
    ),
    -- COMPRA 9 - RECEIVED
    (
        'Comercializadora Materiales Educativos',
        'cnavarro',
        'PAP-PEL-021',
        20,
        20,
        28.00
    ),
    (
        'Comercializadora Materiales Educativos',
        'cnavarro',
        'PAP-VIN-011',
        15,
        15,
        40.00
    ),
    (
        'Comercializadora Materiales Educativos',
        'cnavarro',
        'PAP-CRA-021',
        20,
        20,
        76.40
    ),
    -- COMPRA 10 - CANCELLED
    (
        'Proveedora Integral de Papelería',
        'rortiz',
        'PAP-STA-001',
        10,
        0,
        65.00
    ),
    (
        'Proveedora Integral de Papelería',
        'rortiz',
        'PAP-CRA-012',
        10,
        0,
        82.00
    ),
    (
        'Proveedora Integral de Papelería',
        'rortiz',
        'PAP-FAB-012',
        25,
        0,
        145.20
    ),
    -- COMPRA 11 - RECEIVED
    (
        'Grupo Escolar del Norte',
        'fernando.silva',
        'PAP-DIX-002',
        30,
        30,
        6.30
    ),
    (
        'Grupo Escolar del Norte',
        'fernando.silva',
        'PAP-SCR-002',
        20,
        20,
        54.00
    ),
    (
        'Grupo Escolar del Norte',
        'fernando.silva',
        'PAP-FAB-021',
        30,
        30,
        167.33
    ),
    -- COMPRA 12 - ORDERED
    (
        'Suministros Creativos',
        'lucia.mendoza',
        'PAP-JOV-002',
        10,
        0,
        50.00
    ),
    (
        'Suministros Creativos',
        'lucia.mendoza',
        'PAP-RES-001',
        20,
        0,
        17.00
    ),
    (
        'Suministros Creativos',
        'lucia.mendoza',
        'PAP-CRA-012',
        10,
        0,
        80.00
    ),
    -- COMPRA 13 - DRAFT
    (
        'Distribuidora Escolar del Pacífico',
        'miguel.torres',
        'PAP-FAB-012',
        20,
        0,
        65.00
    ),
    (
        'Distribuidora Escolar del Pacífico',
        'miguel.torres',
        'PAP-FAB-021',
        20,
        0,
        92.00
    ),
    (
        'Distribuidora Escolar del Pacífico',
        'miguel.torres',
        'PAP-CRA-012',
        30,
        0,
        175.35
    ),
    -- COMPRA 14 - RECEIVED
    (
        'Distribuciones del Centro Histórico',
        'natalia.vargas',
        'PAP-MAP-001',
        20,
        20,
        9.00
    ),
    (
        'Distribuciones del Centro Histórico',
        'natalia.vargas',
        'PAP-MAE-001',
        30,
        30,
        4.00
    ),
    (
        'Distribuciones del Centro Histórico',
        'natalia.vargas',
        'PAP-BAR-011',
        50,
        50,
        6.90
    ),
    -- COMPRA 15 - CANCELLED
    (
        'Proveedor Regional Educativo',
        'roberto.morales',
        'PAP-BAR-022',
        20,
        0,
        42.00
    ),
    (
        'Proveedor Regional Educativo',
        'roberto.morales',
        'PAP-STA-031',
        20,
        0,
        15.00
    ),
    (
        'Proveedor Regional Educativo',
        'roberto.morales',
        'PAP-SCO-001',
        30,
        0,
        37.00
    ),
    -- COMPRA 16 - PARTIALLY_RECEIVED
    (
        'Comercializadora Escolar del Oriente',
        'elena.jimenez',
        'PAP-PEN-001',
        20,
        15,
        28.00
    ),
    (
        'Comercializadora Escolar del Oriente',
        'elena.jimenez',
        'PAP-SCR-021',
        20,
        12,
        25.00
    ),
    (
        'Comercializadora Escolar del Oriente',
        'elena.jimenez',
        'PAP-CRA-012',
        20,
        10,
        192.77
    ),
    -- COMPRA 17 - DRAFT
    (
        'Distribuidora Escolar del Centro',
        'andres.ruiz',
        'PAP-DIX-003',
        20,
        0,
        4.50
    ),
    (
        'Distribuidora Escolar del Centro',
        'andres.ruiz',
        'PAP-GEN-003',
        30,
        0,
        6.00
    ),
    (
        'Distribuidora Escolar del Centro',
        'andres.ruiz',
        'PAP-MAE-002',
        20,
        0,
        63.50
    ),
    -- COMPRA 18 - RECEIVED
    (
        'Papeles y Utiles Nacionales',
        'gabriela.castro',
        'PAP-COP-001',
        20,
        20,
        82.00
    ),
    (
        'Papeles y Utiles Nacionales',
        'gabriela.castro',
        'PAP-COP-003',
        15,
        15,
        20.00
    ),
    (
        'Papeles y Utiles Nacionales',
        'gabriela.castro',
        'PAP-MAE-002',
        10,
        10,
        1.56
    ),
    -- COMPRA 19 - ORDERED
    (
        'Papelera Metropolitana',
        'hector.santos',
        'PAP-BAR-013',
        10,
        0,
        52.00
    ),
    (
        'Papelera Metropolitana',
        'hector.santos',
        'PAP-SCO-002',
        20,
        0,
        28.00
    ),
    (
        'Papelera Metropolitana',
        'hector.santos',
        'PAP-BAR-022',
        10,
        0,
        12.50
    ),
    -- COMPRA 20 - RECEIVED
    (
        'Suministros para Oficina MX',
        'monica.ortega',
        'PAP-PEL-031',
        20,
        20,
        29.00
    ),
    (
        'Suministros para Oficina MX',
        'monica.ortega',
        'PAP-STA-041',
        15,
        15,
        13.00
    ),
    (
        'Suministros para Oficina MX',
        'monica.ortega',
        'PAP-BAR-021',
        20,
        20,
        58.50
    )
)
INSERT INTO
    "purchase_item" (
        "purchase_id",
        "product_id",
        "quantity_ordered",
        "quantity_received",
        "unit_cost",
        "subtotal",
        "notes"
    )
SELECT
    purchase.id,
    product.id,
    seed_purchase_items.quantity_ordered,
    seed_purchase_items.quantity_received,
    seed_purchase_items.unit_cost,
    (
        seed_purchase_items.quantity_ordered
        * seed_purchase_items.unit_cost
    ),
    NULL
FROM
    seed_purchase_items
INNER JOIN
    "supplier" AS supplier
    ON supplier.name = seed_purchase_items.supplier_name
INNER JOIN
    "user"
    ON "user".username = seed_purchase_items.username
INNER JOIN
    "purchase"
    ON purchase.supplier_id = supplier.id
    AND purchase.user_id = "user".id
INNER JOIN
    "product"
    ON product.sku = seed_purchase_items.sku
ON CONFLICT DO NOTHING;