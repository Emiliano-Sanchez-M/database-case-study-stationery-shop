CREATE OR REPLACE FUNCTION update_sale_totals()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    target_sale_id BIGINT;
BEGIN

    /*
     * INSERT / UPDATE
     */
    IF TG_OP IN ('INSERT', 'UPDATE') THEN

        target_sale_id := NEW.sale_id;

        UPDATE "sale"
        SET
            "subtotal" = COALESCE(totals.subtotal, 0.00),
            "discount_total" = COALESCE(totals.discount_total, 0.00),
            "tax_total" = COALESCE(totals.tax_total, 0.00),
            "total" = COALESCE(totals.subtotal, 0.00)
                     - COALESCE(totals.discount_total, 0.00)
                     + COALESCE(totals.tax_total, 0.00)

        FROM (
            SELECT
                "sale_id",
                SUM("subtotal") AS subtotal,
                SUM("discount_amount") AS discount_total,
                SUM("tax") AS tax_total
            FROM "sale_item"
            WHERE "sale_id" = target_sale_id
            GROUP BY "sale_id"
        ) AS totals

        WHERE "sale"."id" = target_sale_id;


        /*
         * Si UPDATE cambió de venta, también recalculamos
         * la venta anterior.
         */
        IF TG_OP = 'UPDATE'
           AND OLD.sale_id <> NEW.sale_id THEN

            UPDATE "sale"
            SET
                "subtotal" = COALESCE(totals.subtotal, 0.00),
                "discount_total" = COALESCE(totals.discount_total, 0.00),
                "tax_total" = COALESCE(totals.tax_total, 0.00),
                "total" = COALESCE(totals.subtotal, 0.00)
                         - COALESCE(totals.discount_total, 0.00)
                         + COALESCE(totals.tax_total, 0.00)

            FROM (
                SELECT
                    "sale_id",
                    SUM("subtotal") AS subtotal,
                    SUM("discount_amount") AS discount_total,
                    SUM("tax") AS tax_total
                FROM "sale_item"
                WHERE "sale_id" = OLD.sale_id
                GROUP BY "sale_id"
            ) AS totals

            WHERE "sale"."id" = OLD.sale_id;

            /*
             * Si ya no existen items, la venta debe quedar
             * nuevamente en cero.
             */
            IF NOT EXISTS (
                SELECT 1
                FROM "sale_item"
                WHERE "sale_id" = OLD.sale_id
            ) THEN

                UPDATE "sale"
                SET
                    "subtotal" = 0.00,
                    "discount_total" = 0.00,
                    "tax_total" = 0.00,
                    "total" = 0.00
                WHERE "id" = OLD.sale_id;

            END IF;

        END IF;


    /*
     * DELETE
     */
    ELSIF TG_OP = 'DELETE' THEN

        target_sale_id := OLD.sale_id;

        UPDATE "sale"
        SET
            "subtotal" = COALESCE(totals.subtotal, 0.00),
            "discount_total" = COALESCE(totals.discount_total, 0.00),
            "tax_total" = COALESCE(totals.tax_total, 0.00),
            "total" = COALESCE(totals.subtotal, 0.00)
                     - COALESCE(totals.discount_total, 0.00)
                     + COALESCE(totals.tax_total, 0.00)

        FROM (
            SELECT
                "sale_id",
                SUM("subtotal") AS subtotal,
                SUM("discount_amount") AS discount_total,
                SUM("tax") AS tax_total
            FROM "sale_item"
            WHERE "sale_id" = target_sale_id
            GROUP BY "sale_id"
        ) AS totals

        WHERE "sale"."id" = target_sale_id;


        /*
         * Si ya no existen items, reiniciamos los totales.
         */
        IF NOT EXISTS (
            SELECT 1
            FROM "sale_item"
            WHERE "sale_id" = target_sale_id
        ) THEN

            UPDATE "sale"
            SET
                "subtotal" = 0.00,
                "discount_total" = 0.00,
                "tax_total" = 0.00,
                "total" = 0.00
            WHERE "id" = target_sale_id;

        END IF;

    END IF;


    RETURN NULL;

END;
$$;


DROP TRIGGER IF EXISTS trg_update_sale_totals
ON "sale_item";


CREATE TRIGGER trg_update_sale_totals
AFTER INSERT OR UPDATE OR DELETE
ON "sale_item"
FOR EACH ROW
EXECUTE FUNCTION update_sale_totals();