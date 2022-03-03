# Installa les metriques
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#Comanda imperativa per crear un HPA
kubectl autoscale deployment nfluxdb-deployment --cpu-percent=50 --min=1 --max=5
