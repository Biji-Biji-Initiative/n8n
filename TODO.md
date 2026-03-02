# AGENTS.md Improvement TODO

This file tracks improvements needed for AGENTS.md to better support AI coding agents.

## High Priority

- [ ] **Validate all commands** - Test every command in AGENTS.md to ensure they work
- [ ] **Add actual Ollama models** - Replace placeholder models with actual models being used
- [ ] **Specify Qdrant collection names** - Document which collections are used
- [ ] **Add GKE namespace** - Specify the actual Kubernetes namespace

## Medium Priority

- [ ] **Document custom n8n nodes** - List and describe any custom nodes in `custom-nodes/`
- [ ] **Add webhook endpoints** - Document n8n webhook URLs if relevant
- [ ] **Specify n8n version** - Add version being used
- [ ] **Add environment variables reference** - List all required env vars (without values)

## Low Priority

- [ ] **Add troubleshooting section** - Common issues and solutions
- [ ] **Add architecture diagram link** - If architecture docs exist
- [ ] **Add contact info** - Who to ask for help

## Quality Checklist

| Check | Status |
|-------|--------|
| All commands tested | [ ] |
| File paths accurate | [ ] |
| Under 150 lines | [x] |
| No hardcoded secrets | [x] |
| Links to docs | [ ] |
| 3-tier boundaries | [x] |
| Last updated date | [x] |

---
Created: 2026-03-02
