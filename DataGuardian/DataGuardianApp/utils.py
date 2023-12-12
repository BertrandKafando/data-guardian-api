from django.core.mail import EmailMessage
from django.db import connection, transaction
import base64
import threading
from django.http import QueryDict
from psycopg2.extras import execute_values
import re
import numpy as np
import pandas as pd
import datetime
from .models import *
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

    def insert_dataframe_into_postgresql_table(dataframe, headers, table_name):
        try:
            with connection.cursor() as cursor:
                columns = columns = ", ".join([f"{DBFunctions.clean_column_name(header)} VARCHAR(255)" for header in headers])
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

            col = list(columns)[i]

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
        # Fonction pour nettoyer les noms de colonnes

    def clean_column_name(name):
        return re.sub(r'[^0-9a-zA-Z_]', '_', name)

     
class DataSplitInsertionFromFileFunctions:
    
    def parse_file(file, sep, header=False):
        data = []
        try:
            with open(file, 'r') as f:
                lines = f.readlines()
                if header:
                    lines = lines[1:]  # Exclude header if present

                incomplete_line = ''
                for idx, line in enumerate(lines):
                    line = line.strip()
                    row = line.split(sep)
                    if idx != 0 and len(row) < len(data[0]):
                        # Add the incomplete part to the last read line
                        temp1 = data[-1][-1]
                        temp2 = f' {line}'
                        data[-1][-1]  = temp1[:-1] + temp2[2:-1]
                    else:
                        data.append(row)

            if header:
                headers = data[0]
                data = data[1:]
            else:
                # If no header, generate default column names
                headers = [f"Column_{i}" for i in range(len(data[0]))]

            # Transform into a DataFrame-like structure
            res = {header: [] for header in headers}
            for i, header in enumerate(headers):
                column_data = [row[i] for row in data]
                
                # Attempt to infer data types
                column_series = pd.Series(column_data)

                # Try converting to numeric
                try:
                    numeric_column = pd.to_numeric(column_series)
                    if numeric_column.notnull().all():
                        res[header] = numeric_column
                        continue
                except:
                    pass

                # Try converting to datetime
                try:
                    date_column = pd.to_datetime(column_series)
                    if date_column.notnull().all():
                        res[header] = date_column
                        continue
                except:
                    pass

                # If unable to convert to numeric or datetime, keep as object
                res[header] = column_series

            return pd.DataFrame(res), headers

        except Exception as e:
            print(f"Error parsing file: {e}")
            return None

        
    
    def upload_file_to_dataframe_json(file):
        try:
            df = pd.read_json(file)
            return df
        except Exception as e:
            print(f"Error converting file to dataframe: {e}")
            return -1
       
       
        
    
    def verify1FN(dataframe):
        # Check if there are any duplicate columns
        if len(set(dataframe.columns)) != len(dataframe.columns):
           # delete duplicate columns
            dataframe = dataframe.loc[:, ~dataframe.columns.duplicated()]
            
        # Our checks 
        dataframe = DataSplitInsertionFromFileFunctions.process_data(dataframe)
        return dataframe
    
    



    # Fonction pour compter le nombre moyen de mots dans une colonne
    def average_word_count(series):
        return series.str.split(' ').str.len().mean()



    def process_data(df):

        df.replace('[null]', None, inplace=True)

        for col in df.columns.tolist():
            str_and_space_rows = df[col].apply(
                lambda x: isinstance(x, str) and ' ' in x)
            if str_and_space_rows.sum() > 0.5 * len(df) and DataSplitInsertionFromFileFunctions.average_word_count(df[col]) <= 3:
                original_non_null_count = df[col].notnull().sum()
                expanded_cols = df[col].str.split(
                    ' ', expand=True).add_prefix(col + '_')
                valid_cols = []

                # Identifier les colonnes divisées valides
                for exp_col in expanded_cols:
                    if expanded_cols[exp_col].notnull().sum() >= original_non_null_count * 0.5:
                        valid_cols.append(expanded_cols[exp_col])

                # Ajouter uniquement les colonnes valides au DataFrame
                if valid_cols:
                    valid_expanded_cols = pd.concat(valid_cols, axis=1)
                    col_index = df.columns.get_loc(col)
                    df.drop(columns=[col], inplace=True)
                    for new_col in reversed(valid_expanded_cols.columns):
                        df.insert(col_index, new_col, valid_expanded_cols[new_col])
                        
        return df


       
class DataInsertionStep:

    def data_insertion(chemin_fichier, sep, header=False, table_name='', type_file='CSV'):

        if type_file == 'CSV':
            # Parse the CSV file
            data, headers = DataSplitInsertionFromFileFunctions.parse_file(
                chemin_fichier, sep, header)
            print(data)
        elif type_file == 'EXCEL':
            data = pd.read_excel(chemin_fichier)
        elif type_file == 'JSON':
            # Parse the JSON file
            data = DataSplitInsertionFromFileFunctions.upload_file_to_dataframe_json(
                chemin_fichier)
        elif type_file == 'XML':
            return -1
        elif type_file == 'SQL':
            return -1
        else:
            return -1

        db_name = table_name 

        # TODO : 1FN
       # data = DataSplitInsertionFromFileFunctions.verify1FN(data)

        return DBFunctions.insert_dataframe_into_postgresql_table(data, headers, db_name), data, db_name
