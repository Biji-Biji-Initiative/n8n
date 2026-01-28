# CLAUDE.md

n8n workflow automation deployment with AI stack (Ollama + Qdrant).

## Overview

Production n8n deployment configured for Kubernetes with OAuth2-proxy authentication, external secrets, and horizontal pod autoscaling.

## Tech Stack

| Component | Purpose |
|-----------|---------|
| n8n | Workflow automation |
| Ollama | Local AI models |
| Qdrant | Vector database |
| PostgreSQL | n8n database |
| Helm | Deployment |

## Directory Structure

```
n8n/
├── deploy/
│   └── helm/
│       └── n8n/          # Helm chart
├── AGENTS.md
└── README.md
```

## Key Commands

```bash
# Lint Helm chart
helm lint deploy/helm/n8n

# Template with values
helm template n8n deploy/helm/n8n -f <values-file>

# Check pods
kubectl get pods -n n8n

# View logs
kubectl logs -n n8n -l app=n8n -f
```

## Features

- OAuth2-proxy ready (Authentik integration)
- External Secrets support (GCP Secret Manager)
- HPA enabled for autoscaling
- Full AI stack integration
