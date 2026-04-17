4_laba
Структура отчета: 
# 1 выводы в терминале
# 2. вопросы

# 1 выводы в терминале
1. `kubectl get nodes` — все Ready
main@KRASNOV:/mnt/c/Users/main$ kubectl get nodes
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   2d    v1.35.1
main@KRASNOV:/mnt/c/Users/main$

2. `kubectl get pods -n kube-system` — все системные поды Running 
main@KRASNOV:/mnt/c/Users/main$ kubectl get pods -n kube-system
NAME                               READY   STATUS    RESTARTS      AGE
coredns-7d764666f9-bf2qk           1/1     Running   1 (11m ago)   2d
coredns-7d764666f9-mttml           1/1     Running   1 (11m ago)   2d
etcd-minikube                      1/1     Running   1 (11m ago)   2d
kube-apiserver-minikube            1/1     Running   1 (11m ago)   2d
kube-controller-manager-minikube   1/1     Running   1 (46h ago)   2d
kube-proxy-gbljc                   1/1     Running   1 (46h ago)   2d
kube-scheduler-minikube            1/1     Running   1 (46h ago)   2d
storage-provisioner                1/1     Running   2 (11m ago)   11m
main@KRASNOV:/mnt/c/Users/main$


3. `kubectl get pods` — два пода (nginx и my-webserver) Running
main@KRASNOV:/mnt/c/Users/main$ kubectl get pods
NAME           READY   STATUS    RESTARTS        AGE
my-webserver   2/2     Running   1 (2m22s ago)   8m
nginx          1/1     Running   0               10m
main@KRASNOV:/mnt/c/Users/main$

4. `kubectl get pod my-webserver` — показать RESTARTS > 0 после kill
 main@KRASNOV:/mnt/c/Users/main$ kubectl get pod my-webserver
NAME           READY   STATUS    RESTARTS        AGE
my-webserver   2/2     Running   1 (2m46s ago)   8m24s
main@KRASNOV:/mnt/c/Users/main$


# Вопросы:
1. Какие поды в kube-system всегда должны быть Running?
coredns (DNS), etcd (база данных), kube-apiserver (мозг кластера), kube-controller-manager, kube-scheduler, kube-proxy (сеть). Без них кластер не работает.

2. Почему Pod не удалился, а перезапустился? Кто отвечает?
Потому что kubelet (агент на ноде) следит за состоянием контейнеров. Если контейнер упал — kubelet его перезапускает, чтобы выполнить желаемое состояние, описанное в YAML.

3. Отличие Pod vs Container (1–2 предложения)
Container — это один запущенный процесс с изоляцией. Pod — минимальная единица в Kubernetes, которая может содержать один или несколько контейнеров, разделяющих сеть и хранилище.
