# Guía de instalación y requisitos

## Sistemas soportados

Los scripts de este toolkit están pensados para ejecutarse en sistemas Linux (Debian/Ubuntu, RHEL/Fedora/CentOS y derivados). Algunos pueden funcionar en macOS con ajustes menores, pero no es la plataforma principal.

## Dependencias

| Dependencia | Para qué se usa | Cómo instalar |
|-------------|-----------------|---------------|
| `bash` ≥ 4.x | Todos los scripts | Preinstalado |
| `nmap` | Scripts de red | `apt install nmap` / `dnf install nmap` |
| `openssl` | `ssl-check.sh` | Habitualmente preinstalado |
| `ufw` o `firewalld` | `firewall-baseline.sh` | Según distro |
| `auditd` | Hardening avanzado (opcional) | `apt install auditd` / `dnf install audit` |
| `python3` | Reservado para scripts futuros | Habitualmente preinstalado |

## Instalación

```bash
git clone https://github.com/<tu-organizacion>/cybersec-toolkit.git
cd cybersec-toolkit

# Permisos de ejecución
chmod +x scripts/network/*.sh
chmod +x scripts/audit/*.sh
chmod +x scripts/hardening/*.sh
chmod +x scripts/incident-response/*.sh
```

## Verificación rápida

Ejecuta uno de los scripts informativos (no destructivos):

```bash
./scripts/network/ssl-check.sh idexaformacion.com
```

Si ves la información del certificado, todo está listo.

## Desinstalación

Es un repositorio sin instalación: borra la carpeta y desaparece. Algunos scripts pueden haber creado:

- `./scan-results/`, `./audit-results/`, `./triage_*/`, `./logs_*.tar.gz`

Estos contienen evidencia recolectada y deben tratarse según la política de retención de tu organización antes de eliminarlos.

## Permisos necesarios

| Script | Privilegios |
|--------|-------------|
| `network/*.sh` | Usuario normal |
| `audit/audit-linux.sh` | `root` recomendado para acceso completo |
| `audit/find-suid.sh` | `root` recomendado |
| `audit/password-policy-check.sh` | `root` (lectura de `/etc/shadow`) |
| `hardening/*.sh` | `root` obligatorio |
| `incident-response/triage-linux.sh` | `root` recomendado |
| `incident-response/collect-logs.sh` | `root` recomendado |
| `incident-response/ioc-search.sh` | Variable según IOCs |
