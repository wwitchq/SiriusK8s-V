# LAB6

## block1
---

Создается конфигмап из литералов, после чего выполняется проверка содержимого и подробное описание.
<img width="548" height="1000" alt="изображение" src="https://github.com/user-attachments/assets/980fe6b6-4092-4f2a-ad0b-6f47304e47f6" />

Далее создается файлик pod-with-config.yaml

<img width="1121" height="789" alt="изображение" src="https://github.com/user-attachments/assets/fdd9c69e-8448-4b33-a7b5-975eff41fbd7" />

Создается еще один конфигмап, только уже из файла. Далее запуск пода и его проверка.

<img width="788" height="1018" alt="изображение" src="https://github.com/user-attachments/assets/9ba5fd5a-14d9-44e1-a0d9-38df052f937b" />

## block2
---

Создание Secret, который испольузется для хранения чувствительных данных (пароли, ключи, токены). Далее просмотр и декодирование, чтобы увидеть данные в манифесте.

<img width="800" height="625" alt="изображение" src="https://github.com/user-attachments/assets/5879a063-daf4-43cc-b2e7-07a8db47570d" />

Создается файл pod-with-secret.yaml

<img width="1118" height="546" alt="изображение" src="https://github.com/user-attachments/assets/29aa70d1-a446-450a-8cd0-202b3c77ebb9" />

Запускается под с секретами и проверяем логи.

<img width="493" height="204" alt="изображение" src="https://github.com/user-attachments/assets/6722e32f-bc8b-4c60-b56b-b843047f83b0" />

## block3
---

Создается файлик postgres-pvc.yaml (на скрине забыла исправить строку StorageCLassName, из-за чего потом были проблемы)

<img width="1108" height="970" alt="изображение" src="https://github.com/user-attachments/assets/1fc31ffd-fbf1-4abe-a8a4-77743269a77a" />

Подготавливается хранилище и проверяется статус

<img width="1280" height="194" alt="изображение" src="https://github.com/user-attachments/assets/bf022cdf-471d-44cd-aded-a3785abc8df5" />

Затем создаются данные в хранилище, после чего проверяем на отказоустойчивость.

<img width="990" height="537" alt="изображение" src="https://github.com/user-attachments/assets/5b4137c4-1c13-47b3-8f4b-27a922cc2d6e" />

Проверка сохранности данных.

<img width="840" height="182" alt="изображение" src="https://github.com/user-attachments/assets/b36e6a59-cced-44b3-80db-d392d1004492" />
