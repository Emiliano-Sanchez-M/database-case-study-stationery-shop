-- SEED: ROLES USUARIOS
-- Asigna los roles predeterminados a los usuarios del sistema.
--
-- Los valores son ficticios, y estan destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
    "user_role" ("user_id", "role_id")
SELECT
    "user"."id",
    "role"."id"
FROM
    "user"
    CROSS JOIN "role"
WHERE
    (
        "user"."username" = 'admin'
        AND "role"."name" = 'ADMIN'
    )
    OR (
        "user"."username" IN (
            'mlopez',
            'jrodriguez'
        )
        AND "role"."name" = 'MANAGER'
    )
    OR (
        "user"."username" IN (
            'agarcia',
            'lhernandez',
            'srojas',
            'dcastillo'
        )
        AND "role"."name" = 'CASHIER'
    )
    OR (
        "user"."username" IN (
            'pmartinez',
            'cnavarro',
            'rortiz',
            'fernando.silva'
        )
        AND "role"."name" = 'INVENTORY_MANAGER'
    )
    OR (
        "user"."username" IN (
            'lucia.mendoza',
            'miguel.torres',
            'natalia.vargas'
        )
        AND "role"."name" = 'PURCHASER'
    )
    OR (
        "user"."username" IN (
            'roberto.morales',
            'elena.jimenez',
            'andres.ruiz',
            'gabriela.castro',
            'hector.santos',
            'monica.ortega',
            'oscar.reyes',
            'karla.mendez'
        )
        AND "role"."name" = 'SALES'
    )
ON CONFLICT ("user_id", "role_id") DO NOTHING;