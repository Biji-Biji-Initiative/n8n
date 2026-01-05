# Agent Guide (n8n deployment)

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

---

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

