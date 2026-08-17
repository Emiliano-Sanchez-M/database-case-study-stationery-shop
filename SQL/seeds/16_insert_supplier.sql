-- SEED: SUPPLIER
--
-- Los valores son ficticios y están destinados únicamente al
-- desarrollo local y a pruebas de base de datos.

INSERT INTO
"supplier" (
    "name",
    "phone",
    "email",
    "address",
    "active",
    "created_at",
    "updated_at"
)
VALUES
(
    'Distribuidora Escolar del Centro',
    '5551234501',
    'ventas@distribuidoraescolar.example.com',
    'Av. Universidad 125, Ciudad de México',
    TRUE,
    '2024-02-15 09:00:00',
    '2026-07-20 10:30:00'
),
(
    'Papeles y Utiles Nacionales',
    '5551234502',
    'contacto@papelesutiles.example.com',
    'Calz. de Tlalpan 845, Ciudad de México',
    TRUE,
    '2024-03-10 10:15:00',
    '2026-06-18 14:20:00'
),
(
    'Distribuciones Escolares del Valle',
    '5551234503',
    'ventas@distribucionesvalle.example.com',
    'Av. División del Norte 1540, Ciudad de México',
    TRUE,
    '2024-04-05 08:30:00',
    '2026-08-01 11:45:00'
),
(
    'Mayorista Papelero Mexicano',
    '5551234504',
    'pedidos@mayoristapapelero.example.com',
    'Av. Central 320, Estado de México',
    TRUE,
    '2024-05-20 09:45:00',
    '2026-07-10 16:00:00'
),
(
    'Comercializadora Escolar Azteca',
    '5551234505',
    'ventas@escolarazteca.example.com',
    'Calle Morelos 215, Estado de México',
    TRUE,
    '2024-06-12 11:00:00',
    '2026-05-25 13:30:00'
),
(
    'Suministros para Oficina MX',
    '5551234506',
    'contacto@suministrosoficina.example.com',
    'Av. Insurgentes Sur 1120, Ciudad de México',
    TRUE,
    '2024-07-01 10:30:00',
    '2026-08-05 09:20:00'
),
(
    'Papelera Metropolitana',
    '5551234507',
    'pedidos@papelerametropolitana.example.com',
    'Av. Revolución 950, Ciudad de México',
    TRUE,
    '2024-08-18 08:45:00',
    '2026-04-15 15:10:00'
),
(
    'Distribuidora Escolar del Bajío',
    '4771234508',
    'ventas@escolarbajio.example.com',
    'Blvd. Adolfo López Mateos 650, Guanajuato',
    TRUE,
    '2024-09-25 12:00:00',
    '2026-07-28 10:00:00'
),
(
    'Comercializadora Materiales Educativos',
    '5551234509',
    'ventas@materialeseducativos.example.com',
    'Av. Coyoacán 480, Ciudad de México',
    TRUE,
    '2024-10-14 09:15:00',
    '2026-06-30 12:40:00'
),
(
    'Proveedora Integral de Papelería',
    '5551234510',
    'contacto@proveedorapapeleria.example.com',
    'Av. Patriotismo 725, Ciudad de México',
    TRUE,
    '2024-11-05 10:00:00',
    '2026-08-08 16:25:00'
),
(
    'Grupo Escolar del Norte',
    '8181234511',
    'ventas@grupoescolarnorte.example.com',
    'Av. Constitución 890, Nuevo León',
    TRUE,
    '2025-01-15 09:30:00',
    '2026-07-14 11:15:00'
),
(
    'Suministros Creativos',
    '5551234512',
    'pedidos@suministroscreativos.example.com',
    'Calle Durango 340, Ciudad de México',
    TRUE,
    '2025-02-10 13:00:00',
    '2026-05-18 09:50:00'
),
(
    'Distribuidora Escolar del Pacífico',
    '3311234513',
    'ventas@escolarpacifico.example.com',
    'Av. Vallarta 1850, Jalisco',
    TRUE,
    '2025-03-20 08:20:00',
    '2026-07-22 14:30:00'
),
(
    'Papelería Mayorista del Sur',
    '5551234514',
    'contacto@mayoristasur.example.com',
    'Calz. de la Virgen 620, Ciudad de México',
    FALSE,
    '2023-06-15 10:00:00',
    '2025-12-20 17:00:00'
),
(
    'Antiguos Suministros Escolares',
    '5551234515',
    'ventas@antiguossuministros.example.com',
    'Calle República de Uruguay 215, Ciudad de México',
    FALSE,
    '2023-02-10 09:00:00',
    '2025-08-15 13:45:00'
),
(
    'Distribuciones del Centro Histórico',
    NULL,
    'contacto@centrohistorico.example.com',
    'Calle Bolívar 125, Ciudad de México',
    TRUE,
    '2025-06-01 11:30:00',
    '2026-08-10 10:15:00'
),
(
    'Proveedor Regional Educativo',
    '5551234517',
    NULL,
    NULL,
    TRUE,
    '2025-07-12 14:00:00',
    '2026-07-12 14:00:00'
),
(
    'Comercializadora Escolar del Oriente',
    '5551234518',
    'ventas@escolaroriente.example.com',
    'Av. Zaragoza 1450, Estado de México',
    TRUE,
    '2025-09-05 09:45:00',
    '2026-06-05 11:20:00'
)
ON CONFLICT DO NOTHING;