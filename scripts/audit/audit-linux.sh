#!/usr/bin/env bash
# ==============================================================================
# audit-linux.sh
# ------------------------------------------------------------------------------
# Propósito : Recopila información de configuración de seguridad de un sistema
#             Linux. Lectura no destructiva: solo consulta, no modifica nada.
# Requisito : Bash, utilidades estándar (preferiblemente como root o sudo).
# Uso       : sudo ./audit-linux.sh
# Salida    : Informe en ./audit-results/audit_<hostname>_<timestamp>.txt
# ==============================================================================

set -euo pipefail

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
HOSTNAME="$(hostname)"
OUTPUT_DIR="./audit-results"
OUTPUT_FILE="${OUTPUT_DIR}/audit_${HOSTNAME}_${TIMESTAMP}.txt"

mkdir -p "${OUTPUT_DIR}"

# Función para escribir secciones al informe
section() {
    echo "" >> "${OUTPUT_FILE}"
    echo "==================================================================" >> "${OUTPUT_FILE}"
    echo "  $1" >> "${OUTPUT_FILE}"
    echo "==================================================================" >> "${OUTPUT_FILE}"
}

# Función auxiliar: ejecuta un comando y captura su salida (o error)
run() {
    local cmd="$1"
    echo ">>> $ ${cmd}" >> "${OUTPUT_FILE}"
    eval "${cmd}" >> "${OUTPUT_FILE}" 2>&1 || echo "[no disponible]" >> "${OUTPUT_FILE}"
    echo "" >> "${OUTPUT_FILE}"
}

# ------------------------------------------------------------------------------
echo "[*] Iniciando auditoría de ${HOSTNAME}..."
echo "[*] Resultados se guardarán en ${OUTPUT_FILE}"

{
    echo "INFORME DE AUDITORÍA DE SEGURIDAD - LINUX"
    echo "Host: ${HOSTNAME}"
    echo "Fecha: $(date)"
    echo "Generado por: ${USER}"
} > "${OUTPUT_FILE}"

# --- Información del sistema --------------------------------------------------
section "1. INFORMACIÓN DEL SISTEMA"
run "uname -a"
run "cat /etc/os-release"
run "uptime"

# --- Usuarios y grupos --------------------------------------------------------
section "2. USUARIOS Y GRUPOS"
run "awk -F: '\$3 == 0 {print \$1}' /etc/passwd"   # Usuarios con UID 0
run "awk -F: '(\$2 == \"\" ) {print \$1}' /etc/shadow"  # Usuarios sin contraseña
run "lastlog | head -50"

# --- Sudoers ------------------------------------------------------------------
section "3. CONFIGURACIÓN SUDO"
run "cat /etc/sudoers 2>/dev/null | grep -v '^#' | grep -v '^$'"
run "ls -la /etc/sudoers.d/ 2>/dev/null"

# --- SSH ----------------------------------------------------------------------
section "4. CONFIGURACIÓN SSH"
run "grep -E '^(PermitRootLogin|PasswordAuthentication|PermitEmptyPasswords|Protocol|X11Forwarding|MaxAuthTries|ClientAliveInterval)' /etc/ssh/sshd_config 2>/dev/null"

# --- Firewall -----------------------------------------------------------------
section "5. FIREWALL"
run "ufw status verbose 2>/dev/null"
run "firewall-cmd --list-all 2>/dev/null"
run "iptables -L -n 2>/dev/null | head -50"

# --- Servicios activos --------------------------------------------------------
section "6. SERVICIOS EN EJECUCIÓN"
run "systemctl list-units --type=service --state=running --no-pager | head -50"

# --- Puertos en escucha -------------------------------------------------------
section "7. PUERTOS EN ESCUCHA"
run "ss -tulnp 2>/dev/null"

# --- Actualizaciones pendientes ----------------------------------------------
section "8. ACTUALIZACIONES PENDIENTES"
if command -v apt >/dev/null 2>&1; then
    run "apt list --upgradable 2>/dev/null | head -30"
elif command -v dnf >/dev/null 2>&1; then
    run "dnf check-update 2>/dev/null | head -30"
fi

# --- Logs de autenticación ----------------------------------------------------
section "9. INTENTOS DE AUTENTICACIÓN RECIENTES"
run "grep -i 'failed\\|invalid' /var/log/auth.log 2>/dev/null | tail -20"
run "grep -i 'failed\\|invalid' /var/log/secure 2>/dev/null | tail -20"

# --- Tareas programadas -------------------------------------------------------
section "10. CRON Y TAREAS PROGRAMADAS"
run "ls -la /etc/cron.* 2>/dev/null"
run "crontab -l 2>/dev/null"
run "for u in \$(cut -f1 -d: /etc/passwd); do echo \"--- \$u ---\"; crontab -u \$u -l 2>/dev/null; done"

echo "[✓] Auditoría completada."
echo "[*] Revisa el informe: ${OUTPUT_FILE}"
