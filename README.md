# Task Management System

Sistema de gestión de tareas geoespaciales con API RESTful en Spring Boot, frontend en Vue 3, PostgreSQL + PostGIS, y autenticación JWT.

Esta guía levanta el proyecto completo (**base de datos, backend y frontend**) usando una instalación **local de PostgreSQL**, sin depender del `docker-compose.yml` incluido en `database/` (ese archivo queda como alternativa opcional, no es necesario para seguir esta guía).

---

## Requisitos Previos

- **Java 17** o superior
- **Maven** (o usar el wrapper `./mvnw` incluido)
- **Node.js** `^22.18.0` o `>=24.12.0` y **npm**
- **PostgreSQL 16+** con la extensión **PostGIS** instalados localmente y el servicio corriendo

---

## 🚀 Cómo Levantar el Proyecto

### Paso 1: Preparar la Base de Datos local

1. Asegurate de tener el servicio de PostgreSQL instalado y corriendo, con la extensión PostGIS disponible (instalable como paquete adicional en la mayoría de las distribuciones/gestores de paquetes).

2. Creá la base de datos:

   ```bash
   psql -U postgres -c "CREATE DATABASE task_manager_db;"
   ```

3. Cargá el esquema y los datos de prueba:

   ```bash
   cd database
   psql -U postgres -d task_manager_db -f init.sql
   psql -U postgres -d task_manager_db -f seed.sql
   ```

   `init.sql` crea la extensión PostGIS, las tablas (`users`, `sectors`, `tasks`) y sus índices espaciales. `seed.sql` carga usuarios, sectores (comunas de la Región Metropolitana) y tareas de prueba con coordenadas reales.

4. Configurá la conexión en [backend/src/main/resources/application.properties](backend/src/main/resources/application.properties) para que apunte a tu instancia local (ajustá usuario/contraseña según tu instalación):

   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/task_manager_db
   spring.datasource.username=postgres
   spring.datasource.password=<tu-password-local>
   ```

   > Este archivo queda con tus credenciales locales y normalmente no se sube a git tal cual — si lo modificás, evitá commitear una contraseña real compartida.

### Paso 2: Levantar el Backend

```bash
cd backend
./mvnw spring-boot:run
```

El servidor se levanta en: **http://localhost:8090**

### Paso 3: Levantar el Frontend

```bash
cd frontend
npm install
npm run dev
```

La app se levanta en: **http://localhost:5173** (con proxy automático de `/api` hacia `http://localhost:8090`, configurado en `vite.config.js`).

### Paso 4 (Opcional): Compilar el backend sin ejecutar

```bash
cd backend
./mvnw clean compile
```

---

## 👤 Usuarios de Prueba

El `seed.sql` deja dos usuarios con contraseña utilizable para iniciar sesión directamente:

| Usuario | Contraseña | Ubicación aproximada |
|---|---|---|
| `test_user1` | `test1234` | La Reina |
| `test_user2` | `test5678` | Vitacura |

> El resto de los usuarios del seed (`admin_municipal`, `tecnico_terreno`, `usuario_maipu`, etc.) tienen un hash de contraseña de relleno (no válido para login) — están pensados solo para poblar datos de otras cuentas en las consultas globales (Q6). Para crear tu propio usuario funcional, usá `POST /api/auth/register` o el formulario de registro del frontend.

---

## 📖 Manual de Uso

### 1. Registro e inicio de sesión

- Andá a `http://localhost:5173/register`, completá usuario/email/contraseña y hacé clic en el mapa para fijar tu ubicación. Esa ubicación queda guardada en la BD como tu **"punto registrado"**, usado por varias de las consultas estadísticas (por ejemplo, la Sección 8 del dashboard).
- Si ya tenés cuenta (o usás uno de los usuarios de prueba de arriba), iniciá sesión en `/login`.

### 2. Gestión de Tareas (`/tasks`)

- Formulario para crear una tarea nueva: título, descripción, **fecha y hora de vencimiento** y comuna (sector). No se puede crear (ni el navegador ni el backend lo permiten) una tarea con vencimiento en el pasado.
- Filtros por estado (`Pendientes` / `Completadas` / `Expiradas`) y por palabra clave.
- Cada tarea se puede editar, eliminar o marcar como completada desde el listado. Si editás una tarea `Expirada` y le ponés una fecha/hora futura, vuelve automáticamente a `Pendiente`.
- Las tareas `Pendientes` pasan solas a `Expiradas` apenas se cumple su fecha y hora de vencimiento (chequeo cada vez que se listan tareas, más un job de respaldo que corre cada minuto en el backend).

### 3. Notificaciones (campanita en el header)

- El ícono de campana en la barra de navegación muestra las tareas **pendientes que vencen dentro de los próximos 7 días**, ordenadas por la más próxima a vencer.
- Se actualiza al navegar entre páginas y también hace polling cada 5 minutos.
- Una tarea deja de aparecer ahí sola cuando se completa, se edita a otra fecha, o expira.

### 4. Gestión de Sectores (`/sectors`)

- Cualquier usuario autenticado puede ver el listado de sectores (comunas).
- Los usuarios con rol **ADMIN** además pueden crear, editar y eliminar sectores, indicando latitud/longitud del centroide.

### 5. Dashboard Estadístico (`/stats`)

Responde las 8 preguntas geoespaciales del sistema, cada una en su propia sección:

1. **Tareas completadas por sector** — tabla con el conteo de tareas completadas del usuario logueado, agrupadas por comuna.
2. **Tarea pendiente más cercana** — la tarea sin completar más próxima a tu ubicación registrada.
3. **Sector con más tareas completadas en 2 km** — usando `ST_DWithin` sobre tu ubicación.
4. **Promedio de distancia de tareas completadas (punto elegido por vos)** — a diferencia de la Sección 8, acá elegís el punto de referencia: hacé clic en el mapa de esta sección o usá el botón **"Usar mi ubicación actual"** (geolocalización del navegador), y presioná **"Calcular promedio"**. El resultado se muestra en kilómetros.
5. **Agrupación espacial de tareas pendientes** — sectores donde se concentran más tareas pendientes, con su centroide calculado por PostGIS.
6. **Ranking global de tareas por usuario y sector** — no depende del usuario logueado, muestra el conteo de todos los usuarios.
7. **Sector con más tareas completadas en 5 km** — igual que la 3, con radio de 5 km.
8. **Promedio de distancia de tareas completadas respecto al punto registrado en la BD** — mismo cálculo que la 4, pero siempre contra la ubicación que guardaste al registrarte (no editable desde acá).

> Todas las distancias que muestra el dashboard están en **kilómetros con 2 decimales**; internamente se calculan en metros (`ST_Distance` sobre tipos `geography`).

---

## 🛠️ Tecnologías

| Tecnología | Versión | Uso |
|---|---|---|
| Java | 17 | Lenguaje principal (backend) |
| Spring Boot | 3.5.14 | Framework backend |
| PostgreSQL | 16+ | Base de datos relacional |
| PostGIS | 3.4+ | Extensión geoespacial |
| Vue | 3.5 | Framework frontend |
| Vite | 8 | Build tool / dev server del frontend |
| Leaflet | 1.9 | Mapas interactivos (registro, dashboard) |
| Pinia | 3 | Manejo de estado del frontend |
| Axios | 1.18 | Cliente HTTP del frontend |