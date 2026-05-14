-- Migración: fallos_ingesta
-- Creada el: 2026-05-14 15:44:43

CREATE TABLE IF NOT EXISTS fallos_ingesta (
    id_fallo_ingesta BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_traza VARCHAR(64),
    carga_util JSON NOT NULL,
    mensaje_error TEXT NOT NULL,
    intentos_reintento INT DEFAULT 0,
    fallado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
