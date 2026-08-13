-- PRODUCTOS MAS CAROS
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
ORDER BY
    product.sale_price DESC,
    product.name
LIMIT 10;



-- PRODUCTOS MAS BARATOS
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
ORDER BY
    product.sale_price ASC,
    product.name
LIMIT 10;



-- PRODUCTOS CON PRECIO DE VENTA SUPERIOR A UN VALOR
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
WHERE
    product.sale_price > 100.00
ORDER BY
    product.sale_price DESC,
    product.name;



-- PRODUCTOS CON PRECIO DE VENTA INFERIOR A UN VALOR
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
WHERE
    product.sale_price < 30.00
ORDER BY
    product.sale_price ASC,
    product.name;



-- PRODUCTOS DENTRO DE UN RANGO DE PRECIO
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
WHERE
    product.sale_price BETWEEN 30.00 AND 80.00
ORDER BY
    product.sale_price ASC,
    product.name;



-- PRODUCTOS ORDENADOS POR PRECIO DE VENTA
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
ORDER BY
    product.sale_price ASC,
    product.name;



-- PRODUCTOS ORDENADOS POR COSTO
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    product.active
FROM
    "product" AS product
ORDER BY
    product.cost_price ASC,
    product.name;



-- PRODUCTOS CON MAYOR MARGEN DE GANANCIA
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    (product.sale_price - product.cost_price) AS profit_margin
FROM
    "product" AS product
ORDER BY
    profit_margin DESC,
    product.name;



-- PRODUCTOS CON MENOR MARGEN DE GANANCIA
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    (product.sale_price - product.cost_price) AS profit_margin
FROM
    "product" AS product
ORDER BY
    profit_margin ASC,
    product.name;



-- PRECIO PROMEDIO DE LOS PRODUCTOS
SELECT
    category.id,
    category.name,
    ROUND(AVG(product.sale_price), 2) AS average_sale_price
FROM
    "category" AS category
INNER JOIN
    "product" AS product
    ON product.category_id = category.id
GROUP BY
    category.id,
    category.name
ORDER BY
    average_sale_price DESC,
    category.name;