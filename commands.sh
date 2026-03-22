# Create EKS cluster
eksctl create cluster \
  --name monitoring-cluster \
  --region us-east-2 \
  --zones us-east-2a,us-east-2b \
  --nodegroup-name monitoring-nodes \
  --node-type t3.small \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed \
  --timeout 40m

# Deploy webapp
kubectl apply -f ~/Documents/kubernetes-webapp-project/deployment.yaml
kubectl apply -f ~/Documents/kubernetes-webapp-project/service.yaml

# Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring

# Install Prometheus + Grafana
helm install prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin123 \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

# Access Grafana
kubectl port-forward \
  --namespace monitoring \
  svc/prometheus-stack-grafana \
  3000:80
# Open: http://localhost:3000 (admin/admin123)

# Access Prometheus
kubectl port-forward \
  --namespace monitoring \
  svc/prometheus-stack-kube-prometheus-prometheus \
  9090:9090
# Open: http://localhost:9090

# Delete everything
kubectl delete -f ~/Documents/kubernetes-webapp-project/deployment.yaml
kubectl delete -f ~/Documents/kubernetes-webapp-project/service.yaml
helm uninstall prometheus-stack --namespace monitoring
eksctl delete cluster --name monitoring-cluster --region us-east-2
