#!/usr/bin/env bash
# ==============================================================================
# port-audit.sh
# ------------------------------------------------------------------------------
# Propósito : Auditoría de puertos abiertos en un host concreto. Detecta
#             servicios y versiones para identificar superficies de ataque.
# Requisito : nmap instalado en el sistema.
# Uso       : ./port-audit.sh <host> [tipo]
#             tipo: "rapido" (top 100) | "completo" (1-65535). Por defecto: rapido
# Ejemplo   : ./port-audit.sh 10.0.0.5
#             ./port-audit.sh ejemplo.local completo
# ==============================================================================
# ⚠️  USO LEGÍTIMO ÚNICAMENTE.
# ==============================================================================

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <host> [rapido|completo]"
    exit 1
fi

HOST="$1"
MODE="${2:-rapido}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTPUT_DIR="./scan-results"
OUTPUT_FILE="${OUTPUT_DIR}/port-audit_${HOST//\//_}_${TIMESTAMP}.txt"

if ! command -v nmap >/dev/null 2>&1; then
    echo "ERROR: nmap no está instalado."
    exit 2
fi

mkdir -p "${OUTPUT_DIR}"

echo "[*] Auditoría de puertos sobre ${HOST} (modo: ${MODE})"

case "${MODE}" in
    rapido)
        # -sV: detección de versiones; --top-ports 100: 100 puertos más comunes
        nmap -sV --top-ports 100 "${HOST}" | tee "${OUTPUT_FILE}"
        ;;
    completo)
        # Escaneo completo: lento pero exhaustivo
        echo "[!] Escaneo completo: puede tardar varios minutos."
        nmap -sV -p- "${HOST}" | tee "${OUTPUT_FILE}"
        ;;
    *)
        echo "ERROR: modo desconocido '${MODE}'. Usa 'rapido' o 'completo'."
        exit 3
        ;;
esac

echo
echo "[✓] Auditoría guardada en ${OUTPUT_FILE}"
