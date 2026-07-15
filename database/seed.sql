-- =====================================================================
-- SEEDER
-- Recordatorio: ST_GeogFromText recibe POINT(longitud latitud)
-- Recordatorio: due_date es TIMESTAMP (incluye hora), no solo DATE
-- =====================================================================

-- IMPORTANTE: este script asume que init.sql ya fue ejecutado
-- (tablas vacías). Si ya corriste el seed.sql original, trunca antes:
-- TRUNCATE TABLE tasks, sectors, users RESTART IDENTITY CASCADE;

-- =====================================================================
-- 1. USUARIOS
-- =====================================================================
INSERT INTO users (username, email, password_hash, role, location) VALUES
('admin_municipal',    'admin@muni.cl',        'hash_123', 'ADMIN', ST_GeogFromText('SRID=4326;POINT(-70.9262 -33.6597)')), -- Talagante centro
('tecnico_terreno',    'tecnico@muni.cl',      'hash_456', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.9180 -33.6650)')), -- Talagante sur
('usuario_santiago',   'santiago@muni.cl',     'hash_789', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.6490 -33.4575)')), -- cerca centro Santiago
('usuario_providencia','providencia@muni.cl',  'hash_101', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.6130 -33.4335)')), -- cerca Providencia
('usuario_lascondes',  'lascondes@muni.cl',    'hash_102', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.5790 -33.4100)')), -- cerca Las Condes
('usuario_maipu',      'maipu@muni.cl',        'hash_103', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.7645 -33.5170)')), -- cerca Maipú
('usuario_nunoa',      'nunoa@muni.cl',        'hash_104', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.5995 -33.4590)')), -- cerca Ñuñoa
('usuario_puentealto', 'puentealto@muni.cl',   'hash_105', 'ADMIN', ST_GeogFromText('SRID=4326;POINT(-70.5750 -33.6110)')); -- cerca Puente Alto (2do admin)

-- =====================================================================
-- 2. SECTORES
-- =====================================================================
INSERT INTO sectors (name, category, description, location) VALUES
('Santiago',        'urbano', 'Comuna central de Santiago, corazón administrativo y comercial de la capital', ST_GeogFromText('SRID=4326;POINT(-70.6483 -33.4569)')),
('Providencia',     'urbano', 'Comuna residencial y comercial al oriente de Santiago',                        ST_GeogFromText('SRID=4326;POINT(-70.6124 -33.4328)')),
('Las Condes',      'urbano', 'Comuna de alto desarrollo económico al nororiente de Santiago',                ST_GeogFromText('SRID=4326;POINT(-70.5784 -33.4097)')),
('Maipú',           'urbano', 'Una de las comunas más pobladas de la Región Metropolitana',                  ST_GeogFromText('SRID=4326;POINT(-70.7639 -33.5167)')),
('La Florida',      'urbano', 'Gran comuna del sector sur-oriente de Santiago',                              ST_GeogFromText('SRID=4326;POINT(-70.5892 -33.5239)')),
('Puente Alto',     'urbano', 'La comuna más poblada de Chile, al sur-oriente de Santiago',                  ST_GeogFromText('SRID=4326;POINT(-70.5745 -33.6105)')),
('Ñuñoa',           'urbano', 'Comuna de carácter residencial y cultural en el sector oriente',              ST_GeogFromText('SRID=4326;POINT(-70.5989 -33.4583)')),
('La Reina',        'urbano', 'Comuna residencial al oriente de Santiago, cercana a la cordillera',          ST_GeogFromText('SRID=4326;POINT(-70.5392 -33.4458)')),
('Vitacura',        'urbano', 'Comuna de alta renta y espacios verdes en el nororiente capitalino',          ST_GeogFromText('SRID=4326;POINT(-70.5803 -33.3939)')),
('Talagante',       'rural',  'Capital de la Provincia de Talagante, al suroeste de Santiago',                ST_GeogFromText('SRID=4326;POINT(-70.9265 -33.6600)')),
('Alhué',           'rural',  'Comuna rural al suroeste de la Región Metropolitana, provincia de Melipilla',  ST_GeogFromText('SRID=4326;POINT(-71.1000 -34.0330)')),
('Buin',            'urbano', 'Comuna de la provincia del Maipo, al sur de Santiago',                        ST_GeogFromText('SRID=4326;POINT(-70.7390 -33.7320)')),
('Calera de Tango', 'rural',  'Comuna rural de la provincia del Maipo, entre Santiago y Buin',                ST_GeogFromText('SRID=4326;POINT(-70.7850 -33.6690)')),
('Cerrillos',       'urbano', 'Comuna del sector poniente de Santiago',                                       ST_GeogFromText('SRID=4326;POINT(-70.7060 -33.4970)')),
('Cerro Navia',     'urbano', 'Comuna del sector poniente de Santiago, colindante con Renca y Quinta Normal', ST_GeogFromText('SRID=4326;POINT(-70.7280 -33.4210)')),
('Conchalí',            'urbano', 'Comuna del sector norte de Santiago',                                          ST_GeogFromText('SRID=4326;POINT(-70.6667 -33.3833)')),
('El Bosque',           'urbano', 'Comuna del sector sur de Santiago',                                            ST_GeogFromText('SRID=4326;POINT(-70.6739 -33.5644)')),
('Estación Central',    'urbano', 'Comuna que alberga el principal terminal ferroviario de Santiago',            ST_GeogFromText('SRID=4326;POINT(-70.7000 -33.4600)')),
('Huechuraba',          'urbano', 'Comuna del sector nororiente de Santiago, al pie del cerro San Cristóbal',    ST_GeogFromText('SRID=4326;POINT(-70.6333 -33.3667)')),
('Independencia',       'urbano', 'Comuna del sector norte de Santiago, cercana al centro histórico',            ST_GeogFromText('SRID=4326;POINT(-70.6667 -33.4167)')),
('La Cisterna',         'urbano', 'Comuna del sector sur de Santiago, importante nudo de transporte',            ST_GeogFromText('SRID=4326;POINT(-70.6644 -33.5342)')),
('La Granja',           'urbano', 'Comuna del sector sur de Santiago',                                            ST_GeogFromText('SRID=4326;POINT(-70.6333 -33.5333)')),
('La Pintana',          'urbano', 'Comuna del sector sur de Santiago',                                            ST_GeogFromText('SRID=4326;POINT(-70.6333 -33.5833)')),
('Lo Barnechea',        'rural',  'Comuna precordillerana del sector nororiente, con zonas rurales y de montaña', ST_GeogFromText('SRID=4326;POINT(-70.5167 -33.3500)')),
('Lo Espejo',           'urbano', 'Comuna del sector sur-poniente de Santiago',                                   ST_GeogFromText('SRID=4326;POINT(-70.6833 -33.5333)')),
('Lo Prado',            'urbano', 'Comuna del sector poniente de Santiago',                                       ST_GeogFromText('SRID=4326;POINT(-70.7167 -33.4500)')),
('Macul',               'urbano', 'Comuna del sector suroriente de Santiago',                                     ST_GeogFromText('SRID=4326;POINT(-70.6000 -33.4833)')),
('Pedro Aguirre Cerda', 'urbano', 'Comuna del sector sur-poniente de Santiago',                                   ST_GeogFromText('SRID=4326;POINT(-70.6833 -33.4833)')),
('Peñalolén',           'urbano', 'Comuna precordillerana del sector oriente de Santiago',                       ST_GeogFromText('SRID=4326;POINT(-70.5333 -33.4833)')),
('Pudahuel',            'urbano', 'Comuna del sector poniente de Santiago, sede del aeropuerto internacional',   ST_GeogFromText('SRID=4326;POINT(-70.7500 -33.4333)')),
('Quilicura',           'urbano', 'Comuna del sector norte de Santiago',                                          ST_GeogFromText('SRID=4326;POINT(-70.7333 -33.3667)')),
('Quinta Normal',       'urbano', 'Comuna del sector poniente de Santiago, con importantes parques y museos',    ST_GeogFromText('SRID=4326;POINT(-70.7000 -33.4333)')),
('Recoleta',            'urbano', 'Comuna del sector norte de Santiago, cercana al centro histórico',            ST_GeogFromText('SRID=4326;POINT(-70.6333 -33.4000)')),
('Renca',               'urbano', 'Comuna del sector norponiente de Santiago',                                    ST_GeogFromText('SRID=4326;POINT(-70.7167 -33.4000)')),
('San Joaquín',         'urbano', 'Comuna del sector sur de Santiago',                                            ST_GeogFromText('SRID=4326;POINT(-70.6333 -33.4833)')),
('San Miguel',          'urbano', 'Comuna del sector sur de Santiago',                                            ST_GeogFromText('SRID=4326;POINT(-70.6500 -33.4833)')),
('San Ramón',           'urbano', 'Comuna del sector sur de Santiago',                                            ST_GeogFromText('SRID=4326;POINT(-70.6500 -33.5333)')),
('Pirque',              'rural',  'Comuna rural precordillerana de la provincia Cordillera',                     ST_GeogFromText('SRID=4326;POINT(-70.5667 -33.6333)')),
('San José de Maipo',   'rural',  'Comuna rural de montaña en el Cajón del Maipo',                                ST_GeogFromText('SRID=4326;POINT(-70.3500 -33.6333)')),
('Colina',              'rural',  'Comuna de la provincia de Chacabuco, al norte de Santiago',                    ST_GeogFromText('SRID=4326;POINT(-70.6667 -33.2000)')),
('Lampa',               'rural',  'Comuna de la provincia de Chacabuco, al norte de Santiago',                    ST_GeogFromText('SRID=4326;POINT(-70.8667 -33.2833)')),
('Til Til',             'rural',  'Comuna rural de la provincia de Chacabuco',                                    ST_GeogFromText('SRID=4326;POINT(-70.9167 -33.0833)')),
('San Bernardo',        'urbano', 'Comuna de la provincia del Maipo, al sur de Santiago',                        ST_GeogFromText('SRID=4326;POINT(-70.7000 -33.6000)')),
('Paine',               'rural',  'Comuna rural de la provincia del Maipo',                                       ST_GeogFromText('SRID=4326;POINT(-70.7333 -33.8000)')),
('Melipilla',           'rural',  'Capital de la provincia de Melipilla, al suroeste de Santiago',                ST_GeogFromText('SRID=4326;POINT(-71.2167 -33.6833)')),
('Curacaví',            'rural',  'Comuna rural de la provincia de Melipilla',                                    ST_GeogFromText('SRID=4326;POINT(-71.1333 -33.4000)')),
('María Pinto',         'rural',  'Comuna rural de la provincia de Melipilla',                                    ST_GeogFromText('SRID=4326;POINT(-71.1167 -33.5667)')),
('San Pedro',           'rural',  'Comuna rural de la provincia de Melipilla, la más alejada de Santiago',        ST_GeogFromText('SRID=4326;POINT(-71.4667 -33.9000)')),
('El Monte',            'rural',  'Comuna de la provincia de Talagante',                                          ST_GeogFromText('SRID=4326;POINT(-70.9833 -33.6833)')),
('Isla de Maipo',       'rural',  'Comuna rural de la provincia de Talagante',                                    ST_GeogFromText('SRID=4326;POINT(-70.9167 -33.7500)')),
('Padre Hurtado',       'urbano', 'Comuna de la provincia de Talagante',                                          ST_GeogFromText('SRID=4326;POINT(-70.8500 -33.5667)')),
('Peñaflor',            'urbano', 'Comuna de la provincia de Talagante',                                          ST_GeogFromText('SRID=4326;POINT(-70.9333 -33.6000)'));

-- =====================================================================
-- 3. TAREAS
-- =====================================================================

-- --- Tareas---
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(2, 1, 'Reparar luminaria pública', 'Foco parpadeando en la esquina de la plaza', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6483 -33.4569)'), '2026-06-10 12:00:00');

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(2, 4, 'Pintar paso de cebra', 'Pintura desgastada frente al colegio', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.7639 -33.5167)'), '2026-06-15 12:00:00');

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(2, 2, 'Tapar bache calzada', 'Hoyo profundo en calle Independencia', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6124 -33.4328)'), '2026-05-10 12:00:00', '2026-05-09 14:30:00', true);

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(2, 3, 'Revisión semáforo avenida', 'Luz roja fundida acceso sur', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5784 -33.4097)'), '2026-05-20 12:00:00', '2026-05-19 09:15:00', true);

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(2, 5, 'Señalética caída', 'Señal de tránsito volcada por el viento', 'EXPIRED',
 ST_GeogFromText('SRID=4326;POINT(-70.5892 -33.5239)'), '2026-04-01 12:00:00');

-- --- Usuario 3 (usuario_santiago) - Sector Santiago (id 1) ---
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(3, 1, 'Reparar reja de parque', 'Reja oxidada y suelta en Parque Forestal', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6488 -33.4572)'), '2026-07-22 12:00:00', true); -- ~350m del usuario, vence pronto

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(3, 1, 'Limpieza de plaza', 'Acumulación de basura tras evento', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6600 -33.4650)'), '2026-08-05 12:00:00', false); -- ~1.6km del usuario

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(3, 1, 'Retirar escombros vereda', 'Escombros de obra bloquean vereda', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6492 -33.4578)'), '2026-06-01 12:00:00', '2026-05-30 11:00:00', true); -- ~200m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(3, 1, 'Pintar cruce peatonal', 'Demarcación borrada', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6420 -33.4520)'), '2026-06-10 12:00:00', '2026-06-08 10:00:00', true); -- ~1.1km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(3, 14, 'Poda de árboles', 'Ramas invaden la calle', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6100 -33.4900)'), '2026-05-25 12:00:00', '2026-05-24 16:00:00', true); -- ~5.5km, fuera de radio 5km aprox

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(3, 1, 'Cambiar tapa de alcantarilla', 'Tapa rota, riesgo de accidente', 'EXPIRED',
 ST_GeogFromText('SRID=4326;POINT(-70.6550 -33.4600)'), '2026-03-15 12:00:00');

-- --- Usuario 4 (usuario_providencia) - Sector Providencia (id 2) y Alumbrado Providencia (id 11) ---
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(4, 2, 'Fuga de agua potable', 'Filtración en vereda de Av. 11 de Septiembre', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6135 -33.4340)'), '2026-07-25 12:00:00', true); -- ~150m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(4, 11, 'Poste de luz apagado', 'Cuadra completa sin iluminación nocturna', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6112 -33.4312)'), '2026-08-01 12:00:00', false); -- ~250m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(4, 11, 'Cambio de ampolleta LED', 'Poste con luz intermitente', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6118 -33.4320)'), '2026-06-05 12:00:00', '2026-06-04 09:30:00', true); -- ~200m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(4, 2, 'Reparar grieta en vereda', 'Grieta profunda genera riesgo de caídas', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6200 -33.4400)'), '2026-06-12 12:00:00', '2026-06-11 15:00:00', true); -- ~1.2km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(4, 2, 'Limpieza de sumideros', 'Sumidero tapado provoca inundación', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6350 -33.4450)'), '2026-05-28 12:00:00', '2026-05-27 13:20:00', true); -- ~2.4km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(4, 2, 'Retiro de escombros', 'Escombros abandonados en bandejón', 'EXPIRED',
 ST_GeogFromText('SRID=4326;POINT(-70.6250 -33.4380)'), '2026-03-20 12:00:00');

-- --- Usuario 5 (usuario_lascondes) - Sector Las Condes (id 3) y Semáforos Las Condes (id 12) ---
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(5, 12, 'Semáforo intermitente', 'Semáforo parpadea en amarillo constantemente', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5775 -33.4090)'), '2026-07-18 12:00:00', true); -- ~150m, vence muy pronto

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(5, 3, 'Poda de árboles caídos', 'Rama grande obstruye vereda', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5900 -33.4200)'), '2026-08-10 12:00:00', false); -- ~1.9km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(5, 12, 'Reparación de semáforo peatonal', 'Botón de cruce no funciona', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5780 -33.4095)'), '2026-06-02 12:00:00', '2026-06-01 12:00:00', true); -- ~100m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(5, 3, 'Reposición de pasto', 'Área verde dañada por obras', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5820 -33.4130)'), '2026-06-15 12:00:00', '2026-06-14 10:45:00', true); -- ~600m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(5, 3, 'Limpieza de grafitis', 'Muro municipal rayado', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6000 -33.4300)'), '2026-05-18 12:00:00', '2026-05-17 14:00:00', true); -- ~2.6km

-- --- Usuario 6 (usuario_maipu) - Sector Maipú (id 4) y Bacheo Maipú (id 13) ---
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(6, 13, 'Bache profundo Av. Pajaritos', 'Bache genera riesgo para vehículos', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.7648 -33.5175)'), '2026-07-21 12:00:00', true); -- ~150m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(6, 4, 'Corte de pasto plaza central', 'Pasto crecido en plaza de Maipú', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.7750 -33.5250)'), '2026-08-08 12:00:00', false); -- ~1.7km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(6, 13, 'Repavimentación calle interior', 'Calle con múltiples baches', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.7660 -33.5190)'), '2026-06-07 12:00:00', '2026-06-06 08:30:00', true); -- ~200m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(6, 4, 'Reparación de reja municipal', 'Reja de acceso a plaza dañada', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.7700 -33.5220)'), '2026-05-30 12:00:00', '2026-05-29 09:00:00', true); -- ~800m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(6, 4, 'Retiro de micro-basural', 'Basural en sitio eriazo', 'EXPIRED',
 ST_GeogFromText('SRID=4326;POINT(-70.7900 -33.5300)'), '2026-04-05 12:00:00');

-- --- Usuario 7 (usuario_nunoa) - Sector Ñuñoa (id 7) y Áreas Verdes Ñuñoa (id 14) ---
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(7, 14, 'Riego de plaza seca', 'Áreas verdes sin riego hace semanas', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6005 -33.4598)'), '2026-07-19 12:00:00', true); -- ~100m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(7, 7, 'Reparar juegos infantiles', 'Columpio roto en plaza de barrio', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6100 -33.4700)'), '2026-08-12 12:00:00', false); -- ~1.6km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(7, 14, 'Poda de setos', 'Setos crecidos invaden vereda', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5998 -33.4592)'), '2026-06-03 12:00:00', '2026-06-02 11:15:00', true); -- ~80m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(7, 7, 'Reparación de banca pública', 'Banca de plaza rota', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.6050 -33.4650)'), '2026-05-22 12:00:00', '2026-05-21 10:00:00', true); -- ~950m

-- --- Usuario 8 (usuario_puentealto, ADMIN) - Sector Puente Alto (id 6) y Aseo Puente Alto (id 15) ---
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(8, 15, 'Contenedores desbordados', 'Basura acumulada en esquina', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5755 -33.6115)'), '2026-07-20 12:00:00', true); -- ~100m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(8, 6, 'Reposición de señalética vial', 'Señal PARE derribada', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5850 -33.6200)'), '2026-08-03 12:00:00', false); -- ~1.5km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(8, 15, 'Limpieza de vertedero ilegal', 'Microbasural en sitio eriazo', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5762 -33.6125)'), '2026-06-09 12:00:00', '2026-06-08 14:40:00', true); -- ~150m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(8, 6, 'Reparación de vereda agrietada', 'Vereda levantada por raíces', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5900 -33.6250)'), '2026-05-31 12:00:00', '2026-05-30 09:50:00', true); -- ~1.9km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(8, 6, 'Retiro de árbol caído', 'Árbol bloquea calzada tras temporal', 'EXPIRED',
 ST_GeogFromText('SRID=4326;POINT(-70.6000 -33.6300)'), '2026-04-10 12:00:00');

-- =====================================================================
-- 4. USUARIOS DE PRUEBA "ACCESIBLES" (ids 9 y 10)
-- =====================================================================
-- CREDENCIALES DE PRUEBA
--   usuario: test_user1   password: test1234
--   usuario: test_user2   password: test5678
-- =====================================================================
INSERT INTO users (username, email, password_hash, role, location) VALUES
('test_user1', 'test1@muni.cl', '$2b$10$PxIh/X27BqYuTBsQMAfgJ.MtFRpYHErW/kUM7Dkm9q2/lftRDAjde', 'USER', ST_GeogFromText('SRID=4326;POINT(-70.5395 -33.4460)')), -- cerca La Reina
('test_user2', 'test2@muni.cl', '$2b$10$eY2/tV7ZmkrPFCU0jBxUPeybBm0Wqo5NtiirOtsTzjjjyGiGMqLby', 'USER', ST_GeogFromText('SRID=4326;POINT(-70.5806 -33.3942)')); -- cerca Vitacura

-- --- Tareas test_user1 (id 9), zona La Reina (sector 8) ---

-- PENDING
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(9, 8, 'Poda de árbol peligroso', 'Rama grande a punto de caer sobre la calle', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5397 -33.4462)'), '2026-07-19 12:00:00', true); -- ~50m, vence pronto

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(9, 8, 'Reparar juego infantil', 'Resbalín con estructura suelta', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5420 -33.4480)'), '2026-07-30 12:00:00', true);

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(9, 7, 'Corte de pasto plaza vecinal', 'Pasto crecido hace más de un mes', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5600 -33.4550)'), '2026-08-15 12:00:00', false); -- ~2.3km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(9, 8, 'Reponer luminaria apagada', 'Poste sin luz hace tres noches', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5900 -33.4700)'), '2026-08-20 12:00:00', false); -- ~5.9km, fuera de radio 5km

-- COMPLETED
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(9, 8, 'Reparar vereda agrietada', 'Grieta profunda frente a casa vecina', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5400 -33.4465)'), '2026-06-01 12:00:00', '2026-05-31 10:00:00', true); -- ~100m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(9, 8, 'Limpieza de canaleta', 'Canaleta obstruida por hojas', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5410 -33.4470)'), '2026-06-05 12:00:00', '2026-06-04 09:00:00', true); -- ~250m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(9, 8, 'Pintura de reja municipal', 'Reja oxidada en acceso a plaza', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5450 -33.4500)'), '2026-06-10 12:00:00', '2026-06-09 15:30:00', true); -- ~800m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(9, 7, 'Retiro de escombros', 'Escombros de poda abandonados', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5550 -33.4600)'), '2026-06-18 12:00:00', '2026-06-17 11:20:00', true); -- ~2km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(9, 8, 'Reparación de bandejón central', 'Áreas verdes dañadas por vehículo', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5700 -33.4650)'), '2026-05-15 12:00:00', '2026-05-14 13:00:00', true); -- ~4.2km

-- EXPIRED
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(9, 8, 'Cambio de tapa de alcantarilla', 'Tapa rota, riesgo para peatones', 'EXPIRED',
 ST_GeogFromText('SRID=4326;POINT(-70.5430 -33.4485)'), '2026-04-08 12:00:00');

-- --- Tareas test_user2 (id 10), zona Vitacura (sector 9) ---

-- PENDING
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(10, 9, 'Fuga de agua en bandejón', 'Filtración constante en área verde', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5808 -33.3945)'), '2026-07-20 12:00:00', true); -- ~60m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(10, 9, 'Reparar ciclovía dañada', 'Pavimento levantado en ciclovía', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5830 -33.3960)'), '2026-08-02 12:00:00', true);

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(10, 12, 'Semáforo sin energía', 'Intersección sin funcionamiento tras corte de luz', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.5790 -33.4050)'), '2026-08-18 12:00:00', false); -- ~1.4km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, notification_sent) VALUES
(10, 9, 'Poda de setos altos', 'Setos obstruyen visibilidad en cruce', 'PENDING',
 ST_GeogFromText('SRID=4326;POINT(-70.6000 -33.4200)'), '2026-08-25 12:00:00', false); -- ~5.6km, fuera de radio 5km

-- COMPLETED
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(10, 9, 'Retiro de rama caída', 'Rama bloqueaba parte de la calzada', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5810 -33.3947)'), '2026-06-02 12:00:00', '2026-06-01 08:45:00', true); -- ~120m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(10, 9, 'Reparación de reja parque', 'Reja doblada por accidente vehicular', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5825 -33.3955)'), '2026-06-08 12:00:00', '2026-06-07 14:10:00', true); -- ~350m

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(10, 9, 'Pintura de gimnasio al aire libre', 'Estructuras metálicas oxidadas', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5870 -33.3980)'), '2026-06-14 12:00:00', '2026-06-13 10:30:00', true); -- ~1km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(10, 12, 'Reparación semáforo peatonal', 'Botón de cruce dañado', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5800 -33.4020)'), '2026-06-20 12:00:00', '2026-06-19 16:00:00', true); -- ~1.1km

INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES
(10, 9, 'Limpieza de plaza mirador', 'Basura acumulada tras fin de semana largo', 'COMPLETED',
 ST_GeogFromText('SRID=4326;POINT(-70.5950 -33.4100)'), '2026-05-20 12:00:00', '2026-05-19 12:00:00', true); -- ~3.7km

-- EXPIRED
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES
(10, 9, 'Reposición de baldosas', 'Baldosas sueltas en paseo peatonal', 'EXPIRED',
 ST_GeogFromText('SRID=4326;POINT(-70.5840 -33.3965)'), '2026-04-12 12:00:00');