# Agent Guide (n8n deployment)

This repo contains the **Helm chart** for deploying n8n (plus AI stack components) used by `BBI-K8`.

## Key Paths

- Helm chart: `deploy/helm/n8n/`

## Deployment Contract (Important)

- Keep the chart **environment-agnostic**.
- Environment-specific values live in `BBI-K8/apps/n8n/overlays/<env>/values.yaml`.
- Do not commit secrets (OIDC client secrets, encryption keys, DB passwords).

## Common Commands

```bash
helm lint deploy/helm/n8n
```

