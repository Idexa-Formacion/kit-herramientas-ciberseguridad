#!/usr/bin/env bash
# ==============================================================================
# triage-linux.sh
# ------------------------------------------------------------------------------
# Propósito : Recolección de artefactos volátiles para triaje inicial en un
#             host Linux comprometido (o sospechoso). Pensado como primera
#             foto del estado del sistema antes de actuar.
# Uso       : sudo ./triage-linux.sh
# Salida    : Carpeta ./triage_<host>_<timestamp>/ con archivos de evidencia.
# Notas     : - NO sustituye a una imagen forense completa.
#             - Ejecutar lo antes posible tras detectar la sospecha.
#             - Idealmente, copia la salida a un medio externo de solo lectura.
# ==============================================================================

set -uo pipefail

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
HOST="$(hostname)"
OUT_DIR="./triage_${HOST}_${TIMESTAMP}"

mkdir -p "${OUT_DIR}"

echo "[*] Iniciando triaje. Salida: ${OUT_DIR}"

# Función auxiliar: ejecuta un comando y guarda salida + errores
capture() {
    local name="$1"
    local cmd="$2"
    eval "${cmd}" > "${OUT_DIR}/${name}.txt" 2>&1 || echo "[ERROR ejecutando: ${cmd}]" >> "${OUT_DIR}/${name}.txt"
}

# --- Información del sistema --------------------------------------------------
capture "00_system_info"   "uname -a; cat /etc/os-release; uptime; date"
capture "01_who"           "who; w; last -n 50"

# --- Procesos en ejecución ---------------------------------------------------
capture "10_processes_full" "ps auxf"
capture "11_processes_tree" "ps -ejH"

# --- Conexiones de red --------------------------------------------------------
capture "20_netstat"       "ss -tunap"
capture "21_listening"     "ss -tulnp"
capture "22_routes"        "ip route show"
capture "23_arp"           "ip neigh show"
capture "24_iptables"      "iptables -L -n -v"

# --- Usuarios -----------------------------------------------------------------
capture "30_passwd"        "cat /etc/passwd"
capture "31_shadow"        "cat /etc/shadow"
capture "32_sudoers"       "cat /etc/sudoers; ls -la /etc/sudoers.d/; cat /etc/sudoers.d/*"
capture "33_uid_zero"      "awk -F: '\$3 == 0 {print}' /etc/passwd"

# --- Persistencia: cron, systemd, autostart -----------------------------------
capture "40_cron_etc"      "ls -la /etc/cron.*; cat /etc/crontab"
capture "41_user_crons"    "for u in \$(cut -f1 -d: /etc/passwd); do echo \"--- \$u ---\"; crontab -u \$u -l 2>/dev/null; done"
capture "42_systemd_timers" "systemctl list-timers --all --no-pager"
capture "43_systemd_services" "systemctl list-unit-files --type=service --no-pager"

# --- Logs clave ---------------------------------------------------------------
mkdir -p "${OUT_DIR}/logs"
for log in /var/log/auth.log /var/log/secure /var/log/syslog /var/log/messages /var/log/kern.log; do
    [[ -r "${log}" ]] && cp "${log}" "${OUT_DIR}/logs/" 2>/dev/null || true
done
journalctl --since "7 days ago" --no-pager > "${OUT_DIR}/logs/journalctl_7d.txt" 2>&1 || true

# --- Archivos modificados recientemente --------------------------------------
capture "50_recent_files" "find /etc /usr/local /tmp /var/tmp /root /home -type f -mtime -7 -print 2>/dev/null | head -200"

# --- Hash de los artefactos para integridad ----------------------------------
echo "[*] Calculando hashes SHA-256 de los artefactos..."
find "${OUT_DIR}" -type f -exec sha256sum {} \; > "${OUT_DIR}/HASHES.sha256"

echo
echo "[✓] Triaje finalizado."
echo "[*] Carpeta: ${OUT_DIR}"
echo "[*] Hashes en: ${OUT_DIR}/HASHES.sha256"
echo
echo "Recuerda: copia la carpeta a un medio externo y NO modifiques los archivos."
