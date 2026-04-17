# Пара 2 — Docker: образы, Dockerfile, запуск
**Время:** 80 минут
**Тема:** Собрать образ, понять слои, запустить контейнер правильно

---

## Цель занятия

К концу пары студент умеет писать Dockerfile, собирать образ, запускать контейнер с нужными параметрами и понимает архитектуру слоёв Union FS.

---

## Что должно быть сделано к концу пары ✅

- [ ] Написать Dockerfile для простого Python/Node приложения
- [ ] Собрать образ и запустить контейнер
- [ ] Использовать multistage build — уменьшить размер образа в 3+ раза
- [ ] Запустить контейнер с ограничениями CPU/RAM
- [ ] Посмотреть слои образа (`docker history`, `docker inspect`)
- [ ] Использовать .dockerignore
- [ ] Опубликовать образ на Docker Hub (или локальный registry)

---

## Ход работы

### Блок 1 — Первый Dockerfile (20 мин)

Создаём простое Flask-приложение:

```bash
mkdir ~/docker-lab && cd ~/docker-lab
```

**Файл `app.py`:**
```python
from flask import Flask
import os, socket

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from container! Host: {socket.gethostname()}, Version: {os.getenv('APP_VERSION', '1.0')}"

@app.route('/health')
def health():
    return {"status": "ok"}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**Файл `requirements.txt`:**
```
flask==3.0.0
```

**Плохой Dockerfile (намеренно):**
```dockerfile
FROM python:3.12
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

```bash
# Собрать и запустить
docker build -t myapp:bad .
docker images myapp  # посмотреть размер — будет ~1GB+

docker run -d -p 5000:5000 --name app-bad myapp:bad
curl localhost:5000
```

**Контрольный вопрос:** Почему образ такой большой?

---

### Блок 2 — Multistage build (25 мин)

**Хороший Dockerfile:**
```dockerfile
# Stage 1: builder
FROM python:3.12-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: final image
FROM python:3.12-alpine
WORKDIR /app
# Копируем только установленные пакеты из builder
COPY --from=builder /root/.local /root/.local
COPY app.py .
ENV PATH=/root/.local/bin:$PATH
ENV APP_VERSION=2.0
# Никогда не запускаем от root
RUN adduser -D appuser
USER appuser
EXPOSE 5000
CMD ["python", "app.py"]
```

**Файл `.dockerignore`:**
```
__pycache__/
*.pyc
.git/
.env
*.md
Dockerfile*
```

```bash
docker build -t myapp:good .
docker images myapp  # сравнить размеры!

# Запустить с ограничениями ресурсов
docker run -d \
  -p 5001:5000 \
  --name app-good \
  --memory="128m" \
  --cpus="0.5" \
  --restart=unless-stopped \
  myapp:good

curl localhost:5001
docker stats app-good  # видим лимиты
```

---

### Блок 3 — Исследование образа (20 мин)

```bash
# Посмотреть слои
docker history myapp:good
docker history myapp:bad

# Детальная информация
docker inspect myapp:good | jq '.[0].RootFS'

# Установить dive для визуализации слоёв
wget -q https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_amd64.deb
sudo dpkg -i dive_0.12.0_linux_amd64.deb
dive myapp:good

# Посмотреть что внутри контейнера (без его запуска)
docker create --name inspect-me myapp:good
docker export inspect-me | tar -tv | head -30
docker rm inspect-me
```

---

### Блок 4 — Docker Hub (15 мин)

```bash
# Логин (нужен аккаунт hub.docker.com)
docker login

# Тегировать и опубликовать
docker tag myapp:good ВАШЕ_ИМЯ/flask-demo:v1.0
docker push ВАШЕ_ИМЯ/flask-demo:v1.0

# Проверить: скачать с нуля
docker rmi ВАШЕ_ИМЯ/flask-demo:v1.0
docker pull ВАШЕ_ИМЯ/flask-demo:v1.0
docker run -d -p 5002:5000 ВАШЕ_ИМЯ/flask-demo:v1.0
```

---

## Что сдать преподавателю

1. Вывод `docker images myapp` — две строки (bad vs good), видна разница в размере
2. Вывод `docker history myapp:good` — слои образа
3. `docker stats app-good` — работающие лимиты CPU/RAM
4. URL вашего образа на Docker Hub

---

## Частые проблемы

| Проблема | Решение |
|----------|---------|
| `flask: command not found` в alpine | `ENV PATH=/root/.local/bin:$PATH` должен быть перед CMD |
| Контейнер сразу останавливается | `docker logs <name>` — смотреть ошибки |
| `permission denied` на порту | Порт занят — сменить `-p 5003:5000` |
| `dive` не показывает UI | Запустить в терминале с PTY: добавить флаг `CI=true dive ...` для non-interactive |
