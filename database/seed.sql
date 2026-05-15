-- DATOS DE PRUEBA - Solo para probar queries PostGIS
-- No son datos reales, solo para testeo 
-- Considerar que ST_GeogFromText recibe POINT(longitud latitud) longitud primero, latitud segundo (al revés de Google Maps)


-- 1. Usuarios
INSERT INTO users (username, email, password_hash, role, location) VALUES 
('admin_municipal', 'admin@muni.cl',   'hash_123', 'ADMIN', ST_GeogFromText('SRID=4326;POINT(-70.9262 -33.6597)')),  -- Talagante centro
('tecnico_terreno', 'tecnico@muni.cl', 'hash_456', 'USER',  ST_GeogFromText('SRID=4326;POINT(-70.9180 -33.6650)')); -- Talagante sur

-- 2. Sectores
INSERT INTO sectors (name, category, description, location) VALUES 
('Sector Plaza Talagante', 'construccion', 'Zona central y plaza de armas',     ST_GeogFromText('SRID=4326;POINT(-70.9265 -33.6600)')),
('Sector El Parrón',       'calles',       'Zona residencial norte de Talagante',ST_GeogFromText('SRID=4326;POINT(-70.9100 -33.6520)')),
('Sector Los Boldos',      'semaforos',    'Zona sur acceso a Talagante',        ST_GeogFromText('SRID=4326;POINT(-70.9300 -33.6750)'));

-- 3. Tareas
-- Tarea 1: PENDING, muy cerca del tecnico (~100m)
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES 
(2, 1, 'Reparar luminaria pública', 'Foco parpadeando en la esquina de la plaza', 'PENDING', 
 ST_GeogFromText('SRID=4326;POINT(-70.9190 -33.6660)'), '2026-06-10');

-- Tarea 2: PENDING, lejos del tecnico (~2.5km)
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES 
(2, 2, 'Pintar paso de cebra', 'Pintura desgastada frente al colegio El Parrón', 'PENDING', 
 ST_GeogFromText('SRID=4326;POINT(-70.9105 -33.6525)'), '2026-06-15');

-- Tarea 3: COMPLETED, distancia media (~1km)
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES 
(2, 1, 'Tapar bache calzada', 'Hoyo profundo en calle Independencia', 'COMPLETED', 
 ST_GeogFromText('SRID=4326;POINT(-70.9220 -33.6620)'), '2026-05-10', '2026-05-09 14:30:00', true);

-- Tarea 4: COMPLETED, cerca del centro (~300m del tecnico)
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date, completed_at, notification_sent) VALUES 
(2, 3, 'Revisión semáforo avenida', 'Luz roja fundida acceso sur', 'COMPLETED', 
 ST_GeogFromText('SRID=4326;POINT(-70.9195 -33.6670)'), '2026-05-20', '2026-05-19 09:15:00', true);

-- Tarea 5: EXPIRED, lejos (~3km)
INSERT INTO tasks (user_id, sector_id, title, description, status, location, due_date) VALUES 
(2, 2, 'Señalética caída', 'Señal de tránsito volcada por el viento', 'EXPIRED', 
 ST_GeogFromText('SRID=4326;POINT(-70.9095 -33.6510)'), '2026-04-01');