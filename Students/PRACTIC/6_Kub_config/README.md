# Пара 6 — Kubernetes: ConfigMap, Secret, PersistentVolume
**Время:** 80 минут
**Тема:** Конфигурация и данные отдельно от кода — правильный подход к 12-factor app

---

## Цель занятия

К концу пары студент умеет управлять конфигурацией приложения через ConfigMap/Secret, подключать постоянное хранилище и понимает почему нельзя хранить конфиги внутри образа.

---

## Что должно быть сделано к концу пары ✅

- [ ] Создать ConfigMap и передать в pod как env и как файл
- [ ] Создать Secret и убедиться что он в base64, но не зашифрован в etcd
- [ ] Запустить PostgreSQL с PersistentVolumeClaim
- [ ] Доказать что данные сохранились после удаления пода
- [ ] Использовать `envFrom` для загрузки всего ConfigMap сразу
- [ ] Пояснить: почему Secret небезопасен по умолчанию и что делать

---

## Ход работы

### Блок 1 — ConfigMap (20 мин)

```bash
# Создать ConfigMap из литералов
kubectl create configmap app-config \
  --from-literal=APP_ENV=production \
  --from-literal=LOG_LEVEL=info \
  --from-literal=MAX_CONNECTIONS=100

kubectl get configmap app-config -o yaml
kubectl describe configmap app-config
```

**`pod-with-config.yaml`:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-demo
spec:
  containers:
  - name: app
    image: busybox
    command: ["/bin/sh", "-c", "env | grep -E 'APP|LOG|MAX'; cat /etc/config/nginx.conf; sleep 3600"]

    # Способ 1: все ключи как переменные окружения
    envFrom:
    - configMapRef:
        name: app-config

    # Способ 2: конкретный ключ под своим именем
    env:
    - name: MY_ENV
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_ENV

    # Способ 3: смонтировать как файл
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config

  volumes:
  - name: config-volume
    configMap:
      name: nginx-conf
```

```bash
# Создать ConfigMap из файла
cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    location /health { return 200 "OK"; }
}
EOF

kubectl create configmap nginx-conf --from-file=nginx.conf

kubectl apply -f pod-with-config.yaml
kubectl logs config-demo
# Должны увидеть переменные окружения и содержимое файла
```

---

### Блок 2 — Secrets (15 мин)

```bash
# Создать Secret
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=SuperSecret123

# Посмотреть — данные в base64 (НЕ шифрование!)
kubectl get secret db-credentials -o yaml
echo "U3VwZXJTZWNyZXQxMjM=" | base64 -d  # декодировать

# Правильный способ (с шифрованием) требует EncryptionConfiguration
# Показать что в etcd без шифрования
# kubectl exec -n kube-system etcd-<node> -- \
#   etcdctl get /registry/secrets/default/db-credentials --print-value-only | hexdump -C
```

**`pod-with-secret.yaml`:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-demo
spec:
  containers:
  - name: app
    image: busybox
    command: ["/bin/sh", "-c", "echo User: $DB_USER; echo Pass: $DB_PASS; sleep 3600"]
    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: username
    - name: DB_PASS
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: password
```

```bash
kubectl apply -f pod-with-secret.yaml
kubectl logs secret-demo
```

**Важный разговор:** Secret в K8s по умолчанию — только base64. Настоящее шифрование: `EncryptionConfiguration` + `aescbc/aesgcm` или внешний vault (HashiCorp Vault / AWS Secrets Manager).

---

### Блок 3 — PersistentVolume (30 мин)

**`postgres-pvc.yaml`:**
```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard   # для minikube; для k3s: "local-path"
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
stringData:
  POSTGRES_DB: mydb
  POSTGRES_USER: pguser
  POSTGRES_PASSWORD: pgpassword
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:16-alpine
        envFrom:
        - secretRef:
            name: postgres-secret
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
        resources:
          requests: { memory: "128Mi", cpu: "100m" }
          limits:   { memory: "256Mi", cpu: "200m" }
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: postgres-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-svc
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
```

```bash
kubectl apply -f postgres-pvc.yaml

# Проверить PVC
kubectl get pvc  # должен быть Bound
kubectl get pv   # автоматически создан

# Создать данные
kubectl exec -it $(kubectl get pod -l app=postgres -o name) -- \
  psql -U pguser -d mydb -c \
  "CREATE TABLE sessions (id SERIAL, data TEXT); \
   INSERT INTO sessions (data) VALUES ('важные данные');"

# Удалить ПОД (но не PVC!)
kubectl delete pod $(kubectl get pod -l app=postgres -o name | cut -d/ -f2)

# Deployment автоматически создаст новый под
kubectl get pods -w  # ждём Running

# Данные на месте?
kubectl exec -it $(kubectl get pod -l app=postgres -o name) -- \
  psql -U pguser -d mydb -c "SELECT * FROM sessions;"
# ✓ Данные сохранились!
```

---

## Что сдать преподавателю

1. `kubectl logs config-demo` — все 3 способа передачи ConfigMap работают
2. `kubectl get secret db-credentials -o yaml` — данные в base64
3. `kubectl get pvc postgres-pvc` — статус `Bound`
4. Вывод SELECT после пересоздания пода — данные сохранились

---

## Частые проблемы

| Проблема | Решение |
|----------|---------|
| PVC в статусе `Pending` | `kubectl describe pvc` — нет подходящего PV или StorageClass |
| `storageClassName: standard` не работает | Для k3s использовать `local-path`; `kubectl get sc` покажет доступные |
| Secret не находится в поде | Secret должен быть в том же namespace что и под |
| Pod `CreateContainerConfigError` | ConfigMap или Secret не существует — проверить `kubectl get cm,secret` |
