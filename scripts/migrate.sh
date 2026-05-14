#!/bin/bash

CARPETA_MIGRACIONES="./database/migrations"
FECHA=$(date +%Y_%m_%d_%H%M%S)

# 1. Validar input
if [ -z "$1" ]; then
    echo "Uso: $0 nombre_de_la_tabla"
    exit 1
fi

NOMBRE_LIMPIO=$(echo "$1" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')

# 2. Asegurar estructura y permisos
mkdir -p "$CARPETA_MIGRACIONES"

# 3. Obtener secuencia (SRE-friendly: busca solo patrones 000_)
ULTIMO_ARCHIVO=$(find "$CARPETA_MIGRACIONES" -maxdepth 1 -name "[0-9][0-9][0-9]_*" -printf "%f\n" | sort | tail -n 1)

if [ -z "$ULTIMO_ARCHIVO" ]; then
    SIGUIENTE_NRO=1
else
    ULTIMO_NRO=$(echo "$ULTIMO_ARCHIVO" | cut -c1-3)
    SIGUIENTE_NRO=$((10#$ULTIMO_NRO + 1))
fi

NRO_FORMATEADO=$(printf "%03d" $SIGUIENTE_NRO)
NOMBRE_ARCHIVO="${NRO_FORMATEADO}_${FECHA}_create_${NOMBRE_LIMPIO}.sql"

# 4. Generar Boilerplate SQL Idempotente
cat <<EOF > "$CARPETA_MIGRACIONES/$NOMBRE_ARCHIVO"
-- Migración: $NOMBRE_LIMPIO
-- Creada el: $(date '+%Y-%m-%d %H:%M:%S')

CREATE TABLE IF NOT EXISTS $NOMBRE_LIMPIO (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    -- created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    --    ON UPDATE CURRENT_TIMESTAMP,

    -- INDEX idx_created_at (created_at)

)
  -- ENGINE=InnoDB
  -- DEFAULT CHARSET=utf8mb4
  -- COLLATE=utf8mb4_unicode_ci
;
EOF

# 5. Ajustar permisos (lectura para el contenedor)
chmod 644 "$CARPETA_MIGRACIONES/$NOMBRE_ARCHIVO"

echo "Migración creado: $CARPETA_MIGRACIONES/$NOMBRE_ARCHIVO"
