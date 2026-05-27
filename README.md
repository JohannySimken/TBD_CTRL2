# Task Management System — Backend

Sistema de gestión de tareas geoespaciales con API RESTful en Spring Boot, PostgreSQL + PostGIS, y autenticación JWT.

---

## Requisitos Previos

- **Java 17** o superior
- **Maven** (o usar el wrapper `./mvnw` incluido)
- **Docker** y **Docker Compose** (para la base de datos)

---

## 🚀 Cómo Levantar el Proyecto

### Paso 1: Levantar la Base de Datos

La base de datos PostgreSQL con PostGIS se levanta con Docker Compose. Incluye el esquema (`init.sql`) y datos de prueba (`seed.sql`).

```bash
cd database
docker-compose up -d
```

Esto levanta:
- **PostgreSQL 16** con extensión **PostGIS 3.4**
- Puerto: `5434` (mapeado al 5432 interno)
- Base de datos: `task_manager_db`
- Usuario: `postgres` / Contraseña: `postgres`

Para verificar que la base de datos está corriendo:

```bash
docker ps
# Deberías ver el contenedor "tbd_postgres"
```

Para conectarte manualmente a la base de datos:

```bash
docker exec -it tbd_postgres psql -U postgres -d task_manager_db
```

### Paso 2: Levantar el Backend

```bash
cd backend
./mvnw spring-boot:run
```

El servidor se levanta en: **http://localhost:8090**

### Paso 3 (Opcional): Compilar sin ejecutar

```bash
cd backend
./mvnw clean compile
```


## 🔐 Autenticación

El sistema usa **JWT (JSON Web Token)**. Para acceder a los endpoints protegidos, debes:

1. Registrarte o iniciar sesión para obtener un token
2. Incluir el token en el header de cada request:

```
Authorization: Bearer <tu-token-jwt>
```

---

## 📡 Documentación de Endpoints


### 1. Autenticación (`/api/auth`) — Público

#### `POST /api/auth/register` — Registrar usuario

**Request Body:**

```json
{
    "username": "juan_perez",
    "email": "juan@email.com",
    "password": "miPassword123",
    "latitude": -33.6597,
    "longitude": -70.9262
}
```

| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `username` | String | ✅ | Nombre de usuario (único, máx. 50 chars) |
| `email` | String | ✅ | Email (único, máx. 100 chars) |
| `password` | String | ✅ | Contraseña (se hashea con BCrypt) |
| `latitude` | Double | ✅ | Latitud de la ubicación del usuario |
| `longitude` | Double | ✅ | Longitud de la ubicación del usuario |

**Response (200 OK):**

```json
{
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "username": "juan_perez",
    "role": "USER"
}
```

**Errores posibles:**
- `404` — "El nombre de usuario ya está registrado"
- `404` — "El email ya está registrado"

---

#### `POST /api/auth/login` — Iniciar sesión

**Request Body:**

```json
{
    "username": "juan_perez",
    "password": "miPassword123"
}
```

| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `username` | String | ✅ | Nombre de usuario |
| `password` | String | ✅ | Contraseña |

**Response (200 OK):**

```json
{
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "username": "juan_perez",
    "role": "USER"
}
```

**Errores posibles:**
- `404` — "Credenciales inválidas"

---

### 2. Tareas (`/api/tasks`) 

#### `POST /api/tasks` — Crear tarea

**Headers:** `Authorization: Bearer <token>`

**Request Body:**

```json
{
    "title": "Reparar luminaria pública",
    "description": "Foco parpadeando en la esquina de la plaza",
    "dueDate": "2026-06-10",
    "sectorId": 1,
    "latitude": -33.6660,
    "longitude": -70.9190
}
```

| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `title` | String | ✅ | Título de la tarea (máx. 150 chars) |
| `description` | String | ❌ | Descripción detallada |
| `dueDate` | String | ✅ | Fecha de vencimiento (formato `YYYY-MM-DD`) |
| `sectorId` | Long | ✅ | ID del sector asociado |
| `latitude` | Double | ✅ | Latitud de la ubicación de la tarea |
| `longitude` | Double | ✅ | Longitud de la ubicación de la tarea |

**Response (200 OK):**

```json
{
    "id": 6,
    "title": "Reparar luminaria pública",
    "description": "Foco parpadeando en la esquina de la plaza",
    "status": "PENDING",
    "dueDate": "2026-06-10",
    "completedAt": null,
    "sectorName": "Sector Plaza Talagante",
    "username": "juan_perez",
    "latitude": -33.6660,
    "longitude": -70.9190
}
```

---

#### `GET /api/tasks` — Listar tareas del usuario

**Headers:** `Authorization: Bearer <token>`

**Query Params (opcionales):**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `status` | String | Filtrar por estado: `PENDING`, `COMPLETED` o `EXPIRED` |
| `keyword` | String | Buscar en título y descripción (case-insensitive) |

**Ejemplos:**

```
GET /api/tasks                              → Todas las tareas del usuario
GET /api/tasks?status=PENDING               → Solo tareas pendientes
GET /api/tasks?keyword=luminaria            → Buscar por palabra clave
GET /api/tasks?status=PENDING&keyword=plaza  → Filtro combinado
```

**Response (200 OK):**

```json
[
    {
        "id": 1,
        "title": "Reparar luminaria pública",
        "description": "Foco parpadeando en la esquina de la plaza",
        "status": "PENDING",
        "dueDate": "2026-06-10",
        "completedAt": null,
        "sectorName": "Sector Plaza Talagante",
        "username": "tecnico_terreno",
        "latitude": -33.6660,
        "longitude": -70.9190
    },
    {
        "id": 3,
        "title": "Tapar bache calzada",
        "description": "Hoyo profundo en calle Independencia",
        "status": "COMPLETED",
        "dueDate": "2026-05-10",
        "completedAt": "2026-05-09T14:30",
        "sectorName": "Sector Plaza Talagante",
        "username": "tecnico_terreno",
        "latitude": -33.6620,
        "longitude": -70.9220
    }
]
```

---

#### `PUT /api/tasks/{id}` — Editar tarea

**Headers:** `Authorization: Bearer <token>`

**Request Body:** 

```json
{
    "title": "Reparar luminaria pública (URGENTE)",
    "description": "Foco parpadeando en la esquina de la plaza, urgente",
    "dueDate": "2026-06-05",
    "sectorId": 1,
    "latitude": -33.6660,
    "longitude": -70.9190
}
```

**Response (200 OK):** Devuelve el `TaskResponseDTO` actualizado.

**Errores posibles:**
- `404` — "Tarea no encontrada con id: {id}"
- `404` — "No tienes permisos para editar esta tarea" (si la tarea no pertenece al usuario)

---

#### `DELETE /api/tasks/{id}` — Eliminar tarea

**Headers:** `Authorization: Bearer <token>`

**Response:** `204 No Content` (sin body)

**Errores posibles:**
- `404` — "Tarea no encontrada con id: {id}"
- `404` — "No tienes permisos para eliminar esta tarea"

---

#### `PATCH /api/tasks/{id}/complete` — Marcar como completada

**Headers:** `Authorization: Bearer <token>`

**Request Body:** Ninguno

**Response (200 OK):**

```json
{
    "id": 1,
    "title": "Reparar luminaria pública",
    "description": "Foco parpadeando en la esquina de la plaza",
    "status": "COMPLETED",
    "dueDate": "2026-06-10",
    "completedAt": "2026-05-27T10:30:00",
    "sectorName": "Sector Plaza Talagante",
    "username": "tecnico_terreno",
    "latitude": -33.6660,
    "longitude": -70.9190
}
```

---

### 3. Sectores (`/api/sectors`) —

#### `GET /api/sectors` — Listar todos los sectores

**Response (200 OK):**

```json
[
    {
        "id": 1,
        "name": "Sector Plaza Talagante",
        "category": "construccion",
        "description": "Zona central y plaza de armas",
        "createdAt": "2026-05-26T10:00:00"
    },
    {
        "id": 2,
        "name": "Sector El Parrón",
        "category": "calles",
        "description": "Zona residencial norte de Talagante",
        "createdAt": "2026-05-26T10:00:00"
    }
]
```

> **Nota:** El campo `location` (Point geoespacial) está excluido del JSON con `@JsonIgnore`.

---

#### `GET /api/sectors/{id}` — Obtener sector por ID

**Response (200 OK):** Un solo objeto `SectorEntity` (mismo formato que arriba).

---

#### `POST /api/sectors` — Crear sector (solo ADMIN) 🛡️

**Headers:** `Authorization: Bearer <token>` (con rol ADMIN)

**Request Body:**

```json
{
    "name": "Sector Nuevo",
    "category": "semaforos",
    "description": "Zona de semáforos del sector sur",
    "location": {
        "type": "Point",
        "coordinates": [-70.9300, -33.6750]
    }
}
```

> **Nota:** El campo `location` se envía como un objeto GeoJSON Point. El orden es `[longitud, latitud]`.

**Response (200 OK):** El sector creado.

**Errores posibles:**
- `403` — "No tienes permisos para realizar esta acción" (si no eres ADMIN)

---

#### `PUT /api/sectors/{id}` — Editar sector (solo ADMIN) 🛡️

**Request Body:** Mismo formato que crear.

---

#### `DELETE /api/sectors/{id}` — Eliminar sector (solo ADMIN) 🛡️

**Response:** `204 No Content`

---

### 4. Estadísticas / Consultas Espaciales (`/api/stats`) 

> Todos estos endpoints obtienen el `userId` automáticamente del token JWT (no se envía en el body).

---

#### `GET /api/stats/tasks-by-sector` — Q1: Tareas completadas del usuario por sector

**Response (200 OK):**

```json
[
    {
        "sectorName": "Sector Plaza Talagante",
        "count": 5
    },
    {
        "sectorName": "Sector Los Boldos",
        "count": 2
    }
]
```

---

#### `GET /api/stats/closest-pending` — Q2: Tarea pendiente más cercana al usuario

**Response (200 OK):**

```json
{
    "id": 1,
    "title": "Reparar luminaria pública",
    "description": "Foco parpadeando en la esquina de la plaza",
    "status": "PENDING",
    "dueDate": "2026-06-10",
    "completedAt": null,
    "notificationSent": false,
    "createdAt": "2026-05-26T10:00:00",
    "user": { ... },
    "sector": { ... },
    "location": { ... }
}
```

> **Nota:** Este endpoint devuelve la `TaskEntity` completa (no un DTO).

**Response (204 No Content):** Si no hay tareas pendientes.

---

#### `GET /api/stats/top-sector-2km` — Q3: Sector con más tareas completadas en radio de 2km

**Response (200 OK):**

```json
{
    "sectorName": "Sector Plaza Talagante",
    "count": 3
}
```

**Response (204 No Content):** Si no hay sectores con tareas completadas en el radio.

---

#### `GET /api/stats/avg-distance-completed` — Q4/Q8: Promedio de distancia de tareas completadas

Devuelve la distancia promedio (en **metros**) entre las tareas completadas del usuario y su ubicación registrada.

**Response (200 OK):**

```json
1523.45
```

> **Nota:** Devuelve un `Double` directamente, no un objeto JSON.

---

#### `GET /api/stats/pending-by-sector-cluster` — Q5: Agrupación espacial de tareas pendientes

**Response (200 OK):**

```json
[
    {
        "sectorName": "Sector Plaza Talagante",
        "pendingCount": 4,
        "centroidWkt": "POINT(-70.9230 -33.6640)"
    },
    {
        "sectorName": "Sector El Parrón",
        "pendingCount": 2,
        "centroidWkt": "POINT(-70.9100 -33.6520)"
    }
]
```

| Campo | Tipo | Descripción |
|---|---|---|
| `sectorName` | String | Nombre del sector |
| `pendingCount` | Long | Cantidad de tareas pendientes |
| `centroidWkt` | String | Centroide del grupo en formato WKT (Well-Known Text) |

---

#### `GET /api/stats/tasks-per-user-by-sector` — Q6: Ranking global de tareas por usuario por sector

> **Nota:** Este endpoint NO requiere userId, muestra datos de todos los usuarios.

**Response (200 OK):**

```json
[
    {
        "username": "tecnico_terreno",
        "sectorName": "Sector Plaza Talagante",
        "count": 5
    },
    {
        "username": "admin_municipal",
        "sectorName": "Sector Los Boldos",
        "count": 3
    }
]
```

---

#### `GET /api/stats/top-sector-5km` — Q7: Sector con más tareas completadas en radio de 5km

**Response (200 OK):**

```json
{
    "sectorName": "Sector Plaza Talagante",
    "count": 7
}
```

**Response (204 No Content):** Si no hay sectores con tareas completadas en el radio.


---

## 🛠️ Tecnologías

| Tecnología | Versión | Uso |
|---|---|---|
| Java | 17 | Lenguaje principal |
| Spring Boot | 3.5.14 | Framework backend |
| PostgreSQL | 16 | Base de datos relacional |
| PostGIS | 3.4 | Extensión geoespacial |