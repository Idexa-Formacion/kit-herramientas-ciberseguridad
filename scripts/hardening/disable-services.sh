#!/usr/bin/env bash
# ==============================================================================
# disable-services.sh
# ------------------------------------------------------------------------------
# Propósito : Deshabilita servicios típicamente innecesarios en servidores
#             que aumentan la superficie de ataque.
# Uso       : sudo ./disable-services.sh
# Notas     : Revisa la lista SERVICES y AJÚSTALA según tu entorno antes de
#             ejecutar. No todos los servicios son "innecesarios" en todos
#             los servidores.
# ==============================================================================

set -uo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: este script requiere privilegios de root."
    exit 1
fi

# Servicios candidatos a deshabilitar en servidores estándar.
# REVISA esta lista antes de ejecutar; no todos aplican a todos los entornos.
SERVICES=(
    "avahi-daemon"      # mDNS/Bonjour: rara vez necesario en servidores
    "cups"              # impresión: innecesario en servidores
    "bluetooth"         # innecesario en servidores
    "rpcbind"           # solo si NO usas NFS
    "nfs-server"        # solo si NO sirves NFS
)

echo "=================================================="
echo " DESHABILITAR SERVICIOS"
echo "=================================================="
echo "Servicios a procesar:"
for svc in "${SERVICES[@]}"; do
    echo "  - ${svc}"
done
echo

read -rp "¿Continuar? Escribe 'SI' para proceder: " confirm
if [[ "${confirm}" != "SI" ]]; then
    echo "Operación cancelada."
    exit 0
fi

for svc in "${SERVICES[@]}"; do
    if systemctl list-unit-files | grep -q "^${svc}.service"; then
        echo "[*] Procesando ${svc}..."
        systemctl stop "${svc}" 2>/dev/null || true
        systemctl disable "${svc}" 2>/dev/null || true
        systemctl mask "${svc}" 2>/dev/null || true
        echo "    └── stop/disable/mask aplicados."
    else
        echo "[~] ${svc} no instalado, se omite."
    fi
done

echo
echo "[✓] Proceso completado."
echo "    Para revertir un servicio: systemctl unmask <svc> && systemctl enable --now <svc>"
