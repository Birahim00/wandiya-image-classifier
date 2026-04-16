FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p models outputs

RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# IMPORTANT: Fly.io standard port
ENV PORT=8080
EXPOSE 8080

CMD gunicorn \
    --bind 0.0.0.0:8080 \
    --workers 2 \
    --threads 4 \
    --timeout 120 \
    --preload \
    app:app
