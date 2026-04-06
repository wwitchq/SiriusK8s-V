# Как я чинил файлы из 4-го скрипта

После запуска скрипта `4.sh` в `/opt/break_lab` появилось 5 файлов, каждый из которых не запускался по своей причине. Я разбирался, почему.

----
ФОТО С РАБОТОЙ В ПАПКЕ /images
----

## Что делал

1. Перешёл в папку:
   ```bash
   cd /opt/break_lab
   ```

2. Посмотрел, что есть:
   ```bash
   ls -la
   ```

3. Пробовал запускать каждый файл и смотрел, что не так.

---

## mystery_no_exec

- **Проблема:** нет бита исполнения.
- **Как проверял:**
  ```bash
  ls -l mystery_no_exec
  ./mystery_no_exec
  ```
- **Результат:** `Permission denied`.
- **Починил:**
  ```bash
  chmod +x mystery_no_exec
  ./mystery_no_exec
  ```
- **Что изменилось:** стал запускаться (вывел дату).

---

## mystery_bad_interpreter

- **Проблема:** cannot execute: required file not found.
- **Как проверял:**
  ```bash
  ls -l mystery_bad_interpreter
  file mystery_bad_interpreter
  head -n1 mystery_bad_interpreter
  ./mystery_bad_interpreter
  ```
- **Починил:**
  ```bash
  sed -i '1s|.*|#!/bin/bash|' mystery_bad_interpreter
  chmod +x mystery_bad_interpreter
  ./mystery_bad_interpreter
  ```
- **Что изменилось:** стал запускаться (вывел `never`).

---

## mystery_truncated_elf

- **Проблема:** усечённый ELF-файл.
- **Как проверял:**
  ```bash
  ls -l mystery_truncated_elf
  file mystery_truncated_elf
  ./mystery_truncated_elf
  ```
- **Результат:** `Ошибка формата выполняемого файла`.
- **Починить:** нельзя. Файл обрезан, и недостающая часть утеряна.

---

## not_a_binary

- **Проблема:** исполняемый файл, но внутри текст, хоть он и выполняется.
- **Как проверял:**
  ```bash
  ls -l not_a_binary
  file not_a_binary
  ./not_a_binary
  ```
- **В итоге:** добавил `#!/bin/bash` в начало, чтобы было понятно, что это скрипт.

---

## Общая проверка

В конце я посмотрел, какие файлы теперь точно исполняемые:
```bash
find . -type f -executable -exec sh -c 'echo "=== $1 ==="; file "$1"' _ {} \;
```

После анализа удалил всё:
```bash
cd /opt && sudo rm -rf break_lab
```

---