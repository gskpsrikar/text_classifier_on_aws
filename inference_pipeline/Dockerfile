FROM python:3.9-alpine
WORKDIR /.

COPY app.py .
COPY application/* ./application
COPY requirements.txt .

#RUN apt-get update
#RUN apt-get install python

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD [ "python", "app.py" ]