# Comandes
# Valdiar estat dels nodes
kubectl get nodes
# Llecem en drain del node que volem
kubectl drain worker2.example.com
# Validem que s ha llencat be
kubectl get nodes
