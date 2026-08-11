-- CONSULTAS GENERALES

-- Listar Todos los usuarios
SELECT * FROM "user";

-- Mostrar los datos escenciales de todos los usuarios,
-- concatenando el nombre y los apellidos como un solo campo
SELECT "user".id, concat(
        "user".first_name, ' ', "user".paternal_last_name, ' ', "user".maternal_last_name
    ) AS "Nombre completo", "user".status, "user".created_at
FROM "user";

-- Mostrar nombre y apellido paterno de los usuarios
SELECT concat(
        "user".first_name, ' ', "user".paternal_last_name
    ) as "Nombre y apellido"
FROM "user";

-- CONSULTAS EN BASE AL ESTADO DEL USUARIO

-- Listar todos los usuarios cuyo estado sea activo
SELECT * FROM "user" WHERE "user".status = 'ACTIVE';

-- Listar todos los usuarios cuyo estado sea inactivo
SELECT * FROM "user" WHERE "user".status = 'INACTIVE';

-- Listar todos los usuarios cuyo estado sea bloqueado
SELECT * FROM "user" WHERE "user".status = 'BLOCKED';

-- Muestra los usuarios que no se encuentran activos
SELECT * FROM "user" WHERE "user".status != 'ACTIVE';

-- Muestra todos los usuarios registrados, excluyendo a los usuarios bloqueados
SELECT * FROM "user" WHERE "user".status IN ('ACTIVE', 'INACTIVE');

-- BUSQUEDAS

-- Buscar un usuario especifico y obtener todos sus datos.
-- En este ejemplo, se busca al usuario "admin"
SELECT * FROM "user" WHERE "user".username = 'admin';

-- Buscar por nombre de usuario donde el texto ingresado este en cualquier parte
SELECT * FROM "user" WHERE "user".username ILIKE '%or%';

-- Buscar usuarios cuyo nombre contenga una determinada palabra, insensible a
-- mayusculas y minusculas, en este caso se buscara la coincidencia con "o",
-- y puede tener cualquier caracter antes o despues
SELECT * FROM "user" WHERE "user".first_name ILIKE '%o%';

-- Buscar usuarios cuyo apellido paterno comience con determinadas letras,
-- sensible a mayusculas y minusculas, en este caso se buscara la coincidencia
-- con "M", y puede tener cualquier caracter despues
SELECT * FROM "user" WHERE "user".paternal_last_name LIKE 'M%';

-- Buscar usuarios cuyo nombre o apellido paterno coincida con un termino de
-- busca en cualquier parte, insensible a mayusculas y minusculas
SELECT *
FROM "user"
WHERE
    "user".first_name ILIKE '%ar%'
    OR "user".paternal_last_name ILIKE '%ar%';

-- Buscar un usuario por nombre completo, empieza buscando coincidencias 
-- en el orden que se concatenen los campos
SELECT "user".id, concat_ws(
        ' ', "user".first_name, "user".paternal_last_name, "user".maternal_last_name
    ) AS "Nombre completo", "user".status
FROM "user"
WHERE
    concat_ws(
        ' ',
        "user".first_name,
        "user".paternal_last_name,
        "user".maternal_last_name
    ) ILIKE '%he%';


-- ORDENAMIENTO

-- Mostrar los datos escenciales de todos los usuarios activos, ordenados alfabeticamente 
-- por apellidos
SELECT "user".id, concat(
        "user".paternal_last_name, ' ', "user".maternal_last_name, ' ', "user".first_name
    ) AS "Nombre completo", "user".status, "user".created_at
FROM "user"
WHERE
    "user".status = 'ACTIVE'
ORDER BY "Nombre completo" ASC;

-- Mostrar los datos escenciales de todos los usuarios activos, ordenados del mas reciente 
-- al mas antiguo
SELECT "user".id, concat(
        "user".paternal_last_name, ' ', "user".maternal_last_name, ' ', "user".first_name
    ) AS "Nombre completo", "user".status, "user".created_at
FROM "user"
WHERE
    "user".status = 'ACTIVE'
ORDER BY "user".created_at DESC;

-- Obtener el usuario mas reciente
SELECT * FROM "user" ORDER BY "user".created_at DESC LIMIT 1;

-- Obtener el usuario mas antiguo
SELECT * FROM "user" ORDER BY "user".created_at ASC LIMIT 1;

-- PAGINACION

-- Mostrar los primeros 15 registros de usuarios
SELECT * FROM "user" LIMIT 15;

-- Mostrar los registros que esten dentro de un limite establecido,
SELECT * FROM "user" LIMIT 10 OFFSET 10;

-- CONTEO Y ESTADISTICAS

-- Obtener el numero total de usuarios
SELECT COUNT(*) AS "Total de usuarios" FROM "user";

-- Obtener el total de usuarios activos
SELECT COUNT(*) AS "Usuarios activos"
FROM "user"
WHERE
    "user".status = 'ACTIVE';

-- Obtener el total de usuarios agrupados por su estado
SELECT "user".status, COUNT(*) AS "Total de Usuarios"
FROM "user"
GROUP BY
    "user".status;

-- Obtener el total de usuarios, ademas de un conteo agrupado 
-- de los usuarios segun su estado
SELECT
    count(*) AS "Total de Usuarios",
    COUNT(*) FILTER (
        WHERE
            "user".status = 'ACTIVE'
    ) AS "Usuarios Activos",
    COUNT(*) FILTER (
        WHERE
            "user".status = 'INACTIVE'
    ) AS "Usuarios Inactivos",
    COUNT(*) FILTER (
        WHERE
            "user".status = 'BLOCKED'
    ) AS "Usuarios Bloqueados"
FROM "user";

-- Obtener el total de usuarios registrados por año
SELECT EXTRACT(
        YEAR
        FROM created_at
    ) AS "year", COUNT(*) AS total_usuarios
FROM "user"
GROUP BY
    EXTRACT(
        YEAR
        FROM created_at
    )
ORDER BY "year" ASC;

-- CONSULTAS POR FECHAS

-- Mostrar datos basicos de todos los usuarios creados despues de determinada fecha
SELECT concat(
        "user".paternal_last_name, ' ', "user".maternal_last_name, ' ', "user".first_name
    ) AS "Nombre completo", "user".status, "user".created_at
FROM "user"
WHERE
    "user".created_at >= '2026-01-01 00:00:00';

-- Mostrar el total de usuarios creados en un rango de fechas, 
-- desde una fecha especificada, a la fecha actual
SELECT COUNT(*)
FROM "user"
WHERE
    "user".created_at BETWEEN '2025-01-01 00:00:00' AND NOW();

-- Muestra los usuarios creados en los ultimos 30 dias
SELECT * FROM "user" WHERE created_at >= NOW() - INTERVAL '30 days';

-- Muestra los usuarios creados durante el año actual
SELECT *
FROM "user"
WHERE
    DATE_PART('year', created_at) = DATE_PART('year', CURRENT_DATE);