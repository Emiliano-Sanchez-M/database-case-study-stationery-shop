-- SEED: DATOS FISCALES
-- Inserta datos fiscales representativos para desarrollo y pruebas.
--
-- Los valores son ficticios y estan destinados únicamente al
-- desarrollo local y a pruebas de base de datos.
--
-- Solo una parte de los clientes cuenta con datos fiscales,
-- permitiendo probar consultas de clientes con y sin informacion
-- fiscal.


-- Los customer_id se obtienen mediante una consulta a partir de
-- los datos del cliente en lugar de utilizar valores numericos
-- directamente.
--
-- Esto evita depender de los valores generados por la columna
-- IDENTITY y permite ejecutar la seed sobre una base de datos
-- donde los identificadores puedan ser diferentes.
--
-- La consulta identifica al cliente mediante sus datos personales,
-- permitiendo mantener la relacion con fiscal_data sin asumir
-- identificadores especificos.

INSERT INTO
    "fiscal_data" (
        "customer_id",
        "tax_id",
        "legal_name",
        "tax_regime",
        "postal_code",
        "fiscal_use"
    )
VALUES
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Alejandro'
              AND "paternal_last_name" = 'Ramirez'
              AND "maternal_last_name" = 'Torres'
        ),
        'RATA010101AAA',
        'Alejandro Ramirez Torres',
        '612',
        '01000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Beatriz'
              AND "paternal_last_name" = 'Morales'
              AND "maternal_last_name" = 'Hernandez'
        ),
        'MOHB020202BBB',
        'Beatriz Morales Hernandez',
        '612',
        '02000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Carlos'
              AND "paternal_last_name" = 'Gonzalez'
              AND "maternal_last_name" = 'Martinez'
        ),
        'GOMC030303CCC',
        'Carlos Gonzalez Martinez',
        '601',
        '03000',
        'G01'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Diana'
              AND "paternal_last_name" = 'Lopez'
              AND "maternal_last_name" = 'Garcia'
        ),
        'LOGD040404DDD',
        'Diana Lopez Garcia',
        '612',
        '04000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Eduardo'
              AND "paternal_last_name" = 'Martinez'
              AND "maternal_last_name" = 'Ruiz'
        ),
        'MARE050505EEE',
        'Eduardo Martinez Ruiz',
        '626',
        '05000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Fernanda'
              AND "paternal_last_name" = 'Castillo'
              AND "maternal_last_name" = 'Mendoza'
        ),
        'CAMF060606FFF',
        'Fernanda Castillo Mendoza',
        '612',
        '06000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Gabriel'
              AND "paternal_last_name" = 'Torres'
              AND "maternal_last_name" = 'Ramirez'
        ),
        'TORG070707GGG',
        'Gabriel Torres Ramirez',
        '601',
        '07000',
        'G01'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Hilda'
              AND "paternal_last_name" = 'Navarro'
              AND "maternal_last_name" = 'Flores'
        ),
        'NAFH080808HHH',
        'Hilda Navarro Flores',
        '612',
        '08000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Ivan'
              AND "paternal_last_name" = 'Sanchez'
              AND "maternal_last_name" = 'Vargas'
        ),
        'SAVI090909III',
        'Ivan Sanchez Vargas',
        '612',
        '09000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Julieta'
              AND "paternal_last_name" = 'Rojas'
              AND "maternal_last_name" = 'Morales'
        ),
        'ROMJ101010JJJ',
        'Julieta Rojas Morales',
        '626',
        '10000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Kevin'
              AND "paternal_last_name" = 'Hernandez'
              AND "maternal_last_name" = 'Cruz'
        ),
        'HEKC111111KKK',
        'Kevin Hernandez Cruz',
        '612',
        '11000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Laura'
              AND "paternal_last_name" = 'Vargas'
              AND "maternal_last_name" = 'Jimenez'
        ),
        'VAJL121212LLL',
        'Laura Vargas Jimenez',
        '601',
        '12000',
        'G01'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Manuel'
              AND "paternal_last_name" = 'Flores'
              AND "maternal_last_name" = 'Ortega'
        ),
        'FOOM131313MMM',
        'Manuel Flores Ortega',
        '612',
        '13000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Natalia'
              AND "paternal_last_name" = 'Mendoza'
              AND "maternal_last_name" = 'Reyes'
        ),
        'MERN141414NNN',
        'Natalia Mendoza Reyes',
        '626',
        '14000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Oscar'
              AND "paternal_last_name" = 'Ruiz'
              AND "maternal_last_name" = 'Santos'
        ),
        'RUSO151515OOO',
        'Oscar Ruiz Santos',
        '612',
        '15000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Patricia'
              AND "paternal_last_name" = 'Jimenez'
              AND "maternal_last_name" = 'Salazar'
        ),
        'JISP161616PPP',
        'Patricia Jimenez Salazar',
        '601',
        '16000',
        'G01'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Ricardo'
              AND "paternal_last_name" = 'Ortega'
              AND "maternal_last_name" = 'Valdez'
        ),
        'OEVR171717QQQ',
        'Ricardo Ortega Valdez',
        '612',
        '17000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Sofia'
              AND "paternal_last_name" = 'Reyes'
              AND "maternal_last_name" = 'Guerrero'
        ),
        'REGS181818RRR',
        'Sofia Reyes Guerrero',
        '626',
        '18000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Tomas'
              AND "paternal_last_name" = 'Santos'
              AND "maternal_last_name" = 'Mendez'
        ),
        'SAMT191919SSS',
        'Tomas Santos Mendez',
        '612',
        '19000',
        'G03'
    ),
    (
        (
            SELECT "id"
            FROM "customer"
            WHERE "first_name" = 'Valeria'
              AND "paternal_last_name" = 'Salazar'
              AND "maternal_last_name" = 'Fuentes'
        ),
        'SAFV202020TTT',
        'Valeria Salazar Fuentes',
        '601',
        '20000',
        'G01'
    )
ON CONFLICT DO NOTHING;