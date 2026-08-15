-- SEED: RESERVATION CONFIGURATION
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
"reservation_configuration" (
    "minimum_percentage",
    "expiration_days",
    "cancellation_retention_percentage",
    "expiration_retention_percentage",
    "active",
    "created_at",
    "updated_at"
)
VALUES
(
    20.00,
    7,
    10.00,
    20.00,
    FALSE,
    '2024-01-15 09:00:00',
    '2024-06-30 16:30:00'
),
(
    25.00,
    10,
    15.00,
    25.00,
    FALSE,
    '2024-07-01 09:15:00',
    '2025-02-28 17:00:00'
),
(
    30.00,
    15,
    20.00,
    30.00,
    FALSE,
    '2025-03-01 08:30:00',
    '2025-12-31 18:00:00'
),
(
    40.00,
    10,
    25.00,
    35.00,
    FALSE,
    '2026-01-02 09:00:00',
    '2026-07-31 17:45:00'
),
(
    50.00,
    15,
    30.00,
    40.00,
    TRUE,
    '2026-08-01 09:00:00',
    '2026-08-01 09:00:00'
)
ON CONFLICT DO NOTHING;