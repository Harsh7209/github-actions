FROM python:3.11.15-trixie

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 80

CMD ["gunicorn","--bind", "0.0.0.0:80", "app:app"]