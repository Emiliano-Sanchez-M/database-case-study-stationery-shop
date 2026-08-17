-- SEED: PRODUCT_SUPPLIER
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.
--
-- Los identificadores de los productos y los proveedores se 
-- obtienen mediante SKU y nombre respectivamente, para asi 
--evitar depender de valores específicos de las columnas ID.

INSERT INTO
"product_supplier" (
    "product_id",
    "supplier_id",
    "supplier_code",
    "last_purchase_price",
    "active"
)
SELECT
    product.id,
    supplier.id,
    relation.supplier_code,
    relation.last_purchase_price,
    relation.active
FROM (
    VALUES
        ('NOR-001', 'Distribuidora Escolar del Centro', 'NOR-COL-001', 32.50, TRUE),
        ('NOR-001', 'Mayorista Papelero Mexicano', 'NOR-COL-458', 31.80, TRUE),

        ('NOR-002', 'Distribuidora Escolar del Centro', 'NOR-COL-002', 48.90, TRUE),
        ('NOR-002', 'Papeles y Utiles Nacionales', 'PUN-NOR-025', 47.50, TRUE),

        ('DIX-001', 'Papeles y Utiles Nacionales', 'DIX-LAP-100', 18.20, TRUE),
        ('DIX-001', 'Proveedora Integral de Papelería', 'PIP-DIX-015', 17.90, TRUE),

        ('MAP-001', 'Comercializadora Escolar Azteca', 'CEA-MAP-001', 21.50, TRUE),
        ('MAP-001', 'Suministros Creativos', 'SC-MAP-042', 20.90, TRUE),

        ('SOL-001', 'Distribuciones Escolares del Valle', 'DEV-SOL-010', 19.80, TRUE),

        ('PHD-001', 'Suministros Creativos', 'SC-PHD-001', 52.00, TRUE),
        ('PHD-001', 'Comercializadora Escolar Azteca', 'CEA-PHD-019', 50.75, TRUE),

        ('NOR-003', 'Distribuidora Escolar del Bajío', 'DEB-NOR-034', 64.50, TRUE),
        ('NOR-003', 'Grupo Escolar del Norte', 'GEN-NOR-112', 63.80, TRUE),

        ('FAB-001', 'Papeles y Utiles Nacionales', 'PUN-FAB-001', 28.40, TRUE),

        ('SCRIBE-001', 'Distribuidora Escolar del Centro', 'DEC-SCR-001', 42.50, TRUE),
        ('SCRIBE-001', 'Papelera Metropolitana', 'PM-SCR-087', 41.90, TRUE),

        ('BIC-001', 'Proveedora Integral de Papelería', 'PIP-BIC-025', 9.80, TRUE),
        ('BIC-001', 'Mayorista Papelero Mexicano', 'MPM-BIC-041', 9.50, TRUE),

        ('PELIKAN-001', 'Distribuidora Escolar del Centro', 'DEC-PEL-011', 16.90, TRUE),

        ('PRITT-001', 'Papeles y Utiles Nacionales', 'PUN-PRI-005', 24.80, TRUE),
        ('PRITT-001', 'Distribuciones Escolares del Valle', 'DEV-PRI-022', 24.10, TRUE),

        ('SCOTCH-001', 'Suministros para Oficina MX', 'SOM-SCO-001', 38.50, TRUE),
        ('SCOTCH-001', 'Proveedora Integral de Papelería', 'PIP-SCO-014', 37.90, TRUE),

        ('UHU-001', 'Suministros para Oficina MX', 'SOM-UHU-005', 31.50, TRUE),

        ('NOR-004', 'Distribuidora Escolar del Centro', 'DEC-NOR-088', 55.00, TRUE),
        ('NOR-004', 'Comercializadora Escolar del Oriente', 'CEO-NOR-031', 53.90, TRUE),

        ('KLEENEX-001', 'Papelera Metropolitana', 'PM-KLX-001', 28.90, TRUE),

        ('OFFICE-001', 'Suministros para Oficina MX', 'SOM-OFF-015', 45.00, TRUE),
        ('OFFICE-001', 'Distribuciones Escolares del Valle', 'DEV-OFF-020', 43.80, TRUE),

        ('MAP-002', 'Suministros Creativos', 'SC-MAP-055', 34.50, TRUE),

        ('DIX-002', 'Papeles y Utiles Nacionales', 'PUN-DIX-078', 22.90, TRUE),
        ('DIX-002', 'Distribuidora Escolar del Centro', 'DEC-DIX-101', 22.50, TRUE),

        ('SOL-002', 'Comercializadora Escolar Azteca', 'CEA-SOL-044', 27.80, TRUE),

        ('PHD-002', 'Suministros Creativos', 'SC-PHD-031', 67.50, TRUE),

        ('BACO-001', 'Distribuidora Escolar del Centro', 'DEC-BAC-001', 12.50, TRUE),
        ('BACO-001', 'Proveedor Regional Educativo', 'PRE-BAC-007', 12.10, TRUE),

        ('NOR-005', 'Mayorista Papelero Mexicano', 'MPM-NOR-055', 18.90, TRUE),

        ('SCRIBE-002', 'Papelera Metropolitana', 'PM-SCR-109', 36.80, TRUE),

        ('BIC-002', 'Proveedora Integral de Papelería', 'PIP-BIC-055', 8.50, TRUE),

        ('PRITT-002', 'Distribuidora Escolar del Centro', 'DEC-PRI-018', 19.90, TRUE),

        ('SCOTCH-002', 'Suministros para Oficina MX', 'SOM-SCO-021', 29.50, TRUE),

        ('UHU-002', 'Proveedor Regional Educativo', 'PRE-UHU-014', 27.80, TRUE),

        ('NOR-006', 'Distribuidora Escolar del Bajío', 'DEB-NOR-071', 75.00, TRUE),

        ('MAP-003', 'Comercializadora Escolar del Oriente', 'CEO-MAP-018', 39.50, TRUE),

        ('SOL-003', 'Distribuciones Escolares del Valle', 'DEV-SOL-067', 31.80, TRUE),

        ('PHD-003', 'Suministros Creativos', 'SC-PHD-055', 74.50, TRUE),

        ('DIX-003', 'Papeles y Utiles Nacionales', 'PUN-DIX-102', 26.40, TRUE),

        ('NOR-007', 'Papelería Mayorista del Sur', 'PMS-NOR-014', 29.90, FALSE),

        ('FAB-002', 'Distribuidora Escolar del Centro', 'DEC-FAB-044', 31.50, TRUE),

        ('SCRIBE-003', 'Grupo Escolar del Norte', 'GEN-SCR-028', 48.90, TRUE),

        ('BIC-003', 'Mayorista Papelero Mexicano', 'MPM-BIC-085', 11.20, TRUE),

        ('PRITT-003', 'Distribuidora Escolar del Centro', 'DEC-PRI-044', 25.50, TRUE),

        ('MAP-004', 'Suministros Creativos', NULL, 44.80, TRUE),

        ('SOL-004', 'Comercializadora Escolar Azteca', 'CEA-SOL-099', 36.50, TRUE),

        ('NOR-008', 'Distribuciones del Centro Histórico', 'DCH-NOR-011', 82.00, TRUE),

        ('DIX-004', 'Distribuidora Escolar del Centro', 'DEC-DIX-125', 34.90, TRUE),

        ('PHD-004', 'Comercializadora Escolar Azteca', 'CEA-PHD-072', 91.50, TRUE),

        ('SCRIBE-004', 'Proveedor Regional Educativo', NULL, 54.00, TRUE),

        ('BIC-004', 'Proveedora Integral de Papelería', 'PIP-BIC-101', 13.40, TRUE),

        ('PRITT-004', 'Papeles y Utiles Nacionales', 'PUN-PRI-088', 28.70, TRUE),

        ('SCOTCH-003', 'Suministros para Oficina MX', 'SOM-SCO-044', 42.80, TRUE),

        ('UHU-003', 'Distribuidora Escolar del Centro', 'DEC-UHU-033', 35.90, TRUE),

        ('NOR-009', 'Distribuidora Escolar del Centro', 'DEC-NOR-144', 96.50, TRUE),
        ('NOR-009', 'Grupo Escolar del Norte', 'GEN-NOR-144', 94.80, TRUE),

        ('MAP-005', 'Suministros Creativos', 'SC-MAP-112', 49.90, TRUE),

        ('SOL-005', 'Comercializadora Escolar Azteca', 'CEA-SOL-122', 42.50, TRUE),

        ('DIX-005', 'Papeles y Utiles Nacionales', 'PUN-DIX-155', 39.90, TRUE),

        ('PHD-005', 'Suministros Creativos', 'SC-PHD-091', 110.00, TRUE),

        ('FAB-003', 'Distribuidora Escolar del Bajío', 'DEB-FAB-055', 38.80, TRUE),

        ('SCRIBE-005', 'Papelera Metropolitana', 'PM-SCR-155', 62.50, TRUE),

        ('BIC-005', 'Mayorista Papelero Mexicano', 'MPM-BIC-155', 15.90, TRUE),

        ('PRITT-005', 'Distribuidora Escolar del Centro', 'DEC-PRI-101', 31.80, TRUE),

        ('SCOTCH-004', 'Suministros para Oficina MX', 'SOM-SCO-088', 49.90, TRUE),

        ('UHU-004', 'Proveedor Regional Educativo', 'PRE-UHU-033', 41.50, TRUE),

        ('NOR-010', 'Papeles y Utiles Nacionales', 'PUN-NOR-201', 105.00, TRUE),

        ('MAP-006', 'Comercializadora Escolar del Oriente', 'CEO-MAP-055', 57.80, TRUE),

        ('SOL-006', 'Distribuciones Escolares del Valle', 'DEV-SOL-144', 48.90, TRUE),

        ('DIX-006', 'Distribuidora Escolar del Centro', 'DEC-DIX-188', 43.50, TRUE),

        ('PHD-006', 'Suministros Creativos', 'SC-PHD-144', 125.00, TRUE),

        ('BACO-002', 'Distribuidora Escolar del Centro', 'DEC-BAC-055', 15.20, TRUE),

        ('NOR-011', 'Papelería Mayorista del Sur', 'PMS-NOR-033', 34.50, FALSE),

        ('SCRIBE-006', 'Grupo Escolar del Norte', 'GEN-SCR-077', 68.90, TRUE),

        ('BIC-006', 'Proveedora Integral de Papelería', 'PIP-BIC-188', 18.50, TRUE),

        ('PRITT-006', 'Distribuidora Escolar del Centro', 'DEC-PRI-155', 35.90, TRUE),

        ('SCOTCH-005', 'Suministros para Oficina MX', 'SOM-SCO-122', 58.80, TRUE),

        ('UHU-005', 'Distribuidora Escolar del Centro', 'DEC-UHU-077', 48.50, TRUE),

        ('MAP-007', 'Suministros Creativos', 'SC-MAP-155', 64.90, TRUE),

        ('SOL-007', 'Comercializadora Escolar Azteca', 'CEA-SOL-188', 55.50, TRUE),

        ('DIX-007', 'Papeles y Utiles Nacionales', 'PUN-DIX-211', 49.80, TRUE),

        ('PHD-007', 'Suministros Creativos', 'SC-PHD-188', 139.00, TRUE),

        ('FAB-004', 'Distribuidora Escolar del Bajío', 'DEB-FAB-088', 44.50, TRUE),

        ('SCRIBE-007', 'Papelera Metropolitana', 'PM-SCR-201', 75.90, TRUE),

        ('BIC-007', 'Mayorista Papelero Mexicano', 'MPM-BIC-201', 21.40, TRUE),

        ('PRITT-007', 'Distribuidora Escolar del Centro', 'DEC-PRI-188', 39.80, TRUE),

        ('NOR-012', 'Distribuidora Escolar del Centro', 'DEC-NOR-255', 118.50, TRUE),

        ('MAP-008', 'Comercializadora Escolar del Oriente', 'CEO-MAP-088', 72.50, TRUE),

        ('SOL-008', 'Distribuciones Escolares del Valle', 'DEV-SOL-201', 61.90, TRUE),

        ('DIX-008', 'Distribuidora Escolar del Centro', 'DEC-DIX-255', 55.50, TRUE),

        ('PHD-008', 'Suministros Creativos', 'SC-PHD-211', 155.00, TRUE),

        ('BACO-003', 'Proveedor Regional Educativo', 'PRE-BAC-088', 18.90, TRUE),

        ('SCRIBE-008', 'Grupo Escolar del Norte', 'GEN-SCR-122', 81.50, TRUE),

        ('BIC-008', 'Proveedora Integral de Papelería', 'PIP-BIC-255', 24.50, TRUE),

        ('PRITT-008', 'Distribuidora Escolar del Centro', 'DEC-PRI-211', 44.90, TRUE),

        ('SCOTCH-006', 'Suministros para Oficina MX', 'SOM-SCO-155', 69.80, TRUE),

        ('UHU-006', 'Distribuidora Escolar del Centro', 'DEC-UHU-122', 55.90, TRUE),

        ('NOR-013', 'Papeles y Utiles Nacionales', 'PUN-NOR-288', 132.00, TRUE),

        ('MAP-009', 'Suministros Creativos', 'SC-MAP-211', 79.90, TRUE),

        ('SOL-009', 'Comercializadora Escolar Azteca', 'CEA-SOL-255', 68.50, TRUE),

        ('DIX-009', 'Papeles y Utiles Nacionales', 'PUN-DIX-288', 61.80, TRUE),

        ('PHD-009', 'Suministros Creativos', 'SC-PHD-255', 170.00, TRUE),

        ('SCRIBE-009', 'Papelera Metropolitana', 'PM-SCR-255', 92.50, TRUE),

        ('BIC-009', 'Mayorista Papelero Mexicano', 'MPM-BIC-288', 27.90, TRUE),

        ('PRITT-009', 'Distribuidora Escolar del Centro', 'DEC-PRI-255', 49.90, TRUE),

        ('NOR-014', 'Distribuidora Escolar del Centro', 'DEC-NOR-301', 145.00, TRUE),

        ('MAP-010', 'Comercializadora Escolar del Oriente', 'CEO-MAP-122', 88.50, TRUE),

        ('SOL-010', 'Distribuciones Escolares del Valle', 'DEV-SOL-255', 74.90, TRUE),

        ('DIX-010', 'Distribuidora Escolar del Centro', 'DEC-DIX-301', 68.50, TRUE),

        ('PHD-010', 'Suministros Creativos', 'SC-PHD-301', 185.00, TRUE)
) AS relation (
    "sku",
    "supplier_name",
    "supplier_code",
    "last_purchase_price",
    "active"
)
JOIN "product" AS product
    ON product."sku" = relation."sku"
JOIN "supplier" AS supplier
    ON supplier."name" = relation."supplier_name"
ON CONFLICT ("product_id", "supplier_id") DO NOTHING;