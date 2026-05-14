-- Migración: registros_eventos
-- Creada el: 2026-05-14 15:40:24

CREATE TABLE IF NOT EXISTS registros_eventos (
    id_registro_evento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_traza VARCHAR(64) NOT NULL,
    tipo_evento VARCHAR(120) NOT NULL,
    nombre_servicio VARCHAR(120) NOT NULL,
    severidad ENUM(
        'debug',
        'info',
        'advertencia',
        'error',
        'critico'
    ) DEFAULT 'info',
    id_usuario BIGINT NULL,
    id_sesion VARCHAR(120) NULL,
    carga_util JSON NOT NULL,
    recibido_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_evento TIMESTAMP NULL,
    procesado BOOLEAN DEFAULT FALSE,
    INDEX idx_traza(id_traza),
    INDEX idx_tipo_evento(tipo_evento),
    INDEX idx_servicio(nombre_servicio),
    INDEX idx_recibido(recibido_en),
    INDEX idx_usuario(id_usuario)
    -- created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    --    ON UPDATE CURRENT_TIMESTAMP,

    -- INDEX idx_created_at (created_at)

)
  -- ENGINE=InnoDB
  -- DEFAULT CHARSET=utf8mb4
  -- COLLATE=utf8mb4_unicode_ci
;
