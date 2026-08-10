# Schema

Esta carpeta contiene la definición estructural base de la base de datos.

El archivo `create.sql` representa el esquema base de la versión actual del sistema e incluye las estructuras y restricciones fundamentales necesarias para garantizar la integridad de los datos.

## Tecnologías

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?logo=databricks&logoColor=white)



## Incluido en `create.sql`

El esquema base incluye:

* Tablas y columnas.
* Tipos de datos.
* Claves primarias.
* Claves foráneas.
* Restricciones `NOT NULL`.
* Restricciones `UNIQUE`.
* Restricciones `CHECK` esenciales para la integridad de los datos.
* Comentarios descriptivos de tablas y columnas.

Los `CHECK` incluidos en este archivo corresponden principalmente a reglas estructurales o invariantes fundamentales del dominio, como valores no negativos, rangos válidos y conjuntos de estados permitidos.

## Restricciones adicionales

Las restricciones que se incorporen posteriormente y que requieran una implementación independiente, reglas de negocio más complejas o mantenimiento separado podrán almacenarse en la carpeta `constraints/`.

Esto permite mantener `create.sql` como una definición base, autocontenida y funcional del esquema, mientras que las restricciones adicionales pueden evolucionar de forma independiente.

## Principio de diseño

El objetivo es que una instalación basada únicamente en `create.sql` proporcione una estructura de datos funcional y con las garantías fundamentales de integridad.

Las restricciones adicionales no deben utilizarse para reemplazar las validaciones esenciales que forman parte natural de la definición de las tablas.
