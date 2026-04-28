# Plan de Respuesta ante Incidentes (PRI)

> Plantilla base. Adapta cada sección a tu organización antes de poner el plan en producción. Un plan que no se prueba periódicamente no sirve.

---

**Documento:** Plan de Respuesta ante Incidentes
**Versión:** 1.0
**Aprobado por:** `<Nombre, Cargo>`
**Fecha:** `<DD/MM/AAAA>`

---

## 1. Objetivo

Establecer el procedimiento que `<Nombre de la organización>` seguirá ante un incidente de seguridad para minimizar su impacto, restaurar las operaciones y aprender de la situación.

## 2. Alcance

Aplica a cualquier incidente que afecte a la confidencialidad, integridad o disponibilidad de los activos de información de la organización, incluidos sistemas alojados en la nube y servicios de terceros.

## 3. Definiciones

- **Evento de seguridad:** observación que podría indicar un problema de seguridad.
- **Incidente de seguridad:** uno o varios eventos confirmados que comprometen la seguridad.
- **Brecha de datos personales:** incidente que afecta a datos personales (RGPD art. 4.12).

## 4. Equipo de respuesta (CSIRT)

| Rol | Persona | Backup | Contacto |
|-----|---------|--------|----------|
| Líder de incidente | | | |
| Responsable técnico | | | |
| Comunicación interna | | | |
| Comunicación externa / RRPP | | | |
| Asesoría legal | | | |
| DPO (si aplica) | | | |

**Canal de comunicación primario:** `<...>`
**Canal alternativo (fuera de banda):** `<...>` *(si los sistemas habituales están comprometidos)*

## 5. Clasificación de incidentes

| Severidad | Criterio | Tiempo de respuesta |
|-----------|----------|---------------------|
| Crítica | Compromiso de sistemas críticos, fuga masiva de datos, ransomware activo | Inmediato (<15 min) |
| Alta | Compromiso de un sistema importante, acceso no autorizado confirmado | <1 hora |
| Media | Detección de malware aislado, intentos de intrusión persistentes | <4 horas |
| Baja | Eventos de seguridad sin impacto confirmado | <24 horas |

## 6. Fases del proceso

```
Preparación → Detección → Análisis → Contención →
Erradicación → Recuperación → Lecciones aprendidas
```

> 📋 Cada fase tiene su detalle accionable en [`checklists/respuesta-incidentes.md`](../checklists/respuesta-incidentes.md).

### 6.1 Detección

Fuentes habituales de detección:

- Alertas de SIEM / EDR / antivirus.
- Reportes de usuarios (`<email del buzón de incidentes>`).
- Monitorización proactiva.
- Notificaciones de terceros (proveedores, clientes, CSIRTs).

### 6.2 Análisis y triaje

Antes de tocar nada, capturar artefactos volátiles:

```bash
sudo ./scripts/incident-response/triage-linux.sh
sudo ./scripts/incident-response/collect-logs.sh 30
```

### 6.3 Contención

- Aislar sistemas afectados (red).
- Bloquear cuentas comprometidas.
- Bloquear IOCs en perímetro.

### 6.4 Erradicación

- Identificar y cerrar el vector de entrada.
- Eliminar herramientas del atacante.
- Buscar IOCs en el resto del parque.

### 6.5 Recuperación

- Restaurar desde backups verificados.
- Validar integridad antes de devolver a producción.
- Monitorización reforzada 7-30 días.

### 6.6 Lecciones aprendidas

- Reunión post-incidente en ≤2 semanas.
- Informe final usando [`templates/informe-incidente.md`](informe-incidente.md).
- Acciones de mejora con responsables y plazos.

## 7. Notificaciones obligatorias

| Caso | Notificar a | Plazo |
|------|-------------|-------|
| Brecha de datos personales (RGPD) | AEPD | ≤72h desde el conocimiento |
| Brecha que afecta a derechos y libertades | Afectados | Sin demora indebida |
| Incidente significativo NIS2 (si aplica) | Autoridad competente | Notificación temprana ≤24h |
| Incidente que afecta a clientes/contratos | Clientes según contrato | Según SLA contractual |

## 8. Pruebas y mantenimiento del plan

- [ ] Revisión anual del plan.
- [ ] Simulacro de mesa (`tabletop`) anual.
- [ ] Simulacro técnico cada 2 años.
- [ ] Actualización tras cada incidente real significativo.

## 9. Anexos

- A. Lista de contactos detallada (interno).
- B. Inventario de sistemas críticos (interno).
- C. Playbooks específicos:
  - Ransomware
  - Phishing dirigido
  - Compromiso de cuenta privilegiada
  - Fuga de datos
  - DDoS

---

> 🎓 Una guía teórico-práctica completa para diseñar y operar este tipo de planes está en el curso [Certificación de Profesional Líder en Ciberseguridad LCSPC](https://idexaformacion.com/certificacion-de-profesional-lider-en-ciberseguridad/) de Idexa.
