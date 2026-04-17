# Linux Break Lab — учебные поломки `04_binary_break.sh`

Запустим 4 скрипт, который делает "Несколько «незапускаемых» бинарей в /opt/break_lab/."
<img width="875" height="364" alt="Снимок экрана 2026-03-31 225138" src="https://github.com/user-attachments/assets/d458d1d3-ccb4-4563-be9e-5db31c43655a" />

Сделаем скрипт `mystery_no_exec` исполняемым и посмотрим, что он выводит
<img width="987" height="182" alt="Снимок экрана 2026-03-31 225419" src="https://github.com/user-attachments/assets/83e1c00e-84fc-4c46-a629-296e697ff831" />

Потом проверяем еще один файл `not_a_binary` убеждаемся, что он не бинарный, а просто текстовый
<img width="959" height="48" alt="Снимок экрана 2026-03-31 225431" src="https://github.com/user-attachments/assets/ad6358a6-fa8c-4aae-b448-da2005b2874c" />

Третий файл имеет неправильный конфиг внутри, поэтому исправляем это
<img width="1006" height="145" alt="Снимок экрана 2026-03-31 225506" src="https://github.com/user-attachments/assets/f3a1dc09-06f8-4553-95a0-4615548d76dc" />
<img width="338" height="67" alt="Снимок экрана 2026-03-31 225535" src="https://github.com/user-attachments/assets/e424b692-7ce8-4ad7-9e17-46070ea20d44" />
<img width="1003" height="119" alt="Снимок экрана 2026-03-31 225545" src="https://github.com/user-attachments/assets/79947a09-47ed-427f-873f-ce54d83c6192" />

Четвёртый файл будто обрезанный(повреждённый), потому-что из вывода `readelf` видно, что файл хранит битые данные. Лаба 4 завершена
<img width="1005" height="655" alt="Снимок экрана 2026-03-31 225710" src="https://github.com/user-attachments/assets/b03749f3-ec36-4a03-9cb3-a1a9e343707b" />
