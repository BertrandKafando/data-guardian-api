from django.apps import AppConfig
from django.db.models.signals import post_migrate
from django.dispatch import receiver
from django.conf import settings
import subprocess
import environ
import os
import pathlib
import pandas as pd
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
            if OS_PLATFORM == "MACOS" or OS_PLATFORM == "LINUX":

                path = os.path.join(BASE_DIR, 'DataGuardian/DataGuardianApp/db_configs/data_types.json')

                with open(path) as f:
                    config_data = json.load(f)

            if OS_PLATFORM == "WINDOWS" : 

                path = os.path.join(BASE_DIR, 'DataGuardian\DataGuardianApp\db_configs\\data_types.json')

                with open(path) as f:
                    config_data = json.load(f)


            for field_name, field_info in config_data["generales"].items():

                if field_name == 'specifiques':
                    for type, constraints in field_info.items() :

                        MetaTousContraintes.objects.get_or_create(
                            nom_contrainte=constraints['nom contrainte'],
                            category=type,
                            contrainte=constraints['definition'],
                            commentaire=constraints['commentaire']
                        )
                

                if 'type' in field_info :

                    MetaTousContraintes.objects.get_or_create(
                        nom_contrainte=field_name,
                        category=field_info['type'],
                        contrainte=field_info['definition'],
                        commentaire=field_info['commentaire']
                    )


            for field_name, field_info in config_data["semantiques"].items():

                MetaTousContraintes.objects.get_or_create(
                    nom_contrainte=field_info['type'],
                    category=field_name,
                    contrainte=field_info['definition'],
                    commentaire=field_info['commentaire']
                )


            # This is for tests purposes
            # from .utils import Base64, DBFunctions, DBTypesDetection

            # from sqlalchemy import create_engine, text, Column, Integer, String, Text, Sequence, MetaData
            # from urllib.parse import quote
            # from sqlalchemy.ext.declarative import declarative_base
            # from sqlalchemy.orm import sessionmaker
            # from sqlalchemy.schema import DropTable
            # from sqlalchemy.ext.compiler import compiles

            # @compiles(DropTable, "postgresql")
            # def _compile_drop_table(element, compiler, **kwargs):
            #     return compiler.visit_drop_table(element) + " CASCADE"
            

            # pwd = quote(env('POSTGRES_LOCAL_DB_PASSWORD'))  
            # connection_string = f"postgresql+psycopg2://{env('POSTGRES_LOCAL_DB_USERNAME')}:{pwd}@{env('DATABASE_LOCAL_HOST')}:5432/{env('POSTGRES_DB')}"
            # engine = create_engine(connection_string)

            # conn = engine.connect()

            # query = text('SELECT * FROM CLIENTS')

            # df = pd.read_sql_query(query, conn)

            # detected_types = DBTypesDetection.detect_columns_type(df)

            # Base = declarative_base()
            # metadata = MetaData(bind=engine)

            # class TestResult(Base):
            #     __tablename__ = 'test_result'
            #     id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
            #     result = Column(Text)

            # if engine.dialect.has_table(engine, TestResult.__tablename__): 
            #     TestResult.__table__.drop(engine)

            # Base.metadata.create_all(engine)

            # Session = sessionmaker(bind=engine)
            # session = Session()

            # result_str = str(detected_types)

            # nouveau_resultat = TestResult(result=result_str)

            # session.add(nouveau_resultat)
            # session.commit()
            # End test



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