# AGENTS.md

## Repository Overview
n8n workflow automation platform with Ollama + Qdrant AI stack for Biji-Biji Initiative. Contains Helm chart for Kubernetes deployment. Primary runtime is the n8n server with custom nodes and AI integrations.

## Core Commands
- Install: `npm install` or `pnpm install`
- Dev: `npm run dev` or `pnpm dev`
- Build: `npm run build` or `pnpm build`
- Test: `npm test` or `pnpm test`
- Lint: `npm run lint` or `pnpm lint`
- Helm lint: `helm lint deploy/helm/n8n`

## AI Stack Configuration
- Ollama endpoint: `OLLAMA_HOST` (default: http://localhost:11434)
- Qdrant endpoint: `QDRANT_URL` (default: http://localhost:6333)
- Start Ollama: `ollama serve`
- Start Qdrant: `docker compose up -d qdrant`
- Default models: llama2, mistral (configure in `ai-config/`)

## Project Structure
- `deploy/helm/n8n/` — Helm chart for Kubernetes deployment
- `workflows/` — n8n workflow JSON files
- `custom-nodes/` — Custom n8n nodes for Biji-Biji
- `ai-config/` — Ollama and Qdrant configuration
- `credentials/` — Credential templates (never commit real credentials)

## Deployment Contract (Important)
- Keep the chart **environment-agnostic**
- Environment-specific values live in `BBI-K8/apps/n8n/overlays/<env>/values.yaml`
- Do not commit secrets (OIDC client secrets, encryption keys, DB passwords)

## CRITICAL - Data Protection Rules

> **Master policy:** https://github.com/Biji-Biji-Initiative/BBI-K8/blob/main/docs/DATA_PROTECTION.md

### Forbidden Actions (Require Explicit User Confirmation)
1. Delete PVCs, PVs, or namespaces containing databases
2. Delete or scale StatefulSets/Deployments with databases to 0
3. Modify volumeClaimTemplates in StatefulSets
4. Run database DROP/TRUNCATE/DELETE commands
5. Delete Helm releases containing databases
6. Modify storage configurations that could cause data loss

### Before Any Risky Operation
Always create a Velero backup first:
```bash
velero backup create pre-op-<namespace>-$(date +%Y%m%d-%H%M) --include-namespaces <namespace> --wait
```
Then ask for explicit user confirmation before proceeding.

**Backup Docs:** https://github.com/Biji-Biji-Initiative/BBI-K8/blob/main/docs/BACKUP_AND_RECOVERY.md

## Conventions
- Version control all workflow JSON files
- Test workflows in dev environment before production
- Use environment variables for all configuration
- Document custom nodes in `custom-nodes/README.md`

## Validation Requirements
Before marking work as complete:
- Run: `pnpm lint`
- Run: `pnpm test`
- Run: `helm lint deploy/helm/n8n`
- If you touched workflows, verify they import correctly in n8n UI
- If you added custom nodes, run: `pnpm build:nodes`

## Deployment (GKE)
- Namespace: `n8n`
- Deploy via: ArgoCD GitOps (BBI-K8 repo)
- Image registry: Artifact Registry
- Ask before: modifying `.github/workflows/` or Kubernetes manifests

## Boundaries
- ✅ Always: Test workflows in dev first, version control workflow JSON, create Velero backups before risky ops
- ⚠️ Ask First: AI model configuration changes, production workflow modifications, new dependencies, any data-affecting operations
- 🚫 Never: Commit API keys/credentials, delete workflows without backup, skip workflow testing, delete PVCs/databases without explicit confirmation

## Escalation Rules
Ask a human when:
- Workflows fail after 2 debugging attempts
- Changes touch AI model endpoints
- New integrations require external service access
- Any operation affecting databases or persistent storage

---
Last updated: 2026-03-02
