7_laba
Структура отчета: 
# 1 выводы в терминале
# 2. трудности

# 1 выводы в терминале

1. `kubectl auth can-i list pods -n rbac-demo --as=system:serviceaccount:rbac-demo:app-reader`

main@KRASNOV:/mnt/c/Users/main$ kubectl auth can-i list pods -n rbac-demo --as=system:serviceaccount:rbac-demo:app-reader
yes
2. `kubectl auth can-i delete pods -n rbac-demo --as=system:serviceaccount:rbac-demo:app-reader`
main@KRASNOV:/mnt/c/Users/main$ kubectl auth can-i delete pods -n rbac-demo --as=system:serviceaccount:rbac-demo:app-reader
no

3. `kubectl exec frontend -- wget database-svc` → **timeout** (NetworkPolicy работает)
main@KRASNOV:/mnt/c/Users/main$ kubectl exec frontend -n netpol-demo -- wget -qO- --timeout=3 database-svc
wget: download timed out

4. `kubectl exec backend -- wget database-svc`
main@KRASNOV:/mnt/c/Users/main$ kubectl exec backend -n netpol-demo -- wget -qO- database-svc
200 OK  

5. `openssl verify -CAfile ca.crt webapp.crt` 
main@KRASNOV:/mnt/c/Users/main$ openssl verify -CAfile ca.crt webapp.crt
webapp.crt: OK

Трудности:
- kubectl пишет "connection refused" на порты 52805/61547 → Minikube перезапустился и сменил порт API-сервера → помогло minikube update-context
- curl: Could not resolve host: webapp.local → система не знала, куда стучаться → добавил 192.168.49.2 webapp.local в /etc/hosts
- curl висит и не отвечает → Ingress-контроллер не принимал трафик → проверил kubectl get pods -n ingress-nginx, перезапустили port-forward

