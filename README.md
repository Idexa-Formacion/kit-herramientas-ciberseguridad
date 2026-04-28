<p align="center">
  <a href="https://idexaformacion.com/cursos/ciberseguridad/">
    <img src="https://idexaformacion.com/wp-content/uploads/2023/04/Capa-2.svg" alt="Idexa Formación" width="200" />
  </a>
</p>

<h1 align="center">Kit de Herramientas Ciberseguridad</h1>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Idexa Formación](https://img.shields.io/badge/Formación-Idexa-blue.svg)](https://idexaformacion.com/cursos/ciberseguridad/)

> Kit de herramientas, scripts y plantillas para auditoría, hardening, detección y respuesta ante incidentes de ciberseguridad. Pensado tanto para equipos IT que quieren reforzar su postura de seguridad como para profesionales en formación.

---

## 📑 Índice

- [Sobre el toolkit](#-sobre-el-toolkit)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Inicio rápido](#-inicio-rápido)
- [Herramientas incluidas](#-herramientas-incluidas)
- [Checklists y plantillas](#-checklists-y-plantillas)
- [Buenas prácticas de uso](#-buenas-prácticas-de-uso)
- [🎓 Formación en Ciberseguridad — Cursos Idexa](#-formación-en-ciberseguridad--cursos-idexa)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)
- [Aviso legal](#%EF%B8%8F-aviso-legal)

---

## 🔍 Sobre el toolkit

Este repositorio reúne utilidades prácticas para las cuatro áreas operativas más comunes de un equipo de seguridad:

| Área | Para qué sirve |
|------|----------------|
| **Network** | Reconocimiento, escaneo y análisis de red |
| **Audit** | Auditoría de configuraciones, permisos y políticas |
| **Hardening** | Bastionado de servidores y endpoints |
| **Incident Response** | Recolección de evidencias y triaje inicial |

Todas las herramientas son scripts ligeros (Bash, Python, PowerShell) sin dependencias propietarias. Están pensadas para ser leídas, entendidas y modificadas — no son cajas negras.

---

## 📁 Estructura del repositorio

```
cybersec-toolkit/
├── scripts/
│   ├── network/             # Escaneo y análisis de red
│   ├── audit/               # Auditoría de sistemas
│   ├── hardening/           # Bastionado de servidores
│   └── incident-response/   # Respuesta ante incidentes
├── checklists/              # Listas de verificación (ISO 27001, NIST, etc.)
├── templates/               # Plantillas de políticas e informes
├── docs/                    # Documentación complementaria
└── .github/workflows/       # CI: linting, escaneo de secretos
```

---

## 🚀 Inicio rápido

Clona el repositorio:

```bash
git clone https://github.com/<tu-organizacion>/cybersec-toolkit.git
cd cybersec-toolkit
```

Da permisos de ejecución a los scripts:

```bash
chmod +x scripts/**/*.sh
```

Ejecuta tu primer escaneo (requiere `nmap`):

```bash
./scripts/network/quick-scan.sh 192.168.1.0/24
```

Cada script lleva una cabecera con su propósito, requisitos y ejemplo de uso. Léela antes de ejecutar.

---

## 🧰 Herramientas incluidas

### 🌐 Red (`scripts/network/`)

| Script | Descripción |
|--------|-------------|
| `quick-scan.sh` | Escaneo rápido de hosts activos en una subred |
| `port-audit.sh` | Auditoría de puertos abiertos en un host |
| `ssl-check.sh` | Verifica certificados TLS/SSL y caducidades |

### 🔎 Auditoría (`scripts/audit/`)

| Script | Descripción |
|--------|-------------|
| `audit-linux.sh` | Recopila configuración de seguridad de un Linux (usuarios, sudoers, SSH, firewall) |
| `password-policy-check.sh` | Verifica política de contraseñas frente a un baseline |
| `find-suid.sh` | Busca binarios SUID/SGID potencialmente peligrosos |

### 🛡️ Hardening (`scripts/hardening/`)

| Script | Descripción |
|--------|-------------|
| `harden-ssh.sh` | Aplica una configuración SSH endurecida (con backup previo) |
| `disable-services.sh` | Desactiva servicios innecesarios en servidores Linux |
| `firewall-baseline.sh` | Configura un baseline de `ufw` / `firewalld` |

### 🚨 Respuesta ante incidentes (`scripts/incident-response/`)

| Script | Descripción |
|--------|-------------|
| `triage-linux.sh` | Recolecta artefactos volátiles para triaje en un host Linux |
| `collect-logs.sh` | Empaqueta logs relevantes para análisis forense |
| `ioc-search.sh` | Busca indicadores de compromiso (IOCs) en un sistema |

---

## ✅ Checklists y plantillas

En `checklists/` encontrarás listas de verificación accionables:

- `iso27001-controles.md` — Mapeo rápido de controles ISO/IEC 27001:2022
- `hardening-linux.md` — Checklist de bastionado para servidores Linux
- `respuesta-incidentes.md` — Pasos guiados ante un incidente

En `templates/`:

- `politica-seguridad.md` — Plantilla base de Política de Seguridad
- `informe-incidente.md` — Plantilla de reporte de incidente
- `plan-respuesta.md` — Estructura de un Plan de Respuesta ante Incidentes

---

## 📋 Buenas prácticas de uso

1. **Solo en sistemas autorizados.** Usar estas herramientas contra infraestructura que no te pertenece o sin permiso explícito puede ser delito.
2. **Probar antes en entornos controlados.** Algunos scripts modifican configuraciones del sistema. Hazlos correr primero en una VM o entorno de staging.
3. **Revisar antes de ejecutar.** No ejecutes nada sin entender qué hace. Las cabeceras de cada script explican el propósito y los efectos.
4. **Registrar lo que haces.** Cualquier acción de auditoría o respuesta debe quedar documentada (qué, cuándo, por qué, resultado).

---

## 🎓 Formación en Ciberseguridad — Cursos Idexa

<p align="center">
  <a href="https://idexaformacion.com/cursos/ciberseguridad/">
    <img src="https://idexaformacion.com/wp-content/uploads/2023/04/Capa-2.svg" alt="Idexa Formación" width="200" />
  </a>
</p>

Si quieres profundizar más allá de estas herramientas y entender el **porqué** detrás de cada control, en [**Idexa Formación**](https://idexaformacion.com/cursos/ciberseguridad/) ofrecemos formación práctica orientada a empresas y profesionales.

> *Nuestros cursos están enfocados en capacitarte para reconocer y responder a amenazas comunes, asegurando que no solo adquieras conocimientos técnicos, sino también habilidades prácticas para implementarlos en tu día a día laboral.*

### 📚 Cursos disponibles

#### 🏆 [Certificación de Profesional Líder en Ciberseguridad (LCSPC)](https://idexaformacion.com/certificacion-de-profesional-lider-en-ciberseguridad/)

- **Duración:** 21 horas
- **Modalidad:** Presencial o Streaming
- **Categoría:** Certificaciones Oficiales IT · Ciberseguridad

Formación orientada a profesionales de TI, responsables de seguridad y líderes de proyectos que quieren dirigir estrategias de protección en su organización. Cubre los principios de ciberseguridad, la norma ISO/IEC 27032, gestión de riesgos, implementación de marcos de ciberseguridad y metodologías para proteger privacidad y libertades civiles.

**Ideal si:** Lideras o vas a liderar la estrategia de seguridad de una organización.

---

#### 👥 [Ciberseguridad para empleados](https://idexaformacion.com/ciberseguridad-para-empleados/)

- **Duración:** 8 horas
- **Modalidad:** Online
- **Categoría:** Ciberseguridad

Curso práctico para que cualquier empleado, sin perfil técnico, sepa identificar amenazas comunes (phishing, ingeniería social, malware) y adopte buenas prácticas en su rutina laboral. La forma más rápida de elevar el nivel de seguridad de una organización es formar a su gente.

**Ideal si:** Quieres formar a tu plantilla en concienciación y buenas prácticas básicas.

---

#### 🕵️ [Detección de intrusos](https://idexaformacion.com/deteccion-de-intrusos/)

- **Duración:** 15 horas
- **Modalidad:** Presencial o Streaming
- **Categoría:** Ciberseguridad

Formación técnica para aprender a identificar accesos no autorizados, comportamientos anómalos en red y sistemas, y responder ante intentos de intrusión. Combina teoría y casos prácticos.

**Ideal si:** Trabajas en operaciones de seguridad, SOC, o vas a implementar IDS/IPS.

---

#### 📜 [ISO/IEC 27001:2022 Foundation](https://idexaformacion.com/iso-iec-27001-foundation/)

- **Duración:** 8 horas
- **Modalidad:** Online
- **Categoría:** Certificaciones Oficiales IT · Ciberseguridad

Introducción a la norma internacional de referencia para la gestión de la seguridad de la información. Cubre los fundamentos de un SGSI (Sistema de Gestión de Seguridad de la Información) y prepara para la certificación oficial Foundation.

**Ideal si:** Quieres entender o implementar un SGSI alineado con ISO 27001 en tu organización.

---

### 🎯 ¿Por qué formarse con Idexa?

- **Diseño orientado a empresas** — contenidos pensados para aplicar en entornos reales.
- **Certificaciones reconocidas** — acreditaciones valoradas internacionalmente.
- **Material práctico** — simulaciones y casos reales, no solo teoría.
- **Modalidad flexible** — online, streaming o presencial según necesidades del equipo.

📞 **Contacto Idexa Formación:**
- Particulares: [+34 623 34 74 15](https://wa.me/34623347415)
- Empresas: [+34 651 60 10 22](https://wa.me/34651601022)
- Web: [idexaformacion.com/cursos/ciberseguridad](https://idexaformacion.com/cursos/ciberseguridad/)

---

## 🤝 Contribuir

Las contribuciones son bienvenidas. Antes de abrir un Pull Request:

1. Lee [`CONTRIBUTING.md`](CONTRIBUTING.md).
2. Asegúrate de que tu script lleve cabecera, requisitos y ejemplo de uso.
3. No incluyas credenciales, IPs internas ni datos sensibles en los ejemplos.

Para reportar vulnerabilidades en este toolkit, consulta [`SECURITY.md`](SECURITY.md).

---

## 📄 Licencia

Distribuido bajo licencia MIT. Consulta el archivo [`LICENSE`](LICENSE) para más detalles.

---

## ⚠️ Aviso legal

Las herramientas de este repositorio están destinadas **exclusivamente** a usos legítimos: auditoría de sistemas propios, formación, investigación de seguridad autorizada y respuesta ante incidentes. El uso indebido contra sistemas de terceros sin autorización explícita puede constituir delito según la legislación aplicable. Los autores no se responsabilizan del mal uso de estas herramientas.

---

<p align="center">
  <sub>Mantenido con 🛡️ por la comunidad · Formación oficial en <a href="https://idexaformacion.com">Idexa Formación</a></sub>
</p>
