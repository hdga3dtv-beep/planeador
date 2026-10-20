# Planeador

Panel para armar planeaciones didácticas de primaria (Fases 3, 4 y 5 de la NEM) y sacarlas en Word y PDF.
Funciona en tu computadora, sin internet y sin cuentas: lo que escribes no sale de tu equipo.

## Descargar

**[⬇ Descargar el Planeador (Planeador.zip)](https://github.com/hdga3dtv-beep/planeador/releases/latest/download/Planeador.zip)**

1. Clic derecho en `Planeador.zip` → **Extraer todo…** → **Extraer**.
2. En la carpeta que sale, doble clic en **Instalar**.
   Si Windows pregunta, elige **Ejecutar** (o **Más información → Ejecutar de todas formas**).
3. Queda en `Documentos\Planeador`, con su ícono **Planeador** en el escritorio y en el menú Inicio.

Para actualizarlo, descarga otra vez y vuelve a abrir **Instalar**: tus planeaciones y tus datos se quedan.

## Qué hace

- Eliges el campo formativo central (la metodología se elige sola), los contenidos y PDA del programa sintético
  oficial 2024, los ejes articuladores y los momentos o etapas de la metodología, y los repartes en la semana.
- **Revisar** busca errores antes de entregar: contenidos y PDA que no son textuales del programa, momentos fuera de
  orden, sesiones sin consignas, firmas que faltan…
- **Generar Word y PDF** la arma en la *Planeación Cedros* (el formato de la Esc. Prim. Urbana 136 «Cedros del Líbano»)
  o en el formato de su metodología (ABPC, STEAM, ABP o Aprendizaje Servicio).
- Guarda versiones anteriores, borradores y una papelera, por si algo se pierde.

## Qué necesita

- Windows 10 u 11, con Edge o Chrome.
- Python 3.8 o más nuevo (el instalador lo busca; si falta, abre la Tienda de Microsoft para instalarlo gratis).
- Microsoft Word, para el PDF. Sin Word, el Planeador hace el `.docx`, pero no el PDF.

Más detalles en [LEEME.txt](LEEME.txt).

## Carpetas

| Carpeta o archivo | Qué es |
|---|---|
| `servidor.py` | El programa: un servidor que solo escucha en tu computadora (127.0.0.1) |
| `web/` | El panel (página, estilos, lógica, imágenes y letras) |
| `motor/` | Arma, revisa y exporta el Word (`generar.py`, `verificar.py`, `exportar.ps1`) y el formato de Cedros |
| `datos/` | Contenidos y PDA de los programas sintéticos 2024 de las Fases 3, 4 y 5 |
| `planeaciones/` | Lo que guardas y generas (aquí solo viene la DEMO, con datos ficticios) |
| `Instalar.bat` | Lo copia a `Documentos\Planeador` y le pone su ícono |
