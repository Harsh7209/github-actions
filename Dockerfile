FROM python:3.11.15-trixie

WORKDIR /app

COPY . .

RUN pip install -r requirments.txt
EXPOSE 80

CMD ["python","run.py"]