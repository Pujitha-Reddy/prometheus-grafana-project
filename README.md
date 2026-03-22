# Monitoring with Prometheus + Grafana on Kubernetes

## Overview
Set up a complete monitoring stack on AWS EKS using Prometheus and Grafana.
Monitored a live Kubernetes cluster and web app with real-time dashboards.

## Live Demo
Grafana dashboard was live at: http://localhost:3000 (via port-forward)
Prometheus was live at: http://localhost:9090 (via port-forward)

## Architecture
```
Kubernetes Cluster (EKS)
    |__ default namespace
    |   |__ webapp-deployment (3 pods)
    |__ monitoring namespace
        |__ Prometheus      — collects metrics every 15s
        |__ Grafana         — visualizes metrics
        |__ AlertManager    — handles alerts
        |__ Node Exporter   — collects node metrics
        |__ kube-state-metrics — collects K8s metrics
```

## Tech Stack
- **Metrics Collection:** Prometheus
- **Visualization:** Grafana
- **Package Manager:** Helm v4.1.3
- **Cluster:** AWS EKS (us-east-2)
- **Helm Chart:** kube-prometheus-stack

## Dashboards Used
- Kubernetes / Compute Resources / Cluster
- Kubernetes / Compute Resources / Pod
- Node Exporter / Nodes

## Metrics Monitored
- CPU utilisation per cluster, node, and pod
- Memory utilisation per cluster, node, and pod
- CPU throttling per pod
- Network traffic
- Pod count per namespace

## Key Commands
```bash
# Install monitoring stack
helm install prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin123

# Access Grafana
kubectl port-forward --namespace monitoring \
  svc/prometheus-stack-grafana 3000:80

# Check all monitoring pods
kubectl get pods --namespace monitoring

# Delete everything
helm uninstall prometheus-stack --namespace monitoring
eksctl delete cluster --name monitoring-cluster --region us-east-2
```

## What I Learned
- How Prometheus scrapes and stores metrics
- How Grafana connects to Prometheus as a data source
- How to use Helm to install complex K8s applications
- How to use port-forwarding to access K8s services locally
- Reading PromQL queries for CPU and memory metrics
- Pre-built Kubernetes dashboards in kube-prometheus-stack
- How to monitor individual pods in real time
