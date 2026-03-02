# AGENTS.md

## Repository Overview
n8n workflow automation platform with Ollama + Qdrant AI stack for Biji-Biji Initiative. Primary runtime is the n8n server with custom nodes and AI integrations.

## Core Commands
- Install: `npm install` or `pnpm install`
- Dev: `npm run dev` or `pnpm dev`
- Build: `npm run build` or `pnpm build`
- Test: `npm test` or `pnpm test`
- Lint: `npm run lint` or `pnpm lint`

## AI Stack Configuration
- Ollama endpoint: `OLLAMA_HOST` (default: http://localhost:11434)
- Qdrant endpoint: `QDRANT_URL` (default: http://localhost:6333)
- Start Ollama: `ollama serve`
- Start Qdrant: `docker compose up -d qdrant`
- Default models: llama2, mistral (configure in `ai-config/`)

## Project Structure
- `workflows/` — n8n workflow JSON files
- `custom-nodes/` — Custom n8n nodes for Biji-Biji
- `ai-config/` — Ollama and Qdrant configuration
- `credentials/` — Credential templates (never commit real credentials)

## Conventions
- Version control all workflow JSON files
- Test workflows in dev environment before production
- Use environment variables for all configuration
- Document custom nodes in `custom-nodes/README.md`

## Validation Requirements
Before marking work as complete:
- Run: `pnpm lint`
- Run: `pnpm test`
- If you touched workflows, verify they import correctly in n8n UI
- If you added custom nodes, run: `pnpm build:nodes`

## Deployment (GKE)
- Namespace: `n8n`
- Deploy via: ArgoCD GitOps (infra repo)
- Image registry: Artifact Registry
- Ask before: modifying `.github/workflows/` or Kubernetes manifests

## Boundaries
- ✅ Always: Test workflows in dev first, version control workflow JSON
- ⚠️ Ask First: AI model configuration changes, production workflow modifications, new dependencies
- 🚫 Never: Commit API keys/credentials, delete workflows without backup, skip workflow testing

## Escalation Rules
Ask a human when:
- Workflows fail after 2 debugging attempts
- Changes touch AI model endpoints
- New integrations require external service access

---
Last updated: 2026-03-02
