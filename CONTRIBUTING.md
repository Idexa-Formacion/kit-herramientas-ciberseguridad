# Guía de contribución

¡Gracias por tu interés en mejorar este toolkit! Las contribuciones son bienvenidas: nuevos scripts, mejoras a los existentes, traducciones, checklists adicionales, correcciones tipográficas, etc.

---

## Antes de empezar

1. **Abre primero un issue** describiendo tu propuesta si vas a hacer un cambio grande. Así nos aseguramos de no duplicar trabajo.
2. **Revisa los issues abiertos** por si alguien ya está trabajando en algo similar.

## Cómo contribuir

1. Haz un *fork* del repositorio.
2. Crea una rama descriptiva: `git checkout -b feat/script-detect-rootkits`.
3. Realiza tus cambios siguiendo las convenciones de abajo.
4. Asegúrate de que tu script lleva cabecera (ver plantilla).
5. Abre un Pull Request explicando el qué, el porqué y cómo probarlo.

## Convenciones para scripts

Cada script debe llevar al inicio una cabecera con este formato:

```bash
#!/usr/bin/env bash
# ==============================================================================
# nombre-del-script.sh
# ------------------------------------------------------------------------------
# Propósito : Una o dos frases describiendo qué hace.
# Requisito : Dependencias necesarias.
# Uso       : ./nombre-del-script.sh <args>
# Ejemplo   : ./nombre-del-script.sh 192.168.1.1
# ==============================================================================
```

Otras buenas prácticas:

- **Bash:** usa `set -euo pipefail` siempre que tenga sentido.
- **Validar argumentos** antes de hacer nada destructivo.
- **No depender de credenciales hardcodeadas** ni datos reales.
- **Las acciones destructivas** deben pedir confirmación explícita al usuario.
- **Hacer backup** antes de modificar configuraciones del sistema.
- **Mensajes claros** indicando qué está haciendo el script en cada paso.

## Convenciones para documentación

- Markdown limpio: encabezados jerárquicos, listas claras, tablas cuando aporten.
- Lenguaje directo y operativo. Esta es documentación para gente que va a *hacer* algo, no para impresionar.
- Si añades referencias a estándares (ISO, NIST, CIS), enlaza al documento o sección original cuando sea posible.

## Lo que no aceptamos

- Scripts ofensivos pensados para atacar sistemas de terceros.
- Herramientas que evadan controles legales o de cumplimiento.
- Datos personales reales, IPs internas reales, credenciales o secretos en ejemplos.
- Código sin cabecera, sin validación, o que no se entienda al leerlo.

## Reportar vulnerabilidades

Si encuentras una vulnerabilidad **en este toolkit** (no en un sistema externo), consulta [`SECURITY.md`](SECURITY.md). No abras un issue público con el detalle.

---

Gracias por contribuir. 🛡️
