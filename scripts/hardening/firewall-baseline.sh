#!/usr/bin/env bash
# ==============================================================================
# firewall-baseline.sh
# ------------------------------------------------------------------------------
# Propósito : Configura un firewall con un baseline restrictivo:
#               - Política por defecto: deny entrante, allow saliente
#               - Permite SSH, HTTP, HTTPS
#             Detecta automáticamente si usar UFW o firewalld.
# Uso       : sudo ./firewall-baseline.sh
# ==============================================================================

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: este script requiere privilegios de root."
    exit 1
fi

echo "=================================================="
echo " CONFIGURACIÓN DE FIREWALL - BASELINE"
echo "=================================================="
echo "Reglas a aplicar:"
echo "  - Por defecto: bloquear entrante, permitir saliente"
echo "  - Permitir: SSH (22), HTTP (80), HTTPS (443)"
echo
read -rp "¿Continuar? Escribe 'SI': " confirm
if [[ "${confirm}" != "SI" ]]; then
    echo "Operación cancelada."
    exit 0
fi

# --- UFW (Debian/Ubuntu) ------------------------------------------------------
if command -v ufw >/dev/null 2>&1; then
    echo "[*] Usando UFW..."
    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 22/tcp comment 'SSH'
    ufw allow 80/tcp comment 'HTTP'
    ufw allow 443/tcp comment 'HTTPS'
    ufw --force enable
    ufw status verbose
    echo "[✓] UFW configurado."
    exit 0
fi

# --- firewalld (RHEL/Fedora/CentOS) ------------------------------------------
if command -v firewall-cmd >/dev/null 2>&1; then
    echo "[*] Usando firewalld..."
    systemctl enable --now firewalld

    firewall-cmd --set-default-zone=public

    # Limpia servicios y añade los necesarios
    for svc in $(firewall-cmd --zone=public --list-services); do
        firewall-cmd --zone=public --remove-service="${svc}" --permanent
    done

    firewall-cmd --zone=public --add-service=ssh --permanent
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --zone=public --add-service=https --permanent

    firewall-cmd --reload
    firewall-cmd --list-all
    echo "[✓] firewalld configurado."
    exit 0
fi

echo "[✗] No se ha encontrado UFW ni firewalld en este sistema."
echo "    Instala uno de los dos antes de ejecutar este script."
exit 2
