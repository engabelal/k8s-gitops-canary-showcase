# 📖 Detailed Setup Guide

This guide provides step-by-step instructions for deploying the Canary Deployment Demo.

---

## 📋 Prerequisites

### Required Tools

- **Kubernetes Cluster** (v1.25 or higher)
  - Minikube, Kind, K3s, or cloud provider
- **kubectl** - Kubernetes CLI
- **ArgoCD** - GitOps tool
- **Gateway API Controller** - Envoy Gateway, Istio, or similar
- **Git** - Version control

### Verify Prerequisites

```bash
# Check Kubernetes
kubectl version --short

# Check ArgoCD
kubectl get pods -n argocd

# Check Gateway API CRDs
kubectl get crd gateways.gateway.networking.k8s.io
```

---

## 🔧 Installation Steps

### Step 1: Install ArgoCD (if not installed)

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Step 2: Install Gateway API (Envoy Gateway Example)

```bash
# Install Gateway API CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml

# Install Envoy Gateway
helm install eg oci://docker.io/envoyproxy/gateway-helm --version v1.0.0 -n envoy-gateway-system --create-namespace

# Create Gateway
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: main-envoy-gateway
  namespace: envoy-gateway-system
spec:
  gatewayClassName: eg
  listeners:
    - name: http
      protocol: HTTP
      port: 80
    - name: https
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs:
          - name: your-tls-secret
EOF
```

### Step 3: Fork and Clone Repository

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/k8s-gitops-canary-showcase.git
cd k8s-gitops-canary-showcase
```

### Step 4: Configure Project

```bash
# Run setup script
./scripts/setup.sh

# Or manually edit files:
# - argocd/*.yaml (replace YOUR_USERNAME)
# - k8s-manifests/gateway/httproute.yaml (replace domain)
```

### Step 5: Create Git Tags

```bash
# Commit changes
git add .
git commit -m "feat: configure for my environment"

# Create version tags
git tag v1.0.0
git tag v2.0.1

# Push to remote
git push origin main
git push origin --tags
```

### Step 6: Deploy ArgoCD Project

```bash
# Create ArgoCD project
kubectl apply -f argocd/project.yaml

# Verify project
kubectl get appproject -n argocd canary-project
```

### Step 7: Deploy Applications

```bash
# Deploy ApplicationSet and Gateway app
kubectl apply -f argocd/applicationset.yaml
kubectl apply -f argocd/gateway-application.yaml

# Wait for sync
kubectl wait --for=condition=Synced application -l app=canary-nginx -n argocd --timeout=300s
```

### Step 8: Verify Deployment

```bash
# Check applications
kubectl get applications -n argocd

# Check pods
kubectl get pods -n canary-demo

# Check services
kubectl get svc -n canary-demo

# Check HTTPRoute
kubectl get httproute -n canary-demo
```

---

## 🌐 DNS Configuration

### Option 1: Local Testing (hosts file)

```bash
# Get Gateway IP
GATEWAY_IP=$(kubectl get svc -n envoy-gateway-system -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')

# Add to /etc/hosts
echo "$GATEWAY_IP canary.example.com" | sudo tee -a /etc/hosts
```

### Option 2: Cloud DNS

Configure your DNS provider to point your domain to the Gateway LoadBalancer IP.

```bash
# Get LoadBalancer IP
kubectl get svc -n envoy-gateway-system
```

---

## 🧪 Testing

### Basic Connectivity

```bash
# Test stable version
curl -H "Host: canary.example.com" http://<GATEWAY_IP>/

# Test with domain (if DNS configured)
curl https://canary.example.com/
```

### Traffic Distribution

```bash
# Run test script
./scripts/test-traffic.sh canary.example.com 50

# Manual test
for i in {1..20}; do
  curl -sk https://canary.example.com/ | grep -o "v[0-9]\.[0-9]\.[0-9]"
done | sort | uniq -c
```

---

## 🔐 Security Considerations

### TLS/SSL Setup

```bash
# Create TLS secret
kubectl create secret tls canary-tls \
  --cert=path/to/cert.crt \
  --key=path/to/cert.key \
  -n envoy-gateway-system

# Update Gateway to reference secret
# (Already configured in Gateway manifest)
```

### ArgoCD Access

```bash
# Port forward ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access at: https://localhost:8080
# Username: admin
# Password: (from Step 1)
```

---

## 📊 Monitoring

### ArgoCD Dashboard

Access ArgoCD UI to monitor application sync status, health, and history.

### Kubernetes Dashboard

```bash
# Install dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Create admin user
kubectl create serviceaccount dashboard-admin -n kubernetes-dashboard
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin

# Get token
kubectl -n kubernetes-dashboard create token dashboard-admin

# Port forward
kubectl port-forward -n kubernetes-dashboard svc/kubernetes-dashboard 8443:443
```

---

## 🔄 Update Workflow

### Update Stable Version

1. Edit `k8s-manifests/stable/configmap.yaml`
2. Commit changes
3. Create new tag: `git tag v1.1.0`
4. Push: `git push --tags`
5. Update `argocd/applicationset.yaml` stable revision
6. Commit and push

### Update Canary Version

1. Edit `k8s-manifests/canary/configmap.yaml`
2. Commit changes
3. Create new tag: `git tag v2.1.0`
4. Push: `git push --tags`
5. Update `argocd/applicationset.yaml` canary revision
6. Commit and push

### Adjust Traffic

1. Edit `k8s-manifests/gateway/httproute.yaml`
2. Change weight values
3. Commit and push (no tag needed - tracked at HEAD)

---

## 🐛 Common Issues

### Issue: ArgoCD Can't Access Repository

**Solution:**
```bash
# Add repository to ArgoCD
argocd repo add https://github.com/YOUR_USERNAME/k8s-gitops-canary-showcase.git

# Or via UI: Settings > Repositories > Connect Repo
```

### Issue: Pods in CrashLoopBackOff

**Solution:**
```bash
# Check logs
kubectl logs -n canary-demo -l app=canary-nginx --tail=50

# Check events
kubectl get events -n canary-demo --sort-by='.lastTimestamp'
```

### Issue: Traffic Not Splitting

**Solution:**
```bash
# Verify HTTPRoute
kubectl describe httproute canary-route -n canary-demo

# Check service endpoints
kubectl get endpoints -n canary-demo

# Verify Gateway
kubectl describe gateway main-envoy-gateway -n envoy-gateway-system
```

---

## 🧹 Cleanup

```bash
# Delete applications
kubectl delete -f argocd/

# Delete project
kubectl delete -f argocd/project.yaml

# Delete namespace
kubectl delete namespace canary-demo

# Delete tags (optional)
git tag -d v1.0.0 v2.0.1
git push origin --delete v1.0.0 v2.0.1
```

---

## 📚 Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [Envoy Gateway Documentation](https://gateway.envoyproxy.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

---

**Need help?** Open an issue in the repository!
