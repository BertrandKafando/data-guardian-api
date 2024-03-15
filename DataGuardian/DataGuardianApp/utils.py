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

    def insert_dataframe_into_postgresql_table(dataframe, table_name):
        if not isinstance(dataframe, pd.DataFrame):
            print("The provided 'dataframe' argument is not a pandas DataFrame")
            return -1

        # Générer les clés primaires en utilisant les indices du DataFrame comme valeurs entières
        dataframe[f"{table_name}_id"] = dataframe.index + 1  # +1 pour commencer l'indexation à 1 au lieu de 0
        # Déplacer la colonne de clé primaire au début du DataFrame
        cols = dataframe.columns.tolist()
        cols = cols[-1:] + cols[:-1]
        dataframe = dataframe[cols]

        try:
            with connection.cursor() as cursor:
                dtype_mapping = {col: DBFunctions.map_numpy_type_to_sql(str(dataframe[col].dtype)) for col in dataframe.columns}
                columns = ', '.join([f"{DBFunctions.clean_column_name(header)} {dtype_mapping[header]}" for header in dataframe.columns])
                create_table_query = f"CREATE TABLE IF NOT EXISTS {table_name} ({columns});"
                cursor.execute(create_table_query)

                # Disable constraint checks temporarily
                with connection.constraint_checks_disabled():
                    for i in range(len(dataframe)):
                        row = list(dataframe.iloc[i, :])
                        row = [val.item() if isinstance(val, np.generic) else val for val in row]
                        placeholders = ", ".join(["%s"] * len(row))
                        insert_query = f"INSERT INTO {table_name} ({', '.join([DBFunctions.clean_column_name(col) for col in dataframe.columns])}) VALUES ({placeholders});"
                        cursor.execute(insert_query, row)

            return 0

        except Exception as e:
            print(f"Error inserting data into the table {table_name}: {e}")
            return -1

        

    def map_numpy_type_to_sql(dtype):
        # Mapping des types numpy aux types SQL
        numpy_sql_type_mapping = {
            'int64': 'INTEGER',
            'float64': 'FLOAT',
            'object': 'VARCHAR(500)',
            # Ajoutez d'autres mappings selon vos besoins
        }
        return numpy_sql_type_mapping.get(dtype, 'TEXT')


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
            result_type_col = DBFunctions.executer_fonction_postgresql('TypeDesColonne', str(nom_bd).lower(), str(col).lower())


            if type(result_nb_nulls) != int :
                meta_colonne.nombre_valeurs_manquantes = result_nb_nulls[0]
                meta_colonne.meta_table = meta_table
            else :
                meta_colonne.meta_table = meta_table
    
            if type(result_type_col) != int :
                if result_type_col[0] :
                    meta_colonne.type_donnees = result_type_col[0]

            meta_colonne.nombre_valeurs = meta_table.nombre_lignes
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
                        col_instance.meta_anomalie.add(anomalie)
                        
            col_instance.contraintes.add(*contraintes)

            anomalies = col_instance.meta_anomalie.all()

            nb_anomalies = 0

            if anomalies :

                for anomalie_elt in anomalies :
                    if anomalie_elt.nom_anomalie == "Premiere Forme normale" :
                        if anomalie_elt.valeur_trouvee == 0 :
                            nb_anomalies += 1
                    else :
                        if isinstance(anomalie_elt.valeur_trouvee, int) :
                            if anomalie_elt.valeur_trouvee > 0 :
                                nb_anomalies += anomalie_elt.valeur_trouvee

            col_instance.nombre_anomalies = nb_anomalies
            col_instance.save()
            new_columns_instance.append(col_instance)

        return new_columns_instance


    def check_1FN(columns, nom_bd) : 

        new_columns_instance = list()
        for col_instance in columns :

            result_1FN_checking = DBFunctions.executer_fonction_postgresql('isColumnIn1NF', str(nom_bd).lower(), str(col_instance.nom_colonne).lower())

            anomalie = MetaAnomalie()

            anomalie.nom_anomalie = "Premiere Forme normale"

            if result_1FN_checking[0] == 'Yes' :
                anomalie.valeur_trouvee = 1 #True

            else :
                anomalie.valeur_trouvee = 0 #False

            anomalie.save()
            col_instance.meta_anomalie.add(anomalie)
            col_instance.save()
            new_columns_instance.append(col_instance)

        return new_columns_instance
    

    def count_doublons(table, nom_bd, attributs_cles) : 

        result_doublons = DBFunctions.executer_fonction_postgresql('COUNT_DOUBLONS', str(nom_bd).lower(), str(attributs_cles).lower())

        if 0 in result_doublons : 
            if result_doublons[0] == 'integer' :
                print(result_doublons)
                table.nombre_doublons = result_doublons[0]
                table.save()

        return result_doublons
    

    def check_outliers(columns, nom_bd) : 

        new_columns_instance = list()

        for col_instance in columns :

            result_type_col = DBFunctions.executer_fonction_postgresql('TypeDesColonne',str(nom_bd).lower(), str(col_instance.nom_colonne).lower())

            if result_type_col[0] == 'integer' :

                result_outliers = DBFunctions.executer_fonction_postgresql('count_outliers', str(nom_bd).lower(), str(col_instance.nom_colonne).lower(), 1.5)

                col_instance.nombre_outliers = 0

                if isinstance(result_outliers, tuple)  :
                    if result_outliers[0] > 0 :
                        col_instance.nombre_outliers = result_outliers[0]

                col_instance.save()
                new_columns_instance.append(col_instance)

            else :
                col_instance.nombre_outliers = 0
                col_instance.save()
                new_columns_instance.append(col_instance)

        return new_columns_instance


    def check_cols_repetitions(columns, nom_bd) : 

        new_columns_instance = list()

        for col_instance in columns :

            result_cols_repetitions = DBFunctions.executer_fonction_postgresql('VerifierDuplication',str(nom_bd).lower(), col_instance.nom_colonne)

            if isinstance(result_cols_repetitions, tuple):
                if result_cols_repetitions :
                        
                    anomalie = MetaAnomalie()
                    anomalie.nom_anomalie = "Repetition de colonne"
                    anomalie.valeur_trouvee = result_cols_repetitions[0]
                    anomalie.save()

                col_instance.meta_anomalie.add(anomalie)
            col_instance.save()
            new_columns_instance.append(col_instance)

        return new_columns_instance


    def get_other_stats(columns, nom_bd) : 

        new_columns_instance = list()

        for col_instance in columns :

            result_uppercases = DBFunctions.executer_fonction_postgresql('CountUppercaseNames', str(nom_bd).lower(), str(col_instance.nom_colonne).lower())
            result_lowercases = DBFunctions.executer_fonction_postgresql('CountLowercaseNames', str(nom_bd).lower(), str(col_instance.nom_colonne).lower())
            result_init_caps = DBFunctions.executer_fonction_postgresql('CountInitcapNames', str(nom_bd).lower(), str(col_instance.nom_colonne).lower())
            result_min_val = DBFunctions.executer_fonction_postgresql('get_min_value', str(col_instance.nom_colonne).lower(), str(nom_bd).lower())
            result_max_val = DBFunctions.executer_fonction_postgresql('get_max_value', str(col_instance.nom_colonne).lower(), str(nom_bd).lower())

            if isinstance(result_uppercases, tuple):
                    col_instance.nombre_majuscules = result_uppercases[0]

            if isinstance(result_lowercases, tuple) :
                    col_instance.nombre_minuscules = result_lowercases[0]

            if isinstance(result_init_caps, tuple) :
                    col_instance.nombre_init_cap = result_init_caps[0]

            if type(result_min_val) != int :
                if result_min_val[0] :
                    col_instance.col_min = result_min_val[0]

            if type(result_max_val) != int :
                if result_max_val[0] :
                    col_instance.col_max = result_max_val[0]

            col_instance.save()
            new_columns_instance.append(col_instance)
        
        return new_columns_instance
    

    def compute_score(columns, bdd):
        score = 0.0
        for column in columns:
            nombre_valeurs_manquantes =  column.nombre_valeurs_manquantes if (column.nombre_valeurs_manquantes is not None)  else 0
            nombre_outliers =  column.nombre_outliers if (column.nombre_outliers is not None)  else 0
            nombre_anomalies =  column.nombre_anomalies if (column.nombre_anomalies is not None)  else 0
            nombre_valeurs = column.nombre_valeurs
            
            score += (nombre_valeurs_manquantes  + nombre_outliers + nombre_anomalies)/nombre_valeurs
            # a voir (ajouter des pondérations)

        score = score * 100 / len(columns)
        #save it 
        score_diagnostic = ScoreDiagnostic()
        score_diagnostic.valeur = 100-score
        score_diagnostic.bdd = bdd
        score_diagnostic.save()

        return score_diagnostic
       

    # Fonction pour nettoyer les noms de colonnes
    def clean_column_name(name):  
        new_name = name.strip() 
        res = re.sub(r'[^0-9a-zA-Z_]', '_', new_name)
        res.replace('', '_')
        res.replace('__', '_')
        return res
     
class DataSplitInsertionFromFileFunctions:
    
    def parse_file(file, sep, header=False):
        data = []
        try:
            with open(file, 'r', encoding='utf-8') as f:
                lines = f.readlines()
                if header:
                    pass
                   # header = lines[0].strip().split(sep)
                   # lines = lines[1:]  # Exclude header if present

                incomplete_line = ''
                for idx, line in enumerate(lines):
                    line = line.strip()
                    row = line.split(sep)
                    if idx != 0 and len(row) < len(data[0]):
                        # Add the incomplete part to the last read line
                        temp1 = data[-1][-1]
                        temp2 = f' {line}'
                        data[-1][-1] = temp1[:-1] + temp2[2:-1]
                    else:
                        data.append(row)
                # Check for empty cells and replace with 'non'
            for i in range(len(data)):
                for j in range(len(data[i])):
                    if data[i][j] == '':
                        data[i][j] = None

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

            return pd.DataFrame(res)

        except Exception as e:
            print(f"Error parsing file : {e}")
            return None


        
    
    def upload_file_to_dataframe_json(file, sep):
        try:
            df = pd.read_json(file, sep,)
            return df
        except Exception as e:
            print(f"Error converting file to dataframe: {e}")
            return -1
        
    

   

    def upload_file_to_dataframe_excel(file, header, sep):
        try:
            df = pd.read_excel(file)
            for name in df.columns :
                str_name = str(name)
                if str_name.isdigit() or str_name[0].isdigit():
                        df.rename(columns={name: f"_ch{str_name}"}, inplace=True)
                # strip the column names
                df.rename(columns=lambda x: x.replace(" ","_"), inplace=True)
            return df
        except Exception as e:
            print(f"Error converting file to dataframe excel: {e}")
            return None
    
    



       
    
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

    def data_insertion(chemin_fichier, sep, header=True, table_name='', type_file='CSV'):
        if type_file == 'CSV':
            # Parse the CSV file
            data= DataSplitInsertionFromFileFunctions.parse_file(chemin_fichier, sep, header)
            if data is None:
                return -1,None,None
            
        elif type_file == 'JSON':
            # Parse the JSON file
            data = DataSplitInsertionFromFileFunctions.upload_file_to_dataframe_json(chemin_fichier, sep)
            
        elif type_file == 'XLSX' or type_file == 'XLS':
            # Parse the Excel file
            data = DataSplitInsertionFromFileFunctions.upload_file_to_dataframe_excel(chemin_fichier,header, sep)
            if data is None:
                return -1,None,None
        elif type_file == 'SQL':
            return -1, None, None
        else:
            return -1, None, None
        
        db_name = table_name 

        # TODO : 1FN
       # data = DataSplitInsertionFromFileFunctions.verify1FN(data)

        return DBFunctions.insert_dataframe_into_postgresql_table(data, db_name), data, db_name
    
    
    def separateur (separateur) : 
        if separateur == "Virgule" : 
            return ","
        elif separateur == "Point virgule" : 
            return ";"
        elif separateur == "Tabulation" : 
            return "\t"
        else : 
            return ","
