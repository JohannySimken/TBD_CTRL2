-- DATOS DE PRUEBA - Solo para probar queries PostGIS
-- No son datos reales, solo para testeo 
-- Considerar que ST_GeogFromText recibe POINT(longitud latitud) longitud primero, latitud segundo (al revés de Google Maps)


-- 1. Usuarios
INSERT INTO users (username, email, password_hash, role, location) VALUES 
('admin_municipal', 'admin@muni.cl',   'hash_123', 'ADMIN', ST_GeogFromText('SRID=4326;POINT(-70.9262 -33.6597)')),  -- Talagante centro
('tecnico_terreno', 'tecnico@muni.cl', 'hash_456', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.9180 -33.6650)')); -- Talagante sur

-- 2. Sectores (Comunas de la Región Metropolitana de Santiago)
INSERT INTO sectors (name, category, description, location) VALUES 
('Santiago',        'urbano',       'Comuna central de Santiago, corazón administrativo y comercial de la capital', ST_GeogFromText('SRID=4326;POINT(-70.6483 -33.4569)')),
('Providencia',     'urbano',       'Comuna residencial y comercial al oriente de Santiago',                        ST_GeogFromText('SRID=4326;POINT(-70.6124 -33.4328)')),
('Las Condes',      'urbano',       'Comuna de alto desarrollo económico al nororiente de Santiago',                ST_GeogFromText('SRID=4326;POINT(-70.5784 -33.4097)')),
('Maipú',           'urbano',       'Una de las comunas más pobladas de la Región Metropolitana',                  ST_GeogFromText('SRID=4326;POINT(-70.7639 -33.5167)')),
('La Florida',      'urbano',       'Gran comuna del sector sur-oriente de Santiago',                              ST_GeogFromText('SRID=4326;POINT(-70.5892 -33.5239)')),
('Puente Alto',     'urbano',       'La comuna más poblada de Chile, al sur-oriente de Santiago',                  ST_GeogFromText('SRID=4326;POINT(-70.5745 -33.6105)')),
('Ñuñoa',           'urbano',       'Comuna de carácter residencial y cultural en el sector oriente',              ST_GeogFromText('SRID=4326;POINT(-70.5989 -33.4583)')),
('La Reina',        'urbano',       'Comuna residencial al oriente de Santiago, cercana a la cordillera',          ST_GeogFromText('SRID=4326;POINT(-70.5392 -33.4458)')),
('Vitacura',        'urbano',       'Comuna de alta renta y espacios verdes en el nororiente capitalino',          ST_GeogFromText('SRID=4326;POINT(-70.5803 -33.3939)')),
('Talagante',       'rural',        'Capital de la Provincia de Talagante, al suroeste de Santiago',              ST_GeogFromText('SRID=4326;POINT(-70.9265 -33.6600)'));

-- 3. Tareas
-- Tarea 1: PENDING, asignada a la comuna de Santiago
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES 
(2, 1, 'Reparar luminaria pública', 'Foco parpadeando en la esquina de la plaza', 'PENDING', 
 ST_GeogFromText('SRID=4326;POINT(-70.6483 -33.4569)'), '2026-06-10');

-- Tarea 2: PENDING, asignada a la comuna de Maipú
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES 
(2, 4, 'Pintar paso de cebra', 'Pintura desgastada frente al colegio', 'PENDING', 
 ST_GeogFromText('SRID=4326;POINT(-70.7639 -33.5167)'), '2026-06-15');

-- Tarea 3: COMPLETED, asignada a la comuna de Providencia
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES 
(2, 2, 'Tapar bache calzada', 'Hoyo profundo en calle Independencia', 'COMPLETED', 
 ST_GeogFromText('SRID=4326;POINT(-70.6124 -33.4328)'), '2026-05-10', '2026-05-09 14:30:00', true);

-- Tarea 4: COMPLETED, asignada a la comuna de Las Condes
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES 
(2, 3, 'Revisión semáforo avenida', 'Luz roja fundida acceso sur', 'COMPLETED', 
 ST_GeogFromText('SRID=4326;POINT(-70.5784 -33.4097)'), '2026-05-20', '2026-05-19 09:15:00', true);

-- Tarea 5: EXPIRED, asignada a la comuna de La Florida
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES 
(2, 5, 'Señalética caída', 'Señal de tránsito volcada por el viento', 'EXPIRED', 
 ST_GeogFromText('SRID=4326;POINT(-70.5892 -33.5239)'), '2026-04-01');