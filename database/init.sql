-- Activar PostGIS en la base de datos
CREATE EXTENSION IF NOT EXISTS postgis;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS sectors CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;

-- Tabla USERS
CREATE TABLE users (
    id              BIGSERIAL               PRIMARY KEY,
    username        VARCHAR(50)             NOT NULL UNIQUE,
    email           VARCHAR(100)            NOT NULL UNIQUE,
    password_hash   VARCHAR(255)            NOT NULL,
    role            VARCHAR(20)             NOT NULL DEFAULT 'USER', -- Rol por defecto 'USER', solo admin tendría role = 'ADMIN'
    location        GEOGRAPHY(Point, 4326)  NOT NULL,
    created_at      TIMESTAMP               NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_role CHECK (role IN ('USER', 'ADMIN'))             -- Solo estos dos valores son válidos
);

-- Tabla SECTORS
CREATE TABLE sectors (
    id              BIGSERIAL               PRIMARY KEY,
    name            VARCHAR(100)            NOT NULL UNIQUE,
    category        VARCHAR(50)             NOT NULL,
    description     TEXT,
    location        GEOGRAPHY(Point, 4326)  NOT NULL,
    created_at      TIMESTAMP               NOT NULL DEFAULT NOW()
);

-- Tabla TASKS
CREATE TABLE tasks (
    id                  BIGSERIAL               PRIMARY KEY,
    user_id             BIGINT                  NOT NULL,
    sector_id           BIGINT                  NOT NULL,
    title               VARCHAR(150)            NOT NULL,
    description         TEXT,
    status              VARCHAR(20)             NOT NULL DEFAULT 'PENDING', -- Tarea por defecto 'PENDING'
    location            GEOGRAPHY(Point, 4326)  NOT NULL,
    due_date            TIMESTAMP               NOT NULL,
    completed_at        TIMESTAMP,
    notification_sent   BOOLEAN                 NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMP               NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_tasks_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
    CONSTRAINT fk_tasks_sector FOREIGN KEY (sector_id) REFERENCES sectors(id) ON DELETE RESTRICT,
    CONSTRAINT chk_status      CHECK (status IN ('PENDING', 'COMPLETED', 'EXPIRED'))
);

-- Índices espaciales (GIST) para consultas geoespaciales
CREATE INDEX idx_users_location   ON users   USING GIST(location);
CREATE INDEX idx_sectors_location ON sectors USING GIST(location);
CREATE INDEX idx_tasks_location   ON tasks   USING GIST(location);

-- Índices comunes para filtros
CREATE INDEX idx_tasks_user_id   ON tasks(user_id);
CREATE INDEX idx_tasks_sector_id ON tasks(sector_id);
CREATE INDEX idx_tasks_status    ON tasks(status);
CREATE INDEX idx_tasks_due_date  ON tasks(due_date);