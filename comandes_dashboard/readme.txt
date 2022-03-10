export NODE_PORT=$(kubectl get -n default -o jsonpath="{.spec.ports[0].nodePort}" services dashboard-kubernetes-dashboard)
export NODE_IP=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[0].address}")
echo https://$NODE_IP:$NODE_PORT/
kubectl -n default get secret $(kubectl -n default get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token }}" | base64 -d
