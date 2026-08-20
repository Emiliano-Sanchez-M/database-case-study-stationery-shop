-- SEED: SALE_ITEM
--
-- Inserta los detalles de las ventas existentes.
--
-- Las ventas corresponden a los 41 registros insertados previamente
-- en la tabla "sale".
--
-- Los precios de productos y servicios se obtienen directamente
-- de sus respectivas tablas para evitar duplicar información.
--
-- La descripción representa el valor histórico mostrado al momento
-- de realizar la venta.
--
-- El campo "subtotal" representa el importe bruto de la línea:
-- quantity * unit_price.
--
-- El descuento se almacena por separado en "discount_amount".
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO "sale_item" (
    "sale_id",
    "product_id",
    "service_id",
    "description",
    "quantity",
    "unit_price",
    "discount_id",
    "discount_type",
    "discount_value",
    "discount_amount",
    "tax",
    "subtotal"
)
VALUES
-- SALE 1
(
    1,
    1,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 1),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 1),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 1)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 1),
        2
    )
),
-- SALE 2
(
    2,
    2,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 2),
    3.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 2),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            3.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 2)
        ) * 0.16,
        2
    ),
    ROUND(
        3.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 2),
        2
    )
),
-- SALE 3
(
    3,
    3,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 3),
    5.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 3),
    5,
    'PERCENTAGE',
    8.00,
    ROUND(
        (
            5.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 3)
        ) * 0.08,
        2
    ),
    ROUND(
        (
            (
                5.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 3)
            ) -
            (
                5.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 3)
            ) * 0.08
        ) * 0.16,
        2
    ),
    ROUND(
        5.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 3),
        2
    )
),
-- SALE 4 - SERVICE
(
    4,
    NULL,
    1,
    (SELECT "name" FROM "service" WHERE "id" = 1),
    1.000,
    (
        SELECT "unit_price"
        FROM "service_rate"
        WHERE "service_id" = 1
          AND "active" = TRUE
        ORDER BY "id"
        LIMIT 1
    ),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 1
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ) * 0.16,
        2
    ),
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 1
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ),
        2
    )
),
-- SALE 5
(
    5,
    4,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 4),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 4),
    3,
    'FIXED_AMOUNT',
    20.00,
    LEAST(
        20.00,
        ROUND(
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 4),
            2
        )
    ),
    ROUND(
        (
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 4)
            ) -
            LEAST(
                20.00,
                ROUND(
                    2.000 *
                    (SELECT "sale_price" FROM "product" WHERE "id" = 4),
                    2
                )
            )
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 4),
        2
    )
),
-- SALE 6
(
    6,
    5,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 5),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 5),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 5) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 5),
        2
    )
),
-- SALE 7
(
    7,
    6,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 6),
    4.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 6),
    7,
    'PERCENTAGE',
    20.00,
    ROUND(
        (
            4.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 6)
        ) * 0.20,
        2
    ),
    ROUND(
        (
            (
                4.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 6)
            ) -
            (
                4.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 6)
            ) * 0.20
        ) * 0.16,
        2
    ),
    ROUND(
        4.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 6),
        2
    )
),
-- SALE 8
(
    8,
    7,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 7),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 7),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 7)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 7),
        2
    )
),
-- SALE 9
(
    9,
    8,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 8),
    3.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 8),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            3.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 8)
        ) * 0.16,
        2
    ),
    ROUND(
        3.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 8),
        2
    )
),
-- SALE 10
(
    10,
    9,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 9),
    10.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 9),
    5,
    'PERCENTAGE',
    8.00,
    ROUND(
        (
            10.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 9)
        ) * 0.08,
        2
    ),
    ROUND(
        (
            (
                10.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 9)
            ) -
            (
                10.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 9)
            ) * 0.08
        ) * 0.16,
        2
    ),
    ROUND(
        10.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 9),
        2
    )
),
-- SALE 11
(
    11,
    10,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 10),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 10),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 10) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 10),
        2
    )
),
-- SALE 12 - SERVICE
(
    12,
    NULL,
    2,
    (SELECT "name" FROM "service" WHERE "id" = 2),
    1.000,
    (
        SELECT "unit_price"
        FROM "service_rate"
        WHERE "service_id" = 2
          AND "active" = TRUE
        ORDER BY "id"
        LIMIT 1
    ),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 2
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ) * 0.16,
        2
    ),
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 2
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ),
        2
    )
),
-- SALE 13
(
    13,
    11,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 11),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 11),
    13,
    'PERCENTAGE',
    25.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 11)
        ) * 0.25,
        2
    ),
    ROUND(
        (
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 11)
            ) -
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 11)
            ) * 0.25
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 11),
        2
    )
),
-- SALE 14
(
    14,
    12,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 12),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 12),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 12) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 12),
        2
    )
),
-- SALE 15
(
    15,
    13,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 13),
    3.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 13),
    17,
    'PERCENTAGE',
    18.00,
    ROUND(
        (
            3.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 13)
        ) * 0.18,
        2
    ),
    ROUND(
        (
            (
                3.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 13)
            ) -
            (
                3.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 13)
            ) * 0.18
        ) * 0.16,
        2
    ),
    ROUND(
        3.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 13),
        2
    )
),
-- SALE 16
(
    16,
    14,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 14),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 14),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 14)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 14),
        2
    )
),
-- SALE 17
(
    17,
    15,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 15),
    4.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 15),
    3,
    'FIXED_AMOUNT',
    20.00,
    LEAST(
        20.00,
        ROUND(
            4.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 15),
            2
        )
    ),
    ROUND(
        (
            (
                4.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 15)
            ) -
            LEAST(
                20.00,
                ROUND(
                    4.000 *
                    (SELECT "sale_price" FROM "product" WHERE "id" = 15),
                    2
                )
            )
        ) * 0.16,
        2
    ),
    ROUND(
        4.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 15),
        2
    )
),
-- SALE 18
(
    18,
    16,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 16),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 16),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 16) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 16),
        2
    )
),
-- SALE 19
(
    19,
    17,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 17),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 17),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 17)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 17),
        2
    )
),
-- SALE 20
(
    20,
    18,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 18),
    5.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 18),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            5.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 18)
        ) * 0.16,
        2
    ),
    ROUND(
        5.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 18),
        2
    )
),
-- SALE 21
(
    21,
    19,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 19),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 19),
    19,
    'FIXED_AMOUNT',
    150.00,
    LEAST(
        150.00,
        ROUND(
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 19),
            2
        )
    ),
    ROUND(
        (
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 19)
            ) -
            LEAST(
                150.00,
                ROUND(
                    2.000 *
                    (SELECT "sale_price" FROM "product" WHERE "id" = 19),
                    2
                )
            )
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 19),
        2
    )
),
-- SALE 22
(
    22,
    20,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 20),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 20),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 20) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 20),
        2
    )
),
-- SALE 23 - SERVICE
(
    23,
    NULL,
    3,
    (SELECT "name" FROM "service" WHERE "id" = 3),
    1.000,
    (
        SELECT "unit_price"
        FROM "service_rate"
        WHERE "service_id" = 3
          AND "active" = TRUE
        ORDER BY "id"
        LIMIT 1
    ),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 3
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ) * 0.16,
        2
    ),
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 3
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ),
        2
    )
),
-- SALE 24
(
    24,
    21,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 21),
    3.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 21),
    20,
    'PERCENTAGE',
    10.00,
    ROUND(
        (
            3.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 21)
        ) * 0.10,
        2
    ),
    ROUND(
        (
            (
                3.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 21)
            ) -
            (
                3.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 21)
            ) * 0.10
        ) * 0.16,
        2
    ),
    ROUND(
        3.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 21),
        2
    )
),
-- SALE 25
(
    25,
    22,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 22),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 22),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 22)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 22),
        2
    )
),
-- SALE 26
(
    26,
    23,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 23),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 23),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 23) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 23),
        2
    )
),
-- SALE 27
(
    27,
    24,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 24),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 24),
    7,
    'PERCENTAGE',
    20.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 24)
        ) * 0.20,
        2
    ),
    ROUND(
        (
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 24)
            ) -
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 24)
            ) * 0.20
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 24),
        2
    )
),
-- SALE 28
(
    28,
    25,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 25),
    3.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 25),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            3.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 25)
        ) * 0.16,
        2
    ),
    ROUND(
        3.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 25),
        2
    )
),
-- SALE 29
(
    29,
    26,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 26),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 26),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 26) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 26),
        2
    )
),
-- SALE 30
(
    30,
    27,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 27),
    4.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 27),
    25,
    'PERCENTAGE',
    5.00,
    ROUND(
        (
            4.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 27)
        ) * 0.05,
        2
    ),
    ROUND(
        (
            (
                4.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 27)
            ) -
            (
                4.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 27)
            ) * 0.05
        ) * 0.16,
        2
    ),
    ROUND(
        4.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 27),
        2
    )
),
-- SALE 31
(
    31,
    28,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 28),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 28),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 28)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 28),
        2
    )
),
-- SALE 32
(
    32,
    29,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 29),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 29),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 29) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 29),
        2
    )
),
-- SALE 33
(
    33,
    30,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 30),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 30),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 30)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 30),
        2
    )
),
-- SALE 34
(
    34,
    1,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 1),
    3.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 1),
    13,
    'PERCENTAGE',
    25.00,
    ROUND(
        (
            3.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 1)
        ) * 0.25,
        2
    ),
    ROUND(
        (
            (
                3.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 1)
            ) -
            (
                3.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 1)
            ) * 0.25
        ) * 0.16,
        2
    ),
    ROUND(
        3.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 1),
        2
    )
),
-- SALE 35
(
    35,
    5,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 5),
    5.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 5),
    5,
    'PERCENTAGE',
    8.00,
    ROUND(
        (
            5.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 5)
        ) * 0.08,
        2
    ),
    ROUND(
        (
            (
                5.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 5)
            ) -
            (
                5.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 5)
            ) * 0.08
        ) * 0.16,
        2
    ),
    ROUND(
        5.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 5),
        2
    )
),
-- SALE 36 - SERVICE
(
    36,
    NULL,
    4,
    (SELECT "name" FROM "service" WHERE "id" = 4),
    1.000,
    (
        SELECT "unit_price"
        FROM "service_rate"
        WHERE "service_id" = 4
          AND "active" = TRUE
        ORDER BY "id"
        LIMIT 1
    ),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 4
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ) * 0.16,
        2
    ),
    ROUND(
        (
            SELECT "unit_price"
            FROM "service_rate"
            WHERE "service_id" = 4
              AND "active" = TRUE
            ORDER BY "id"
            LIMIT 1
        ),
        2
    )
),
-- SALE 37
(
    37,
    10,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 10),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 10),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 10)
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 10),
        2
    )
),
-- SALE 38
(
    38,
    20,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 20),
    3.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 20),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (
            3.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 20)
        ) * 0.16,
        2
    ),
    ROUND(
        3.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 20),
        2
    )
),
-- SALE 39
(
    39,
    15,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 15),
    2.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 15),
    17,
    'PERCENTAGE',
    18.00,
    ROUND(
        (
            2.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 15)
        ) * 0.18,
        2
    ),
    ROUND(
        (
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 15)
            ) -
            (
                2.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 15)
            ) * 0.18
        ) * 0.16,
        2
    ),
    ROUND(
        2.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 15),
        2
    )
),
-- SALE 40
(
    40,
    25,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 25),
    1.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 25),
    NULL,
    NULL,
    NULL,
    0.00,
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 25) * 0.16,
        2
    ),
    ROUND(
        (SELECT "sale_price" FROM "product" WHERE "id" = 25),
        2
    )
),
-- SALE 41
(
    41,
    30,
    NULL,
    (SELECT "name" FROM "product" WHERE "id" = 30),
    4.000,
    (SELECT "sale_price" FROM "product" WHERE "id" = 30),
    20,
    'PERCENTAGE',
    10.00,
    ROUND(
        (
            4.000 *
            (SELECT "sale_price" FROM "product" WHERE "id" = 30)
        ) * 0.10,
        2
    ),
    ROUND(
        (
            (
                4.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 30)
            ) -
            (
                4.000 *
                (SELECT "sale_price" FROM "product" WHERE "id" = 30)
            ) * 0.10
        ) * 0.16,
        2
    ),
    ROUND(
        4.000 *
        (SELECT "sale_price" FROM "product" WHERE "id" = 30),
        2
    )
)
ON CONFLICT DO NOTHING;