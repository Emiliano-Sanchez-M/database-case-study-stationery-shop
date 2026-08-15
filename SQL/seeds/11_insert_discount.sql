-- SEED: DISCOUNT
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo en un entorno local y a pruebas de base de datos.

INSERT INTO
"discount" (
    "name",
    "type",
    "value",
    "conditions",
    "starts_at",
    "ends_at",
    "active",
    "created_at",
    "updated_at"
)
VALUES
(
    'Descuento de bienvenida',
    'PERCENTAGE',
    10.00,
    '{"minimum_purchase": 100.00}',
    '2026-01-05 00:00:00',
    NULL,
    TRUE,
    '2026-01-05 09:15:00',
    '2026-01-05 09:15:00'
),
(
    'Regreso a clases',
    'PERCENTAGE',
    15.00,
    '{"categories": ["Cuadernos", "Papeleria escolar"]}',
    '2026-07-15 00:00:00',
    '2026-09-15 23:59:59',
    TRUE,
    '2026-07-10 10:30:00',
    '2026-08-01 12:20:00'
),
(
    'Oferta en colores',
    'FIXED_AMOUNT',
    20.00,
    '{"categories": ["Colores"], "minimum_quantity": 2}',
    '2026-08-01 00:00:00',
    '2026-08-31 23:59:59',
    TRUE,
    '2026-07-28 14:10:00',
    '2026-08-02 08:45:00'
),
(
    'Descuento en productos Norma',
    'PERCENTAGE',
    12.00,
    '{"brands": ["Norma"]}',
    '2026-06-01 00:00:00',
    '2026-06-30 23:59:59',
    FALSE,
    '2026-05-25 11:00:00',
    '2026-07-01 09:30:00'
),
(
    'Compra mayorista',
    'PERCENTAGE',
    8.00,
    '{"minimum_quantity": 10}',
    '2026-01-01 00:00:00',
    NULL,
    TRUE,
    '2025-12-20 16:45:00',
    '2026-01-02 10:15:00'
),
(
    'Descuento de verano',
    'FIXED_AMOUNT',
    50.00,
    '{"minimum_purchase": 500.00}',
    '2026-06-15 00:00:00',
    '2026-07-31 23:59:59',
    FALSE,
    '2026-06-01 13:20:00',
    '2026-08-01 09:10:00'
),
(
    'Promocion lapices',
    'PERCENTAGE',
    20.00,
    '{"products": ["Lapiz Dixon HB"], "minimum_quantity": 3}',
    '2026-08-05 00:00:00',
    '2026-08-20 23:59:59',
    TRUE,
    '2026-08-03 15:30:00',
    '2026-08-05 08:00:00'
),
(
    'Oferta especial septiembre',
    'PERCENTAGE',
    10.00,
    '{"categories": ["Utiles escolares"], "minimum_purchase": 300.00}',
    '2026-09-01 00:00:00',
    '2026-09-30 23:59:59',
    TRUE,
    '2026-08-10 10:00:00',
    '2026-08-10 10:00:00'
),
(
    'Descuento por volumen',
    'FIXED_AMOUNT',
    100.00,
    '{"minimum_quantity": 20}',
    '2026-03-01 00:00:00',
    NULL,
    TRUE,
    '2026-02-20 09:45:00',
    '2026-03-01 09:45:00'
),
(
    'Promocion plastilina',
    'PERCENTAGE',
    15.00,
    '{"brands": ["Play-Doh", "SOL"], "categories": ["Material didactico"]}',
    '2026-05-01 00:00:00',
    '2026-05-31 23:59:59',
    FALSE,
    '2026-04-20 12:00:00',
    '2026-06-01 08:30:00'
),
(
    'Descuento estudiantes',
    'PERCENTAGE',
    5.00,
    '{"customer_type": "STUDENT", "minimum_purchase": 150.00}',
    '2026-01-10 00:00:00',
    NULL,
    TRUE,
    '2026-01-08 14:20:00',
    '2026-01-10 14:20:00'
),
(
    'Promocion fin de semana',
    'FIXED_AMOUNT',
    30.00,
    '{"days_of_week": ["SATURDAY", "SUNDAY"], "minimum_purchase": 250.00}',
    '2026-08-01 00:00:00',
    '2026-12-31 23:59:59',
    TRUE,
    '2026-07-25 10:10:00',
    '2026-08-01 10:10:00'
),
(
    'Oferta cuadernos',
    'PERCENTAGE',
    25.00,
    '{"categories": ["Cuadernos"], "minimum_quantity": 3}',
    '2026-08-10 00:00:00',
    '2026-08-25 23:59:59',
    TRUE,
    '2026-08-08 16:00:00',
    '2026-08-10 09:00:00'
),
(
    'Descuento papeleria basica',
    'PERCENTAGE',
    7.50,
    '{"categories": ["Papeleria basica"]}',
    '2026-02-01 00:00:00',
    NULL,
    TRUE,
    '2026-01-25 11:30:00',
    '2026-02-01 11:30:00'
),
(
    'Liquidacion de temporada',
    'PERCENTAGE',
    40.00,
    '{"categories": ["Regalos", "Decoracion"], "minimum_purchase": 200.00}',
    '2025-11-01 00:00:00',
    '2025-12-31 23:59:59',
    FALSE,
    '2025-10-20 13:00:00',
    '2026-01-02 10:00:00'
),
(
    'Descuento aniversario',
    'FIXED_AMOUNT',
    75.00,
    '{"minimum_purchase": 750.00}',
    '2026-10-01 00:00:00',
    '2026-10-15 23:59:59',
    TRUE,
    '2026-08-12 12:15:00',
    '2026-08-12 12:15:00'
),
(
    'Promocion regreso a clases premium',
    'PERCENTAGE',
    18.00,
    '{"brands": ["Norma", "Dixon"], "minimum_purchase": 400.00}',
    '2026-08-15 00:00:00',
    '2026-09-10 23:59:59',
    TRUE,
    '2026-08-11 15:00:00',
    '2026-08-11 15:00:00'
),
(
    'Descuento material artistico',
    'PERCENTAGE',
    10.00,
    '{"categories": ["Material artistico"]}',
    '2026-04-01 00:00:00',
    '2026-04-30 23:59:59',
    FALSE,
    '2026-03-20 10:30:00',
    '2026-05-01 09:00:00'
),
(
    'Oferta especial compras grandes',
    'FIXED_AMOUNT',
    150.00,
    '{"minimum_purchase": 1500.00, "maximum_discount": 150.00}',
    '2026-08-01 00:00:00',
    NULL,
    TRUE,
    '2026-07-30 14:00:00',
    '2026-08-01 08:30:00'
),
(
    'Descuento primera compra',
    'PERCENTAGE',
    10.00,
    '{"customer_type": "NEW_CUSTOMER"}',
    '2026-01-01 00:00:00',
    NULL,
    TRUE,
    '2025-12-15 09:00:00',
    '2026-01-01 09:00:00'
),
(
    'Promocion escolar antigua',
    'PERCENTAGE',
    20.00,
    '{"categories": ["Utiles escolares"]}',
    '2025-08-01 00:00:00',
    '2025-09-30 23:59:59',
    FALSE,
    '2025-07-15 12:00:00',
    '2025-10-01 08:00:00'
),
(
    'Descuento productos seleccionados',
    'FIXED_AMOUNT',
    25.00,
    '{"products": ["Producto A", "Producto B", "Producto C"]}',
    '2026-07-01 00:00:00',
    '2026-08-31 23:59:59',
    TRUE,
    '2026-06-25 10:45:00',
    '2026-07-01 10:45:00'
),
(
    'Promocion diciembre',
    'PERCENTAGE',
    15.00,
    '{"categories": ["Regalos"], "minimum_purchase": 350.00}',
    '2026-12-01 00:00:00',
    '2026-12-31 23:59:59',
    TRUE,
    '2026-08-13 16:30:00',
    '2026-08-13 16:30:00'
),
(
    'Descuento liquidacion',
    'FIXED_AMOUNT',
    60.00,
    '{"minimum_quantity": 5}',
    '2026-01-15 00:00:00',
    '2026-02-15 23:59:59',
    FALSE,
    '2026-01-10 09:15:00',
    '2026-02-16 08:45:00'
),
(
    'Promocion permanente por volumen',
    'PERCENTAGE',
    5.00,
    '{"minimum_quantity": 50}',
    '2026-03-01 00:00:00',
    NULL,
    TRUE,
    '2026-02-25 11:20:00',
    '2026-03-01 11:20:00'
)
ON CONFLICT DO NOTHING;