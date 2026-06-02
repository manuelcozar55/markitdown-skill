# Supported Formats

| Format | Extensions | Install requirement | Conversion result |
|--------|------------|---------------------|-------------------|
| PDF | `.pdf` | `markitdown[pdf]` or `markitdown[all]` | Text paragraphs and detected structure |
| Word | `.docx`, `.doc` | `markitdown[docx]` or `markitdown[all]` | Headings, lists, paragraphs, tables |
| Excel | `.xlsx`, `.xls` | `markitdown[xlsx]` or `markitdown[all]` | Sheet sections and Markdown tables |
| PowerPoint | `.pptx`, `.ppt` | `markitdown[pptx]` or `markitdown[all]` | Slide sections and speaker notes |
| HTML | `.html`, `.htm`, URLs | base package | Clean Markdown with boilerplate removed |
| CSV | `.csv` | base package | Markdown table |
| JSON | `.json` | base package | Structured text representation |
| XML | `.xml` | base package | Structured text representation |
| EPUB | `.epub` | `markitdown[all]` | Book sections as Markdown |
| ZIP | `.zip` | `markitdown[all]` | Extracted readable contents |
| Outlook message | `.msg` | `markitdown[all]` | Email body and metadata |
| Images | `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp` | base package for metadata; LLM client for descriptions | Metadata or LLM-generated description |
| Audio | `.mp3`, `.wav`, `.m4a` | `markitdown[all]` plus configured transcription support | Transcript when supported |
| Plain text | `.txt`, `.md` | base package | Text passthrough or normalization |

## Install Profiles

| Profile | Command | Use case |
|---------|---------|----------|
| Minimal | `pip install markitdown --break-system-packages` | HTML, CSV, JSON, XML, text |
| Documents | `pip install 'markitdown[pdf,docx,xlsx,pptx]' --break-system-packages` | Office and PDF pipelines |
| Complete | `pip install 'markitdown[all]' --break-system-packages` | Broad ingestion systems |

## Selection Guide

- Use the minimal profile for web content cleanup and text normalization.
- Use the documents profile for enterprise document analysis.
- Use the complete profile for agents that receive unpredictable uploads.
- Add OCR before MarkItDown when PDFs are scanned image documents.
- Filter very large spreadsheets before conversion when only specific sheets, rows, or columns are relevant.
