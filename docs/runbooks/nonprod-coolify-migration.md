---
title: "n8n Non-production Coolify Migration Runbook"
type: "runbook"
owner: "platform"
last_updated: "2026-08-08"
scope: "dev and staging only"
---

# n8n Non-production Coolify Migration

This runbook moves `n8n-dev` and `n8n-staging` to separate Coolify Compose
applications. It never authorizes production work, canonical-route changes,
or deletion of Kubernetes state.

## Resource envelope

The default target cap per environment is 1.25 GiB and 1.00 CPU: PostgreSQL
uses 512 MiB / 0.50 CPU and n8n uses 768 MiB / 0.50 CPU. The two shadows
therefore cap at 2.5 GiB and 2.0 CPU combined. These values are conservative
multiples of the 2026-08-08 live/VPA observations; they are not a claim that
every workflow is safe at that size. Raise an explicit
`N8N_*_MEMORY_LIMIT` or `N8N_*_CPU_LIMIT` only with workload evidence, then
record that evidence in the migration packet.

## Target contract

`deploy/coolify/compose.yaml` is the target runtime contract. Each environment
gets an isolated application and named volumes for PostgreSQL and
`/home/node/.n8n`. Ollama and Qdrant are intentionally absent: the live vector
stores contain only their initialization files, and neither is required for
n8n workflow or credential preservation.

Values are mapped from the native environment secret authority into the matching
`/deploy/n8n` authority. The target must preserve the source `N8N_ENCRYPTION_KEY`;
an otherwise successful database restore is unusable if encrypted credentials
cannot be read.

## Required gates

1. Validate the Compose contract without real values:

   ```sh
   docker compose --env-file deploy/coolify/compose.example.env \
     -f deploy/coolify/compose.yaml config --quiet
   ```

2. Take and verify a current source backup before any quiesce or data export.
   Preserve a PostgreSQL custom dump and a tar archive of `/home/node/.n8n`
   for each environment.
3. Restore only into a new, isolated Coolify application. Verify PostgreSQL
   connectivity, encryption-key readability, workflow/credential metadata read,
   and the n8n `/healthz` endpoint.
4. Route only DNS-only `n8n-dev.deploy.mereka.io` and
   `n8n-staging.deploy.mereka.io` shadows after their certificates and n8n
   authenticated admin login are proven. Do not change canonical n8n hosts in
   this phase.
5. Prove rollback by stopping the shadow route while Kubernetes remains healthy.
   Retain the Kubernetes deployments, PVCs, and canonical routes through the
   seven-day stable nonprod window.

## Recovery

If target validation fails, stop the affected Coolify application and retain
its volumes for diagnosis. Continue serving from Kubernetes; do not delete a
target or source volume as a rollback mechanism. A later GitOps retirement is a
separate reviewed change with final backups and a documented Longhorn release.
