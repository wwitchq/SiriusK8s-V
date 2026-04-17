В пятой лабораторной работе нужно было настроить systemd unit для скрипта-сервера и разобраться почему сервис постоянно падает.
Скрипт создаёт unit файл /etc/systemd/system/script-server.service с параметрами Restart=always (автоматический перезапуск при падении), MemoryMax=64M (лимит памяти), CPUQuota=30% (ограничение CPU).
Для диагностики использовала команду systemctl status script-server — показала что сервис в цикле перезапуска (activating/auto-restart) и завершается с кодом status=1/FAILURE.
Для поиска причины проверила логи: journalctl -u script-server -b --no-pager
Команда journalctl показывает логи systemd сервисов. Ключ -u выбирает конкретный сервис, -b только за текущую загрузку, --no-pager вывод без постраничного просмотра.
В логах увидела что скрипт выводит сообщение о старте и сразу завершается с exit 1.
Для исправления отредактировала скрипт через vim — заменила exit 1 на рабочий цикл который работает постоянно.
После перезапуска systemctl restart script-server и проверки systemctl status сервис работает стабильно (active/running).
https://asciinema.org/a/HQfvEsylHnMFMIsq