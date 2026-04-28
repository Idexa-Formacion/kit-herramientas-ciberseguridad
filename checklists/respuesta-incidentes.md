# Checklist — Respuesta ante incidentes

> Pasos a seguir ante la sospecha o confirmación de un incidente de seguridad. Basado en el ciclo de vida NIST SP 800-61: Preparación → Detección → Contención → Erradicación → Recuperación → Lecciones aprendidas.

---

## 🔵 Fase 0 — Preparación (antes del incidente)

- [ ] Plan de Respuesta ante Incidentes documentado y aprobado.
- [ ] Equipo de respuesta (CSIRT) con roles y contactos definidos.
- [ ] Canales de comunicación seguros y alternativos (fuera de banda).
- [ ] Lista de contactos: dirección, asesoría legal, autoridades (INCIBE-CERT, AEPD si hay datos personales), proveedores.
- [ ] Herramientas de triaje y forense disponibles y probadas (ver `scripts/incident-response/`).
- [ ] Backups recientes y verificados.
- [ ] Personal formado en respuesta ante incidentes.

---

## 🟡 Fase 1 — Detección y análisis

### 1.1 Detectar y reportar

- [ ] Origen de la alerta identificado (SIEM, antivirus, usuario, monitorización…).
- [ ] Timestamp inicial de la detección registrado.
- [ ] Persona que reporta y persona que recibe identificadas.

### 1.2 Triaje inicial

- [ ] ¿Es un falso positivo? (Verifica antes de escalar.)
- [ ] Activos afectados identificados (host, usuario, sistema).
- [ ] Recolección de artefactos volátiles **antes** de tocar el sistema:

  ```bash
  sudo ./scripts/incident-response/triage-linux.sh
  ```

- [ ] Logs preservados:

  ```bash
  sudo ./scripts/incident-response/collect-logs.sh 30
  ```

### 1.3 Categorizar

- [ ] Tipo de incidente: malware, intrusión, fuga de datos, DoS, ingeniería social, etc.
- [ ] Severidad: crítica / alta / media / baja según matriz de la organización.
- [ ] ¿Hay datos personales involucrados? Si sí → considerar notificación a AEPD en ≤72h (RGPD art. 33).

---

## 🟠 Fase 2 — Contención

### 2.1 Contención a corto plazo

- [ ] Aislar el sistema afectado (desconexión de red, no apagar salvo necesidad).
- [ ] Bloquear cuentas comprometidas o sospechosas.
- [ ] Cambiar credenciales potencialmente expuestas.
- [ ] Bloquear IPs/dominios maliciosos en firewall y proxy.

### 2.2 Contención a largo plazo

- [ ] Aplicar parches o configuraciones temporales para evitar reinfección.
- [ ] Reforzar monitorización en activos similares.

---

## 🔴 Fase 3 — Erradicación

- [ ] Causa raíz identificada (vector de entrada, vulnerabilidad explotada, fallo humano).
- [ ] Malware/herramientas del atacante eliminados.
- [ ] Vulnerabilidades parcheadas en todos los sistemas equivalentes.
- [ ] Búsqueda de IOCs en el resto del parque:

  ```bash
  ./scripts/incident-response/ioc-search.sh archivo-iocs.txt
  ```

---

## 🟢 Fase 4 — Recuperación

- [ ] Sistemas restaurados desde backups verificados o reinstalados desde cero.
- [ ] Validación de integridad antes de devolver a producción.
- [ ] Monitorización reforzada durante 7-30 días tras la vuelta a producción.
- [ ] Comunicación a usuarios afectados completada.

---

## 📝 Fase 5 — Lecciones aprendidas

- [ ] Reunión post-incidente realizada en ≤2 semanas.
- [ ] Línea de tiempo del incidente documentada.
- [ ] Causa raíz y factores contribuyentes documentados.
- [ ] Acciones de mejora definidas con responsable y plazo:
  - [ ] Mejoras técnicas (controles, monitorización).
  - [ ] Mejoras de proceso (playbooks, comunicación).
  - [ ] Mejoras de formación (concienciación, simulacros).
- [ ] Informe final archivado para futuras consultas y auditorías.

---

## 📞 Contactos clave (rellenar en tu copia)

| Rol | Persona | Contacto |
|-----|---------|----------|
| Líder de incidente | | |
| Responsable IT | | |
| Asesoría legal | | |
| DPO (si aplica) | | |
| Comunicación / RRPP | | |
| INCIBE-CERT | — | incidencias@incibe-cert.es / 017 |
| AEPD (brechas RGPD) | — | sedeagpd.gob.es |

---

## 🎓 Para profundizar

- [Certificación de Profesional Líder en Ciberseguridad (Idexa)](https://idexaformacion.com/certificacion-de-profesional-lider-en-ciberseguridad/) — incluye gestión de riesgos y estrategia de respuesta.
- [Detección de intrusos (Idexa)](https://idexaformacion.com/deteccion-de-intrusos/) — formación específica para identificar accesos no autorizados.
