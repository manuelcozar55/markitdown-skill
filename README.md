<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,50:1a2744,100:0f1a2e&height=200&section=header&text=MarkItDown%20Skill&fontSize=48&fontColor=58A6FF&animation=fadeIn&fontAlignY=40&desc=Convert%20PDFs%2C%20Office%20files%2C%20HTML%20and%20data%20into%20Claude-ready%20Markdown&descAlignY=62&descSize=15&descColor=8b949e" width="100%" />

[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![Markdown](https://img.shields.io/badge/Markdown-Optimized-000000?style=for-the-badge&logo=markdown&logoColor=white)](https://daringfireball.net/projects/markdown/)
[![Claude Skill](https://img.shields.io/badge/Claude-Skill-0052CC?style=for-the-badge&logoColor=white)](#instalar-en-claude-code)
[![Documents](https://img.shields.io/badge/PDF_DOCX_XLSX_PPTX-Supported-FF6B6B?style=for-the-badge&logoColor=white)](#formatos-soportados)
[![License](https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge)](LICENSE)

<br/>

> **MarkItDown Skill convierte documentos en Markdown limpio para Claude.**
> Añade esta skill a Claude Code para que sepa cuándo convertir PDFs, Office, HTML, hojas de cálculo, archivos comprimidos, imágenes, audio y datos estructurados antes de analizarlos.

</div>

---

## Para qué sirve

Claude y otros agentes trabajan mejor con Markdown que con archivos binarios o contenido ruidoso. Esta skill enseña un flujo experto para usar MarkItDown antes de pasar documentos al contexto del modelo.

| Problema | Solución con esta skill |
|----------|--------------------------|
| PDFs, DOCX, XLSX o PPTX no son texto directo | Convertirlos a Markdown estructurado |
| HTML incluye scripts, navegación y etiquetas | Limpiarlo antes de analizarlo |
| Archivos grandes consumen demasiados tokens | Aplicar presupuesto y truncado controlado |
| ZIP, MSG, imágenes o audio necesitan tratamiento especial | Usar reglas de conversión y seguridad |
| CSV, JSON, XML o YAML pueden ser difíciles de leer | Normalizarlos cuando aporte claridad |

---

## Instalar en Claude Code

### 1. Clona el repositorio

```bash
git clone https://github.com/manuelcozar55/markitdown-skill.git
cd markitdown-skill
```

### 2. Copia la skill a Claude

```bash
mkdir -p ~/.claude/skills
cp -R skills/markitdown ~/.claude/skills/
```

La estructura final debe quedar así:

```text
~/.claude/skills/markitdown/SKILL.md
~/.claude/skills/markitdown/references/supported-formats.md
```

### 3. Instala MarkItDown

Instalación completa para documentos variados:

```bash
python3 -m pip install 'markitdown[all]'
```

Instalación mínima si solo conviertes HTML, CSV, JSON, XML o texto:

```bash
python3 -m pip install markitdown
```

### 4. Reinicia Claude Code

Cierra y vuelve a abrir Claude Code para que detecte la nueva skill.

### 5. Prueba la skill

Pide algo como:

```text
Analiza este PDF y resume sus puntos clave.
Convierte este DOCX a Markdown antes de revisarlo.
Extrae las tablas importantes de este XLSX para Claude.
Limpia esta página HTML y dame solo el contenido útil.
```

Claude debería cargar la skill cuando detecte documentos, archivos web, hojas de cálculo, archivos comprimidos, imágenes, audio o datos estructurados que convenga convertir a Markdown.

---

## Uso directo de MarkItDown

```python
from markitdown import MarkItDown

md = MarkItDown()
result = md.convert("report.pdf")
print(result.markdown)
```

Con límite de contexto:

```python
from markitdown import MarkItDown


def prepare_context(source: str, max_chars: int = 40000) -> str:
    text = MarkItDown().convert(source).markdown or ""
    if len(text) <= max_chars:
        return text
    half = max_chars // 2
    return text[:half] + "\n\n[... content truncated ...]\n\n" + text[-half:]
```

---

## Arquitectura

```mermaid
flowchart TD
    A([Archivo, URL o dato de entrada]) --> B{¿Conviene convertir?}
    B -->|PDF Office HTML EPUB ZIP MSG| C[MarkItDown]
    B -->|CSV JSON XML YAML| D[Normalizar si mejora lectura]
    B -->|Markdown o texto corto| E[Usar directamente]
    C --> F[Markdown limpio]
    D --> F
    E --> F
    F --> G[Revisión de tamaño]
    G --> H[Contexto listo para Claude]

    style A fill:#1a2744,stroke:#58A6FF,color:#fff
    style B fill:#0f1a2e,stroke:#58A6FF,color:#fff
    style C fill:#1f2937,stroke:#3fb950,color:#ccc
    style D fill:#1f2937,stroke:#3fb950,color:#ccc
    style E fill:#1f2937,stroke:#8b949e,color:#ccc
    style F fill:#0d2818,stroke:#3fb950,color:#fff
    style G fill:#1f2937,stroke:#FF6B6B,color:#ccc
    style H fill:#0d2818,stroke:#3fb950,color:#fff
```

---

## Formatos soportados

| Categoría | Ejemplos | Recomendación |
|-----------|----------|----------------|
| Documentos | PDF, DOCX, PPTX, EPUB | Convertir antes del análisis |
| Hojas de cálculo | XLSX, XLS, CSV | Convertir y filtrar tablas grandes |
| Web | HTML, URLs | Convertir para reducir ruido y tokens |
| Datos estructurados | JSON, XML, YAML | Convertir cuando mejore la legibilidad |
| Archivos y email | ZIP, MSG | Convertir e inspeccionar secciones extraídas |
| Media | Imágenes, audio | Usar conversión enriquecida o transcripción cuando haga falta |

Matriz completa: [`skills/markitdown/references/supported-formats.md`](skills/markitdown/references/supported-formats.md)

---

## Estructura del repositorio

```text
markitdown-skill/
├── README.md
├── LICENSE
├── skills/
│   └── markitdown/
│       ├── SKILL.md
│       └── references/
│           └── supported-formats.md
└── tests/
    └── validate-skill.sh
```

---

## Validación

```bash
./tests/validate-skill.sh
```

Salida esperada:

```text
PASS: skill repository validation completed
```

---

## Notas de experto

- La skill usa frontmatter compatible con Agent Skills: `name` y `description` compactos.
- El disparador está optimizado para conversiones de documentos, web, hojas de cálculo, archivos, imágenes, audio y datos estructurados.
- La referencia de formatos vive fuera del `SKILL.md` para mantener la skill ligera.
- La guía prioriza conversión local, control de tamaño y tratamiento seguro de archivos no confiables.

---

## Roadmap

- [ ] Añadir flujo OCR para PDFs escaneados.
- [ ] Añadir ejemplos de conversión por lotes.
- [ ] Añadir benchmarks de reducción de tokens en HTML.
- [ ] Añadir workflow CI para validación automática.

---

## Autor

**Manuel Antonio Cózar Baranguán**
*AI Engineer & Innovation Researcher*

[![GitHub](https://img.shields.io/badge/GitHub-@manuelcozar55-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/manuelcozar55)
[![Email](https://img.shields.io/badge/Email-manuelcozar55@gmail.com-EA4335?style=flat-square&logo=gmail&logoColor=white)](mailto:manuelcozar55@gmail.com)

---

<div align="center">

*Documentos limpios. Menos contexto. Mejor análisis en Claude.*

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0f1a2e,60:1a2744,100:0d1117&height=100&section=footer" width="100%" />

</div>
