-- SEED: MARCAS
-- Inserta marcas representativas de productos de papeleria.
--
-- Las marcas corresponden a productos comercializados en Mexico
-- y estan destinadas al desarrollo local y a pruebas de base de datos.

INSERT INTO
    "brand" ("name", "description")
VALUES
    (
        'Dixon',
        'Marca de instrumentos de escritura y productos escolares.'
    ),
    (
        'Norma',
        'Marca de productos escolares, papeleria y escritura.'
    ),
    (
        'Pelikan',
        'Marca de articulos escolares, escritura y productos artisticos.'
    ),
    (
        'Barrilito',
        'Marca de productos escolares y articulos de papeleria.'
    ),
    (
        'Baco',
        'Marca de articulos escolares y productos de papeleria.'
    ),
    (
        'MAE',
        'Marca de utiles escolares y articulos de papeleria.'
    ),
    (
        'Vinci',
        'Marca de productos artisticos y materiales escolares.'
    ),
    (
        'Crayola',
        'Marca de materiales para colorear y actividades artisticas.'
    ),
    (
        'Maped',
        'Marca de instrumentos escolares y productos de papeleria.'
    ),
    (
        'Faber-Castell',
        'Marca de instrumentos de escritura y productos artisticos.'
    ),
    (
        'Staedtler',
        'Marca de instrumentos de escritura, dibujo y geometria.'
    ),
    (
        'BIC',
        'Marca de instrumentos de escritura y productos escolares.'
    ),
    (
        'Pilot',
        'Marca de instrumentos de escritura.'
    ),
    (
        'Pentel',
        'Marca de instrumentos de escritura y dibujo.'
    ),
    (
        'Paper Mate',
        'Marca de instrumentos de escritura.'
    ),
    (
        'Pritt',
        'Marca de adhesivos y productos escolares.'
    ),
    (
        'Resistol',
        'Marca de adhesivos para diferentes aplicaciones.'
    ),
    (
        'Scribe',
        'Marca de cuadernos, libretas y productos de papel.'
    ),
    (
        'Estrella',
        'Marca de cuadernos y productos escolares.'
    ),
    (
        'Copamex',
        'Marca de productos de papel y papeleria.'
    ),
    (
        'Sharpie',
        'Marca de marcadores y productos de escritura.'
    ),
    (
        'Stabilo',
        'Marca de instrumentos de escritura y marcadores.'
    ),
    (
        'Prismacolor',
        'Marca de materiales artisticos y productos para dibujo.'
    ),
    (
        'Jovi',
        'Marca de materiales artisticos y productos para modelado.'
    ),
    (
        'Colorim',
        'Marca de plastilinas y materiales escolares.'
    ),
    (
        'Mussa',
        'Marca de materiales escolares y productos de modelado.'
    ),
    (
        'Makyco',
        'Marca de productos escolares y materiales de modelado.'
    ),
    (
        'Pascua',
        'Marca de productos de papeleria y materiales escolares.'
    ),
    (
        'UHU',
        'Marca de adhesivos y productos para manualidades.'
    ),
    (
        'Scotch',
        'Marca de cintas adhesivas y productos para oficina.'
    )
ON CONFLICT ("name") DO NOTHING;