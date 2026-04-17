# <b>ЧЁ СДЕЛАЛ?</b>
Скрипт заполнил диск до отказа. Сначала было проверено использование диска `df -h` и `du -sh /* 2>/dev/null | sort -hr | head -20`. Обнаружен основной заполнитель /var/lib/linux_break_lab/disk_fill.bin и удалён через `rm -f`. Затем найден процесс, удерживающий удалённый файл, с помощью `lsof | grep deleted`, и убит через `kill` + `cat /var/lib/linux_break_lab/orphan_holder.pid`. В конце уменьшен процент зарезервированных блоков через `tune2fs -m 1` (для ext4).

# <b>ЗЗЗЗапись</b>
https://asciinema.org/a/896334