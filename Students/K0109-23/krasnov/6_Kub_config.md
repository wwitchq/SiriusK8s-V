6_laba
Структура отчета: 
# 1 выводы в терминале
# 2. вопросы

# 1 выводы в терминале
1. `kubectl logs config-demo` — все 3 способа передачи ConfigMap работают
main@KRASNOV:/mnt/c/Users/main$ kubectl logs config-demo
LOG_LEVEL=info
WEBAPP_CLUSTERIP_SERVICE_HOST=10.103.100.117
WEBAPP_SVC_SERVICE_HOST=10.110.91.81
WEBAPP_CLUSTERIP_SERVICE_PORT=80
WEBAPP_CLUSTERIP_PORT=tcp://10.103.100.117:80
MAX_CONNECTIONS=100
WEBAPP_SVC_PORT=tcp://10.110.91.81:80
WEBAPP_SVC_SERVICE_PORT=80
WEBAPP_CLUSTERIP_PORT_80_TCP_ADDR=10.103.100.117
WEBAPP_CLUSTERIP_PORT_80_TCP_PORT=80
WEBAPP_CLUSTERIP_PORT_80_TCP_PROTO=tcp
WEBAPP_SVC_PORT_80_TCP_ADDR=10.110.91.81
WEBAPP_SVC_PORT_80_TCP_PORT=80
WEBAPP_SVC_PORT_80_TCP_PROTO=tcp
WEBAPP_CLUSTERIP_PORT_80_TCP=tcp://10.103.100.117:80
APP_ENV=production
WEBAPP_SVC_PORT_80_TCP=tcp://10.110.91.81:80
server {
listen 80;
server_name localhost;
location /health { return 200 "OK"; }
}

2. `kubectl get secret db-credentials -o yaml` — данные в base64
main@KRASNOV:/mnt/c/Users/main$ kubectl get secret db-credentials -o yaml
apiVersion: v1
kind: Secret
metadata:
  creationTimestamp: "2026-03-29T12:10:53Z"
  name: db-credentials
  namespace: default
  resourceVersion: "4645"
  uid: e82e72b9-5f0a-45a4-96a6-bd8da8e088ab
type: Opaque

3. `kubectl get pvc postgres-pvc` — статус `Bound`
main@KRASNOV:/mnt/c/Users/main$ kubectl get pvc postgres-pvc
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-pvc   Bound    pvc-a4b689a7-62f4-41c9-a017-885f5b8e5199   1Gi        RWO            standard       <unset>                 88s
main@KRASNOV:/mnt/c/Users/main$

4. Вывод SELECT после пересоздания пода — данные сохранились
main@KRASNOV:/mnt/c/Users/main$ kubectl exec -it $(kubectl get pod -l app=postgres -o name) -- \ \
> psql -U pguser -d mydb -c "SELECT * FROM sessions;"
 id |     data
----+---------------
  1 | важные данные
(1 row)


# Вопросы:
1. Что такое ConfigMap и зачем?
→ Хранилище конфигурации приложения (переменные окружения, файлы конфигов). Отделяет конфиг от кода — можно менять настройки без пересборки образа.

2. Сколько способов передачи ConfigMap в под?
→ 3 способа:
envFrom — все ключи как переменные окружения
env + configMapKeyRef — конкретный ключ под своим именем
volumeMounts — смонтировать как файл в файловую систему

3. Что такое Secret и чем отличается от ConfigMap?
→ То же самое, но для чувствительных данных (пароли, ключи). Хранится в base64 (не шифрование!), а ConfigMap — в открытом виде.

4. Почему Secret небезопасен по умолчанию?
→ Base64 — это кодирование, а не шифрование. Любой с доступом к etcd может прочитать. Решение: включить EncryptionConfiguration или использовать внешний vault (HashiCorp Vault).

5. Что такое PersistentVolumeClaim (PVC)?
→ Запрос на хранилище от пода. Kubernetes автоматически создаёт PersistentVolume (PV) нужного размера и подключает его к поду.

6. Зачем PVC для базы данных?
→ Чтобы данные сохранились при удалении/пересоздании пода. Без PVC база удаляется вместе с подом.

