-- SEED: SERVICE
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
"service" (
    "name",
    "description",
    "active",
    "created_at",
    "updated_at"
)
VALUES
(
    'Impresion blanco y negro',
    'Impresion de documentos en blanco y negro en papel tamaño carta.',
    TRUE,
    '2025-01-10 09:00:00',
    '2025-01-10 09:00:00'
),
(
    'Impresion a color',
    'Impresion de documentos e imagenes a color en papel tamaño carta.',
    TRUE,
    '2025-01-01 10:30:00',
    '2026-07-15 11:20:00'
),
(
    'Fotocopia blanco y negro',
    'Servicio de copiado de documentos en blanco y negro.',
    TRUE,
    '2025-02-05 08:45:00',
    '2025-02-05 08:45:00'
),
(
    'Fotocopia a color',
    'Servicio de copiado de documentos a color.',
    TRUE,
    '2025-02-05 08:50:00',
    '2025-08-01 12:00:00'
),
(
    'Escaneo de documentos',
    'Digitalizacion de documentos mediante escaner.',
    TRUE,
    '2025-03-12 09:15:00',
    '2025-03-12 09:15:00'
),
(
    'Engargolado',
    'Encuadernacion de documentos mediante arillo plastico.',
    TRUE,
    '2025-01-20 10:00:00',
    '2026-01-05 14:30:00'
),
(
    'Enmicado',
    'Proteccion de documentos mediante laminado plastico.',
    TRUE,
    '2025-01-22 11:00:00',
    '2025-12-10 09:45:00'
),
(
    'Plastificado',
    'Plastificado de documentos, tarjetas y materiales impresos.',
    TRUE,
    '2025-04-08 13:30:00',
    '2025-04-08 13:30:00'
),
(
    'Corte de papel',
    'Corte de hojas y materiales impresos a medidas especificas.',
    TRUE,
    '2025-05-15 10:20:00',
    '2025-05-15 10:20:00'
),
(
    'Impresion fotografica',
    'Impresion de fotografias en papel fotografico.',
    TRUE,
    '2025-06-01 09:30:00',
    '2026-06-20 16:15:00'
),
(
    'Impresion de planos',
    'Impresion de planos y documentos de gran formato.',
    TRUE,
    '2025-06-15 11:45:00',
    '2026-05-10 10:00:00'
),
(
    'Diseño de invitaciones',
    'Diseño e impresion de invitaciones personalizadas para eventos.',
    TRUE,
    '2025-07-01 12:00:00',
    '2026-07-01 12:00:00'
),
(
    'Diseño de tarjetas',
    'Diseño e impresion de tarjetas de presentacion personalizadas.',
    TRUE,
    '2025-07-10 14:00:00',
    '2025-07-10 14:00:00'
),
(
    'Digitalizacion de fotografias',
    'Conversion de fotografias fisicas a archivos digitales.',
    TRUE,
    '2025-08-05 09:40:00',
    '2025-08-05 09:40:00'
),
(
    'Restauracion basica de documentos',
    'Correccion digital basica de manchas, recortes y defectos en documentos.',
    TRUE,
    '2025-09-01 10:15:00',
    '2026-02-12 15:30:00'
),
(
    'Impresion de etiquetas',
    'Impresion de etiquetas adhesivas personalizadas.',
    TRUE,
    '2025-10-10 11:30:00',
    '2025-10-10 11:30:00'
),
(
    'Encuadernado profesional',
    'Encuadernacion de documentos mediante diferentes acabados.',
    TRUE,
    '2025-11-15 13:00:00',
    '2026-03-20 09:15:00'
),
(
    'Copiado de documentos antiguos',
    'Reproduccion de documentos antiguos procurando conservar su formato original.',
    FALSE,
    '2024-05-20 10:00:00',
    '2025-11-30 16:00:00'
),
(
    'Servicio de fax',
    'Envio y recepcion de documentos mediante servicio de fax.',
    FALSE,
    '2024-03-15 09:00:00',
    '2025-06-30 17:00:00'
),
(
    'Revelado fotografico',
    'Servicio tradicional de revelado e impresion fotografica.',
    FALSE,
    '2024-01-10 08:30:00',
    '2025-01-15 12:45:00'
)
ON CONFLICT DO NOTHING;