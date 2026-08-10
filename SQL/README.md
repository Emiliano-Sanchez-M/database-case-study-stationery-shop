# SQL

Esta carpeta contiene los scripts SQL utilizados para definir, consultar, mantener y automatizar la base de datos del sistema.

La estructura está organizada por responsabilidad, con el objetivo de mantener separadas la definición estructural del esquema, las restricciones adicionales, las consultas, las automatizaciones y demás componentes específicos de PostgreSQL.

## Tecnología

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql\&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?logo=databricks\&logoColor=white)

---

## Estructura

```text
SQL/
├── README.md
│
├── schema/
    ├── README.
    └── create.sql
```

> Las carpetas que todavía no sean necesarias podrán incorporarse conforme el proyecto requiera nuevas funcionalidades SQL.

## Organización

### `schema/`

Contiene la definición estructural base de la base de datos.

Incluye las tablas, columnas, tipos de datos, claves, restricciones fundamentales y comentarios descriptivos necesarios para crear el esquema inicial.

El archivo principal es `create.sql`.

## Principio de organización

La estructura de `SQL/` busca separar las diferentes responsabilidades de la base de datos sin fragmentar innecesariamente su definición.

El esquema base debe permanecer autocontenido y funcional, mientras que los componentes adicionales pueden evolucionar de manera independiente cuando su complejidad o propósito lo justifique.

Cada subcarpeta debe contener su propio `README.md`, donde se documentará su propósito, tecnología utilizada y criterios de organización específicos.

Las nuevas categorías deberán incorporarse únicamente cuando exista una necesidad real de mantener ese tipo de código, evitando crear estructuras innecesarias de forma anticipada.
