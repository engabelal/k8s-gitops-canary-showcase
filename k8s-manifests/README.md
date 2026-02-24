# Kubernetes Manifests

This directory contains all Kubernetes resource definitions for the canary deployment.

## Structure

- **base/** - Shared resources (namespace)
- **stable/** - Stable version manifests (pinned to git tag v1.0.0)
- **canary/** - Canary version manifests (pinned to git tag v2.0.1)
- **gateway/** - Gateway API routing configuration (tracked at HEAD)

## Version Management

- `stable/` and `canary/` folders are pinned to specific git tags
- `gateway/` folder is always tracked at HEAD for dynamic traffic control
- Edit HTML content in configmap.yaml files
- Create new git tags for version releases

## Labels

All resources use consistent labels:
- `app: canary-nginx` - Application identifier
- `version: stable|canary` - Version identifier
