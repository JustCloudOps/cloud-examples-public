FROM --platform=linux/amd64 python:3.12

WORKDIR /app

COPY src/ .

RUN pip install -r requirements.txt

CMD ["python", "app.py"]