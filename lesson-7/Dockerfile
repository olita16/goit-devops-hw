FROM python:3.12-slim

WORKDIR /app

# Копіюємо лише Helm-чарти (якщо потрібні у контейнері)
COPY charts/django-app/ /app/

# Встановлюємо pip-залежності, якщо потрібні
COPY requirements.txt /app/
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Команда, щоб контейнер працював без manage.py
CMD ["tail", "-f", "/dev/null"]
