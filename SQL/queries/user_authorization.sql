-- USUARIOS CON SUS ROLES
SELECT
    "user".username,
    CONCAT(
        "user".first_name,
        ' ',
        "user".paternal_last_name,
        ' ',
        "user".maternal_last_name
    ) AS user_name,
    STRING_AGG("role".name, ', ' ORDER BY "role".name) AS roles
FROM "user"
JOIN user_role
    ON user_role.user_id = "user".id
JOIN "role"
    ON "role".id = user_role.role_id
GROUP BY
    "user".id,
    "user".username,
    "user".first_name,
    "user".paternal_last_name,
    "user".maternal_last_name
ORDER BY
    "user".username;


--- USUARIOS SIN ROLES
SELECT
    "user".username,
    CONCAT(
        "user".first_name,
        ' ',
        "user".paternal_last_name,
        ' ',
        "user".maternal_last_name
    ) AS user_name
FROM "user"
LEFT JOIN user_role
    ON user_role.user_id = "user".id
WHERE user_role.user_id IS NULL
ORDER BY
    "user".username;



-- ROLES CON USUARIOS
SELECT
    "role".name AS role,
    STRING_AGG(
        "user".username,
        ', '
        ORDER BY "user".username
    ) AS users
FROM "role"
JOIN user_role
    ON user_role.role_id = "role".id
JOIN "user"
    ON "user".id = user_role.user_id
GROUP BY
    "role".id,
    "role".name
ORDER BY
    "role".name;



-- ROLES SIN USUARIOS ASIGNADOS
SELECT
    "role".name AS role,
    "role".description
FROM "role"
LEFT JOIN user_role
    ON user_role.role_id = "role".id
WHERE user_role.role_id IS NULL
ORDER BY
    "role".name;



-- PERMISOS DE CADA ROL
SELECT
    "role"."name" AS "role",
    STRING_AGG(
        "permission"."name",
        ', '
        ORDER BY "permission"."name"
    ) AS "permissions"
FROM "role"
LEFT JOIN "role_permission"
    ON "role"."id" = "role_permission"."role_id"
LEFT JOIN "permission"
    ON "role_permission"."permission_id" = "permission"."id"
GROUP BY
    "role"."id",
    "role"."name"
ORDER BY
    "role"."name";



-- ROLES CON UN PERMISO ESPECIFICO
SELECT
    "role"."name" AS "role",
    "permission"."name" AS "permission"
FROM "role"
INNER JOIN "role_permission"
    ON "role"."id" = "role_permission"."role_id"
INNER JOIN "permission"
    ON "role_permission"."permission_id" = "permission"."id"
WHERE "permission"."name" = 'USER_CREATE'
ORDER BY
    "role"."name";




-- PERMISOS SIN ROLES
SELECT
    "permission"."name" AS "permission",
    "permission"."description"
FROM "permission"
LEFT JOIN "role_permission"
    ON "permission"."id" = "role_permission"."permission_id"
WHERE "role_permission"."role_id" IS NULL
ORDER BY
    "permission"."name";



-- ROLES SIN PERMISOS
SELECT
    "role"."name" AS "role",
    "role"."description"
FROM "role"
LEFT JOIN "role_permission"
    ON "role"."id" = "role_permission"."role_id"
WHERE "role_permission"."permission_id" IS NULL
ORDER BY
    "role"."name";



-- PERMISOS EFECTIVOS DE CADA USUARIO
SELECT
    "user"."username" AS "username",
    CONCAT(
        "user"."first_name",
        ' ',
        "user"."paternal_last_name",
        ' ',
        "user"."maternal_last_name"
    ) AS "full_name",
    "permission"."name" AS "permission"
FROM "user"
INNER JOIN "user_role"
    ON "user"."id" = "user_role"."user_id"
INNER JOIN "role_permission"
    ON "user_role"."role_id" = "role_permission"."role_id"
INNER JOIN "permission"
    ON "role_permission"."permission_id" = "permission"."id"
ORDER BY
    "user"."username",
    "permission"."name";



-- PERMISOS AGRUPADOS POR USUARIO
SELECT
    "user"."username" AS "username",
    CONCAT(
        "user"."first_name",
        ' ',
        "user"."paternal_last_name",
        ' ',
        "user"."maternal_last_name"
    ) AS "full_name",
    STRING_AGG(
        DISTINCT "permission"."name",
        ', '
        ORDER BY "permission"."name"
    ) AS "permissions"
FROM "user"
INNER JOIN "user_role"
    ON "user"."id" = "user_role"."user_id"
INNER JOIN "role_permission"
    ON "user_role"."role_id" = "role_permission"."role_id"
INNER JOIN "permission"
    ON "role_permission"."permission_id" = "permission"."id"
GROUP BY
    "user"."id",
    "user"."username",
    "user"."first_name",
    "user"."paternal_last_name",
    "user"."maternal_last_name"
ORDER BY
    "user"."username";



-- ROLES AGRUPADOS POS USUARIO
SELECT
    "user"."username" AS "username",
    CONCAT(
        "user"."first_name",
        ' ',
        "user"."paternal_last_name",
        ' ',
        "user"."maternal_last_name"
    ) AS "full_name",
    STRING_AGG(
        DISTINCT "role"."name",
        ', '
        ORDER BY "role"."name"
    ) AS "roles"
FROM "user"
INNER JOIN "user_role"
    ON "user"."id" = "user_role"."user_id"
INNER JOIN "role"
    ON "user_role"."role_id" = "role"."id"
GROUP BY
    "user"."id",
    "user"."username",
    "user"."first_name",
    "user"."paternal_last_name",
    "user"."maternal_last_name"
ORDER BY
    "user"."username";



-- USUARIOS CON UN PERMISO ESPECIFICO
SELECT
    "user"."username" AS "username",
    CONCAT(
        "user"."first_name",
        ' ',
        "user"."paternal_last_name",
        ' ',
        "user"."maternal_last_name"
    ) AS "full_name",
    "permission"."name" AS "permission"
FROM "user"
INNER JOIN "user_role"
    ON "user"."id" = "user_role"."user_id"
INNER JOIN "role_permission"
    ON "user_role"."role_id" = "role_permission"."role_id"
INNER JOIN "permission"
    ON "role_permission"."permission_id" = "permission"."id"
WHERE "permission"."name" = 'PRODUCT_CREATE'
ORDER BY
    "user"."username";



-- ROLES CON ACCESO COMPLETO O PARCIAL A UNA FUNCIONALIDAD
SELECT DISTINCT
    "role"."name" AS "role",
    "role"."description"
FROM "role"
INNER JOIN "role_permission"
    ON "role"."id" = "role_permission"."role_id"
INNER JOIN "permission"
    ON "role_permission"."permission_id" = "permission"."id"
WHERE "permission"."name" IN (
    'PRODUCT_CREATE',
    'PRODUCT_READ',
    'PRODUCT_UPDATE',
    'PRODUCT_DEACTIVATE'
)
ORDER BY
    "role"."name";


-- ROLES CON ACCESO COMPLETO A UNA FUNCIONALIDAD
SELECT
    "role"."name" AS "role",
    "role"."description"
FROM "role"
INNER JOIN "role_permission"
    ON "role"."id" = "role_permission"."role_id"
INNER JOIN "permission"
    ON "role_permission"."permission_id" = "permission"."id"
WHERE "permission"."name" IN (
    'PRODUCT_CREATE',
    'PRODUCT_READ',
    'PRODUCT_UPDATE',
    'PRODUCT_DEACTIVATE'
)
GROUP BY
    "role"."id",
    "role"."name",
    "role"."description"
HAVING COUNT(DISTINCT "permission"."name") = 4
ORDER BY
    "role"."name";



-- PERMISOS AGRUPADOS POR FUNCIONALIDAD

-- La tabla "permission" no almacena una funcionalidad
-- explícita. Por ello, esta consulta la deriva a partir
-- del prefijo del nombre del permiso.
-- Ejemplo:
--     PRODUCT_CREATE
--     PRODUCT_READ
--     PRODUCT_UPDATE
--     PRODUCT_DEACTIVATE
--
-- Se consideran parte de la funcionalidad "PRODUCT".

-- En permisos compuestos, como:
--     RESERVATION_PAYMENT_CREATE
--     RESERVATION_PAYMENT_READ
--     RESERVATION_CONFIGURATION_READ
--
-- se utiliza "RESERVATION" como funcionalidad principal,
-- considerando "PAYMENT" y "CONFIGURATION" como
-- subfuncionalidades de reservaciones.
-- Esta clasificación es propia de la consulta y no
-- representa una relación almacenada en la base de datos.
SELECT
    SPLIT_PART("permission"."name", '_', 1) AS "functionality",
    STRING_AGG(
        "permission"."name",
        ', '
        ORDER BY "permission"."name"
    ) AS "permissions"
FROM "permission"
GROUP BY
    SPLIT_PART("permission"."name", '_', 1)
ORDER BY
    "functionality";



-- USUARIOS ACTIVOS SIN ROLES
SELECT
    "user"."username" AS "username",
    CONCAT(
        "user"."first_name",
        ' ',
        "user"."paternal_last_name",
        ' ',
        "user"."maternal_last_name"
    ) AS "full_name",
    "user"."status"
FROM "user"
LEFT JOIN "user_role"
    ON "user"."id" = "user_role"."user_id"
WHERE
    "user"."status" = 'ACTIVE'
    AND "user_role"."role_id" IS NULL
ORDER BY
    "user"."username";



-- USUARIOS ACTIVOS CON ROLES
SELECT DISTINCT
    "user"."username" AS "username",
    CONCAT(
        "user"."first_name",
        ' ',
        "user"."paternal_last_name",
        ' ',
        "user"."maternal_last_name"
    ) AS "full_name",
    "user"."status"
FROM "user"
INNER JOIN "user_role"
    ON "user"."id" = "user_role"."user_id"
WHERE
    "user"."status" = 'ACTIVE'
ORDER BY
    "user"."username";



-- USUARIOS BLOQUEADOS CON ROLES
SELECT DISTINCT
    "user"."username" AS "username",
    CONCAT(
        "user"."first_name",
        ' ',
        "user"."paternal_last_name",
        ' ',
        "user"."maternal_last_name"
    ) AS "full_name",
    "user"."status"
FROM "user"
INNER JOIN "user_role"
    ON "user"."id" = "user_role"."user_id"
WHERE
    "user"."status" = 'BLOCKED'
ORDER BY
    "user"."username";



-- ROLES CON MAYOR CANTIDAD DE PERMISOS

-- Esta consulta permite identificar los roles que tienen
-- asignada la mayor cantidad de permisos.
--
-- Se utiliza LEFT JOIN para incluir tambien los roles que
-- no tienen permisos asignados, mostrando una cantidad de 0.
--
-- La cantidad de permisos no representa necesariamente el
-- nivel de privilegio de un rol. Un rol con pocos permisos
-- puede tener acceso a operaciones mas sensibles que un rol
-- con una mayor cantidad de permisos.
--
-- El resultado se utiliza principalmente para analizar la
-- distribucion de permisos y detectar roles con una cantidad
-- de permisos significativamente mayor o menor que los demas.
SELECT
    "role"."name" AS "role",
    "role"."description",
    COUNT(DISTINCT "role_permission"."permission_id") AS "permission_count"
FROM "role"
LEFT JOIN "role_permission"
    ON "role"."id" = "role_permission"."role_id"
GROUP BY
    "role"."id",
    "role"."name",
    "role"."description"
ORDER BY
    "permission_count" DESC,
    "role"."name";