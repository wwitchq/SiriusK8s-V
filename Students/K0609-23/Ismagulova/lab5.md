# LAB5

## block1
---

Создается файл deployment

<img width="1280" height="702" alt="изображение" src="https://github.com/user-attachments/assets/7a1b3348-5eca-46b7-b712-8fe28c7cc6fb" />

Далее применяются конфигурации и выполняется мониторинг подов.

<img width="832" height="337" alt="изображение" src="https://github.com/user-attachments/assets/6509f4f5-0c20-48e3-a2f0-b2ce34ced05f" />

Проверка статуса и просмотр ReplicaSet.
<img width="906" height="272" alt="изображение" src="https://github.com/user-attachments/assets/6b2d57cc-6052-4afb-86f5-7c14395216e3" />

## block2
---

Создается файл service.yaml

<img width="772" height="372" alt="изображение" src="https://github.com/user-attachments/assets/4ddedf8b-db7e-4c05-83b5-1518af948653" />

Для доступа к приложению сначала нужно применить конфигурацию сервиса, а затем определяем IP-адреса узла. Затем выполняется проверка балансировки нагрузки: обновляем приложение и делаем контроль выполнения.

<img width="1124" height="222" alt="изображение" src="https://github.com/user-attachments/assets/1239c118-92e5-44c6-966c-a250cc09fa55" />

Дальше делаем откат на предыдущую версию.

<img width="1079" height="476" alt="изображение" src="https://github.com/user-attachments/assets/efe48aa4-5130-4682-a43a-c69b35bf4ddd" />

## block3
---

Создается деплоймент и сервис
<img width="1247" height="300" alt="изображение" src="https://github.com/user-attachments/assets/d707250a-62b2-4cb3-812d-1de58642d25a" />

Дальше создается файл ingress.

<img width="1148" height="698" alt="изображение" src="https://github.com/user-attachments/assets/a859eff2-39c2-4e43-9096-c086a83a44d2" />

Далее применяются конфигурации и просматривается статус.

<img width="782" height="226" alt="изображение" src="https://github.com/user-attachments/assets/5d80815b-0632-4ffb-af87-e79d1535d562" />

Выполняем проверку состояния узлов, также следует сделать локальную привязку домена и просматривем ingress.

<img width="1253" height="421" alt="изображение" src="https://github.com/user-attachments/assets/350987da-721d-4a71-8bff-eed0bc984d77" />

Здесь следует сделать проверку маршрута к API и Web-интерфейсу (поскольку я использую k3s, выполняла с немного другими командами).

<img width="647" height="470" alt="изображение" src="https://github.com/user-attachments/assets/c70f17c1-757e-4192-b2f9-cdf75cf7f958" />

## block4
---

В данном блоке мы сравниваем.

Сначала создается сервис.

<img width="1234" height="285" alt="изображение" src="https://github.com/user-attachments/assets/40df7669-5bae-4e12-a75c-cd5c975c3ec4" />

Выполняется проверка изнутри кластера.

<img width="1054" height="365" alt="изображение" src="https://github.com/user-attachments/assets/825e3eff-4859-4b44-bbed-04b85d249d6d" />

Команду для просмотра выполняем, чтобы увидеть назначенный порт (например, 30080), по которому приложение доступно извне через IP любой ноды.
```
kubectl get svc webapp-svc
```
<img width="1055" height="113" alt="изображение" src="https://github.com/user-attachments/assets/e22682a5-813b-46ea-bcb3-d2ab47bc1d20" />

---
Скажу честно, из-за проблем с moinikube и k3s, очень долго просидела с данной лабой, зато следующие быстро сделала)
