---
title: "n8n Production Coolify Migration Runbook"
type: "runbook"
owner: "platform"
last_updated: "2026-08-13"
scope: "production Kubernetes exit"
---

# n8n Production Coolify Migration

This runbook completes the user-directed removal of n8n from BBI Kubernetes.
It is a recovery-and-cutover process, not a direct PVC, PV, namespace, or
Longhorn cleanup. Kubernetes remains the serving and rollback topology until
all gates are recorded.

## Source and target contract

- Source: Kubernetes namespace `n8n`, canonical route `n8n.mereka.io`.
- Target: the isolated Coolify production-shadow application on
  `deploy-apps-01`, initially on a non-canonical route.
- Initial target image: `n8nio/n8n:1.16.0@sha256:902574afc331f89ac1a66ae190c75caa6a3f3211b2b359af4376ef2de8fd3725`.
  This is the observed 2026-08-13 source version and image identity. Do not
  combine the exit with the source's `2.6.3` default or any other n8n upgrade.
- Persistent state: PostgreSQL plus `/home/node/.n8n`; retain the same
  `N8N_ENCRYPTION_KEY` during restore or encrypted credentials are unreadable.
- Ollama and Qdrant are deliberately excluded. They are not required for the
  n8n server, workflow metadata, or credential recovery.

The 2026-08-13 source observation found n8n `1.16.0`, only 33,362 bytes in the
n8n home directory, and no workflows, credentials, or executions. That makes
this a low-data migration, not permission to skip recovery proof.

## Required Coolify values

Configure values from the environment's native secret authority without
committing or printing them:

- `N8N_ENVIRONMENT=prod`
- `N8N_IMAGE` set to the exact source image identity above
- `N8N_DATABASE`, `N8N_DB_PASSWORD`, and the unchanged `N8N_ENCRYPTION_KEY`
- shadow `N8N_HOST` and `N8N_PUBLIC_URL`, then canonical values only at route
  cutover
- `GENERIC_TIMEZONE=Asia/Kuala_Lumpur`

Keep the production shadow’s automatic deployment disabled until the source
carrier is on `main` and the restore inputs have been verified. Do not use a
Kubernetes service hostname, a host-local image build, or a mutable image tag.

## Cutover gates

1. Validate the compose projection with the validation-only environment:

   ```sh
   docker compose --env-file deploy/coolify/compose.example.env \
     -f deploy/coolify/compose.yaml config --quiet
   ```

2. Select a fresh successful `n8n-pg-backup` logical backup and prove the
   backup object is readable. Independently archive and verify the small n8n
   home directory. A Job completion or a partial Velero backup alone is not a
   recovery receipt.
3. Restore both data planes into new Coolify volumes. Verify database schema,
   workflow, credential, and execution counts; verify that the preserved
   encryption key opens the restored instance; and verify `/healthz` plus an
   authenticated admin session on the shadow route.
4. Capture the shadow route, canonical Kubernetes route, and rollback route
   immediately before DNS changes. Move canonical routing only after all three
   are recorded and TLS is valid.
5. After stable canonical proof, land a separate reviewed BBI GitOps carrier
   that removes the n8n application and backup declarations. Do not delete
   Longhorn storage imperatively. Retain source PV identities for the approved
   recovery window, then use a later source-controlled reclamation decision.

## Rollback and residual risk

If restore, authentication, webhook behavior, or route proof fails, return the
canonical route to Kubernetes and keep both source and target volumes. Do not
solve a failed migration by deleting a target, source PVC, PV, Longhorn volume,
replica, snapshot, or namespace.

The initial Coolify target deliberately preserves the current n8n version. A
later n8n upgrade needs its own tested database migration, compatibility review,
and rollback plan after the Kubernetes exit is proven.
