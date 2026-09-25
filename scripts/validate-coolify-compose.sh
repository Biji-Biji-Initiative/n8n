#!/usr/bin/env bash
# Validate the standard Compose projection while retaining Coolify's documented
# `exclude_from_hc` extension for successful one-shot recovery services.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
compose_path="$repo_root/deploy/coolify/compose.yaml"

python3 - "$compose_path" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
for service in ("restore-fetch", "restore-data"):
    match = re.search(
        rf"^  {re.escape(service)}:\n(?P<body>.*?)(?=^  \S|\Z)",
        text,
        flags=re.MULTILINE | re.DOTALL,
    )
    assert match, service
    body = match.group("body")
    assert "restart: \"no\"" in body, service
    assert "exclude_from_hc: true" in body, service

assert "N8N_RESTORE_ENABLED" in text
assert "refusing to overwrite non-empty n8n target volume" in text
assert "production n8n requires a verified first restore" in text
assert "restore-data:" in re.search(
    r"^  n8n:\n(?P<body>.*?)(?=^  \S|\Z)", text, re.MULTILINE | re.DOTALL
).group("body")
PY

# `exclude_from_hc` is understood by Coolify but not stock Compose. Strip only
# that control-plane extension for the local schema check.
sed '/^[[:space:]]*exclude_from_hc:[[:space:]]*true[[:space:]]*$/d' "$compose_path" \
  | docker compose \
      --env-file "$repo_root/deploy/coolify/compose.example.env" \
      -f - config "$@"
