#!/bin/bash

# Setup script for Canary Deployment Demo
# This script helps you configure the project for your environment

set -e

echo "🚀 Canary Deployment Setup"
echo "=========================="
echo ""

# Get user inputs
read -p "Enter your GitHub username: " GITHUB_USER
read -p "Enter your repository name [k8s-gitops-canary-showcase]: " REPO_NAME
REPO_NAME=${REPO_NAME:-k8s-gitops-canary-showcase}

read -p "Enter your domain name [canary.example.com]: " DOMAIN
DOMAIN=${DOMAIN:-canary.example.com}

echo ""
echo "📝 Configuration:"
echo "   GitHub: https://github.com/$GITHUB_USER/$REPO_NAME.git"
echo "   Domain: $DOMAIN"
echo ""

read -p "Continue with these settings? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled"
    exit 1
fi

# Update ArgoCD files
echo "🔧 Updating ArgoCD configurations..."
find argocd -type f -name "*.yaml" -exec sed -i '' "s|YOUR_USERNAME|$GITHUB_USER|g" {} \;
find argocd -type f -name "*.yaml" -exec sed -i '' "s|k8s-gitops-canary-showcase|$REPO_NAME|g" {} \;

# Update HTTPRoute
echo "🔧 Updating Gateway configuration..."
sed -i '' "s|canary.example.com|$DOMAIN|g" k8s-manifests/gateway/httproute.yaml

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "📚 Next steps:"
echo "   1. Review the changes in argocd/ and k8s-manifests/gateway/"
echo "   2. Commit and push: git add . && git commit -m 'Configure project'"
echo "   3. Create tags: git tag v1.0.0 && git tag v2.0.1"
echo "   4. Push tags: git push && git push --tags"
echo "   5. Apply ArgoCD project: kubectl apply -f argocd/project.yaml"
echo "   6. Deploy apps: kubectl apply -f argocd/"
echo ""
