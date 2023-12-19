from django.apps import AppConfig
from django.db.models.signals import post_migrate
from django.dispatch import receiver
from django.conf import settings
import subprocess
import environ
import os
import pathlib



BASE_DIR = settings.BASE_DIR
OS_PLATFORM = settings.OS_PLATFORM
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
    if OS_PLATFORM =="MACOS" or OS_PLATFORM =="LINUX": 
        functions_script_path = os.path.join(BASE_DIR, "DataGuardian/DataGuardianApp/db_configs/functions.sql")
        test_data_script_path = os.path.join(BASE_DIR, "DataGuardian/DataGuardianApp/db_configs/test_data.sql")

    if OS_PLATFORM =="WINDOWS" : 

        functions_script_path = os.path.join(BASE_DIR, "DataGuardian\DataGuardianApp\db_configs\\functions.sql")
        test_data_script_path = os.path.join(BASE_DIR, "DataGuardian\DataGuardianApp\db_configs\\test_data.sql")

    try:
        if os.path.isfile(functions_script_path):
            subprocess.run(['psql', '-U', env("POSTGRES_USER"), '-d', env("POSTGRES_DB"), '-a', '-f', functions_script_path])
            print("Scripts SQL exécutés avec succès.")
        if os.path.isfile(test_data_script_path):
            subprocess.run(['psql', '-U', env("POSTGRES_USER"), '-d', env("POSTGRES_DB"), '-a', '-f', test_data_script_path])
            print("Création des données de test réalisé avec succès.")
    except Exception as e:
        print(f"Erreur lors de l'exécution des scripts SQL : {e}")
