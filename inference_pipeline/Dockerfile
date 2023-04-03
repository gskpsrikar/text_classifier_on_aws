FROM python:3.9-slim-buster
WORKDIR /.

COPY app.py .
COPY models.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD [ "python", "app.py" ]q