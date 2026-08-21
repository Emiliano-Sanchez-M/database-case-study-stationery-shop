## -- SEED: TICKET

-- Genera un ticket para cada venta completada, mientras que las 
-- ventas pendientes, canceladas o reembolsadas no generan ningun 
-- ticket nuevo.
-- 
-- El número de ticket se genera a partir del identificador de la venta,
-- para mantener una relación que pueda ser reproducible y asi evitar
-- tener que depender de valores de IDs previamente conocidos.

-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
"ticket" (
"sale_id",
"ticket_number",
"issued_at"
)
SELECT
"s"."id",
'TKT-' || LPAD("s"."id"::TEXT, 6, '0'),
COALESCE("s"."completed_at", "s"."created_at")
FROM
"sale" AS "s"
WHERE
"s"."status" = 'COMPLETED'
ON CONFLICT DO NOTHING;