1. mystery_no_exec – нет прав на исполнение

Когда я посмотрел права командой ls -l /opt/break_lab/mystery_no_exec, Команда file показала, что внутри настоящий ELF-исполнимый файл. При попытке запуска (./
mystery_no_exec) вылезает ошибка Permission denied. Чтобы убедиться, что дело именно в правах, я использовал strace -f ./mystery_no_exec. В выводе нашлась 
строчка execve(...) = -1 EACCES (Permission denied). Ошибка EACCES как раз означает, что прав недостаточно. Исправление: sudo chmod +x /opt/break_lab/
mystery_no_exec. После этого заработало.

2. mystery_bad_interpreter – неверный интерпретатор

Первая строка файла (head -1) содержала #!/bin/no_such_interpreter_break_lab. Такого файла в системе нет. Команда file распознала файл как скрипт, но при попытке 
запуска я получил bad interpreter: No such file or directory. Чтобы увидеть системный вызов, я выполнил strace -f /opt/break_lab/mystery_bad_interpreter 2>&1 | 
grep execve. Результат: execve(...) = -1 ENOENT (Нет такого файла или каталога). Ошибка ENOENT означает, что не найден интерпретатор, указанный в shebang. Важно: 
сам файл существует, но программа, которая должна его выполнять, отсутствует. Я исправил это командой sudo sed -i '1c#!/bin/bash' /opt/break_lab/
mystery_bad_interpreter. Здесь 1c заменяет первую строку целиком. После правки скрипт стал выводить never.

3. mystery_truncated_elf – усечённый ELF

Команда file /opt/break_lab/mystery_truncated_elf выдала предупреждение: can't read elf program headers at 232, missing section headers at 141824. Это значит, 
что заголовок ELF ещё присутствует (первые байты 7f 45 4c 46), но остальные части файла обрезаны. Попытка запуска приводит к ошибке. При вызове strace 
я увидел execve(...) = -1 ENOEXEC (Ошибка формата выполнимого файла). ENOEXEC – это ответ ядра, когда оно не может распознать формат. Восстановить такой файл 
невозможно,.

4. not_a_binary – текст без shebang

Этот файл содержал просто echo hello. Команда file определила его как ASCII text. ./not_a_binary в некоторых системах может сработать, потому что shell по 
умолчанию пытается выполнить текст через /bin/sh.Ввывел hello. Чтобы сделать скрипт более правильным, я добавила shebang: sudo sed -i '1i#!/bin/bash' 
not_a_binary. Команда 1i вставляет строку перед первой строкой. После этого file показал Bourne-Again shell script.

5. mystery_dyn (если бы он был)

Этот файл должен был имитировать ситуацию, когда интерпретатор ELF (program interpreter) указан неверно. Проверить можно через readelf -l mystery_dyn | grep 
interpreter. Я правдя старалась, но это самый сомнительный пункт.

Предоставляю видио:
 https://asciinema.org/a/PdEI4Zh40PFMuXcb
 
 я очень старалась, но вроде не получилось(