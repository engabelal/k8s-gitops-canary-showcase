# ArgoCD Configurations

This directory contains ArgoCD application definitions for GitOps deployment.

## Files

### project.yaml
Defines the ArgoCD AppProject with:
- Allowed source repositories
- Destination namespaces
- Resource permissions

### applicationset.yaml
ApplicationSet that generates two applications:
- `nginx-stable` - Pinned to tag v1.0.0
- `nginx-canary` - Pinned to tag v2.0.1

Uses list generator to create multiple apps from a single definition.

### gateway-application.yaml
Standalone application for Gateway API routing:
- Tracked at HEAD (no tag)
- Allows dynamic traffic weight changes
- Syncs immediately on git push

## Configuration

Before deploying, update:
1. `repoURL` - Your GitHub repository URL
2. Repository name if different from `k8s-gitops-canary-showcase`

Use the setup script: `../scripts/setup.sh`

## Deployment

```bash
# Create project first
kubectl apply -f project.yaml

# Deploy applications
kubectl apply -f applicationset.yaml
kubectl apply -f gateway-application.yaml
```
