#!/bin/bash

NAME='web-api'
DJANGODIR=$APP_FOLDER/DataGuardian
NUM_WORKERS=3
DJANGO_SETTINGS_MODULE=DataGuardian.settings
DJANGO_WSGI_MODULE=DataGuardian.wsgi

echo 'Starting…'

cd $DJANGODIR
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH


python manage.py migrate
python manage.py collectstatic --noinput


exec /usr/local/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
	--name $NAME \
	--workers $NUM_WORKERS \
	--bind '0.0.0.0:8000' \
	--timeout 2000 \
	--log-level=debug \
	--log-file=- 