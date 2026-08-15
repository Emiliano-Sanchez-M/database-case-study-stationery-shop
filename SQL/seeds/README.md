# Seeds

Esta carpeta contiene los datos iniciales y de prueba utilizados para poblar la base de datos durante el desarrollo.

Las seeds permiten disponer de un conjunto de datos representativo para:

* probar consultas SQL;
* validar restricciones y reglas de integridad;
* desarrollar y probar funcionalidades de la aplicación;
* verificar relaciones entre tablas;
* reproducir escenarios de prueba;
* facilitar el desarrollo sin tener que insertar datos manualmente;
* generar posteriormente datasets más grandes y variados.

Las seeds **no representan necesariamente datos reales de un negocio**. Algunos registros están inspirados en escenarios comunes de una papelería, mientras que otros son datos ficticios creados específicamente para cubrir diferentes casos de prueba.

---

## Estructura

La carpeta está organizada mediante archivos independientes para cada tabla o grupo de datos:

```text
seeds/
├── README.md
├── 01_insert_user.sql
├── 02_insert_role.sql
├── 03_insert_permission.sql
├── 04_insert_role_permission.sql
├── 05_insert_user_role.sql
├── 06_insert_customer.sql
├── 07_fiscal_data.sql
├── 08_insert_category.sql
├── 09_insert_brand.sql
├── 10_insert_product.sql
├── 11_insert_discount.sql
├── 12_insert_service.sql
├── 13_insert_payment_method.sql
├── 14_insert_reservation_configuration.sql
├── ...
└── dictionaries/
```

Los archivos se mantienen separados para facilitar su mantenimiento, revisión y ejecución individual.

---

# Orden de ejecución

El orden de las seeds es importante debido a las dependencias existentes entre las entidades.

Una tabla que utiliza registros de otra tabla debe poblarse después de que sus registros dependientes ya existan.

Por ejemplo:

```text
product
   ↓
inventory
```

No tendría sentido crear un registro de `inventory` para un `product_id` que todavía no existe.

---

# Orden completo recomendado

La ejecución general queda resumida de la siguiente manera:

```text
01. user
02. role
03. permission
04. role_permission
05. user_role

06. customer
07. fiscal_data

08. category
09. brand
10. product

11. discount
12. service
13. service_rate
14. payment_method
15. reservation_configuration

16. supplier
17. product_supplier

18. inventory
19. inventory_movement
20. inventory_incident

21. purchase
22. purchase_item
23. purchase_incident

24. sale
25. sale_item
26. payment
27. ticket

28. reservation
29. reservation_item
30. reservation_payment

31. return
32. return_item

33. cash_register
34. cash_movement
35. cash_closing

36. invoice

37. product_interest

38. business_configuration

39. audit_record
```

Este orden representa el **orden lógico recomendado**, no necesariamente una secuencia obligatoria de ejecución de todos los archivos en cualquier escenario. Las dependencias concretas de cada tabla deben prevalecer si la estructura de la base de datos cambia.

---

# Principios de las seeds

## Datos variados

Las seeds deben procurar representar diferentes escenarios y no únicamente registros ideales.

Por ejemplo:

* registros activos e inactivos;
* registros con y sin información opcional;
* fechas antiguas y recientes;
* diferentes estados;
* diferentes valores numéricos;
* relaciones uno a muchos;
* relaciones muchos a muchos;
* escenarios límite;
* registros históricos;
* datos que permitan probar consultas complejas.

Esto permite que las consultas SQL y las aplicaciones desarrolladas sobre la base de datos puedan probarse en escenarios más cercanos a los que encontrarían en un sistema real.

---

## Datos reproducibles

Las seeds deben poder ejecutarse nuevamente de forma controlada.

Cuando sea apropiado, se utilizarán estrategias como:

```sql
ON CONFLICT DO NOTHING;
```

o referencias determinísticas a los registros existentes.

La estrategia concreta dependerá de las características y restricciones de cada tabla.

---

## Datos ficticios

Los datos utilizados para desarrollo y pruebas no deben representar información personal real.

Cuando una tabla requiera información que normalmente sería sensible, como datos fiscales, teléfonos, correos o identificadores, deben utilizarse datos ficticios.

---

# Datasets de mayor tamaño

Las seeds iniciales tienen como objetivo proporcionar un conjunto de datos controlado y legible.

Sin embargo, algunas tablas pueden requerir posteriormente cientos o miles de registros para realizar pruebas de rendimiento, paginación, búsquedas y consultas complejas.

Para estos escenarios se incorporará una carpeta:

```text
seeds/
└── dictionaries/
```

Esta carpeta contendrá diccionarios reutilizables para la generación de datos, por ejemplo:

```text
dictionaries/
├── names.sql
├── surnames.sql
├── domains.sql
└── ...
```

Los diccionarios permitirán generar combinaciones variadas de datos de forma reproducible, evitando tener que escribir manualmente cientos o miles de registros.

Por ejemplo:

```text
100 nombres
×
200 apellidos
×
diferentes combinaciones
=
gran cantidad de registros posibles
```

Esta estrategia será especialmente útil para generar datasets grandes de clientes, usuarios y otras entidades cuando sea necesario realizar pruebas más exigentes.

---

# Evolución de las seeds

Las seeds no deben considerarse datos definitivos de producción.

A medida que avance el proyecto, podrán:

* agregarse nuevos escenarios;
* eliminarse registros innecesarios;
* modificarse datos para cubrir nuevas reglas;
* aumentar su volumen;
* dividirse en datasets específicos;
* incorporar nuevos diccionarios;
* adaptarse a nuevas consultas;
* adaptarse a nuevas funcionalidades de la aplicación.

El objetivo es que las seeds evolucionen junto con el modelo de datos y con las necesidades de prueba del proyecto.

---

# Criterio para agregar nuevos registros

Antes de agregar registros a una seed, se debe procurar que estos tengan un propósito.

Un registro puede existir para:

1. representar un escenario normal;
2. cubrir una restricción;
3. probar una consulta;
4. probar una relación;
5. representar un estado diferente;
6. probar fechas o rangos temporales;
7. cubrir valores opcionales;
8. probar casos límite;
9. facilitar el desarrollo de una funcionalidad;
10. generar datos suficientes para pruebas de volumen.

De esta manera, las seeds funcionan no solamente como datos iniciales, sino también como una herramienta de **testing y desarrollo**.

---

## Propósito final

La carpeta `seeds` busca proporcionar una base de datos de desarrollo **consistente, variada, reproducible y suficientemente realista**, capaz de servir tanto para demostrar el funcionamiento del modelo de datos como para facilitar el desarrollo y las pruebas de aplicaciones construidas sobre él.
