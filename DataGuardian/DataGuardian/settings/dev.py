from .base import *

print("yoooooo")

print(env('POSTGRES_LOCAL_DB_PASSWORD'))

DATABASES = {
	'default': {
			'ENGINE':'django.db.backends.postgresql',
			'NAME' : env('POSTGRES_DB'),
			'USER': env('POSTGRES_LOCAL_DB_USERNAME'),
			'PASSWORD': env('POSTGRES_LOCAL_DB_PASSWORD'),
			'HOST': env('DATABASE_LOCAL_HOST'),
			'PORT': '5432',
            'ATOMIC_REQUESTS': True
	}
}


SECRET_KEY = env('DEV_SECRET_KEY')
ALLOWED_HOSTS = ['*']
DEBUG=True