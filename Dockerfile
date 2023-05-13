FROM python:3.9-slim-buster

RUN pip install kopf kubernetes

COPY ./swarz.py ./swarz.py

CMD ["kopf", "run", "./swarz.py"]