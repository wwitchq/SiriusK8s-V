**Отчет по лабораторной работе №7: Безопасность Kubernetes: RBAC, NetworkPolicy, Falco**
1. Чему научился 
В ходе выполнения лабораторной работы освоены базовые механизмы защиты кластера Kubernetes.

RBAC: создан ServiceAccount app-reader в namespace rbac-demo, Role pod-reader с правами get, list, watch на поды и их логи, RoleBinding связывает их. Проверка прав через kubectl auth can-i показала, что ServiceAccount может читать поды, но не может их удалять, а также не имеет доступа к другим namespace.

NetworkPolicy: в namespace netpol-demo запущены три пода (frontend, backend, database) с соответствующими метками. До применения политик все поды могли общаться друг с другом. После применения политики default-deny-ingress весь входящий трафик запрещён. Затем разрешён трафик: frontend принимает отовсюду, backend – только от frontend, database – только от backend. Проверка через wget подтвердила, что frontend не может обратиться к database (таймаут), а backend к database – успешно.

TLS сертификаты: создан собственный корневой CA, сгенерирован ключ и CSR для webapp.local, сертификат подписан CA. TLS‑Secret импортирован в Kubernetes, Ingress настроен на использование этого секрета. После добавления записи в /etc/hosts команда curl --cacert ca.crt https://webapp.local успешно получила ответ от nginx.


2. Возникшие проблемы и способы их решения

В ходе выполнения работы проблем не возникло. Все политики применились, проверки дали ожидаемые результаты, TLS‑соединение установлено, Falco зафиксировал подозрительные действия.

<img width="1289" height="271" alt="image" src="https://github.com/user-attachments/assets/af840a12-4449-4cd4-be87-02b28a2d71d4" />
<img width="1291" height="64" alt="image" src="https://github.com/user-attachments/assets/1a112b26-6b35-4002-97cd-9562944be28b" />
<img width="1279" height="300" alt="image" src="https://github.com/user-attachments/assets/8ecb519c-a2c4-4ae2-9a91-6ef3699c9d1b" />
<img width="1284" height="107" alt="image" src="https://github.com/user-attachments/assets/71665672-7988-472e-a56e-05531601565b" />

