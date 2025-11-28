# Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY ./my_django_project/ /app


# Встановлюємо залежності
RUN pip install --no-cache-dir -r requirements.txt

# Виставляємо порт
EXPOSE 8000

# Команда запуску
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
