#!/bin/bash

# 1. Cargar variables de entorno
if [ -f .env ]; then
    set -a; source .env; set +a
else
    echo -e "\033[0;31mError: Archivo .env no encontrado.\033[0m"
    exit 1
fi

# 2. Verificar si Harlequin está instalado
if ! command -v harlequin &> /dev/null; then
    echo -e "\033[1;33mHarlequin no está instalado.\033[0m"
    echo "Puedes instalarlo con: pipx install harlequin[mysql]"
    exit 1
fi

echo -e "\033[0;36mConectando a MariaDB: ${DB_NAME}...\033[0m"

# 3. Ejecutar Harlequin usando las variables del .env
harlequin -a mysql \
    -h localhost \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    --password "${DB_PASSWORD}" \
    --database "${DB_NAME}"
