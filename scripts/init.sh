#!/bin/bash

# Configuración visual
VERDE='\033[0;32m'
CIAN='\033[0;36m'
ROJO='\033[0;31m'
AMARILLO='\033[1;33m'
NC='\033[0m'

# 1. Cargar y validar .env
if [ -f .env ]; then
    set -a; source .env; set +a
else
    echo -e "${ROJO}Error: Archivo .env no encontrado.${NC}"
    exit 1
fi

# Validación SRE: Verificar variables críticas
: "${DB_USER:?Variable no definida en .env}"
: "${DB_NAME:?Variable no definida en .env}"

echo -e "${CIAN}Iniciando limpieza y despliegue con Podman...${NC}"

# 2. Limpieza (Remover volúmenes para asegurar recreación de tablas)
podman compose down -v --remove-orphans

# 3. Levantar base de datos
podman compose up -d

if [ $? -ne 0 ]; then
    echo -e "${ROJO}Error crítico levantando contenedores.${NC}"
    exit 1
fi

# 4. Esperar Healthcheck con Timeout (Anti-bucle infinito)
echo -ne "${AMARILLO}Esperando que MariaDB esté Ready "
MAX_RETRIES=30
COUNT=0

until [ "$(podman inspect -f '{{.State.Health.Status}}' mariadb-recoleccion-eventos 2>/dev/null)" == "healthy" ] || [ $COUNT -eq $MAX_RETRIES ]; do
    printf "."
    sleep 2
    ((COUNT++))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
    echo -e "\n${ROJO}Error: Tiempo de espera agotado. Revisa los logs con 'podman logs mariadb-recoleccion-eventos'${NC}"
    exit 1
fi

echo -e "${NC}\n${VERDE}¡MariaDB lista y saludable!${NC}"

# 5. Validar esquema (Uso de -t para formato tabla)
echo -e "${CIAN}Esquema de tablas actual:${NC}"
podman exec mariadb-recoleccion-eventos mariadb \
    -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" \
    -e "SHOW TABLES;"

echo -e "\n${VERDE}====== DATABASE RECOLECCION EVENTOS READY ======${NC}"
