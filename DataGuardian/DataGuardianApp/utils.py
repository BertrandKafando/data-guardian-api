from django.core.mail import EmailMessage
from django.db import connection, transaction
import base64
import threading
from django.http import QueryDict
from psycopg2.extras import execute_values
import re
import numpy as np
import pandas as pd

class EmailThread(threading.Thread):

    def __init__(self, email):
        self.email = email
        threading.Thread.__init__(self)

    def run(self):
        self.email.send()


class Email:

    @staticmethod
    def send_email(data):
        email = EmailMessage(
            subject=data['email_subject'], body=data['email_body'], to=[data['to_email']])
        EmailThread(email).start()


class Base64 :
    def isBase64(sb):
            try:
                if isinstance(sb, str):
                    # If there's any unicode here, an exception will be thrown and the function will return false
                    sb_bytes = bytes(sb, 'ascii')
                elif isinstance(sb, bytes):
                    sb_bytes = sb
                else:
                    raise ValueError("Argument must be string or bytes")
                return base64.b64encode(base64.b64decode(sb_bytes)) == sb_bytes
            except Exception:
                return False
            

class DBFunctions:


    def executer_fonction_postgresql(nom_fonction, *args):

        with connection.cursor() as cursor:

            try:

                params = ', '.join('%s' for _ in args)
                
                cursor.execute(f"SELECT {nom_fonction}({params});", args)
                
                result = cursor.fetchone()
                
                return result
            
            except Exception as e:

                print(f"Erreur lors de l'exécution de la fonction {nom_fonction}: {e}")
                return -1

    def insert_dataframe_into_postgresql_table(dataframe, table_name):
        try:
            with connection.cursor() as cursor:
                dataframe_columns = list(dataframe.columns)
                columns = ", ".join(
                    f"col{i+1} VARCHAR" for i in range(len(dataframe.columns)))
                
                cursor.execute(
                    f"CREATE TABLE IF NOT EXISTS {table_name} ({columns});")

                # Disable constraint checks temporarily
                with connection.constraint_checks_disabled():
                    for i in range(0,dataframe.shape[0]):
                        row = list(dataframe.iloc[i, :])
                        row = [val.item() if isinstance(val, np.generic)
                               else val for val in row]
                        placeholders = ", ".join(["%s"] * len(row))
                        insert_query = f"INSERT INTO {table_name} VALUES ({placeholders});"
                        cursor.execute(insert_query, row)

            return 0

        except Exception as e:
            print(f"Error inserting data into the table {table_name}: {e}")
            return -1
        


    def extract_nested_data(request):
        data = request.POST 
        nested_data = {}

        # Expression régulière pour identifier les clés imbriquées
        pattern = re.compile(r'(\w+)\[(\w+)\]')

        for key in data:
            match = pattern.match(key)
            if match:
                outer_key, inner_key = match.groups()
                if outer_key not in nested_data:
                    nested_data[outer_key] = {}
                nested_data[outer_key][inner_key] = data[key]
            else:
                nested_data[key] = data[key]

        # Gestion des fichiers
        if 'base_de_donnees[fichier_bd]' in request.FILES:
            nested_data['base_de_donnees']['fichier_bd'] = request.FILES['base_de_donnees[fichier_bd]']

        return nested_data
    

    def check_nulls(columns, meta_table, nom_bd) : 

        meta_col_instances = list()

        for i in range(len(list(columns))) :

            col = "col"+str(i+1)

            meta_colonne = MetaColonne()
            meta_colonne.nom_colonne = col
            result_nb_nulls = DBFunctions.executer_fonction_postgresql('NombreDeNULLs', nom_bd, col)

            if type(result_nb_nulls) != int :
                meta_colonne.nombre_valeurs_manquantes = result_nb_nulls[0]
                meta_colonne.meta_table = meta_table
                meta_colonne.save()
                meta_col_instances.append(meta_colonne)

        return meta_col_instances
    

    def check_constraints(columns, nom_bd) : 

        new_columns_instance = list()

        for col_instance in columns :

            # On suppose que toutes les règles varchars s'appliquent sur cette colonne (On a pas encore la possibilité de connaitre la sémantique)

            contraintes = MetaTousContraintes.objects.filter(category__icontains="String")

            for constraint in contraintes : 

                result_count_values_not_matching_regex = DBFunctions.executer_fonction_postgresql('count_values_not_matching_regex', nom_bd, col_instance.nom_colonne, constraint.contrainte)

                if type(result_count_values_not_matching_regex) != int :

                    if result_count_values_not_matching_regex[0] != 0 :

                        anomalie = MetaAnomalie()
                        anomalie.nom_anomalie = constraint.nom_contrainte
                        anomalie.valeur_trouvee = int(result_count_values_not_matching_regex[0])

                        anomalie.save()

                        col_instance.meta_anomalie = anomalie

            col_instance.contraintes.add(*contraintes)
            col_instance.save()
            new_columns_instance.append(col_instance)

        return new_columns_instance

            
