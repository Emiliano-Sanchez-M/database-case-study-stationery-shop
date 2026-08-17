-- SEED: INVENTORY
--
-- Registra existencias iniciales para los productos de la papeleria.
--
-- Las cantidades son ficticias y están destinadas únicamente al
-- desarrollo local y a pruebas de base de datos.
--
-- Los productos se obtienen por SKU para evitar depender de
-- los IDs generados por la base de datos.

WITH seed_inventory (
    sku,
    quantity,
    reserved_quantity,
    updated_at
) AS (
    VALUES
    -- STOCK ALTO
    ('PAP-DIX-001', 85, 5, NOW() - INTERVAL '2 days'),
    ('PAP-BIC-001', 120, 10, NOW() - INTERVAL '1 day'),
    ('PAP-BIC-002', 95, 8, NOW() - INTERVAL '3 days'),
    ('PAP-COP-001', 60, 5, NOW() - INTERVAL '4 days'),
    ('PAP-PEL-011', 110, 15, NOW() - INTERVAL '2 days'),
    ('PAP-GEN-001', 150, 20, NOW() - INTERVAL '5 days'),
    -- STOCK MEDIO
    ('PAP-DIX-002', 42, 4, NOW() - INTERVAL '6 days'),
    ('PAP-FAB-001', 38, 3, NOW() - INTERVAL '8 days'),
    ('PAP-PIL-001', 25, 2, NOW() - INTERVAL '4 days'),
    ('PAP-PEN-001', 18, 3, NOW() - INTERVAL '10 days'),
    ('PAP-CRA-001', 32, 5, NOW() - INTERVAL '7 days'),
    ('PAP-SCR-001', 28, 4, NOW() - INTERVAL '3 days'),
    ('PAP-NOR-021', 35, 6, NOW() - INTERVAL '9 days'),
    ('PAP-RES-001', 45, 8, NOW() - INTERVAL '5 days'),
    ('PAP-PRI-001', 30, 5, NOW() - INTERVAL '2 days'),
    ('PAP-MAP-001', 50, 7, NOW() - INTERVAL '6 days'),
    -- STOCK BAJO
    ('PAP-FAB-002', 8, 2, NOW() - INTERVAL '1 day'),
    ('PAP-SHA-001', 7, 1, NOW() - INTERVAL '3 days'),
    ('PAP-STA-001', 6, 2, NOW() - INTERVAL '5 days'),
    ('PAP-FAB-021', 4, 1, NOW() - INTERVAL '2 days'),
    ('PAP-STA-012', 3, 1, NOW() - INTERVAL '4 days'),
    ('PAP-PRI-011', 5, 0, NOW() - INTERVAL '8 days'),
    ('PAP-BAR-013', 6, 2, NOW() - INTERVAL '6 days'),
    -- SIN EXISTENCIAS
    ('PAP-DIX-003', 0, 0, NOW() - INTERVAL '20 days'),
    ('PAP-SCR-004', 0, 0, NOW() - INTERVAL '30 days'),
    ('PAP-NOR-031', 0, 0, NOW() - INTERVAL '15 days'),
    ('PAP-VIN-004', 0, 0, NOW() - INTERVAL '25 days'),
    ('PAP-SCO-002', 0, 0, NOW() - INTERVAL '40 days'),
    -- PRODUCTOS SIN MARCA
    ('PAP-GEN-003', 55, 5, NOW() - INTERVAL '3 days'),
    ('PAP-GEN-004', 42, 4, NOW() - INTERVAL '5 days'),
    ('PAP-GEN-005', 18, 3, NOW() - INTERVAL '7 days'),
    ('PAP-GEN-008', 75, 10, NOW() - INTERVAL '2 days'),
    ('PAP-GEN-010', 24, 2, NOW() - INTERVAL '4 days'),
    -- PRODUCTOS ADICIONALES
    ('PAP-BIC-011', 65, 5, NOW() - INTERVAL '3 days'),
    ('PAP-PIL-011', 22, 2, NOW() - INTERVAL '5 days'),
    ('PAP-PEN-011', 16, 1, NOW() - INTERVAL '6 days'),
    ('PAP-NOR-051', 27, 4, NOW() - INTERVAL '2 days'),
    ('PAP-VIN-021', 14, 2, NOW() - INTERVAL '8 days'),
    ('PAP-MAP-021', 35, 5, NOW() - INTERVAL '4 days'),
    ('PAP-MAP-022', 12, 2, NOW() - INTERVAL '3 days'),
    ('PAP-RES-011', 31, 5, NOW() - INTERVAL '2 days'),
    ('PAP-PRI-021', 13, 2, NOW() - INTERVAL '5 days'),
    ('PAP-STA-041', 9, 1, NOW() - INTERVAL '1 day'),
    ('PAP-FAB-051', 20, 3, NOW() - INTERVAL '2 days'),
    ('PAP-DIX-031', 48, 6, NOW())
)
INSERT INTO
    "inventory" (
        "product_id",
        "quantity",
        "reserved_quantity",
        "updated_at"
    )
SELECT
    product.id,
    seed_inventory.quantity,
    seed_inventory.reserved_quantity,
    seed_inventory.updated_at
FROM
    seed_inventory
INNER JOIN
    "product" AS product
    ON product.sku = seed_inventory.sku
ON CONFLICT ("product_id") DO NOTHING;