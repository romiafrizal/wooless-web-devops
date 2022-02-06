FROM python:3.9-slim-buster
WORKDIR /usr/src/app

COPY . .
WORKDIR /usr/src/app/wooless
RUN pip install --no-cache-dir -r requirements.txt

ENV FLASK_APP=run.py \
    FLASK_ENV=production

EXPOSE 80
CMD [ "python", "run.py" ]