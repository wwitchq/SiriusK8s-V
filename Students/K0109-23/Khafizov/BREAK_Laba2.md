# Linux Break Lab — учебные поломки `02_network_break.sh`

Запустим скрипт, который попортит нам маршруты по умолчанию и DNS
<img width="1009" height="330" alt="Снимок экрана 2026-03-31 221932" src="https://github.com/user-attachments/assets/692c1c62-1db8-49e5-b374-87868152bae2" />

Потом вводим `ip route`, чтобы узнать информацию о интерфейсах. Скрипт должен был испортить `default via`, но он у меня остался не тронутым
<img width="780" height="124" alt="Снимок экрана 2026-03-31 221943" src="https://github.com/user-attachments/assets/5457db88-db1b-4ae5-8bdf-739d53a94f58" />

Но всё же стоит по заданию исправить `default via`
<img width="568" height="33" alt="Снимок экрана 2026-03-31 222046" src="https://github.com/user-attachments/assets/834b90af-1901-4338-866e-44f2c00963a7" />

После этого переходим в `/etc/resolf.conf`
<img width="330" height="67" alt="Снимок экрана 2026-03-31 222114" src="https://github.com/user-attachments/assets/c66626b7-e5c4-4d87-bd46-1b28751aa188" />

Видим, что нас скрипт испортил файл, поэтому меняем его
<img width="315" height="64" alt="Снимок экрана 2026-03-31 222137" src="https://github.com/user-attachments/assets/598199a1-1920-4b33-a8de-ef25a97b93dd" />

Также скрипт коснулся `/etc/nsswitch.conf`, а конкретно строки hosts. Скрипт просто удалил dns для определения IP-адреса по доменному имени
<img width="733" height="422" alt="Снимок экрана 2026-03-31 222211" src="https://github.com/user-attachments/assets/ac613433-c452-45e3-b903-8507b7a1c084" />

Теперь пробуем достучаться до DNS гугла
<img width="599" height="165" alt="Снимок экрана 2026-03-31 222247" src="https://github.com/user-attachments/assets/7fa2459e-a857-4352-9f86-a8ed9272862c" />

И попробуем с помощью curl вывести HTTP-заголовки c Avito. Лаба успешно выполнена
<img width="1016" height="490" alt="Снимок экрана 2026-03-31 222318" src="https://github.com/user-attachments/assets/8a958447-016a-4b7b-9d0e-8aee69801b7f" />

