-- Migración: tipos_eventos
-- Creada el: 2026-05-14 15:45:05

CREATE TABLE IF NOT EXISTS tipos_evento (
    id_tipo_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(120) UNIQUE NOT NULL,
    descripcion TEXT,
    dias_retencion INT DEFAULT 90
);
