from django.apps import AppConfig
from django.db.models.signals import post_migrate
from django.dispatch import receiver
from django.conf import settings

import subprocess
import environ
import os


BASE_DIR = settings.BASE_DIR
env = environ.Env()
environ.Env.read_env()

class DataguardianappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'DataGuardianApp'

    def ready(self):
        super().ready()
        post_migrate.connect(run_sql_scripts, sender=self)




@receiver(post_migrate)
def run_sql_scripts(sender, **kwargs):

    print("Exécution des scripts SQL pour la création des fonctions et procédures...")
    script_path = os.path.join(BASE_DIR, "DataGuardian/DataGuardianApp/db_configs/functions.sql")
    print(script_path)

    try:
        subprocess.run(['psql', '-U', env("POSTGRES_USER"), '-d', env("POSTGRES_DB"), '-a', '-f', script_path])
        print("Scripts SQL exécutés avec succès.")
    except Exception as e:
        print(f"Erreur lors de l'exécution des scripts SQL : {e}")
