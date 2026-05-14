-- Migración: api_clientes
-- Creada el: 2026-05-14 15:43:14

CREATE TABLE IF NOT EXISTS api_clientes (
    id_api_cliente BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(120) UNIQUE NOT NULL,
    usuario VARCHAR(120) UNIQUE NOT NULL,
    hash_contrasena VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
