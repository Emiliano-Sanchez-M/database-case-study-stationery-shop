-- BUSCAR PRODUCTO POR SKU
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
    product.sku = 'PAP-BAR-001';



-- BUSCAR PRODUCTO POR CODIGO DE BARRAS
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
    product.barcode = '7501234500001';


-- BUSCAR PRODUCTOS POR NOMBRE( ESTA CONSULTA ES ESTRICTA, SI NO
-- SE ESCRIBE EL NOMBRE COMPLETO, NO LO RECONOCERA )
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
    product.name ILIKE 'Cuaderno' -- Prueba tambien con 'Cuaderno Scribe Raya'
ORDER BY
    product.name;



-- BUSCAR PRODUCTOS POR PARTE DEL NOMBRE
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
    product.name ILIKE '%cuaderno%'
ORDER BY
    product.name;