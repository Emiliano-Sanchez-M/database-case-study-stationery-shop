-- PRODUCTOS CON SU MARCA
SELECT
    product.id,
    product.sku,
    product.name,
    brand.name AS brand_name,
    product.sale_price,
    product.active
FROM
    "product" AS product
INNER JOIN
    "brand" AS brand
    ON product.brand_id = brand.id
ORDER BY
    brand.name,
    product.name;



-- PRODUCTOS AGRUPADOS POR MARCA
SELECT
    brand.name AS brand_name,
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.active
FROM
    "brand" AS brand
INNER JOIN
    "product" AS product
    ON product.brand_id = brand.id
ORDER BY
    brand.name,
    product.name;



-- CANTIDAD DE PRODUCTOS POR MARCA
SELECT
    brand.id,
    brand.name AS brand_name,
    COUNT(product.id) AS product_count
FROM
    "brand" AS brand
LEFT JOIN
    "product" AS product
    ON product.brand_id = brand.id
GROUP BY
    brand.id,
    brand.name
ORDER BY
    product_count DESC,
    brand.name;



-- PRODUCTOS DE UNA MARCA ESPECIFICA
SELECT
    product.id,
    product.sku,
    product.name,
    brand.name AS brand_name,
    product.sale_price,
    product.active
FROM
    "product" AS product
INNER JOIN
    "brand" AS brand
    ON product.brand_id = brand.id
WHERE
    brand.name = 'Norma'
ORDER BY
    product.name;



-- PRODUCTOS ACTIVOS POR MARCA
SELECT
    brand.id,
    brand.name AS brand_name,
    product.id AS product_id,
    product.sku,
    product.name,
    product.sale_price
FROM
    "brand" AS brand
INNER JOIN
    "product" AS product
    ON product.brand_id = brand.id
WHERE
    product.active = TRUE
ORDER BY
    brand.name,
    product.name;



-- PRODUCTOS INACTIVOS POR MARCA
SELECT
    brand.id,
    brand.name AS brand_name,
    product.id AS product_id,
    product.sku,
    product.name,
    product.sale_price
FROM
    "brand" AS brand
INNER JOIN
    "product" AS product
    ON product.brand_id = brand.id
WHERE
    product.active = FALSE
ORDER BY
    brand.name,
    product.name;


-- MARCAS SIN PRODUCTOS
SELECT
    brand.id,
    brand.name,
    brand.description,
    brand.active
FROM
    "brand" AS brand
LEFT JOIN
    "product" AS product
    ON product.brand_id = brand.id
WHERE
    product.id IS NULL
ORDER BY
    brand.name;



-- MARCAS CON MAYOR CANTIDAD DE PRODUCTOS
SELECT
    brand.id,
    brand.name,
    COUNT(product.id) AS product_count
FROM
    "brand" AS brand
LEFT JOIN
    "product" AS product
    ON product.brand_id = brand.id
GROUP BY
    brand.id,
    brand.name
ORDER BY
    product_count DESC,
    brand.name;



-- MARCAS CON MENOR CANTIDAD DE PRODUCTOS
SELECT
    brand.id,
    brand.name,
    COUNT(product.id) AS product_count
FROM
    "brand" AS brand
LEFT JOIN
    "product" AS product
    ON product.brand_id = brand.id
GROUP BY
    brand.id,
    brand.name
ORDER BY
    product_count ASC,
    brand.name;



-- PRECIO PROMEDIO POR MARCA
SELECT
    brand.id,
    brand.name,
    ROUND(AVG(product.sale_price), 2) AS average_sale_price
FROM
    "brand" AS brand
INNER JOIN
    "product" AS product
    ON product.brand_id = brand.id
GROUP BY
    brand.id,
    brand.name
ORDER BY
    average_sale_price DESC,
    brand.name;



-- BUSCAR PRODUCTOS POR MARCA
SELECT
    product.id,
    product.sku,
    product.name,
    brand.name AS brand_name,
    product.sale_price,
    product.active
FROM
    "product" AS product
INNER JOIN
    "brand" AS brand
    ON product.brand_id = brand.id
WHERE
    brand.name ILIKE '%Norma%'
ORDER BY
    product.name;