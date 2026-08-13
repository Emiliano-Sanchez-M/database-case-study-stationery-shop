-- SEED: CATEGORIAS
-- Inserta categorias representativas de productos de papeleria.
--
-- Algunos valores son ficticios y estan destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
    "category" ("name", "description")
VALUES
    (
        'Papeleria',
        'Articulos generales de papeleria.'
    ),
    (
        'Escritura',
        'Lapices, bolígrafos, plumas y otros instrumentos de escritura.'
    ),
    (
        'Colores',
        'Lapices de colores, crayones y materiales para colorear.'
    ),
    (
        'Marcadores',
        'Marcadores, plumones y rotuladores para diferentes usos.'
    ),
    (
        'Dibujo',
        'Materiales utilizados para dibujo y trazado.'
    ),
    (
        'Pintura',
        'Pinturas, pinceles y materiales para actividades artisticas.'
    ),
    (
        'Plastilina',
        'Plastilinas, modelinas y materiales para modelado.'
    ),
    (
        'Cuadernos',
        'Cuadernos, libretas y blocs para escritura y notas.'
    ),
    (
        'Papel',
        'Hojas, papel bond y otros productos de papel.'
    ),
    (
        'Cartulina',
        'Cartulinas y materiales de papel de mayor gramaje.'
    ),
    (
        'Material Didactico',
        'Materiales utilizados para actividades educativas y escolares.'
    ),
    (
        'Geometria',
        'Reglas, escuadras, compases y otros instrumentos geometricos.'
    ),
    (
        'Corte',
        'Tijeras, cutters y herramientas para cortar materiales.'
    ),
    (
        'Adhesivos',
        'Pegamentos, adhesivos y materiales para unir superficies.'
    ),
    (
        'Correctores',
        'Correctores liquidos, en cinta y otros productos para correccion.'
    ),
    (
        'Borradores',
        'Gomas de borrar y productos para eliminar trazos.'
    ),
    (
        'Sacapuntas',
        'Sacapuntas manuales y electricos.'
    ),
    (
        'Organizacion',
        'Productos utilizados para organizar documentos y materiales.'
    ),
    (
        'Archivado',
        'Carpetas, folders y productos para archivo documental.'
    ),
    (
        'Engargolado',
        'Materiales y accesorios para engargolado y encuadernacion.'
    ),
    (
        'Oficina',
        'Articulos de uso general para oficina.'
    ),
    (
        'Escolar',
        'Articulos destinados principalmente al uso escolar.'
    ),
    (
        'Manualidades',
        'Materiales para trabajos manuales y proyectos creativos.'
    ),
    (
        'Presentacion',
        'Materiales utilizados para exposiciones y presentaciones.'
    ),
    (
        'Etiquetado',
        'Etiquetas, rotulos y materiales para identificacion.'
    )
ON CONFLICT ("name") DO NOTHING;