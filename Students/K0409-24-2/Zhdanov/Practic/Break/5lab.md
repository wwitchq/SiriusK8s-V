# Что сделал.
Сначала проверил статус службы `script-server` через `systemctl status` и просмотрели логи за текущую сессию командой `journalctl -u script-server -b --no-pager`. Выяснилось, что скрипт завершается с кодом ошибки 1. В файле `/opt/break_lab/script_server.sh` заменил `exit 1` на `exit 0`. После этого выполнили `systemctl daemon-reload` и `systemctl restart script-server.service`. Затем снова проверили статус через `systemctl status`.

# Запись консоли.
https://asciinema.org/a/uuwVOQDKBOy8owa6