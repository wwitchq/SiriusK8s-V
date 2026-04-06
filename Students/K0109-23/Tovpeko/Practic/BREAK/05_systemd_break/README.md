# Как я анализировал и останавливал сервис из 5-го скрипта

После запуска скрипта `5.sh` появился сервис `script-server.service`, который сразу начал падать и перезапускаться. Я разобрался, что с ним и как остановить.


----
ФОТО С РАБОТОЙ В ПАПКЕ /images
----

## Что делал

1. Посмотрел статус сервиса:
   ```bash
   systemctl status script-server
   ```
   Видно, что статус `activating (auto-restart)` — он постоянно перезапускается.

2. Посмотрел логи:
   ```bash
   journalctl -u script-server -b --no-pager
   ```
   В логах много строк `script-server: старт ...` и `Process exited`, потому что он постоянно падает.

3. Остановил сервис:
   ```bash
   sudo systemctl stop script-server
   ```

4. Отключил автозапуск:
   ```bash
   sudo systemctl disable script-server
   ```

5. Удалил файлы:
   ```bash
   sudo rm -f /etc/systemd/system/script-server.service
   sudo rm -f /opt/break_lab/script_server.sh
   sudo systemctl daemon-reload
   ```

## Что было сломано

- Сервис `script-server.service` был настроен на постоянный перезапуск (`Restart=always`) и сразу падал (`exit 1`).
- Из-за этого он создавал много записей в логе.

## Что починил

- Остановил процесс.
- Отключил автозапуск.
- Удалил юнит-файл и скрипт.

Сервис больше не запускается.

---