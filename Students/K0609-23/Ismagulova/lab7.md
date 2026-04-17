# LAB7

## block1
---

Создается пространство имен командой:
```
kubectl create namespace rbac-demo
```

Далее следует создать rbac.yaml

<img width="837" height="695" alt="изображение" src="https://github.com/user-attachments/assets/5531a2e1-3e0a-4d3c-9645-a6564870f2df" />

Применяются настройки RBAC, после чего выполняется проверка прав (то что разрешено, запрещено и находится в области видимости)

<img width="842" height="621" alt="изображение" src="https://github.com/user-attachments/assets/d90f32d4-a52f-4e1e-b23c-36b1ffb9f13f" />

Запускается под от имени ServiceAccount.
Применяем конфигаурции с помощью команды 
```
kubectl apply -f pod-rbac-demo.yaml
```

<img width="763" height="355" alt="изображение" src="https://github.com/user-attachments/assets/f9ecca9d-6c81-4016-91c2-7592a5a4e026" />

Требуется сделать вход в под и попробовать API. Внутри выполняем следующее: просмотр списка подов, попытка удаления пода и попытка заглянуть в другой Namespace

<img width="1226" height="289" alt="изображение" src="https://github.com/user-attachments/assets/23d40086-9e5b-4521-aac2-7951c383ec59" />



## block2
---

Сначала команда создается изолированное пространство имен, чтобы тестовые ресурсы не смешивались с остальными. Далее для каждого компонента (фронтенд, бэкенд и база данных) выполняется запуск пода на базе легкого образа nginx:alpine. Следом создается внутренний сервис (ClusterIP), сопоставляя имя (например, database-svc) с портом 80; это позволяет подам общаться друг с другом по стабильным DNS-именам вместо изменчивых IP-адресов.

<img width="986" height="666" alt="изображение" src="https://github.com/user-attachments/assets/d0b193fd-2cae-491e-b8dc-4dcd8298b43d" />

Далее заходим внутрь пода с именем frontend в указанном пространстве имен и выполняем там сетевой запрос с помощью утилиты wget. 

<img width="1001" height="706" alt="изображение" src="https://github.com/user-attachments/assets/216490dd-de85-4659-8d1a-a3ef4aa289ec" />

Создается networkpolicies.yaml

<img width="805" height="686" alt="изображение" src="https://github.com/user-attachments/assets/20972ea3-1f86-4a77-a28c-7f481c2b1e94" />

Применяются настройки.

<img width="1252" height="333" alt="изображение" src="https://github.com/user-attachments/assets/87d8c776-580d-4276-9452-becc92abeba4" />

Далее выполняется проверка изоляции.

<img width="947" height="679" alt="изображение" src="https://github.com/user-attachments/assets/d5b92546-876c-4f80-8a2e-a5766055f2d7" />
<img width="952" height="168" alt="изображение" src="https://github.com/user-attachments/assets/91553dcd-88e9-4a07-aacc-01a2324d828a" />
<img width="960" height="688" alt="изображение" src="https://github.com/user-attachments/assets/686edb2a-ff1e-47b7-a832-6b8b518ea36d" />

Команда выводит список всех правил сетевой безопасности (NetworkPolicies), которые созданы в конкретном пространстве имен.
```
kubectl get networkpolicies -n netpol-demo
``` 

<img width="603" height="189" alt="изображение" src="https://github.com/user-attachments/assets/02edd495-29f0-4b27-b43e-3f7e1893e007" />

## block3
---

Далее подготавливается папка, генерируется приватный ключ, создается корневой сертификат и проверяется результат выполненной работы.

<img width="1048" height="473" alt="изображение" src="https://github.com/user-attachments/assets/71a225e6-90a3-4074-ad87-6991a8090325" />

Создается файл расширений, генерируется приватный ключ сервера, а также создается запрос на подпись (CSR), после чего проверяем.

<img width="872" height="705" alt="изображение" src="https://github.com/user-attachments/assets/af2a7731-e720-461c-941a-a877c9497e78" />

Выполняется подпись сертификата, проверка доп имен и финальная проверка доверия (Вывод "ОК" означает, что выполнено успешно).

<img width="961" height="590" alt="изображение" src="https://github.com/user-attachments/assets/342ff0b1-350a-4456-a2ed-855663482d68" />

Здесь создается TLS-секрет, после чего следует выполнить краткую и детальную проверки.

<img width="961" height="590" alt="изображение" src="https://github.com/user-attachments/assets/1abab670-c2b7-4840-9a39-91f2f1f0caad" />

Создается ingress-tls.yaml, также подтверждение настроек.

<img width="1058" height="629" alt="изображение" src="https://github.com/user-attachments/assets/2999131d-ac3d-4075-a717-643ee117b00f" />

Привязка домена к IP-адресу, после этого проверка связи (поскольку я использую k3s, следовательно используются и другие команды).

<img width="784" height="337" alt="изображение" src="https://github.com/user-attachments/assets/573cc055-9959-4277-99b6-6c414ad5c40c" />

Проверка TLS соединение с нашим CA.

<img width="781" height="712" alt="изображение" src="https://github.com/user-attachments/assets/8e1209ac-3eab-4d8f-a828-80dc8649a8c0" />

Более детальная проверка.

<img width="1022" height="179" alt="изображение" src="https://github.com/user-attachments/assets/20333a7c-167e-45b2-93c1-93fce8dd811d" />

Затем следует осуществить извлечение и чтение данных, после чего быстрая проверка срока годности.

<img width="1025" height="448" alt="изображение" src="https://github.com/user-attachments/assets/a22b24ad-6454-433a-8b84-316802a4bae8" />

---

Установить falco не получилось, спрошу на паре.


