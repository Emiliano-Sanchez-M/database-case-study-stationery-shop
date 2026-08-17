-- SEED: SERVICE_RATE
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
"service_rate" (
    "service_id",
    "name",
    "unit_price",
    "configuration",
    "active",
    "created_at",
    "updated_at"
)
VALUES
-- IMPRESION BLANCO Y NEGRO
(
    1,
    'Carta',
    1.50,
    '{"paper_size": "LETTER", "color": false}',
    TRUE,
    '2025-01-10 09:15:00',
    '2025-01-10 09:15:00'
),
(
    1,
    'Oficio',
    2.00,
    '{"paper_size": "LEGAL", "color": false}',
    TRUE,
    '2025-01-10 09:20:00',
    '2026-05-15 10:30:00'
),
-- IMPRESION A COLOR
(
    2,
    'Carta',
    3.50,
    '{"paper_size": "LETTER", "color": true, "quality": "STANDARD"}',
    TRUE,
    '2025-01-01 11:00:00',
    '2026-07-15 11:30:00'
),
(
    2,
    'Carta alta calidad',
    6.00,
    '{"paper_size": "LETTER", "color": true, "quality": "HIGH"}',
    TRUE,
    '2025-01-02 09:00:00',
    '2026-07-15 11:35:00'
),
(
    2,
    'Oficio',
    5.00,
    '{"paper_size": "LEGAL", "color": true, "quality": "STANDARD"}',
    TRUE,
    '2025-01-02 09:15:00',
    '2026-07-15 11:40:00'
),
-- FOTOCOPIA BLANCO Y NEGRO
(
    3,
    'Carta',
    1.00,
    '{"paper_size": "LETTER", "color": false}',
    TRUE,
    '2025-02-05 09:00:00',
    '2025-02-05 09:00:00'
),
(
    3,
    'Oficio',
    1.50,
    '{"paper_size": "LEGAL", "color": false}',
    TRUE,
    '2025-02-05 09:10:00',
    '2026-01-20 12:00:00'
),
-- FOTOCOPIA A COLOR
(
    4,
    'Carta',
    3.00,
    '{"paper_size": "LETTER", "color": true}',
    TRUE,
    '2025-02-05 09:30:00',
    '2025-08-01 12:15:00'
),
(
    4,
    'Oficio',
    4.50,
    '{"paper_size": "LEGAL", "color": true}',
    TRUE,
    '2025-02-05 09:40:00',
    '2025-08-01 12:20:00'
),
-- ESCANEO
(
    5,
    'Por documento',
    5.00,
    '{"output_formats": ["PDF", "JPG"], "resolution_dpi": 300}',
    TRUE,
    '2025-03-12 09:30:00',
    '2025-03-12 09:30:00'
),
(
    5,
    'Alta resolucion',
    10.00,
    '{"output_formats": ["PDF", "JPG", "PNG"], "resolution_dpi": 600}',
    TRUE,
    '2025-03-12 09:35:00',
    '2026-02-01 10:00:00'
),
-- ENGARGOLADO
(
    6,
    'Hasta 50 hojas',
    25.00,
    '{"min_pages": 1, "max_pages": 50, "binding": "PLASTIC_RING"}',
    TRUE,
    '2025-01-20 10:30:00',
    '2026-01-05 14:45:00'
),
(
    6,
    '51 a 100 hojas',
    35.00,
    '{"min_pages": 51, "max_pages": 100, "binding": "PLASTIC_RING"}',
    TRUE,
    '2025-01-20 10:35:00',
    '2026-01-05 14:50:00'
),
(
    6,
    '101 a 200 hojas',
    50.00,
    '{"min_pages": 101, "max_pages": 200, "binding": "PLASTIC_RING"}',
    TRUE,
    '2025-01-20 10:40:00',
    '2026-01-05 14:55:00'
),
-- ENMICADO
(
    7,
    'Carta',
    18.00,
    '{"paper_size": "LETTER", "finish": "GLOSSY"}',
    TRUE,
    '2025-01-22 11:15:00',
    '2025-12-10 10:00:00'
),
(
    7,
    'Oficio',
    25.00,
    '{"paper_size": "LEGAL", "finish": "GLOSSY"}',
    TRUE,
    '2025-01-22 11:20:00',
    '2025-12-10 10:05:00'
),
-- PLASTIFICADO
(
    8,
    'Credencial',
    15.00,
    '{"size": "CREDENTIAL", "finish": "GLOSSY"}',
    TRUE,
    '2025-04-08 13:45:00',
    '2025-04-08 13:45:00'
),
(
    8,
    'Carta',
    30.00,
    '{"paper_size": "LETTER", "finish": "GLOSSY"}',
    TRUE,
    '2025-04-08 13:50:00',
    '2026-03-10 11:00:00'
),
-- CORTE DE PAPEL
(
    9,
    'Corte sencillo',
    5.00,
    '{"cuts": 1, "precision": "STANDARD"}',
    TRUE,
    '2025-05-15 10:30:00',
    '2025-05-15 10:30:00'
),
(
    9,
    'Corte multiple',
    15.00,
    '{"cuts": 5, "precision": "HIGH"}',
    TRUE,
    '2025-05-15 10:35:00',
    '2026-04-15 09:30:00'
),
-- IMPRESION FOTOGRAFICA
(
    10,
    '10 x 15 cm',
    12.00,
    '{"width_cm": 10, "height_cm": 15, "paper": "PHOTO"}',
    TRUE,
    '2025-06-01 09:45:00',
    '2026-06-20 16:30:00'
),
(
    10,
    '13 x 18 cm',
    18.00,
    '{"width_cm": 13, "height_cm": 18, "paper": "PHOTO"}',
    TRUE,
    '2025-06-01 09:50:00',
    '2026-06-20 16:35:00'
),
(
    10,
    '20 x 25 cm',
    35.00,
    '{"width_cm": 20, "height_cm": 25, "paper": "PHOTO"}',
    TRUE,
    '2025-06-01 09:55:00',
    '2026-06-20 16:40:00'
),
-- IMPRESION DE PLANOS
(
    11,
    'Blanco y negro',
    35.00,
    '{"color": false, "paper_size": "A1"}',
    TRUE,
    '2025-06-15 12:00:00',
    '2026-05-10 10:15:00'
),
(
    11,
    'Color',
    80.00,
    '{"color": true, "paper_size": "A1"}',
    TRUE,
    '2025-06-15 12:05:00',
    '2026-05-10 10:20:00'
),
-- DISEÑO DE INVITACIONES
(
    12,
    'Diseño basico',
    100.00,
    '{"design_type": "BASIC", "revisions": 1}',
    TRUE,
    '2025-07-01 12:15:00',
    '2026-07-01 12:15:00'
),
(
    12,
    'Diseño personalizado',
    200.00,
    '{"design_type": "CUSTOM", "revisions": 3}',
    TRUE,
    '2025-07-01 12:20:00',
    '2026-07-01 12:20:00'
),
-- DISEÑO DE TARJETAS
(
    13,
    'Diseño basico',
    80.00,
    '{"design_type": "BASIC", "revisions": 1}',
    TRUE,
    '2025-07-10 14:15:00',
    '2025-07-10 14:15:00'
),
(
    13,
    'Diseño personalizado',
    150.00,
    '{"design_type": "CUSTOM", "revisions": 3}',
    TRUE,
    '2025-07-10 14:20:00',
    '2026-02-20 13:00:00'
),
-- DIGITALIZACION DE FOTOGRAFIAS
(
    14,
    'Fotografia individual',
    10.00,
    '{"format": "JPG", "resolution_dpi": 300}',
    TRUE,
    '2025-08-05 10:00:00',
    '2025-08-05 10:00:00'
),
(
    14,
    'Alta resolucion',
    20.00,
    '{"format": "PNG", "resolution_dpi": 600}',
    TRUE,
    '2025-08-05 10:05:00',
    '2026-01-15 11:30:00'
),
-- RESTAURACION BASICA
(
    15,
    'Restauracion sencilla',
    50.00,
    '{"complexity": "LOW", "revisions": 1}',
    TRUE,
    '2025-09-01 10:30:00',
    '2026-02-12 15:45:00'
),
(
    15,
    'Restauracion avanzada',
    120.00,
    '{"complexity": "HIGH", "revisions": 3}',
    TRUE,
    '2025-09-01 10:35:00',
    '2026-02-12 15:50:00'
),
-- IMPRESION DE ETIQUETAS
(
    16,
    'Hoja de etiquetas',
    20.00,
    '{"paper_type": "ADHESIVE", "sheet_size": "LETTER"}',
    TRUE,
    '2025-10-10 11:45:00',
    '2025-10-10 11:45:00'
),
(
    16,
    'Etiqueta individual',
    3.00,
    '{"paper_type": "ADHESIVE", "individual": true}',
    TRUE,
    '2025-10-10 11:50:00',
    '2026-03-15 10:00:00'
),
-- ENCUADERNADO PROFESIONAL
(
    17,
    'Encuadernado basico',
    60.00,
    '{"binding": "PROFESSIONAL", "cover": "STANDARD"}',
    TRUE,
    '2025-11-15 13:15:00',
    '2026-03-20 09:30:00'
),
(
    17,
    'Encuadernado con pasta dura',
    100.00,
    '{"binding": "HARD_COVER", "cover": "PREMIUM"}',
    TRUE,
    '2025-11-15 13:20:00',
    '2026-03-20 09:35:00'
),
-- TARIFA HISTORICA INACTIVA
(
    2,
    'Carta economica',
    2.50,
    '{"paper_size": "LETTER", "color": true, "quality": "ECONOMIC"}',
    FALSE,
    '2025-01-01 10:45:00',
    '2026-01-01 09:00:00'
),
(
    6,
    'Hasta 30 hojas',
    20.00,
    '{"min_pages": 1, "max_pages": 30, "binding": "PLASTIC_RING"}',
    FALSE,
    '2025-01-20 10:15:00',
    '2026-01-05 14:40:00'
)
ON CONFLICT DO NOTHING;