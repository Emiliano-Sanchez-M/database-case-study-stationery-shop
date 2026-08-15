-- PRODUCTOS CON SU CATEGORIA
SELECT
    product.id,
    product.sku,
    product.name,
    category.id AS category_id,
    category.name AS category_name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
ORDER BY category.name, product.name;



-- PRODUCTOS AGRUPADOS POR CATEGORIA
SELECT category.name AS category_name, product.id, product.sku, product.name, product.sale_price, product.active
FROM
    "category" AS category
    INNER JOIN "product" AS product ON product.category_id = category.id
ORDER BY category.name, product.name;



-- PRODUCTOS DE UNA CATEGORIA ESPECIFICA
SELECT product.id, product.sku, product.name, category.name AS category_name, product.sale_price, product.cost_price, product.active
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
WHERE
    category.name = 'Cuadernos'
ORDER BY product.name;



-- PRODUCTOS ACTIVOS POR CATEGORIA
SELECT
    category.id AS category_id,
    category.name AS category_name,
    product.id AS product_id,
    product.sku,
    product.name,
    product.sale_price
FROM
    "category" AS category
    INNER JOIN "product" AS product ON product.category_id = category.id
WHERE
    product.active = TRUE
ORDER BY category.name, product.name;



-- PRODUCTOS INACTIVOS POR CATEGORIA
SELECT
    category.id AS category_id,
    category.name AS category_name,
    product.id AS product_id,
    product.sku,
    product.name,
    product.sale_price
FROM
    "category" AS category
    INNER JOIN "product" AS product ON product.category_id = category.id
WHERE
    product.active = FALSE
ORDER BY category.name, product.name;



-- CATEGORIAS SIN PRODUCTOS
SELECT category.id, category.name, category.description, category.active
FROM
    "category" AS category
    LEFT JOIN "product" AS product ON product.category_id = category.id
WHERE
    product.id IS NULL
ORDER BY category.name;



-- CATEGORIAS CON MAYOR CANTIDAD DE PRODUCTOS
SELECT category.id, category.name, COUNT(product.id) AS product_count
FROM
    "category" AS category
    LEFT JOIN "product" AS product ON product.category_id = category.id
GROUP BY
    category.id,
    category.name
ORDER BY product_count DESC, category.name
LIMIT 10;



-- CATEGORIAS CON MENOR CANTIDAD DE PRODUCTOS
SELECT category.id, category.name, COUNT(product.id) AS product_count
FROM
    "category" AS category
    LEFT JOIN "product" AS product ON product.category_id = category.id
GROUP BY
    category.id,
    category.name
ORDER BY product_count ASC, category.name
LIMIT 10;



-- PRECIO PROMEDIO POR CATEGORIA
SELECT
    category.id,
    category.name AS category_name,
    ROUND(AVG(product.sale_price), 2) AS average_sale_price
FROM
    "category" AS category
    INNER JOIN "product" AS product ON product.category_id = category.id
GROUP BY
    category.id,
    category.name
ORDER BY average_sale_price DESC, category.name;



-- COSTO PROMEDIO POR CATEGORIA
SELECT
    category.id,
    category.name AS category_name,
    ROUND(AVG(product.cost_price), 2) AS average_cost
FROM
    "category" AS category
    INNER JOIN "product" AS product ON product.category_id = category.id
GROUP BY
    category.id,
    category.name
ORDER BY average_cost DESC, category.name;



-- MARGEN PROMEDIO POR CATEGORIA
SELECT
    category.id,
    category.name AS category_name,
    ROUND(
        AVG(
            product.sale_price - product.cost_price
        ),
        2
    ) AS average_profit_margin
FROM
    "category" AS category
    INNER JOIN "product" AS product ON product.category_id = category.id
GROUP BY
    category.id,
    category.name
ORDER BY average_profit_margin DESC, category.name;



-- PRODUCTOS CON CATEGORIA Y MARCA
SELECT
    product.id,
    product.sku,
    product.name,
    category.name AS category_name,
    brand.name AS brand_name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
    LEFT JOIN "brand" AS brand ON product.brand_id = brand.id
ORDER BY category.name, brand.name, product.name;



-- PRODUCTOS AGRUPADOS POR CATEGORIA Y MARCA
SELECT
    category.name AS category_name,
    brand.name AS brand_name,
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.active
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
    LEFT JOIN "brand" AS brand ON product.brand_id = brand.id
ORDER BY category.name, brand.name, product.name;



-- CANTIDAD DE PRODUCTOS POR CATEGORIA Y MARCA
SELECT
    category.id AS category_id,
    category.name AS category_name,
    brand.id AS brand_id,
    brand.name AS brand_name,
    COUNT(product.id) AS product_count
FROM
    "category" AS category
    INNER JOIN "product" AS product ON product.category_id = category.id
    LEFT JOIN "brand" AS brand ON product.brand_id = brand.id
GROUP BY
    category.id,
    category.name,
    brand.id,
    brand.name
ORDER BY category.name, product_count DESC, brand.name;



-- PRODUCTOS DE UNA CATEGORIA Y MARCA ESPECIFICAS
SELECT
    product.id,
    product.sku,
    product.name,
    category.name AS category_name,
    brand.name AS brand_name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
    INNER JOIN "brand" AS brand ON product.brand_id = brand.id
WHERE
    category.name = 'Colores'
    AND brand.name = 'Norma'
ORDER BY product.name;



-- PRODUCTOS ACTIVOS POR CATEGORIA Y MARCA
SELECT
    product.id,
    product.sku,
    product.name,
    category.name AS category_name,
    brand.name AS brand_name,
    product.sale_price
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
    LEFT JOIN "brand" AS brand ON product.brand_id = brand.id
WHERE
    product.active = TRUE
ORDER BY category.name, brand.name, product.name;



-- PRODUCTOS SIN MARCA CON SU CATEGORIA
SELECT
    product.id,
    product.sku,
    product.name,
    category.id AS category_id,
    category.name AS category_name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
WHERE
    product.brand_id IS NULL
ORDER BY category.name, product.name;



-- BUSCAR PRODUCTOS POR CATEGORIA
SELECT
    product.id,
    product.sku,
    product.name,
    category.name AS category_name,
    brand.name AS brand_name,
    product.sale_price,
    product.active
FROM
    "product" AS product
    INNER JOIN "category" AS category ON product.category_id = category.id
    LEFT JOIN "brand" AS brand ON product.brand_id = brand.id
WHERE
    category.name ILIKE '%cuadernos%'
ORDER BY product.name;