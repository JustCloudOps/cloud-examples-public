## Argo CD

Manual install from overlay:
`kustomize build . --enable-helm --load-restrictor LoadRestrictionsNone | k apply -f -`

Access via port forward:
`kubectl port-forward deployment/release-name-argocd-server -n argocd  8888:8080`

Get initial admin pass:
`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`