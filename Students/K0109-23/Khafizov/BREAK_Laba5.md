# Linux Break Lab — учебные поломки `05_systemd_break.sh`

Запускаем 5 скрипт, который создаёт "Unit script-server.service с падающим процессом и лимитами ресурсов."
<img width="1008" height="292" alt="Снимок экрана 2026-03-31 225748" src="https://github.com/user-attachments/assets/5f92e807-7788-4d44-b864-5f715ac9f497" />

Проверяем с помощью `systemctl`, что он действительно не работает 
<img width="1011" height="299" alt="Снимок экрана 2026-03-31 225820" src="https://github.com/user-attachments/assets/717a1792-c1bf-48dc-86b0-f5daf548a023" />

Из логов видно, что сервис прерывается с кодом 1, стоит проверить `/etc/systemd/system/script-server.service` возможно ошибка кроется в самом UNIT или в скрипте, который выполняет сервис
<img width="977" height="463" alt="Снимок экрана 2026-03-31 225958" src="https://github.com/user-attachments/assets/f13373b9-346c-43a4-be83-6bd277e05693" />

Видим, что скрипт сам исполняется с кодом `exit 1`. Напоминаю, что `exit 0` - успешно, а `exit 1` - ошибка. Меняем это
<img width="687" height="166" alt="Снимок экрана 2026-03-31 230036" src="https://github.com/user-attachments/assets/56deb0de-8f07-4cf8-9537-4f716e23f971" />

После того, как поменяли перезагружаем systemd и сам сервис для принятия изменений.
<img width="987" height="103" alt="Снимок экрана 2026-03-31 230318" src="https://github.com/user-attachments/assets/7e38a278-d68f-4bf2-8b3c-4a0fdce2349a" />

Видим, что теперь работает без ошибок. Лаба 5 выполнена я иду спать
<img width="1010" height="315" alt="Снимок экрана 2026-03-31 230328" src="https://github.com/user-attachments/assets/037a327f-b216-49a0-97d2-d1a8ed18ee45" />
