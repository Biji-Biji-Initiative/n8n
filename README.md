# n8n Deployment

This repository contains the n8n deployment contract and an isolated Coolify
runtime definition. The application is an experimental automation service; its
Ollama and Qdrant stack is not required for workflow or credential preservation
and is intentionally absent from the Coolify topology.

Kubernetes is the current production serving and rollback topology until a
verified Coolify target, canonical route proof, and separately reviewed BBI
GitOps retirement carrier are complete. See
[`docs/runbooks/production-coolify-migration.md`](docs/runbooks/production-coolify-migration.md).

## Helm Chart

Chart location: `deploy/helm/n8n/`

## Features

- PostgreSQL-backed n8n runtime with a durable n8n home volume
- Environment-scoped Coolify Compose contract
- External Secrets support for the Kubernetes rollback topology
- Explicit recovery and GitOps-only retirement gates
