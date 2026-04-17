# 5

В пятой лабораторной работе требовалось исправить systemd-сервис, который запускался и сразу падал (restart loop).

Был проверен статус сервиса командой systemctl status script-server. В выводе видно, что процесс завершился с кодом status=1/FAILURE. Для поиска причины выполнена проверка логов: journalctl -u script-server -b --no-pager. В логах обнаружена жёлтая строка с указанием на файл /opt/break_lab/script_server.sh и код ошибки.

Содержимое файла script_server.sh просмотрено через cat. В скрипте присутствовала строка exit 0, но при этом он завершался с кодом 1. Для диагностики выполнен ручной запуск: bash -x /opt/break_lab/script_server.sh. Выявлено, что проблема связана с директивой set -euo pipefail и некорректной обработкой вывода.

С помощью vim в файле script_server.sh была исправлена строка/
Выполнена перезагрузка конфигурации systemd: sudo systemctl daemon-reload, затем перезапуск сервиса: sudo systemctl restart script-server. При повторной проверке systemctl status script-server отображается code=exited, status=0/SUCCESS, сервис больше не падает и работает стабильно.

# Запись всех действий сохранена с помощью asciinema и загружена для просмотра.

Ссылка на запись: https://asciinema.org/a/1zkQcnl7h8aiVgBF