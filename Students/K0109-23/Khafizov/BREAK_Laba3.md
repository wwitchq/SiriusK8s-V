# Linux Break Lab — учебные поломки `03_disk_break.sh`

Запустим 3 скрипт, который "Заполняет root раздел большим файлом (+ опционально «удалённый, но открытый» файл)."
<img width="769" height="290" alt="Снимок экрана 2026-03-31 224330" src="https://github.com/user-attachments/assets/81eb2622-106c-4eb7-9b96-b4717e412c70" />

Проверим свободное место на диске и видим, что корень забит
<img width="709" height="199" alt="Снимок экрана 2026-03-31 224342" src="https://github.com/user-attachments/assets/17c6e098-6738-471f-bc7a-8f7c1f74b7d8" />

Найдем этот файл с помощью `du -h`, `sort`, `tail`
<img width="987" height="463" alt="Снимок экрана 2026-03-31 224420" src="https://github.com/user-attachments/assets/619b2b8e-5cd9-4396-9026-f1efa30d6e47" />

После того, как нашли просто удалим бинарник
<img width="978" height="106" alt="Снимок экрана 2026-03-31 224502" src="https://github.com/user-attachments/assets/ebf49259-d499-4621-887e-a60ac5079752" />

После удалим ещё фоновый процесс
<img width="981" height="120" alt="Снимок экрана 2026-03-31 224534" src="https://github.com/user-attachments/assets/f0415608-fbd7-4881-ade7-a3984700ac3f" />

И проверим, что место на диске освободилось(немного и то потому-что есть еще мои программы на этой виртуалке). Лаба 3 завершена.
<img width="721" height="204" alt="Снимок экрана 2026-03-31 225038" src="https://github.com/user-attachments/assets/be48133f-0d05-415e-8c38-9a5a62ab3ca8" />
