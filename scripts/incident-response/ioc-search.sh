#!/usr/bin/env bash
# ==============================================================================
# ioc-search.sh
# ------------------------------------------------------------------------------
# Propósito : Busca indicadores de compromiso (IOCs) básicos en un sistema
#             Linux: hashes de archivos, IPs, dominios, nombres de procesos.
# Uso       : ./ioc-search.sh <archivo-iocs>
# Formato del archivo IOCs (un IOC por línea, prefijo tipo:valor):
#     hash:abc123...           # SHA-256 a buscar en /tmp /var/tmp /home
#     ip:1.2.3.4               # IP a buscar en logs y conexiones activas
#     domain:malicioso.com     # Dominio a buscar en logs
#     process:nombre_proceso   # Proceso a buscar en ps
#
# Ejemplo del archivo: ver templates/iocs-ejemplo.txt
# ==============================================================================

set -uo pipefail

if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <archivo-iocs>"
    exit 1
fi

IOC_FILE="$1"
if [[ ! -r "${IOC_FILE}" ]]; then
    echo "ERROR: no se puede leer ${IOC_FILE}"
    exit 2
fi

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT="./ioc-search_${TIMESTAMP}.txt"

{
    echo "BÚSQUEDA DE IOCs"
    echo "Host: $(hostname)"
    echo "Fecha: $(date)"
    echo "Archivo IOCs: ${IOC_FILE}"
    echo "============================================================"
} > "${REPORT}"

HITS=0

while IFS= read -r line; do
    # Saltar líneas vacías y comentarios
    [[ -z "${line}" || "${line:0:1}" == "#" ]] && continue

    type="${line%%:*}"
    value="${line#*:}"

    case "${type}" in
        hash)
            echo ">>> Buscando hash: ${value}" >> "${REPORT}"
            FOUND=$(find /tmp /var/tmp /home -type f 2>/dev/null \
                     | xargs -I{} sha256sum {} 2>/dev/null \
                     | grep -i "^${value}" || true)
            if [[ -n "${FOUND}" ]]; then
                echo "[!] COINCIDENCIA: ${FOUND}" >> "${REPORT}"
                HITS=$((HITS+1))
            else
                echo "    sin coincidencias." >> "${REPORT}"
            fi
            ;;
        ip)
            echo ">>> Buscando IP: ${value}" >> "${REPORT}"
            FOUND=$(ss -tunap 2>/dev/null | grep "${value}" || true)
            [[ -n "${FOUND}" ]] && { echo "[!] Conexión activa: ${FOUND}" >> "${REPORT}"; HITS=$((HITS+1)); }

            FOUND_LOG=$(grep -r "${value}" /var/log/ 2>/dev/null | head -5 || true)
            [[ -n "${FOUND_LOG}" ]] && { echo "[!] En logs: ${FOUND_LOG}" >> "${REPORT}"; HITS=$((HITS+1)); }
            ;;
        domain)
            echo ">>> Buscando dominio: ${value}" >> "${REPORT}"
            FOUND=$(grep -r "${value}" /var/log/ 2>/dev/null | head -5 || true)
            [[ -n "${FOUND}" ]] && { echo "[!] En logs: ${FOUND}" >> "${REPORT}"; HITS=$((HITS+1)); }
            ;;
        process)
            echo ">>> Buscando proceso: ${value}" >> "${REPORT}"
            FOUND=$(ps aux | grep -F "${value}" | grep -v grep || true)
            [[ -n "${FOUND}" ]] && { echo "[!] Proceso activo: ${FOUND}" >> "${REPORT}"; HITS=$((HITS+1)); }
            ;;
        *)
            echo ">>> Tipo de IOC desconocido: ${type}" >> "${REPORT}"
            ;;
    esac
    echo "" >> "${REPORT}"
done < "${IOC_FILE}"

{
    echo "============================================================"
    echo "Total coincidencias: ${HITS}"
} >> "${REPORT}"

echo "[✓] Búsqueda completada. Coincidencias: ${HITS}"
echo "[*] Informe: ${REPORT}"

(( HITS > 0 )) && exit 1
exit 0
