# <b>ЧЁ СДЕЛАЛ?</b>
Сначала проверен статус через `systemctl status script-server.service` и просмотрены логи через `journalctl -u script-server.service -b`. Выявлено, что скрипт завершается с кодом 1. Отредактирован /opt/break_lab/script_server.sh где исправлено exit 1 на exit 0. В конце выполнены `systemctl daemon-reload`, `systemctl restart systemctl`, после чего проверен статус через `systemctl status`.

# <b>ЗЗЗЗапись</b>
https://asciinema.org/a/899556