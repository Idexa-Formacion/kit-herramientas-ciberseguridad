#!/usr/bin/env bash
# ==============================================================================
# collect-logs.sh
# ------------------------------------------------------------------------------
# Propósito : Recopila y empaqueta los logs relevantes de un sistema Linux
#             para análisis posterior, en un único archivo .tar.gz.
# Uso       : sudo ./collect-logs.sh [días]
#             días: cuántos días de journalctl recoger (por defecto 14)
# Salida    : logs_<host>_<timestamp>.tar.gz
# ==============================================================================

set -euo pipefail

DAYS="${1:-14}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
HOST="$(hostname)"
WORK_DIR="./logs_${HOST}_${TIMESTAMP}"
ARCHIVE="${WORK_DIR}.tar.gz"

mkdir -p "${WORK_DIR}"

echo "[*] Recopilando logs del sistema (últimos ${DAYS} días)..."

# --- /var/log -----------------------------------------------------------------
mkdir -p "${WORK_DIR}/var_log"
LOGS=(
    /var/log/auth.log
    /var/log/auth.log.1
    /var/log/secure
    /var/log/secure-*
    /var/log/syslog
    /var/log/messages
    /var/log/kern.log
    /var/log/dpkg.log
    /var/log/yum.log
    /var/log/dnf.log
    /var/log/audit/audit.log
    /var/log/apache2/access.log
    /var/log/apache2/error.log
    /var/log/nginx/access.log
    /var/log/nginx/error.log
)

for log in "${LOGS[@]}"; do
    if compgen -G "${log}" > /dev/null 2>&1; then
        for f in ${log}; do
            [[ -r "${f}" ]] && cp --parents "${f}" "${WORK_DIR}/var_log/" 2>/dev/null || true
        done
    fi
done

# --- journalctl ---------------------------------------------------------------
if command -v journalctl >/dev/null 2>&1; then
    echo "[*] Exportando journalctl (últimos ${DAYS} días)..."
    journalctl --since "${DAYS} days ago" --no-pager > "${WORK_DIR}/journalctl_${DAYS}d.txt" 2>&1 || true
fi

# --- Metadatos ----------------------------------------------------------------
{
    echo "Recopilación de logs"
    echo "Host: ${HOST}"
    echo "Fecha: $(date)"
    echo "Usuario: ${USER}"
    echo "Días incluidos en journalctl: ${DAYS}"
} > "${WORK_DIR}/METADATA.txt"

# --- Hash de los archivos antes de empaquetar --------------------------------
echo "[*] Calculando hashes..."
find "${WORK_DIR}" -type f -exec sha256sum {} \; > "${WORK_DIR}/HASHES.sha256"

# --- Empaquetar --------------------------------------------------------------
tar -czf "${ARCHIVE}" "${WORK_DIR}"
HASH_OUT="$(sha256sum "${ARCHIVE}" | awk '{print $1}')"

echo
echo "[✓] Archivo: ${ARCHIVE}"
echo "[✓] SHA-256: ${HASH_OUT}"
echo
echo "Conserva tanto el archivo como su hash para mantener cadena de custodia."

# Limpieza de la carpeta intermedia (opcional: comentar si quieres conservarla)
rm -rf "${WORK_DIR}"
