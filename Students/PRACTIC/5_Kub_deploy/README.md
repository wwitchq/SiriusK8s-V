# Пара 5 — Kubernetes: Deployment, Service, Ingress
**Время:** 80 минут
**Тема:** Задеплоить приложение так, чтобы оно обновлялось без даунтайма и было доступно извне

---

## Цель занятия

К концу пары студент умеет делать rolling update, откатывать версию и настраивать маршрутизацию трафика через Ingress.

---

## Что должно быть сделано к концу пары ✅

- [ ] Создать Deployment с 3 репликами
- [ ] Сделать rolling update без даунтайма (проверить через curl в цикле)
- [ ] Откатиться на предыдущую версию (`rollout undo`)
- [ ] Создать Service типа ClusterIP и NodePort
- [ ] Настроить Ingress с rules по пути (/api → backend, / → frontend)
- [ ] Объяснить разницу между ClusterIP / NodePort / LoadBalancer

---

## Ход работы

### Блок 1 — Deployment (25 мин)

**`deployment.yaml`:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  labels:
    app: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # на 1 под больше разрешённых во время обновления
      maxUnavailable: 0  # ни один под не падает во время обновления
  template:
    metadata:
      labels:
        app: webapp
        version: v1
    spec:
      containers:
      - name: webapp
        image: nginxdemos/hello:plain-text   # показывает имя хоста
        ports:
        - containerPort: 80
        resources:
          requests: { cpu: "50m", memory: "32Mi" }
          limits:   { cpu: "100m", memory: "64Mi" }
        readinessProbe:
          httpGet: { path: /, port: 80 }
          initialDelaySeconds: 3
          periodSeconds: 3
```

```bash
kubectl apply -f deployment.yaml
kubectl get pods -w  # видим 3 пода поднимаются

# Статус деплоймента
kubectl rollout status deployment/webapp

# Посмотреть ReplicaSet
kubectl get rs  # Deployment управляет через RS
```

---

### Блок 2 — Service + Rolling Update (25 мин)

**`service.yaml`:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-svc
spec:
  selector:
    app: webapp
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

```bash
kubectl apply -f service.yaml

# Проверить что трафик идёт через все поды
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
# или для minikube:
NODE_IP=$(minikube ip)

# Запустить в ДРУГОМ терминале — будет показывать разные хосты (round-robin)
while true; do curl -s $NODE_IP:30080 | grep "Server name"; sleep 0.5; done

# В основном терминале — сделать rolling update
kubectl set image deployment/webapp webapp=nginxdemos/hello:latest

# Смотреть: в другом терминале трафик НЕ прерывался!
kubectl rollout status deployment/webapp

# История деплойментов
kubectl rollout history deployment/webapp

# Откатиться на предыдущую версию
kubectl rollout undo deployment/webapp
kubectl rollout status deployment/webapp
kubectl rollout history deployment/webapp  # revision вернулась
```

---

### Блок 3 — Ingress (20 мин)

> Нужен Ingress Controller. Для minikube: `minikube addons enable ingress`
> Для k3s: Traefik уже встроен.

**Создадим второй сервис для демонстрации маршрутизации:**

```bash
kubectl create deployment api-backend --image=hashicorp/http-echo -- /http-echo -text="Hello from API"
kubectl expose deployment api-backend --port=5678 --name=api-svc
```

**`ingress.yaml`:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: webapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 5678
```

```bash
kubectl apply -f ingress.yaml
kubectl get ingress

# Добавить запись в /etc/hosts (для теста)
echo "$(minikube ip) webapp.local" | sudo tee -a /etc/hosts

curl webapp.local        # → nginx hello
curl webapp.local/api    # → Hello from API

# Посмотреть Ingress Controller поды
kubectl get pods -n ingress-nginx
```

---

### Блок 4 — Сравнение типов Service (10 мин)

```bash
# ClusterIP — только внутри кластера
kubectl expose deployment webapp --name=webapp-clusterip --type=ClusterIP --port=80
kubectl get svc webapp-clusterip  # EXTERNAL-IP: <none>

# Зайти в под и проверить
kubectl run test --rm -it --image=alpine -- sh
  wget -qO- webapp-clusterip  # работает изнутри кластера
  exit

# NodePort — порт на каждой ноде
kubectl get svc webapp-svc  # видим NodePort 30080

# LoadBalancer — только в облаке (AWS/GCP)
# Имитация: kubectl expose ... --type=LoadBalancer
# (в minikube останется Pending без cloud provider)
```

---

## Что сдать преподавателю

1. `kubectl get pods` — 3 пода webapp Running
2. `kubectl rollout history deployment/webapp` — минимум 2 ревизии
3. `curl webapp.local` и `curl webapp.local/api` — разные ответы
4. Объяснить: в чём разница ClusterIP и NodePort (устно)

---

## Частые проблемы

| Проблема | Решение |
|----------|---------|
| Ingress `ADDRESS` пустой | `kubectl get pods -n ingress-nginx` — контроллер должен быть Running |
| `curl webapp.local` не работает | Проверить `/etc/hosts`, добавить `minikube ip webapp.local` |
| Rolling update не видно | Слишком быстро — добавить `sleep 1` между curl-ами или замедлить образ |
| `hashicorp/http-echo` не найден | Заменить на `docker.io/hashicorp/http-echo` или `kennethreitz/httpbin` |
