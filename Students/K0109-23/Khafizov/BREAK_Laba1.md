# BREAK — учебные поломки Linux `01_nginx_log_challenge.sh`

Запускаем первый скрипт `01_nginx_log_challenge.sh` и сразу выведем содержимое `/var/log/nginx/access.log`.
<img width="803" height="729" alt="Снимок экрана 2026-03-31 215326" src="https://github.com/user-attachments/assets/62fd204e-68bb-425a-be43-4c3087f4d38c" />

 Видим много IP-адресов, поэтому с помощью `awk` (утилита для анализа, фильтрации и управление структурированными данными) топ 10 IP
 <img width="1001" height="230" alt="Снимок экрана 2026-03-31 215443" src="https://github.com/user-attachments/assets/8102cb7e-ae20-40b4-95b9-4ed2c3089082" />

Тоже самое с json
<img width="1001" height="231" alt="Снимок экрана 2026-03-31 215847" src="https://github.com/user-attachments/assets/7f8364e0-bf6d-4eb1-9d8b-7885d5f23fb7" />

Теперь удалим все логи чтобы места не занимали. 1 лаба закрыта
<img width="1000" height="60" alt="Снимок экрана 2026-03-31 215956" src="https://github.com/user-attachments/assets/d0a6fa20-95d5-49df-adff-d26a20c829f0" />
