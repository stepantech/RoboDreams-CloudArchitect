# GitOps s ArgoCD
Nejprve vytvoříme nějaký Kubernetes cluster, třeba AKS v Azure. Poté nainstalujeme ArgoCD.

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

K UI ArgoCD se připojíme přes port forwarding a heslo je uloženo v secret. Pro jednoduchou ukázku použijeme repo https://github.com/argoproj/argocd-example-apps a adresář guestbook.