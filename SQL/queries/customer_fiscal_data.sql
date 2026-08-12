-- CLIENTES CON DATOS FISCALES
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.email,
    customer.phone,
    fiscal_data.id AS fiscal_data_id
FROM
    "customer" AS customer
INNER JOIN
    fiscal_data
    ON fiscal_data.customer_id = customer.id
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES SIN DATOS FISCALES
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.email,
    customer.phone
FROM
    "customer" AS customer
LEFT JOIN
    fiscal_data
    ON fiscal_data.customer_id = customer.id
WHERE
    fiscal_data.id IS NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES CON INFORMACION FISCAL
SELECT
    customer.id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.email,
    customer.phone,
    fiscal_data.tax_regime,
    fiscal_data.postal_code
FROM
    "customer" AS customer
INNER JOIN
    fiscal_data
    ON fiscal_data.customer_id = customer.id
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- DATOS FISCALES DE UN CLIENTE
SELECT
    customer.id AS customer_id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    fiscal_data.id AS fiscal_data_id,
    fiscal_data.tax_id,
    fiscal_data.legal_name,
    fiscal_data.tax_regime,
    fiscal_data.postal_code,
    fiscal_data.fiscal_use,
    fiscal_data.created_at,
    fiscal_data.updated_at
FROM
    "customer" AS customer
INNER JOIN
    "fiscal_data" AS fiscal_data
    ON fiscal_data.customer_id = customer.id
WHERE
    customer.id = 1;



-- CLIENTES CON INFORMACION FISCAL COMPLETA
SELECT
    customer.id AS customer_id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    fiscal_data.tax_id,
    fiscal_data.legal_name,
    fiscal_data.tax_regime,
    fiscal_data.postal_code,
    fiscal_data.fiscal_use
FROM
    "customer" AS customer
INNER JOIN
    "fiscal_data" AS fiscal_data
    ON fiscal_data.customer_id = customer.id
WHERE
    fiscal_data.tax_id IS NOT NULL
    AND fiscal_data.legal_name IS NOT NULL
    AND fiscal_data.tax_regime IS NOT NULL
    AND fiscal_data.postal_code IS NOT NULL
    AND fiscal_data.fiscal_use IS NOT NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES CON INFORMACION FISCAL INCOMPLETA
SELECT
    customer.id AS customer_id,
    customer.first_name,
    customer.paternal_last_name,
    customer.maternal_last_name,
    fiscal_data.tax_id,
    fiscal_data.legal_name,
    fiscal_data.tax_regime,
    fiscal_data.postal_code,
    fiscal_data.fiscal_use
FROM
    "customer" AS customer
INNER JOIN
    "fiscal_data" AS fiscal_data
    ON fiscal_data.customer_id = customer.id
WHERE
    fiscal_data.tax_id IS NULL
    OR fiscal_data.legal_name IS NULL
    OR fiscal_data.tax_regime IS NULL
    OR fiscal_data.postal_code IS NULL
    OR fiscal_data.fiscal_use IS NULL
ORDER BY
    customer.paternal_last_name,
    customer.maternal_last_name,
    customer.first_name;



-- CLIENTES AGRUPADOS POR REGIMEN FISCAL
SELECT
    fiscal_data.tax_regime,
    COUNT(*) AS customer_count
FROM
    "customer" AS customer
INNER JOIN
    "fiscal_data" AS fiscal_data
    ON fiscal_data.customer_id = customer.id
GROUP BY
    fiscal_data.tax_regime
ORDER BY
    customer_count DESC,
    fiscal_data.tax_regime;



-- CANTIDAD DE CLIENTES CON Y SIN DATOS FISCALES
SELECT
    CASE
        WHEN fiscal_data.id IS NULL THEN 'SIN DATOS FISCALES'
        ELSE 'CON DATOS FISCALES'
    END AS fiscal_status,
    COUNT(*) AS customer_count
FROM
    "customer" AS customer
LEFT JOIN
    "fiscal_data" AS fiscal_data
    ON fiscal_data.customer_id = customer.id
GROUP BY
    fiscal_status
ORDER BY
    fiscal_status;



-- CLIENTES CON DATOS FISCALES POR CODIGO POSTAL
SELECT
    fiscal_data.postal_code,
    COUNT(*) AS customer_count
FROM
    "customer" AS customer
INNER JOIN
    "fiscal_data" AS fiscal_data
    ON fiscal_data.customer_id = customer.id
GROUP BY
    fiscal_data.postal_code
ORDER BY
    customer_count DESC,
    fiscal_data.postal_code;
