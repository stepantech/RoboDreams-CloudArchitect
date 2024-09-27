# 13. lekce: CI/CD a DevSecOps

## Pull-based deployment
Klasické řešení je nasazovat tak, že CI/CD pipeline kontaktuje Kubernetes a pošle do něj instrukce (často přes Helm). Co kdyby ale cluster samotný měl schopnost doptávat se, co má dělat a toto místo pravdy byl Git? Naše CI/CD pipeline pak nasazuje tak, že zapíše nejnovější konfigurace a šablony do Gitu a o víc se nestará - Kubernetes clustery si to stáhnou svým tempem až se k tomu dostanou. Zejména pokud jich jsou tisíce a jde třeba o výdajové boxy dopravní společnosti a občasnými výpadky konektivity.

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

K UI ArgoCD se připojíme přes port forwarding a heslo je uloženo v secret. Pro jednoduchou ukázku použijeme repo https://github.com/argoproj/argocd-example-apps a adresář guestbook.
