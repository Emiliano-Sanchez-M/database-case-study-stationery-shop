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

-- ROLES CON UN PERMISO ESPECIFICO

-- PERMISOS SIN ROLES

-- ROLES SIN PERMISOS

-- PERMISOS EFECTIVOS DE CADA USUARIO

-- PERMISOS AGRUPADOS POR USUARIO

-- ROLES AGRUPADOS POS USUARIO

-- USUARIOS CON UN PERMISO ESPECIFICO

-- ROLES CON ACCESO A UNA FUNCIONALIDAD

-- PERMISOS AGRUPADOS POR FUNCIONALIDAD

-- USUARIOS ACTIVOS SIN ROLES

-- USUARIOS ACTIVOS CON ROLES

-- USUARIOS BLOQUEADOS CON ROLES

-- ROLES CON MAYOR CANTIDAD DE PERMISOS