-- SEED: PAYMENT METHOD
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
"payment_method" (
    "name",
    "type",
    "active"
)
VALUES
(
    'Efectivo',
    'CASH',
    TRUE
),
(
    'Tarjeta de debito',
    'CARD',
    TRUE
),
(
    'Tarjeta de credito',
    'CARD',
    TRUE
),
(
    'Transferencia bancaria',
    'TRANSFER',
    TRUE
),
(
    'Mercado Pago',
    'DIGITAL_WALLET',
    TRUE
),
(
    'Pago con CoDi',
    'DIGITAL_WALLET',
    TRUE
),
(
    'Deposito bancario',
    'TRANSFER',
    TRUE
),
(
    'Cheque',
    'OTHER',
    FALSE
),
(
    'Vale de despensa',
    'OTHER',
    TRUE
),
(
    'Pago pendiente',
    'OTHER',
    FALSE
)
ON CONFLICT DO NOTHING;