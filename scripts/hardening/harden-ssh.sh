#!/usr/bin/env bash
# ==============================================================================
# harden-ssh.sh
# ------------------------------------------------------------------------------
# Propósito : Aplica una configuración SSH endurecida en /etc/ssh/sshd_config.
#             Antes de modificar nada, hace backup del archivo original.
# Uso       : sudo ./harden-ssh.sh
# Notas     : - Asegúrate de tener acceso por consola física antes de
#               aplicarlo en un servidor remoto, por si algo sale mal.
#             - Este script DESHABILITA login root y autenticación por
#               contraseña: necesitas tener configurada autenticación por
#               clave pública previamente.
# ==============================================================================

set -euo pipefail

CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="${CONFIG_FILE}.bak.$(date +%Y%m%d_%H%M%S)"

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: este script requiere privilegios de root."
    exit 1
fi

if [[ ! -f "${CONFIG_FILE}" ]]; then
    echo "ERROR: no se encuentra ${CONFIG_FILE}."
    exit 2
fi

# --- Confirmación interactiva -------------------------------------------------
cat <<EOF
==================================================
  HARDENING SSH
==================================================
Este script aplicará la siguiente configuración:

  PermitRootLogin no
  PasswordAuthentication no
  PermitEmptyPasswords no
  X11Forwarding no
  MaxAuthTries 3
  ClientAliveInterval 300
  ClientAliveCountMax 2
  Protocol 2

¿Tienes ya acceso por clave pública configurado y probado?
Si pierdes la clave, podrías quedarte sin acceso al servidor.

EOF

read -rp "Escribe 'SI' para continuar: " confirm
if [[ "${confirm}" != "SI" ]]; then
    echo "Operación cancelada."
    exit 0
fi

# --- Backup -------------------------------------------------------------------
cp "${CONFIG_FILE}" "${BACKUP_FILE}"
echo "[✓] Backup creado: ${BACKUP_FILE}"

# --- Función para set/replace de directivas ----------------------------------
set_directive() {
    local key="$1"
    local value="$2"
    if grep -qE "^[#\s]*${key}\b" "${CONFIG_FILE}"; then
        sed -i -E "s|^[#\s]*${key}\b.*|${key} ${value}|" "${CONFIG_FILE}"
    else
        echo "${key} ${value}" >> "${CONFIG_FILE}"
    fi
}

# --- Aplicar configuración endurecida ----------------------------------------
set_directive "PermitRootLogin" "no"
set_directive "PasswordAuthentication" "no"
set_directive "PermitEmptyPasswords" "no"
set_directive "X11Forwarding" "no"
set_directive "MaxAuthTries" "3"
set_directive "ClientAliveInterval" "300"
set_directive "ClientAliveCountMax" "2"
set_directive "Protocol" "2"

echo "[✓] Directivas aplicadas."

# --- Validación sintáctica antes de recargar ---------------------------------
if ! sshd -t 2>/dev/null; then
    echo "[✗] La configuración tiene errores. Restaurando backup..."
    cp "${BACKUP_FILE}" "${CONFIG_FILE}"
    exit 3
fi

# --- Recarga del servicio -----------------------------------------------------
if systemctl reload ssh 2>/dev/null || systemctl reload sshd 2>/dev/null; then
    echo "[✓] Servicio SSH recargado."
else
    echo "[!] No se pudo recargar SSH. Hazlo manualmente: systemctl reload sshd"
fi

echo
echo "Hardening aplicado. Backup en: ${BACKUP_FILE}"
echo "PRUEBA AHORA una nueva conexión SSH desde otra terminal antes de cerrar esta."
