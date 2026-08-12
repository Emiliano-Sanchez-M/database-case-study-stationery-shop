-- CLIENTES REGISTRADOS
SELECT
    customer.id,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES ACTIVOS
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email
FROM
    "customer" AS customer
WHERE
    customer.active = TRUE
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES INACTIVOS
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
WHERE
    customer.active = FALSE
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES CON TELEFONO
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
WHERE
    customer.phone IS NOT NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES SIN TELEFONO
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
WHERE
    customer.phone IS NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;

-- CLIENTES CON CORREO
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
WHERE
    customer.email IS NOT NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES SIN CORREO
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
WHERE
    customer.email IS NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CANTIDAD DE CLIENTES
SELECT
    COUNT(*) AS total_clientes
FROM
    "customer";



-- CANTIDAD DE CLIENTES ACTIVOS E INACTIVOS
SELECT
    customer.active,
    COUNT(*) AS cantidad_clientes
FROM
    "customer" AS customer
GROUP BY
    customer.active
ORDER BY
    customer.active DESC;



--  CLIENTES REGISTRADOS RECIENTEMENTE
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.created_at,
    customer.active
FROM
    "customer" AS customer
WHERE
    customer.created_at >= CURRENT_TIMESTAMP - INTERVAL '30 days'
ORDER BY
    customer.created_at DESC;



--  CLIENTES CON INFORMACION DE CONTACTO COMPLETA
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
WHERE
    customer.phone IS NOT NULL
    AND customer.email IS NOT NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



--  CLIENTES CON INFORMACION DE CONTACTO INCOMPLETA
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.phone,
    customer.email,
    customer.active
FROM
    "customer" AS customer
WHERE
    (
        customer.phone IS NOT NULL
        AND customer.email IS NULL
    )
    OR
    (
        customer.phone IS NULL
        AND customer.email IS NOT NULL
    )
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;