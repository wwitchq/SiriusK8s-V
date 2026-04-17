# Dockerfile
FROM python:3.12-slim

WORKDIR /app

# Копируем файлы
COPY requirements.txt .
COPY app.py .

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.org/simple --default-timeout=100

# Создаём непривилегированного пользователя
RUN adduser --disabled-password appuser
USER appuser

ENV APP_VERSION=2.0
EXPOSE 5000

CMD ["python", "app.py"]