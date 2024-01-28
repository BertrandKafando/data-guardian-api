from django.apps import AppConfig
from django.db.models.signals import post_migrate
from django.dispatch import receiver
from django.conf import settings
import subprocess
import environ
import os
import pathlib
import json



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

        # Importation du modèle à l'intérieur de la fonction ready
        from .models import MetaTousContraintes

        # Fonction pour ajouter des données initiales
        @receiver(post_migrate)
        def ajouter_donnees_initiales(sender, **kwargs):
            # Insérer vos nouvelles données ici
            donnees = [
                {'nom_contrainte': 'Espace superflus', 'category': 'String',
                    'contrainte': '( ){2,}', 'commentaire': 'pour rechercher des espaces superflus'},
                {'nom_contrainte': 'Répitions de trois lettres consécutives', 'category': 'String',
                    'contrainte': '(.)\\1\\1', 'commentaire': 'pour rechercher des répétitions de trois lettres consécutives'},
                {'nom_contrainte': 'caractere speciaux', 'category': 'String',
                    'contrainte': '[[:punct:]]', 'commentaire': 'detecter les caracteres speciaux'},
            ]

            if OS_PLATFORM == "MACOS" or OS_PLATFORM == "LINUX":

                path = os.path.join(BASE_DIR, 'DataGuardian/DataGuardianApp/db_configs/data_types.json')

                with open(path) as f:
                    config_data = json.load(f)

            if OS_PLATFORM == "WINDOWS" : 

                path = os.path.join(BASE_DIR, 'DataGuardian\DataGuardianApp\db_configs\\data_types.json')

                with open(f) as f:
                    config_data = json.load(f)


            for category, constraints in config_data["generales"].items():
                for constraint_name, anomaly_list in constraints.items():
                    for anomaly in anomaly_list:

                        MetaTousContraintes.objects.get_or_create(
                            nom_contrainte=anomaly["nom"],
                            category=category,
                            contrainte=anomaly["regex"],
                            commentaire=anomaly["commentaire"]
                        )


            for field_name, field_info in config_data["specifiques"].items():
                for anomaly in field_info["anomalies"]:

                    MetaTousContraintes.objects.get_or_create(
                        nom_contrainte=anomaly["nom"],
                        category=field_name,
                        contrainte=anomaly["regex"],
                        commentaire=anomaly["commentaire"]
                    )



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
