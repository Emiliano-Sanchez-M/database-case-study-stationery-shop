-- SEED: PAYMENT
--
-- Los pagos se relacionan con las ventas y los metodos de pago a travez
-- de identificadores naturales, evitando depender de IDs fijos generados
-- por la base de datos.
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.
--
-- La distribucion de pagos representa diferentes escenarios, por ejemplo:
-- pagos completos, pagos divididos, pagos pendientes, intentos fallidos
-- y reembolsos.
--
-- Los importes corresponden a los totales calculados por el trigger de la tabla 
-- sale a partir de sus sale_item correspondientes.


WITH seed_payments (
    sale_id,
    payment_method_name,
    amount,
    status,
    reference,
    created_at
) AS (
    VALUES
    -- VENTAS COMPLETADAS
    (
        1,
        'Efectivo',
        19.72,
        'COMPLETED',
        NULL,
        '2026-08-01 09:22:00'::TIMESTAMP
    ),
    (
        2,
        'Tarjeta de debito',
        43.50,
        'COMPLETED',
        'CARD-DEB-20260801-0001',
        '2026-08-01 10:45:00'::TIMESTAMP
    ),
    (
        3,
        'Efectivo',
        53.36,
        'COMPLETED',
        NULL,
        '2026-08-02 11:31:00'::TIMESTAMP
    ),
    -- Venta 5: pago dividido
    (
        5,
        'Efectivo',
        3.48,
        'COMPLETED',
        NULL,
        '2026-08-03 09:18:00'::TIMESTAMP
    ),
    -- Venta 7: pago dividido
    (
        7,
        'Efectivo',
        10.00,
        'COMPLETED',
        NULL,
        '2026-08-04 10:21:00'::TIMESTAMP
    ),
    (
        7,
        'Mercado Pago',
        15.98,
        'COMPLETED',
        'MP-20260804-0001',
        '2026-08-04 10:21:30'::TIMESTAMP
    ),
    (
        8,
        'Tarjeta de credito',
        74.24,
        'COMPLETED',
        'CARD-CRE-20260804-0001',
        '2026-08-04 16:34:00'::TIMESTAMP
    ),
    (
        10,
        'Transferencia bancaria',
        192.10,
        'COMPLETED',
        'TRF-20260805-0001',
        '2026-08-05 12:02:00'::TIMESTAMP
    ),
    (
        12,
        'Efectivo',
        4.06,
        'COMPLETED',
        NULL,
        '2026-08-06 14:35:00'::TIMESTAMP
    ),
    -- Venta 13: pago dividido
    (
        13,
        'Efectivo',
        30.00,
        'COMPLETED',
        NULL,
        '2026-08-07 09:32:00'::TIMESTAMP
    ),
    (
        13,
        'Tarjeta de debito',
        36.12,
        'COMPLETED',
        'CARD-DEB-20260807-0001',
        '2026-08-07 09:32:30'::TIMESTAMP
    ),
    (
        15,
        'Tarjeta de credito',
        136.97,
        'COMPLETED',
        'CARD-CRE-20260808-0001',
        '2026-08-08 10:17:00'::TIMESTAMP
    ),
    -- Venta 17: pago dividido
    (
        17,
        'Efectivo',
        100.00,
        'COMPLETED',
        NULL,
        '2026-08-09 09:16:00'::TIMESTAMP
    ),
    (
        17,
        'Transferencia bancaria',
        178.40,
        'COMPLETED',
        'TRF-20260809-0001',
        '2026-08-09 09:16:30'::TIMESTAMP
    ),
    (
        19,
        'Efectivo',
        97.44,
        'COMPLETED',
        NULL,
        '2026-08-10 11:38:00'::TIMESTAMP
    ),
    -- Venta 21 tiene total 0.00, por lo que no puede tener payment.
    (
        23,
        'Efectivo',
        1.16,
        'COMPLETED',
        NULL,
        '2026-08-12 10:43:00'::TIMESTAMP
    ),
    -- Venta 24: pago dividido
    (
        24,
        'Efectivo',
        100.00,
        'COMPLETED',
        NULL,
        '2026-08-12 16:15:00'::TIMESTAMP
    ),
    (
        24,
        'Pago con CoDi',
        260.18,
        'COMPLETED',
        'CODI-20260812-0001',
        '2026-08-12 16:15:30'::TIMESTAMP
    ),
    (
        26,
        'Efectivo',
        67.28,
        'COMPLETED',
        NULL,
        '2026-08-14 09:54:00'::TIMESTAMP
    ),
    -- Venta 28
    (
        28,
        'Tarjeta de credito',
        320.16,
        'COMPLETED',
        'CARD-CRE-20260815-0001',
        '2026-08-15 10:33:00'::TIMESTAMP
    ),
    -- Venta 30
    (
        30,
        'Efectivo',
        100.00,
        'COMPLETED',
        NULL,
        '2026-08-16 09:47:00'::TIMESTAMP
    ),
    (
        30,
        'Tarjeta de debito',
        155.66,
        'COMPLETED',
        'CARD-DEB-20260816-0001',
        '2026-08-16 09:47:30'::TIMESTAMP
    ),
    (
        31,
        'Mercado Pago',
        88.16,
        'COMPLETED',
        'MP-20260816-0001',
        '2026-08-16 12:31:00'::TIMESTAMP
    ),
    (
        33,
        'Transferencia bancaria',
        290.00,
        'COMPLETED',
        'TRF-20260817-0001',
        '2026-08-17 14:41:00'::TIMESTAMP
    ),
    (
        35,
        'Efectivo',
        37.35,
        'COMPLETED',
        NULL,
        '2026-08-18 13:55:00'::TIMESTAMP
    ),
    (
        37,
        'Tarjeta de debito',
        20.88,
        'COMPLETED',
        'CARD-DEB-20260819-0001',
        '2026-08-19 11:48:00'::TIMESTAMP
    ),
    -- Venta 38: pago dividido
    (
        38,
        'Efectivo',
        300.00,
        'COMPLETED',
        NULL,
        '2026-08-19 16:19:00'::TIMESTAMP
    ),
    (
        38,
        'Tarjeta de credito',
        430.80,
        'COMPLETED',
        'CARD-CRE-20260819-0001',
        '2026-08-19 16:19:30'::TIMESTAMP
    ),
    -- Venta 40
    (
        40,
        'Deposito bancario',
        106.72,
        'COMPLETED',
        'DEP-20260820-0001',
        '2026-08-20 10:58:00'::TIMESTAMP
    ),
    -- Venta 41
    (
        41,
        'Tarjeta de credito',
        522.00,
        'COMPLETED',
        'CARD-CRE-20260820-0001',
        '2026-08-20 12:25:00'::TIMESTAMP
    ),
    -- VENTAS PENDIENTES
    (
        4,
        'Pago pendiente',
        1.74,
        'PENDING',
        NULL,
        '2026-08-02 13:11:00'::TIMESTAMP
    ),
    (
        9,
        'Tarjeta de credito',
        167.04,
        'PENDING',
        'CARD-PEND-20260805-0001',
        '2026-08-05 09:41:00'::TIMESTAMP
    ),
    (
        16,
        'Transferencia bancaria',
        190.24,
        'PENDING',
        'TRF-PEND-20260808-0001',
        '2026-08-08 15:21:00'::TIMESTAMP
    ),
    (
        22,
        'Pago con CoDi',
        243.60,
        'PENDING',
        'CODI-PEND-20260811-0001',
        '2026-08-11 13:26:00'::TIMESTAMP
    ),
    (
        29,
        'Efectivo',
        65.00,
        'PENDING',
        NULL,
        '2026-08-15 15:41:00'::TIMESTAMP
    ),
    (
        36,
        'Tarjeta de debito',
        3.48,
        'PENDING',
        'CARD-PEND-20260819-0002',
        '2026-08-19 09:16:00'::TIMESTAMP
    ),
    (
        39,
        'Transferencia bancaria',
        123.66,
        'PENDING',
        'TRF-PEND-20260820-0001',
        '2026-08-20 09:31:00'::TIMESTAMP
    ),
    -- VENTAS CANCELADAS
    (
        6,
        'Tarjeta de credito',
        8.12,
        'FAILED',
        'CARD-FAIL-20260803-0001',
        '2026-08-03 12:35:00'::TIMESTAMP
    ),
    (
        14,
        'Transferencia bancaria',
        83.52,
        'FAILED',
        'TRF-FAIL-20260807-0001',
        '2026-08-07 13:55:00'::TIMESTAMP
    ),
    (
        20,
        'Tarjeta de debito',
        452.40,
        'FAILED',
        'CARD-FAIL-20260810-0001',
        '2026-08-10 17:20:00'::TIMESTAMP
    ),
    (
        27,
        'Mercado Pago',
        96.51,
        'FAILED',
        'MP-FAIL-20260814-0001',
        '2026-08-14 14:25:00'::TIMESTAMP
    ),
    (
        32,
        'Efectivo',
        48.72,
        'FAILED',
        NULL,
        '2026-08-17 11:10:00'::TIMESTAMP
    ),
    -- VENTAS REEMBOLSADAS
    (
        11,
        'Tarjeta de credito',
        10.44,
        'REFUNDED',
        'REF-CARD-20260806-0001',
        '2026-08-06 10:30:00'::TIMESTAMP
    ),
    (
        18,
        'Mercado Pago',
        139.20,
        'REFUNDED',
        'REF-MP-20260809-0001',
        '2026-08-09 13:00:00'::TIMESTAMP
    ),
    (
        25,
        'Tarjeta de debito',
        58.00,
        'REFUNDED',
        'REF-CARD-20260813-0001',
        '2026-08-13 11:35:00'::TIMESTAMP
    ),
    (
        34,
        'Transferencia bancaria',
        22.18,
        'REFUNDED',
        'REF-TRF-20260818-0001',
        '2026-08-18 10:35:00'::TIMESTAMP
    )
)
INSERT INTO
    "payment" (
        "sale_id",
        "payment_method_id",
        "amount",
        "status",
        "reference",
        "user_id",
        "created_at"
    )
SELECT
    seed_payments.sale_id,
    payment_method.id,
    seed_payments.amount,
    seed_payments.status,
    seed_payments.reference,
    sale.user_id,
    seed_payments.created_at
FROM
    seed_payments
INNER JOIN
    "sale" AS sale
    ON sale.id = seed_payments.sale_id
INNER JOIN
    "payment_method" AS payment_method
    ON payment_method.name = seed_payments.payment_method_name
ON CONFLICT DO NOTHING;