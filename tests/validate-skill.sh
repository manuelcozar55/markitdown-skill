#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$ROOT/skills/markitdown/SKILL.md"
FORMATS="$ROOT/skills/markitdown/references/supported-formats.md"
README="$ROOT/README.md"
LICENSE="$ROOT/LICENSE"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[ -f "$SKILL" ] || fail "missing skills/markitdown/SKILL.md"
[ -f "$FORMATS" ] || fail "missing supported-formats reference"
[ -f "$README" ] || fail "missing README.md"
[ -f "$LICENSE" ] || fail "missing LICENSE"
grep -q 'Apache License' "$LICENSE" || fail "LICENSE must contain Apache License"
grep -q 'capsule-render.vercel.app' "$README" || fail "README missing capsule header"
grep -q '```mermaid' "$README" || fail "README missing architecture diagram"
grep -q 'Manuel Antonio Cózar Baranguán' "$README" || fail "README missing author name"
grep -q 'manuelcozar55@gmail.com' "$README" || fail "README missing requested email"

grep -q '^---$' "$SKILL" || fail "SKILL.md missing YAML frontmatter delimiter"
grep -q '^name: markitdown$' "$SKILL" || fail "SKILL.md missing name"
grep -q '^description: ' "$SKILL" || fail "SKILL.md missing description"
grep -q '^# MarkItDown Skill$' "$SKILL" || fail "SKILL.md missing title"
grep -q 'references/supported-formats.md' "$SKILL" || fail "SKILL.md missing supported-formats link"
grep -q '^# Supported Formats$' "$FORMATS" || fail "supported-formats missing title"
grep -q 'pip install' "$README" || fail "README missing install command"
grep -q 'skills/markitdown/SKILL.md' "$README" || fail "README missing skill path"

if grep -RniE 'generated with|assisted-by|openai generated' "$ROOT" \
  --exclude-dir=.git \
  --exclude-dir=.crush \
  --exclude='validate-skill.sh'; then
  fail "forbidden attribution or assistant trace found"
fi

python3 - <<'PY' "$SKILL"
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
if not text.startswith("---\n"):
    raise SystemExit("frontmatter must start at byte 0")
end = text.find("\n---\n", 4)
if end == -1:
    raise SystemExit("frontmatter must close")
frontmatter = text[4:end]
if len(frontmatter) > 1024:
    raise SystemExit(f"frontmatter too long: {len(frontmatter)} chars")
if "description: >" in frontmatter:
    raise SystemExit("description must be a compact single-line trigger")
PY

printf 'PASS: skill repository validation completed\n'
