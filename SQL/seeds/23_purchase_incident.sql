-- SEED: PURCHASE INCIDENT
--
-- Los incidentes se relacionan con compras y artículos de compra
-- mediante identificadores obtenidos dinámicamente.
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

WITH seed_purchase_incidents (
    supplier_name,
    username,
    sku,
    type,
    quantity,
    description,
    resolution,
    status,
    created_at,
    resolved_at
) AS (
    VALUES
    -- COMPRA 1 - RECEIVED
    (
        'Distribuidora Escolar del Centro',
        'admin',
        'PAP-DIX-001',
        'DAMAGED',
        3,
        'Tres lapices llegaron con la mina rota.',
        'Se acepto el daño y se desconto la cantidad afectada del pedido.',
        'RESOLVED',
        '2026-06-05 15:10:00'::TIMESTAMP,
        '2026-06-06 10:30:00'::TIMESTAMP
    ),
    (
        'Distribuidora Escolar del Centro',
        'admin',
        'PAP-BIC-001',
        'MISSING',
        5,
        'Cinco boligrafos no fueron incluidos en la entrega.',
        'El proveedor confirmo el faltante y realizara el envio en la siguiente entrega.',
        'IN_REVIEW',
        '2026-06-05 15:30:00'::TIMESTAMP,
        NULL
    ),
    -- COMPRA 2 - RECEIVED
    (
        'Papeles y Utiles Nacionales',
        'mlopez',
        'PAP-COP-001',
        'DAMAGED',
        2,
        'Dos paquetes de papel presentaron daños por humedad.',
        'Se solicito reposicion de los paquetes afectados.',
        'RESOLVED',
        '2026-06-11 13:20:00'::TIMESTAMP,
        '2026-06-12 09:45:00'::TIMESTAMP
    ),
    (
        'Papeles y Utiles Nacionales',
        'mlopez',
        'PAP-MAE-001',
        'OVERAGE',
        5,
        'Se recibieron cinco cartulinas adicionales respecto a la cantidad solicitada.',
        'Se acepto el excedente y se registro como inventario recibido.',
        'RESOLVED',
        '2026-06-11 14:00:00'::TIMESTAMP,
        '2026-06-11 16:30:00'::TIMESTAMP
    ),
    -- COMPRA 3 - PARTIALLY_RECEIVED
    (
        'Distribuciones Escolares del Valle',
        'jrodriguez',
        'PAP-SCR-001',
        'MISSING',
        5,
        'Cinco cuadernos quedaron pendientes de entrega.',
        'El faltante se mantendra pendiente hasta recibir el complemento.',
        'PENDING',
        '2026-06-18 13:30:00'::TIMESTAMP,
        NULL
    ),
    (
        'Distribuciones Escolares del Valle',
        'jrodriguez',
        'PAP-FAB-021',
        'DAMAGED',
        1,
        'Un set de dibujo llego con materiales dañados.',
        'Se solicito reposicion del producto.',
        'IN_REVIEW',
        '2026-06-18 14:00:00'::TIMESTAMP,
        NULL
    ),
    -- COMPRA 7 - RECEIVED
    (
        'Papelera Metropolitana',
        'dcastillo',
        'PAP-BAR-011',
        'WRONG_PRODUCT',
        2,
        'Se recibieron dos folders de un modelo diferente al solicitado.',
        'El proveedor autorizo el cambio por el producto correcto.',
        'RESOLVED',
        '2026-05-23 12:00:00'::TIMESTAMP,
        '2026-05-24 10:15:00'::TIMESTAMP
    ),
    (
        'Papelera Metropolitana',
        'dcastillo',
        'PAP-PEL-011',
        'DAMAGED',
        4,
        'Cuatro gomas llegaron deformadas y no aptas para venta.',
        NULL,
        'REJECTED',
        '2026-05-23 12:30:00'::TIMESTAMP,
        '2026-05-25 09:00:00'::TIMESTAMP
    ),
    -- COMPRA 8 - PARTIALLY_RECEIVED
    (
        'Distribuidora Escolar del Bajío',
        'pmartinez',
        'PAP-JOV-001',
        'MISSING',
        5,
        'Cinco unidades quedaron pendientes de entrega.',
        'El proveedor confirmo que seran enviadas posteriormente.',
        'IN_REVIEW',
        '2026-07-20 12:00:00'::TIMESTAMP,
        NULL
    ),
    (
        'Distribuidora Escolar del Bajío',
        'pmartinez',
        'PAP-NOR-002',
        'DAMAGED',
        2,
        'Dos cajas de colores llegaron con el empaque abierto.',
        'Se solicito reemplazo de las unidades afectadas.',
        'PENDING',
        '2026-07-20 12:20:00'::TIMESTAMP,
        NULL
    ),
    -- COMPRA 9 - RECEIVED
    (
        'Comercializadora Materiales Educativos',
        'cnavarro',
        'PAP-PEL-021',
        'DAMAGED',
        2,
        'Dos cajas de acuarelas presentaron daños en el empaque.',
        'Se acepto la devolucion y reposicion por parte del proveedor.',
        'RESOLVED',
        '2026-06-29 16:00:00'::TIMESTAMP,
        '2026-06-30 11:20:00'::TIMESTAMP
    ),
    (
        'Comercializadora Materiales Educativos',
        'cnavarro',
        'PAP-CRA-021',
        'OVERAGE',
        3,
        'Se recibieron tres kits escolares adicionales.',
        'Se aceptaron los kits adicionales y se actualizo el inventario.',
        'RESOLVED',
        '2026-06-29 16:30:00'::TIMESTAMP,
        '2026-06-30 12:00:00'::TIMESTAMP
    ),
    -- COMPRA 10 - CANCELLED
    (
        'Proveedora Integral de Papelería',
        'rortiz',
        'PAP-STA-001',
        'WRONG_PRODUCT',
        2,
        'El proveedor envio un modelo distinto antes de la cancelacion definitiva.',
        'El producto fue rechazado y devuelto al proveedor.',
        'RESOLVED',
        '2026-05-13 10:00:00'::TIMESTAMP,
        '2026-05-13 15:30:00'::TIMESTAMP
    ),
    -- COMPRA 11 - RECEIVED
    (
        'Grupo Escolar del Norte',
        'fernando.silva',
        'PAP-DIX-002',
        'DAMAGED',
        2,
        'Dos lapices llegaron con defectos de fabricacion.',
        'El proveedor acepto realizar la reposicion.',
        'RESOLVED',
        '2026-04-18 14:00:00'::TIMESTAMP,
        '2026-04-19 10:00:00'::TIMESTAMP
    ),
    (
        'Grupo Escolar del Norte',
        'fernando.silva',
        'PAP-FAB-021',
        'MISSING',
        3,
        'Tres sets de dibujo no fueron incluidos en la entrega.',
        'Se genero una nota de credito por las unidades faltantes.',
        'RESOLVED',
        '2026-04-18 14:20:00'::TIMESTAMP,
        '2026-04-20 11:00:00'::TIMESTAMP
    ),
    -- COMPRA 14 - RECEIVED
    (
        'Distribuciones del Centro Histórico',
        'natalia.vargas',
        'PAP-MAP-001',
        'WRONG_PRODUCT',
        1,
        'Se recibio una regla de longitud diferente a la solicitada.',
        'El producto fue cambiado por la presentacion correcta.',
        'RESOLVED',
        '2026-07-07 10:30:00'::TIMESTAMP,
        '2026-07-08 09:15:00'::TIMESTAMP
    ),
    -- COMPRA 15 - CANCELLED
    (
        'Proveedor Regional Educativo',
        'roberto.morales',
        'PAP-BAR-022',
        'WRONG_PRODUCT',
        1,
        'Se envio una perforadora diferente a la solicitada antes de cancelar el pedido.',
        'El producto fue devuelto y el pedido quedo cancelado.',
        'RESOLVED',
        '2026-06-11 14:30:00'::TIMESTAMP,
        '2026-06-12 10:00:00'::TIMESTAMP
    ),
    -- COMPRA 16 - PARTIALLY_RECEIVED
    (
        'Comercializadora Escolar del Oriente',
        'elena.jimenez',
        'PAP-PEN-001',
        'DAMAGED',
        2,
        'Dos boligrafos llegaron con la punta danada.',
        'Se solicito reposicion de las unidades afectadas.',
        'IN_REVIEW',
        '2026-08-04 11:00:00'::TIMESTAMP,
        NULL
    ),
    (
        'Comercializadora Escolar del Oriente',
        'elena.jimenez',
        'PAP-SCR-021',
        'MISSING',
        8,
        'Ocho cuadernos quedaron pendientes de entrega.',
        'El faltante permanece abierto hasta completar la entrega.',
        'PENDING',
        '2026-08-04 11:15:00'::TIMESTAMP,
        NULL
    ),
    -- COMPRA 18 - RECEIVED
    (
        'Papeles y Utiles Nacionales',
        'gabriela.castro',
        'PAP-COP-001',
        'DAMAGED',
        1,
        'Un paquete de papel presento daños en el empaque.',
        'Se reemplazo el paquete afectado.',
        'RESOLVED',
        '2026-06-01 17:00:00'::TIMESTAMP,
        '2026-06-02 10:00:00'::TIMESTAMP
    ),
    -- COMPRA 20 - RECEIVED
    (
        'Suministros para Oficina MX',
        'monica.ortega',
        'PAP-PEL-031',
        'OVERAGE',
        2,
        'Se recibieron dos cajas adicionales de lapices de colores.',
        'Se acepto el excedente y se incorporo al inventario.',
        'RESOLVED',
        '2026-06-18 11:20:00'::TIMESTAMP,
        '2026-06-18 13:00:00'::TIMESTAMP
    ),
    (
        'Suministros para Oficina MX',
        'monica.ortega',
        'PAP-STA-041',
        'DAMAGED',
        1,
        'Un marcador llego con la punta danada.',
        'Se solicito reposicion al proveedor.',
        'REJECTED',
        '2026-06-18 11:45:00'::TIMESTAMP,
        '2026-06-19 09:30:00'::TIMESTAMP
    )
)
INSERT INTO
    "purchase_incident" (
        "purchase_id",
        "purchase_item_id",
        "type",
        "quantity",
        "description",
        "resolution",
        "status",
        "created_at",
        "resolved_at"
    )
SELECT
    purchase.id,
    purchase_item.id,
    seed_purchase_incidents.type,
    seed_purchase_incidents.quantity,
    seed_purchase_incidents.description,
    seed_purchase_incidents.resolution,
    seed_purchase_incidents.status,
    seed_purchase_incidents.created_at,
    seed_purchase_incidents.resolved_at
FROM
    seed_purchase_incidents
INNER JOIN
    "supplier" AS supplier
    ON supplier.name = seed_purchase_incidents.supplier_name
INNER JOIN
    "user"
    ON "user".username = seed_purchase_incidents.username
INNER JOIN
    "purchase"
    ON purchase.supplier_id = supplier.id
    AND purchase.user_id = "user".id
INNER JOIN
    "product"
    ON product.sku = seed_purchase_incidents.sku
INNER JOIN
    "purchase_item"
    ON purchase_item.purchase_id = purchase.id
    AND purchase_item.product_id = product.id
ON CONFLICT DO NOTHING;

-- COMPRA 12 - ORDERED
-- No se generan incidentes porque la compra aun no ha sido recibida.
-- COMPRA 13 - DRAFT
-- No se generan incidentes porque la compra aun no ha sido enviada.