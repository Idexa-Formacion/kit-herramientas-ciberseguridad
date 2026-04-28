#!/usr/bin/env bash
# ==============================================================================
# password-policy-check.sh
# ------------------------------------------------------------------------------
# Propósito : Verifica que la política de contraseñas del sistema cumple un
#             baseline mínimo recomendado (PAM + login.defs).
# Uso       : sudo ./password-policy-check.sh
# Resultado : Lista de comprobaciones con OK/FAIL.
# ==============================================================================

set -uo pipefail

PASS=0
FAIL=0

check() {
    local desc="$1"
    local result="$2"
    if [[ "${result}" == "ok" ]]; then
        printf "[ OK ] %s\n" "${desc}"
        PASS=$((PASS+1))
    else
        printf "[FAIL] %s\n" "${desc}"
        FAIL=$((FAIL+1))
    fi
}

echo "==================================================="
echo " VERIFICACIÓN DE POLÍTICA DE CONTRASEÑAS"
echo "==================================================="

# --- /etc/login.defs ----------------------------------------------------------
LOGIN_DEFS="/etc/login.defs"
if [[ -r "${LOGIN_DEFS}" ]]; then
    MAX_DAYS=$(grep -E '^PASS_MAX_DAYS' "${LOGIN_DEFS}" | awk '{print $2}')
    MIN_LEN=$(grep -E '^PASS_MIN_LEN' "${LOGIN_DEFS}" | awk '{print $2}')
    MIN_DAYS=$(grep -E '^PASS_MIN_DAYS' "${LOGIN_DEFS}" | awk '{print $2}')

    [[ -n "${MAX_DAYS:-}" && "${MAX_DAYS}" -le 90 ]] && check "PASS_MAX_DAYS ≤ 90 (actual: ${MAX_DAYS})" "ok" \
        || check "PASS_MAX_DAYS ≤ 90 (actual: ${MAX_DAYS:-no definido})" "fail"

    [[ -n "${MIN_LEN:-}" && "${MIN_LEN}" -ge 12 ]] && check "PASS_MIN_LEN ≥ 12 (actual: ${MIN_LEN})" "ok" \
        || check "PASS_MIN_LEN ≥ 12 (actual: ${MIN_LEN:-no definido})" "fail"

    [[ -n "${MIN_DAYS:-}" && "${MIN_DAYS}" -ge 1 ]] && check "PASS_MIN_DAYS ≥ 1 (actual: ${MIN_DAYS})" "ok" \
        || check "PASS_MIN_DAYS ≥ 1 (actual: ${MIN_DAYS:-no definido})" "fail"
else
    check "Acceso a ${LOGIN_DEFS}" "fail"
fi

# --- PAM (pwquality) ----------------------------------------------------------
PAM_FILE=""
[[ -r /etc/security/pwquality.conf ]] && PAM_FILE="/etc/security/pwquality.conf"

if [[ -n "${PAM_FILE}" ]]; then
    grep -qE '^minlen\s*=\s*([1-9][2-9]|[2-9][0-9])' "${PAM_FILE}" \
        && check "pwquality.conf: minlen ≥ 12" "ok" \
        || check "pwquality.conf: minlen ≥ 12" "fail"

    grep -qE '^dcredit\s*=\s*-' "${PAM_FILE}" \
        && check "pwquality.conf: dcredit (requiere dígito)" "ok" \
        || check "pwquality.conf: dcredit (requiere dígito)" "fail"

    grep -qE '^ucredit\s*=\s*-' "${PAM_FILE}" \
        && check "pwquality.conf: ucredit (requiere mayúscula)" "ok" \
        || check "pwquality.conf: ucredit (requiere mayúscula)" "fail"

    grep -qE '^ocredit\s*=\s*-' "${PAM_FILE}" \
        && check "pwquality.conf: ocredit (requiere símbolo)" "ok" \
        || check "pwquality.conf: ocredit (requiere símbolo)" "fail"
else
    check "pwquality.conf existe" "fail"
fi

# --- Resumen ------------------------------------------------------------------
echo
echo "---------------------------------------------------"
echo " Resumen: ${PASS} OK · ${FAIL} FAIL"
echo "---------------------------------------------------"

(( FAIL > 0 )) && exit 1
exit 0
