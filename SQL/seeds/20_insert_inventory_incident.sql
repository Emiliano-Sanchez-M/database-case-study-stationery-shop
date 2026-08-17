-- SEED: INVENTORY INCIDENT
--
-- Genera incidencias de inventario representativas para
-- desarrollo local y pruebas de base de datos.
--
-- system_quantity se obtiene directamente de inventory.
--
-- difference se calcula como:
--
-- physical_quantity - system_quantity
--
-- Los usuarios se obtienen por username para evitar depender
-- de IDs generados por la base de datos.

WITH seed_incidents (
    sku,
    physical_quantity,
    reason,
    status,
    reported_by_username,
    resolved_by_username,
    notes,
    created_at,
    resolved_at
) AS (
    VALUES
    -- INCIDENCIA RESUELTA: FALTANTE
    (
        'PAP-BIC-001',
        117,
        'Diferencia detectada durante conteo semanal.',
        'RESOLVED',
        'mlopez',
        'admin',
        'Se encontraron tres unidades menos que las registradas.',
        NOW() - INTERVAL '45 days',
        NOW() - INTERVAL '43 days'
    ),
    -- INCIDENCIA RESUELTA: SOBRANTE
    (
        'PAP-DIX-001',
        89,
        'Sobrante detectado durante inventario fisico.',
        'RESOLVED',
        'jrodriguez',
        'admin',
        'Se localizaron cuatro unidades almacenadas en una zona diferente.',
        NOW() - INTERVAL '40 days',
        NOW() - INTERVAL '39 days'
    ),
    -- INCIDENCIA EN REVISION
    (
        'PAP-FAB-001',
        63,
        'Faltante detectado durante conteo.',
        'IN_REVIEW',
        'agarcia',
        NULL,
        'Se encontraron cinco unidades menos de las registradas.',
        NOW() - INTERVAL '18 days',
        NULL
    ),
    -- SIN DIFERENCIA
    (
        'PAP-SCR-001',
        75,
        'Verificacion rutinaria de inventario.',
        'RESOLVED',
        'lhernandez',
        'pmartinez',
        'La cantidad fisica coincide con el sistema.',
        NOW() - INTERVAL '30 days',
        NOW() - INTERVAL '29 days'
    ),
    -- PENDIENTE
    (
        'PAP-SHA-002',
        7,
        'Producto faltante posiblemente relacionado con merma.',
        'PENDING',
        'srojas',
        NULL,
        'Pendiente de revisar movimientos recientes.',
        NOW() - INTERVAL '8 days',
        NULL
    ),
    -- RESUELTA
    (
        'PAP-COP-001',
        39,
        'Diferencia durante conteo de almacen.',
        'RESOLVED',
        'dcastillo',
        'admin',
        'Se detectaron tres paquetes menos.',
        NOW() - INTERVAL '25 days',
        NOW() - INTERVAL '23 days'
    ),
    -- SOBRANTE
    (
        'PAP-MAE-001',
        155,
        'Material localizado fuera del area habitual.',
        'RESOLVED',
        'cnavarro',
        'pmartinez',
        'Se encontraron cinco piezas adicionales.',
        NOW() - INTERVAL '20 days',
        NOW() - INTERVAL '19 days'
    ),
    -- RECHAZADA
    (
        'PAP-RES-001',
        44,
        'Faltante de adhesivos durante revision mensual.',
        'REJECTED',
        'rortiz',
        'admin',
        'La diferencia correspondia a productos registrados en otra ubicacion.',
        NOW() - INTERVAL '55 days',
        NOW() - INTERVAL '52 days'
    ),
    -- CANCELADA
    (
        'PAP-JOV-002',
        7,
        'Diferencia detectada en producto de baja rotacion.',
        'CANCELLED',
        'lucia.mendoza',
        'admin',
        'La incidencia fue cancelada despues de localizar las unidades.',
        NOW() - INTERVAL '70 days',
        NOW() - INTERVAL '68 days'
    ),
    -- PENDIENTE
    (
        'PAP-VIN-001',
        17,
        'Dos unidades faltantes durante inventario.',
        'PENDING',
        'miguel.torres',
        NULL,
        'Pendiente de investigar posible merma.',
        NOW() - INTERVAL '5 days',
        NULL
    ),
    -- EN REVISION
    (
        'PAP-MAP-001',
        76,
        'Sobrante detectado durante conteo fisico.',
        'IN_REVIEW',
        'natalia.vargas',
        NULL,
        'Se encontraron cuatro reglas adicionales.',
        NOW() - INTERVAL '12 days',
        NULL
    ),
    -- RESUELTA
    (
        'PAP-BAR-021',
        16,
        'Faltante detectado en material de oficina.',
        'RESOLVED',
        'roberto.morales',
        'admin',
        'Se ajusto el inventario despues de confirmar la merma.',
        NOW() - INTERVAL '90 days',
        NOW() - INTERVAL '88 days'
    ),
    -- SOBRANTE
    (
        'PAP-GEN-003',
        51,
        'Sobrante encontrado durante conteo de manualidades.',
        'RESOLVED',
        'elena.jimenez',
        'pmartinez',
        'Se encontraron tres laminas adicionales.',
        NOW() - INTERVAL '35 days',
        NOW() - INTERVAL '34 days'
    ),
    -- EN REVISION
    (
        'PAP-PIL-011',
        20,
        'Diferencia detectada durante revision de escritura.',
        'IN_REVIEW',
        'andres.ruiz',
        NULL,
        'Se requiere verificar movimientos de venta recientes.',
        NOW() - INTERVAL '15 days',
        NULL
    ),
    -- SIN DIFERENCIA
    (
        'PAP-DIX-031',
        20,
        'Conteo de control sin diferencias.',
        'RESOLVED',
        'gabriela.castro',
        'admin',
        'El conteo fisico coincide con la existencia registrada.',
        NOW() - INTERVAL '10 days',
        NOW() - INTERVAL '10 days'
    )
)
INSERT INTO
    "inventory_incident" (
        "product_id",
        "system_quantity",
        "physical_quantity",
        "difference",
        "reason",
        "status",
        "reported_by",
        "resolved_by",
        "notes",
        "created_at",
        "resolved_at"
    )
SELECT
    product.id,
    inventory.quantity,
    seed_incidents.physical_quantity,
    seed_incidents.physical_quantity - inventory.quantity,
    seed_incidents.reason,
    seed_incidents.status,
    reporter.id,
    resolver.id,
    seed_incidents.notes,
    seed_incidents.created_at,
    seed_incidents.resolved_at
FROM
    seed_incidents
INNER JOIN
    "product" AS product
    ON product.sku = seed_incidents.sku
INNER JOIN
    "inventory" AS inventory
    ON inventory.product_id = product.id
INNER JOIN
    "user" AS reporter
    ON reporter.username = seed_incidents.reported_by_username
LEFT JOIN
    "user" AS resolver
    ON resolver.username = seed_incidents.resolved_by_username
WHERE NOT EXISTS (
    SELECT 1
    FROM "inventory_incident" AS existing
    WHERE existing.product_id = product.id
      AND existing.created_at = seed_incidents.created_at
);