#!/usr/bin/env bash
# ==============================================================================
# quick-scan.sh
# ------------------------------------------------------------------------------
# Propósito : Escaneo rápido de hosts activos en una subred. Útil como primer
#             paso de reconocimiento en un entorno autorizado.
# Requisito : nmap instalado en el sistema.
# Uso       : ./quick-scan.sh <subred>
# Ejemplo   : ./quick-scan.sh 192.168.1.0/24
# Salida    : Lista de hosts activos + archivo de resultados con timestamp.
# ==============================================================================
# ⚠️  USO LEGÍTIMO ÚNICAMENTE: solo contra redes que te pertenezcan o sobre las
#     que tengas autorización explícita por escrito.
# ==============================================================================

set -euo pipefail

# --- Validación de argumentos -------------------------------------------------
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <subred>"
    echo "Ejemplo: $0 192.168.1.0/24"
    exit 1
fi

TARGET="$1"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTPUT_DIR="./scan-results"
OUTPUT_FILE="${OUTPUT_DIR}/quick-scan_${TIMESTAMP}.txt"

# --- Comprobación de dependencias ---------------------------------------------
if ! command -v nmap >/dev/null 2>&1; then
    echo "ERROR: nmap no está instalado. Instálalo con tu gestor de paquetes."
    echo "  Debian/Ubuntu: sudo apt install nmap"
    echo "  RHEL/Fedora:   sudo dnf install nmap"
    exit 2
fi

mkdir -p "${OUTPUT_DIR}"

# --- Ejecución ----------------------------------------------------------------
echo "[*] Iniciando escaneo rápido sobre ${TARGET}"
echo "[*] Resultados en: ${OUTPUT_FILE}"
echo

# -sn: solo descubrimiento de hosts (ping scan), sin escaneo de puertos
nmap -sn "${TARGET}" | tee "${OUTPUT_FILE}"

echo
echo "[✓] Escaneo finalizado. Resultados guardados en ${OUTPUT_FILE}"
