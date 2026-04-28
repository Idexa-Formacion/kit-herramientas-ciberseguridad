#!/usr/bin/env bash
# ==============================================================================
# ssl-check.sh
# ------------------------------------------------------------------------------
# Propósito : Verifica el certificado TLS/SSL de un servicio: emisor, fechas,
#             algoritmo y días restantes hasta caducidad.
# Requisito : openssl
# Uso       : ./ssl-check.sh <host> [puerto]
#             Puerto por defecto: 443
# Ejemplo   : ./ssl-check.sh idexaformacion.com
#             ./ssl-check.sh smtp.example.com 465
# ==============================================================================

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <host> [puerto]"
    exit 1
fi

HOST="$1"
PORT="${2:-443}"

if ! command -v openssl >/dev/null 2>&1; then
    echo "ERROR: openssl no está instalado."
    exit 2
fi

echo "[*] Comprobando certificado de ${HOST}:${PORT}"
echo "------------------------------------------------"

# Recupera el certificado en formato PEM
CERT=$(echo | openssl s_client -servername "${HOST}" -connect "${HOST}:${PORT}" 2>/dev/null | openssl x509 -noout -subject -issuer -dates -fingerprint -sha256 2>/dev/null || true)

if [[ -z "${CERT}" ]]; then
    echo "[✗] No se pudo recuperar el certificado. Verifica host/puerto."
    exit 3
fi

echo "${CERT}"
echo "------------------------------------------------"

# Calcula días hasta caducidad
END_DATE=$(echo | openssl s_client -servername "${HOST}" -connect "${HOST}:${PORT}" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
END_EPOCH=$(date -d "${END_DATE}" +%s)
NOW_EPOCH=$(date +%s)
DAYS_LEFT=$(( (END_EPOCH - NOW_EPOCH) / 86400 ))

echo
if (( DAYS_LEFT < 0 )); then
    echo "[✗] CERTIFICADO CADUCADO hace $(( -DAYS_LEFT )) días."
elif (( DAYS_LEFT < 30 )); then
    echo "[!] AVISO: el certificado caduca en ${DAYS_LEFT} días."
else
    echo "[✓] El certificado es válido durante ${DAYS_LEFT} días más."
fi
