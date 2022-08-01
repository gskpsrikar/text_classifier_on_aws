FROM python:3.9-alpine
WORKDIR ./docker_images
ADD training .
#RUN apt-get update
#RUN apt-get install python
RUN pip install -r requirements.txt
ENTRYPOINT ["python", "training_entrypoint.py"]
