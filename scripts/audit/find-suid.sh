#!/usr/bin/env bash
# ==============================================================================
# find-suid.sh
# ------------------------------------------------------------------------------
# Propósito : Localiza binarios con bits SUID/SGID en el sistema. Estos
#             binarios pueden ser vías de escalada de privilegios si están
#             mal configurados o son inusuales.
# Uso       : sudo ./find-suid.sh
# Salida    : Lista de binarios con SUID/SGID.
# ==============================================================================

set -uo pipefail

OUTPUT_DIR="./audit-results"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="${OUTPUT_DIR}/suid-sgid_${TIMESTAMP}.txt"

mkdir -p "${OUTPUT_DIR}"

echo "[*] Buscando binarios SUID/SGID. Puede tardar unos minutos..."

{
    echo "BINARIOS SUID/SGID DETECTADOS"
    echo "Host: $(hostname)"
    echo "Fecha: $(date)"
    echo ""
    echo "--- SUID (-perm -4000) ---"
    find / -xdev -type f -perm -4000 -print 2>/dev/null
    echo ""
    echo "--- SGID (-perm -2000) ---"
    find / -xdev -type f -perm -2000 -print 2>/dev/null
} | tee "${OUTPUT_FILE}"

echo
echo "[✓] Resultados guardados en ${OUTPUT_FILE}"
echo
echo "Próximos pasos sugeridos:"
echo "  - Comparar con un baseline aprobado de tu organización."
echo "  - Investigar binarios fuera de /usr/bin, /usr/sbin, /bin, /sbin."
echo "  - Consultar GTFOBins (https://gtfobins.github.io/) para riesgos conocidos."
