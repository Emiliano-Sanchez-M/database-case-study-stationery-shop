-- PRODUCTOS REGISTRADOS
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
ORDER BY
    product.name;



-- PRODUCTOS ACTIVOS
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.active = TRUE
ORDER BY
    product.name;


-- PRODUCTOS INACTIVOS
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.active = FALSE
ORDER BY
    product.name;



-- PRODUCTOS CON CODIGO DE BARRAS
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.barcode IS NOT NULL
ORDER BY
    product.name;



-- PRODUCTOS SIN CODIGO DE BARRAS
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.barcode IS NULL
ORDER BY
    product.name;



-- PRODUCTOS CON DESCRIPCION
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.description IS NOT NULL
ORDER BY
    product.name;



-- PRODUCTOS SIN DESCRIPCION
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.description IS NULL
ORDER BY
    product.name;



-- PRODUCTOS CON MARCA
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.brand_id IS NOT NULL
ORDER BY
    product.name;



-- PRODUCTOS SIN MARCA
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.brand_id IS NULL
ORDER BY
    product.name;



-- PRODUCTOS CON PRECIO DE VENTA
-- Aunque en el schema, es decir, en el archivo de creacion de la BD
-- se especifica que todos los productos registrados tienen precio de
-- venta, es decir, son NOT NULL, esta consulta es valida, y sirve 
-- como ejemplo
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.sale_price IS NOT NULL
ORDER BY
    product.name;



-- PRODUCTOS CON COSTO
SELECT
    product.id,
    product.sku,
    product.barcode,
    product.name,
    product.description,
    product.category_id,
    product.brand_id,
    product.sale_price,
    product.cost_price,
    product.stock_alert_level,
    product.active,
    product.created_at,
    product.updated_at
FROM
    "product" AS product
WHERE
    product.cost_price IS NOT NULL
ORDER BY
    product.name;



-- PRODUCTOS CON MARGEN DE GANANCIA
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
    product.name;



-- PRODUCTOS CON NIVEL DE ALERTA
SELECT
    product.id,
    product.sku,
    product.name,
    product.stock_alert_level,
    product.active
FROM
    "product" AS product
WHERE
    product.stock_alert_level IS NOT NULL
ORDER BY
    product.stock_alert_level DESC,
    product.name;



-- PRODUCTOS CON NIVEL DE ALERTA EN CERO
SELECT
    product.id,
    product.sku,
    product.name,
    product.stock_alert_level,
    product.active
FROM
    "product" AS product
WHERE
    product.stock_alert_level IS NOT NULL
ORDER BY
    product.stock_alert_level DESC,
    product.name;



-- PRODUCTOS REGISTRADOS RECIENTEMENTE
SELECT
    product.id,
    product.sku,
    product.name,
    product.created_at,
    product.active
FROM
    "product" AS product
WHERE
    product.created_at >= NOW() - INTERVAL '30 days'
ORDER BY
    product.created_at DESC;


-- PRODUCTOS ACTUALIZADOS RECIENTEMENTE
SELECT
    product.id,
    product.sku,
    product.name,
    product.updated_at,
    product.active
FROM
    "product" AS product
WHERE
    product.updated_at >= NOW() - INTERVAL '30 days'
ORDER BY
    product.updated_at DESC;



-- PRODUCTOS CON MARGEN NEGATIVO
SELECT
    product.id,
    product.sku,
    product.name,
    product.sale_price,
    product.cost_price,
    (product.sale_price - product.cost_price) AS profit_margin
FROM
    "product" AS product
WHERE
    product.sale_price < product.cost_price
ORDER BY
    profit_margin;