# Caso de estudio de una base de datos — Papelería

> Diseño y construcción de una base de datos relacional a partir de un caso de negocio realista.

<br>

**Tecnologias**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql\&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?logo=databricks\&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white)


* **PostgreSQL** — Sistema gestor de base de datos.
* **SQL** — Lenguaje utilizado para diseñar y consultar la base de datos.
* **Git** — Control de versiones.
* **GitHub** — Repositorio y documentación del proyecto.

<br>

**¿Qué es este proyecto?**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Este repositorio contiene el diseño y la implementación de una base de datos para una papelería.

Pero la idea del proyecto no es simplemente crear unas cuantas tablas y hacer `CREATE TABLE`.

Antes de escribir SQL, se analiza el negocio: qué hace, qué información necesita, quién participa en sus procesos y qué reglas deben cumplirse. A partir de ese análisis se construye el modelo de datos y, finalmente, se lleva a una implementación en PostgreSQL.

En otras palabras:

```text
Negocio
   ↓
Reglas y necesidades
   ↓
Modelo del dominio
   ↓
Modelo de datos
   ↓
Base de datos
   ↓
SQL
```

La intención es que cada parte del diseño tenga una razón detrás.

<br>

**¿Qué estoy intentando resolver?**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Una papelería no solamente necesita guardar productos.

También necesita saber, por ejemplo:

* qué productos tiene disponibles;
* cuánto inventario existe;
* quiénes son sus clientes y proveedores;
* qué productos se compraron;
* qué productos se vendieron;
* cómo se realizaron los pagos;
* qué ocurre con el dinero de caja;
* qué usuarios pueden realizar determinadas operaciones;
* qué reglas deben cumplirse para evitar información inconsistente.

Todos estos procesos generan información relacionada.

El objetivo de la base de datos es organizar esa información de manera que pueda ser almacenada, relacionada y consultada de forma consistente.

<br>

**Antes de crear las tablas**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Una de las partes importantes de este proyecto es que **el esquema SQL no es el punto de partida**.

Primero se documenta el problema.

La documentación cubre desde el contexto general del negocio hasta el diseño detallado de los datos:

| Documento                                                                  | ¿Qué encontrarás?                                                                    |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| [01 — Business Context](DOCS/01-business-context.md)                       | El contexto del negocio y el problema que se quiere resolver.                        |
| [02 — Business Rules](DOCS/02-business-rules.md)                           | Las reglas que debe respetar el sistema.                                             |
| [03 — Glossary](DOCS/03-glosary.md)                                        | Los términos utilizados dentro del dominio.                                          |
| [04 — Actors](DOCS/04-actors.md)                                           | Las personas o roles que interactúan con el sistema.                                 |
| [05 — Functional Requirements](DOCS/05-functional-requirements.md)         | Lo que el sistema debe permitir hacer.                                               |
| [06 — Non-Functional Requirements](DOCS/06-non-functional-requirements.md) | Características y restricciones que debe cumplir la solución.                        |
| [07 — Use Cases](DOCS/07-use-cases.md)                                     | Los principales escenarios de interacción con el sistema.                            |
| [08 — Domain Model](DOCS/08-domain-model.md)                               | Los conceptos principales del dominio y cómo se relacionan.                          |
| [09 — ER Model](DOCS/09-er-model.md)                                       | La representación de las entidades y sus relaciones.                                 |
| [10 — Data Dictionary](DOCS/10-data-dictionary.md)                         | El detalle de las tablas, columnas y características de los datos.                   |
| [11 — Normalization](DOCS/11-normalization.md)                             | El análisis utilizado para reducir redundancia y mejorar la estructura de los datos. |

Si estás aprendiendo bases de datos, puedes recorrer estos documentos en ese orden para entender cómo se llegó al diseño final.

Si ya tienes experiencia, puedes ir directamente al modelo entidad-relación, diccionario de datos o implementación SQL.

<br>

**De la documentación al SQL**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Una vez definido el modelo, comienza la implementación.

La carpeta [`SQL/`](SQL/) contiene los scripts de la base de datos:

```text
SQL/
├── schema/
├── seeds/
├── queries/
└── README.md
```

### `schema/`

Aquí se encuentra la estructura de la base de datos.

Actualmente contiene el script inicial de creación del esquema y las estructuras necesarias para comenzar la implementación.

### `seeds/`

Esta carpeta estará destinada a los datos iniciales o de referencia que necesite la base de datos.

### `queries/`

Aquí se irán incorporando consultas SQL para recuperar y trabajar con la información almacenada.

La implementación se irá ampliando progresivamente con elementos como:

* restricciones;
* índices;
* consultas;
* datos iniciales;
* triggers;
* validaciones;
* y otros elementos propios de una implementación relacional.

Por eso, **el SQL que encontrarás hoy no representa necesariamente el punto final del proyecto**. La base de datos seguirá creciendo a partir del diseño ya documentado.

Puedes consultar [`SQL/README.md`](SQL/README.md) para conocer con más detalle cómo está organizada esta parte del proyecto.

<br>

**Decisiones de diseño**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Diseñar una base de datos implica tomar decisiones.

¿Por qué una relación existe de determinada manera?

¿Por qué una tabla tiene ciertas responsabilidades?

¿Por qué se eligió una determinada estructura?

¿Se consideraron otras alternativas?

Para evitar que estas decisiones queden únicamente en la cabeza de quien desarrolla el proyecto, las decisiones relevantes se documentan mediante **Architecture Decision Records (ADR)**.

Puedes encontrarlos en:

```text
DOCS/ADR/
```

Los ADR registran el contexto de una decisión, las alternativas consideradas, la decisión adoptada y sus consecuencias.

Esto permite que el diseño pueda entenderse incluso tiempo después de haber sido creado.

<br>

**Algunas ideas detrás del diseño**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

El proyecto busca aplicar conceptos fundamentales del diseño de bases de datos, entre ellos:

* modelado relacional;
* claves primarias y foráneas;
* cardinalidad y relaciones;
* integridad referencial;
* restricciones de datos;
* normalización;
* separación de responsabilidades;
* consistencia de la información;
* trazabilidad entre requerimientos y estructura de datos.

No se trata de utilizar todas estas herramientas simplemente porque existen, sino de entender **cuándo tienen sentido y qué problema resuelven**.

<br>

**Un proyecto abierto para aprender y contribuir**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Este repositorio también busca funcionar como un **recurso abierto de aprendizaje y práctica de bases de datos relacionales.**

**Puedes utilizarlo para:**

- estudiar un ejemplo de diseño de base de datos basado en un caso de negocio;
- practicar PostgreSQL y SQL;
- analizar modelos entidad-relación;
- estudiar normalización;
- practicar consultas;
- experimentar con datos de prueba;
- utilizar partes del proyecto como referencia para trabajos académicos o personales;
- proponer mejoras al diseño o a la implementación;
- crear nuevas consultas y escenarios de prueba.
- desarrollar una aplicación, API, servicio o sistema que utilice esta base de datos;
- utilizar la base de datos como punto de partida para construir una solución propia;
- adaptar o extender el modelo para otros proyectos o necesidades.

El proyecto no pretende ser una solución única o definitiva para todos los sistemas de gestión de papelerías. Su objetivo es servir **como un caso de estudio práctico que pueda evolucionar y ser utilizado como punto de partida para aprender y experimentar y construir nuevas solucioes.**

**¿Quieres construir una aplicación sobre esta base de datos?**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Si quieres utilizar este modelo como base para desarrollar una aplicación de escritorio, aplicación web, API, sistema administrativo, proyecto académico o cualquier otra solución, puedes hacerlo de acuerdo con los términos de la Apache License 2.0.

Puedes, por ejemplo, construir:

```
Esta base de datos
       ↓
   ┌───┴───────────────┐
   ↓                   ↓
Backend / API       Aplicación
   ↓                   ↓
Spring Boot       Web / Desktop
   │
   └──────────┬────────┘
              ↓
       Sistema completo

```

La implementación de esas aplicaciones no forma parte necesariamente de este repositorio. Cada persona puede elegir las tecnologías, arquitectura y funcionalidades que considere adecuadas.

Esto permite que el mismo modelo de datos pueda servir como base para diferentes implementaciones y, al mismo tiempo, comparar cómo distintas personas resuelven el mismo problema desde perspectivas diferentes.


**Contribuciones**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Las contribuciones son bienvenidas.

Puedes contribuir, por ejemplo, mediante:

- nuevas consultas SQL;
- consultas alternativas para resolver un mismo problema;
- datos de prueba para nuevos escenarios;
- casos límite que permitan detectar problemas en el diseño;
- mejoras de restricciones e integridad;
- índices y optimizaciones;
- vistas;
- triggers y validaciones;
- mejoras en la documentación;
- correcciones de errores;
- propuestas de cambios en el modelo;
- nuevos casos de uso relacionados con el dominio.

Una contribución no tiene que consistir necesariamente en código. Una buena consulta, una corrección en la documentación o la identificación de un problema de diseño también puede aportar valor al proyecto.

Si encuentras una mejora o quieres proponer una nueva funcionalidad, puedes abrir un issue para discutirla antes de realizar los cambios.

**¿Cómo está organizado el proyecto?**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

```text
database-case-study-stationery-shop/
│
├── DOCS/
│   ├── 01-business-context.md
│   ├── 02-business-rules.md
│   ├── 03-glosary.md
│   ├── 04-actors.md
│   ├── 05-functional-requirements.md
│   ├── 06-non-functional-requirements.md
│   ├── 07-use-cases.md
│   ├── 08-domain-model.md
│   ├── 09-er-model.md
│   ├── 10-data-dictionary.md
│   ├── 11-normalization.md
│   │
│   └── ADR/
│
├── SQL/
│   ├── schema/
│   ├── seeds/
│   ├── queries/
│   └── README.md
│
├── .gitattributes
├── LICENSE
└── README.md
```

La idea es mantener separadas las dos partes principales del proyecto:

**`DOCS/` → por qué y cómo se diseñó**

**`SQL/` → cómo se implementó**

**¿En qué punto está?**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

La parte de análisis y diseño ya está documentada y el esquema SQL inicial ya se encuentra implementado.

La implementación continuará evolucionando de manera incremental.

```text
✓ Análisis del negocio
✓ Reglas de negocio
✓ Requerimientos
✓ Casos de uso
✓ Modelo de dominio
✓ Modelo entidad-relación
✓ Diccionario de datos
✓ Normalización
✓ ADR
✓ Esquema SQL inicial

→ Restricciones adicionales
→ Índices
→ Datos iniciales
→ Consultas
→ Triggers
→ Validaciones
→ Refinamiento
```

Esto permite que el proyecto avance sin perder la relación entre el diseño y la implementación.

**¿Qué puedes aprender de este repositorio?**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Si estás empezando con bases de datos, este proyecto puede servirte para ver algo que muchas veces no se muestra en ejemplos pequeños:

**cómo se pasa de un problema del mundo real a una base de datos.**

No solamente encontrarás SQL, sino también el razonamiento que existe antes de escribirlo.

Si ya tienes experiencia, puedes utilizar el repositorio para revisar las decisiones de modelado, normalización, relaciones, restricciones y la evolución de la implementación.

**Licencia**<br>
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Este proyecto está disponible bajo los términos de la Apache License 2.0.

Puedes consultar los términos completos en [`LICENSE`](LICENSE).

<br>

**Contribuye al caso de estudio**
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

Este proyecto puede seguir creciendo con diferentes perspectivas.

Si estás aprendiendo SQL, puedes aportar una consulta.

Si estás estudiando bases de datos, puedes proponer un escenario de prueba.

Si tienes experiencia, puedes señalar un problema de diseño, proponer una optimización o plantear una alternativa.

La idea es que el repositorio no sea solamente un proyecto terminado, sino un caso de estudio vivo, donde diferentes personas puedan aprender, experimentar, discutir decisiones y aportar nuevas soluciones.

¿Encontraste algo que podría mejorarse? Abre un issue, propón una consulta o contribuye con un pull request.