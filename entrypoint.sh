#!/bin/bash
NAME='web-api'
DJANGODIR=DataGuardian
NUM_WORKERS=3
DJANGO_SETTINGS_MODULE=DataGuardian.settings
DJANGO_WSGI_MODULE=DataGuardian.wsgi

echo 'Starting…'

cd $DJANGODIR
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Prepare log files and start outputting logs to stdout
/wait-for-it.sh postgresql:5432 -t 30

python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput


exec /usr/local/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
	--name $NAME \
	--workers $NUM_WORKERS \
	--bind '0.0.0.0:8000' \
	--timeout 1000 \
	--log-level=debug \
	--log-file=- 