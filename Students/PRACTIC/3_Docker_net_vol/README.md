# Пара 3 — Docker: сети, volumes, docker-compose
**Время:** 80 минут
**Тема:** Многоконтейнерное приложение — поднять полный стек через compose

---

## Цель занятия

К концу пары студент самостоятельно поднимает стек из 3 сервисов (frontend nginx + backend Flask + database PostgreSQL) через docker-compose и понимает как контейнеры общаются между собой.

---

## Что должно быть сделано к концу пары ✅

- [ ] Объяснить разницу bridge / host / overlay сетей
- [ ] Создать свою bridge-сеть и убедиться что контейнеры видят друг друга по имени
- [ ] Поднять PostgreSQL с persistent volume (данные пережили перезапуск)
- [ ] Написать docker-compose.yml для 3-сервисного стека
- [ ] Масштабировать один сервис `docker compose up --scale`
- [ ] Сделать healthcheck для сервисов

---

## Ход работы

### Блок 1 — Docker networking (20 мин)

```bash
# Посмотреть сети
docker network ls
docker network inspect bridge

# Создать изолированную сеть
docker network create --driver bridge app-network

# Запустить два контейнера в этой сети
docker run -d --name db --network app-network \
  -e POSTGRES_PASSWORD=secret \
  postgres:16-alpine

docker run -it --rm --network app-network alpine sh

# Внутри alpine — пробуем достучаться до db по имени
ping db          # DNS работает внутри сети!
nc -zv db 5432   # порт открыт
exit

# Сравнить: контейнер без нашей сети НЕ видит db
docker run -it --rm alpine ping db  # не найдёт
```

**Вывод:** Каждая `network` — это отдельный namespace + DNS.

---

### Блок 2 — Volumes и persistent data (15 мин)

```bash
# Запустить Postgres с volume
docker volume create pgdata

docker run -d \
  --name postgres-persistent \
  -e POSTGRES_DB=mydb \
  -e POSTGRES_USER=user \
  -e POSTGRES_PASSWORD=pass \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine

# Создать тестовые данные
docker exec -it postgres-persistent psql -U user -d mydb -c \
  "CREATE TABLE items (id SERIAL, name TEXT); INSERT INTO items VALUES (1, 'test');"

# Удалить контейнер (НЕ volume)
docker rm -f postgres-persistent

# Поднять снова — данные должны быть на месте!
docker run -d \
  --name postgres-restored \
  -e POSTGRES_DB=mydb \
  -e POSTGRES_USER=user \
  -e POSTGRES_PASSWORD=pass \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine

docker exec postgres-restored psql -U user -d mydb -c "SELECT * FROM items;"
# Данные живы ✓

# Посмотреть где физически лежит volume
docker volume inspect pgdata
```

---

### Блок 3 — docker-compose (30 мин)

Создаём структуру проекта:
```bash
mkdir ~/compose-lab && cd ~/compose-lab
mkdir -p backend frontend
```

**`backend/app.py`:**
```python
from flask import Flask, jsonify
import psycopg2, os

app = Flask(__name__)

def get_db():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "db"),
        database=os.getenv("DB_NAME", "mydb"),
        user=os.getenv("DB_USER", "user"),
        password=os.getenv("DB_PASS", "pass")
    )

@app.route('/api/items')
def items():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT id, name FROM items")
    rows = cur.fetchall()
    conn.close()
    return jsonify([{"id": r[0], "name": r[1]} for r in rows])

@app.route('/health')
def health():
    return {"status": "ok"}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**`backend/requirements.txt`:**
```
flask==3.0.0
psycopg2-binary==2.9.9
```

**`backend/Dockerfile`:**
```dockerfile
FROM python:3.12-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
```

**`frontend/nginx.conf`:**
```nginx
server {
    listen 80;
    location /api/ {
        proxy_pass http://backend:5000/api/;
        proxy_set_header Host $host;
    }
    location / {
        return 200 '<h1>Frontend OK</h1><p>API: <a href="/api/items">/api/items</a></p>';
        add_header Content-Type text/html;
    }
}
```

**`docker-compose.yml`:**
```yaml
version: '3.9'

services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d mydb"]
      interval: 5s
      timeout: 3s
      retries: 5

  backend:
    build: ./backend
    environment:
      DB_HOST: db
      DB_NAME: mydb
      DB_USER: user
      DB_PASS: pass
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:5000/health"]
      interval: 10s
      timeout: 3s
      retries: 3

  frontend:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./frontend/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      backend:
        condition: service_healthy

volumes:
  pgdata:
```

```bash
# Поднять весь стек
docker compose up -d --build

# Следить за состоянием
docker compose ps
docker compose logs -f

# Создать данные в БД
docker compose exec db psql -U user -d mydb -c \
  "CREATE TABLE IF NOT EXISTS items (id SERIAL, name TEXT); \
   INSERT INTO items (name) VALUES ('apple'), ('banana'), ('cherry');"

# Проверить цепочку: frontend → backend → db
curl localhost:8080/api/items

# Масштабировать backend
docker compose up -d --scale backend=3
docker compose ps  # видим 3 экземпляра

# Остановить
docker compose down
```

---

### Блок 4 — Итог (5 мин)

```bash
# Посмотреть все volumes
docker volume ls

# Очистить всё (включая volumes)
docker compose down -v
docker system prune -f
```

---

## Что сдать преподавателю

1. `docker compose ps` — все сервисы `healthy`
2. `curl localhost:8080/api/items` — данные из БД через nginx
3. `docker compose ps` после `--scale backend=3` — 3 экземпляра backend

---

## Частые проблемы

| Проблема | Решение |
|----------|---------|
| `backend` не может подключиться к `db` | `depends_on` с `condition: service_healthy` — ждать пока db готова |
| `nginx` возвращает 502 | Backend ещё не запустился — `docker compose logs backend` |
| Volume не создаётся | Указать в секции `volumes:` в конце compose файла |
| `psycopg2` не устанавливается в alpine | Использовать `psycopg2-binary` вместо `psycopg2` |
