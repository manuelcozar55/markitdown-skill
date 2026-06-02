---
name: markitdown
description: Use when converting files, documents, archives, web pages, images, audio, PDFs, Office files, spreadsheets, or structured data into Markdown for LLM-ready analysis.
---

# MarkItDown Skill

Convert files and documents to clean Markdown before analysis so large or binary sources become readable, structured, and token-efficient.

## When to Use

Use MarkItDown before passing these sources into an LLM:

| Source | Use MarkItDown? | Reason |
|--------|------------------|--------|
| PDF, DOCX, XLSX, PPTX, EPUB | Yes | Binary formats are otherwise unreadable |
| HTML or web pages | Yes | Removes tags, scripts, navigation, and boilerplate |
| ZIP or MSG archives | Yes | Extracts contained readable content |
| Images or audio | Sometimes | Needs LLM-enhanced conversion for rich descriptions/transcription |
| CSV, JSON, XML, YAML | Optional | Already text; useful when normalization helps |
| Plain Markdown | No | Already optimized for LLM consumption |

Rule of thumb: always use MarkItDown for HTML and binary formats. For CSV, JSON, XML, or YAML already in context, use it only when normalized Markdown improves readability.

## Installation

```bash
pip install 'markitdown[all]' --break-system-packages
```

Minimal install for HTML, CSV, JSON, XML, and plain text:

```bash
pip install markitdown --break-system-packages
```

Selective install for common document pipelines:

```bash
pip install 'markitdown[pdf,docx,xlsx,pptx]' --break-system-packages
```

## Core API

```python
from markitdown import MarkItDown

md = MarkItDown()
result = md.convert("path/to/file.pdf")

print(result.markdown)
print(result.title)
```

| Method | Use when |
|--------|----------|
| `md.convert(path_or_url)` | General purpose conversion with format auto-detection |
| `md.convert_local(path)` | Local files only, safer for untrusted input |
| `md.convert_url(url)` | Explicit URL conversion |
| `md.convert_stream(stream)` | Binary streams and file-like objects |

## Standard Workflow

### 1. Decide whether conversion adds value

```python
import os

HIGH_VALUE = {
    ".pdf", ".docx", ".doc", ".xlsx", ".xls", ".pptx", ".ppt",
    ".html", ".htm", ".epub", ".zip", ".msg",
}
MEDIUM_VALUE = {".csv", ".json", ".xml", ".yaml", ".yml"}


def should_use_markitdown(filepath: str) -> bool:
    ext = os.path.splitext(filepath)[1].lower()
    return ext in HIGH_VALUE or ext in MEDIUM_VALUE
```

### 2. Convert with error handling

```python
from markitdown import MarkItDown


def convert_to_markdown(source: str) -> str:
    md = MarkItDown()
    try:
        result = md.convert(source)
    except Exception as exc:
        raise RuntimeError(f"MarkItDown conversion failed for {source}: {exc}") from exc
    return result.markdown or ""
```

### 3. Apply a token budget

```python
def convert_with_limit(source: str, max_chars: int = 40000) -> str:
    text = convert_to_markdown(source)
    if len(text) <= max_chars:
        return text

    half = max_chars // 2
    return text[:half] + "\n\n[... content truncated ...]\n\n" + text[-half:]
```

## Format Notes

| Format | Notes |
|--------|-------|
| PDF | Extracts text layer; scanned PDFs need OCR. Tables may require manual review. |
| XLSX | Each sheet becomes a section with Markdown tables. Filter large sheets first. |
| DOCX | Preserves headings, lists, and tables. Images need LLM-enhanced conversion. |
| PPTX | Converts slides and speaker notes. Image descriptions need an LLM client. |
| HTML | Strong token savings by stripping scripts, styles, navigation, and boilerplate. |
| Images | Extracts metadata without an LLM; use LLM-enhanced conversion for descriptions. |
| CSV | Converts to Markdown tables; token count may remain similar. |
| JSON/XML/YAML | Useful mainly for normalization and consistent downstream processing. |

See `references/supported-formats.md` for the supported-format matrix.

## Practical Integration

```python
from markitdown import MarkItDown
import os


def prepare_file_for_llm(filepath: str) -> dict:
    md = MarkItDown()
    try:
        result = md.convert(filepath)
    except Exception as exc:
        return {
            "error": str(exc),
            "content": "",
            "tokens_approx": 0,
            "format": os.path.splitext(filepath)[1].lower(),
            "truncated": False,
        }

    text = result.markdown or ""
    return {
        "content": text,
        "title": result.title,
        "tokens_approx": len(text) // 4,
        "format": os.path.splitext(filepath)[1].lower(),
        "truncated": False,
    }
```

## LLM-Enhanced Conversion

Use an LLM client only when the source requires semantic interpretation, such as image descriptions or audio transcription.

```python
from markitdown import MarkItDown

client = your_configured_llm_client()
md = MarkItDown(llm_client=client, llm_model="vision-capable-model")
result = md.convert("presentation.pptx")
```

## Security

- Prefer `md.convert_local()` for untrusted local files.
- Prefer `md.convert_url()` when network access is intentional.
- Sanitize user-controlled paths and URLs before conversion.
- Do not pass secrets, private credentials, or unrestricted filesystem paths into conversion pipelines.
- Treat converted archive contents as untrusted input.

## Diagnostics

```bash
python3 -c "import markitdown; print(markitdown.__version__)"
pip show markitdown
markitdown path/to/file.pdf
```

Common failures:

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Empty PDF output | Scanned image-only PDF | Add OCR workflow before analysis |
| ImportError for PDF/XLSX/PPTX | Missing optional dependency | Install `markitdown[all]` or selected extras |
| 403 for URL conversion | Server blocks automated clients | Fetch content through an approved application path, then convert stream/content |
| Very large Markdown | Large spreadsheet, archive, or long document | Filter source data or apply `convert_with_limit()` |
