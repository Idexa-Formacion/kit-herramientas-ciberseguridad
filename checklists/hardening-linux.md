# Checklist — Hardening de servidores Linux

> Lista accionable de medidas de bastionado para servidores Linux. Pensada para revisarse de arriba abajo en un servidor recién instalado o existente.

---

## 1. Cuentas y autenticación

- [ ] La cuenta `root` no permite login directo por SSH.
- [ ] Solo cuentas necesarias existen en `/etc/passwd` (revisar UIDs duplicados y UID=0 inesperados).
- [ ] Política de contraseñas configurada: `PASS_MAX_DAYS ≤ 90`, `PASS_MIN_LEN ≥ 12`.
- [ ] `pwquality.conf` configurado con complejidad mínima.
- [ ] Cuentas inactivas bloqueadas o eliminadas.
- [ ] MFA configurado para accesos administrativos cuando sea posible.

## 2. SSH

- [ ] `PermitRootLogin no`
- [ ] `PasswordAuthentication no` (autenticación por clave pública).
- [ ] `PermitEmptyPasswords no`
- [ ] `MaxAuthTries 3`
- [ ] `ClientAliveInterval 300` y `ClientAliveCountMax 2`
- [ ] `Protocol 2`
- [ ] Solo algoritmos modernos en `Ciphers`, `MACs`, `KexAlgorithms`.
- [ ] Restricción de usuarios/grupos con `AllowUsers` o `AllowGroups`.

> 🔧 El script [`harden-ssh.sh`](../scripts/hardening/harden-ssh.sh) automatiza la mayoría de estos puntos.

## 3. Firewall

- [ ] Política por defecto: `deny` entrante, `allow` saliente.
- [ ] Solo puertos imprescindibles abiertos.
- [ ] Reglas documentadas y justificadas.
- [ ] Logging de paquetes denegados habilitado.

> 🔧 Ver [`firewall-baseline.sh`](../scripts/hardening/firewall-baseline.sh).

## 4. Servicios

- [ ] Solo servicios necesarios en ejecución.
- [ ] Servicios innecesarios (avahi, cups, bluetooth) deshabilitados y enmascarados.
- [ ] Servicios expuestos públicamente revisados uno a uno.

> 🔧 Ver [`disable-services.sh`](../scripts/hardening/disable-services.sh).

## 5. Actualizaciones y parches

- [ ] Sistema operativo y paquetes al día.
- [ ] Actualizaciones de seguridad automáticas configuradas (`unattended-upgrades`, `dnf-automatic`).
- [ ] Proceso documentado para parchar fuera de banda ante CVEs críticas.

## 6. Logs y monitorización

- [ ] `rsyslog` o `systemd-journald` activo y configurado.
- [ ] Logs centralizados en un servidor remoto o SIEM.
- [ ] Logs de autenticación (`/var/log/auth.log`, `/var/log/secure`) revisados periódicamente.
- [ ] Auditd activo para eventos críticos (modificación `/etc/passwd`, `sudo`, etc.).
- [ ] Alertas configuradas para eventos sospechosos.

## 7. Sistema de ficheros

- [ ] Particiones separadas para `/var`, `/tmp`, `/home` (recomendado).
- [ ] `/tmp` montado con `noexec,nosuid,nodev`.
- [ ] Permisos de directorios sensibles correctos:
  - `/etc/shadow` → `640 root:shadow` (o `000`/`400` según distro).
  - `/etc/passwd` → `644 root:root`.
- [ ] Inventario de binarios SUID/SGID revisado.

> 🔧 Ver [`find-suid.sh`](../scripts/audit/find-suid.sh).

## 8. Kernel y red

- [ ] Parámetros sysctl endurecidos:
  - `net.ipv4.conf.all.rp_filter = 1`
  - `net.ipv4.conf.all.accept_redirects = 0`
  - `net.ipv4.conf.all.send_redirects = 0`
  - `net.ipv4.icmp_echo_ignore_broadcasts = 1`
  - `kernel.randomize_va_space = 2`
- [ ] IPv6 deshabilitado si no se usa.
- [ ] Módulos del kernel innecesarios deshabilitados (USB-storage, firewire, etc., en servidores).

## 9. Cifrado

- [ ] Discos cifrados (LUKS) en sistemas con datos sensibles.
- [ ] TLS configurado correctamente en servicios públicos (≥ TLS 1.2, idealmente 1.3).
- [ ] Certificados monitorizados con alertas de caducidad.

> 🔧 Ver [`ssl-check.sh`](../scripts/network/ssl-check.sh).

## 10. Backups

- [ ] Estrategia de backup definida (3-2-1 o equivalente).
- [ ] Backups cifrados y almacenados fuera del servidor.
- [ ] Pruebas de restauración periódicas y documentadas.

---

## Verificación periódica

- 🔁 Revisar este checklist al menos **trimestralmente**.
- 🔁 Ejecutar [`audit-linux.sh`](../scripts/audit/audit-linux.sh) y comparar con el baseline.
- 🔁 Tras incidentes o cambios significativos, repetir desde el punto 1.

---

## Para profundizar

- 🎓 [Detección de intrusos (Idexa)](https://idexaformacion.com/deteccion-de-intrusos/) — 15h, presencial o streaming. Cubre la parte ofensiva y de detección que complementa el hardening.
