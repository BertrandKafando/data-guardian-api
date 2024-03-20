from django.core.mail import EmailMessage
from django.db import connection, transaction
import base64
import threading
from django.http import QueryDict
from psycopg2.extras import execute_values
import re
import os
import numpy as np
import pandas as pd
import datetime
import re
from datetime import datetime
from .models import *
import pycountry
import requests
import geonamescache
from google.cloud import translate
from currency_symbols import CurrencySymbols
import re

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
            

    def exec_function_postgresql_get_all(nom_fonction, *args):

        result= []
        with connection.cursor() as cursor:

            try:

                # params = ', '.join('%s' for _ in args)
                
                # cursor.execute(f"SELECT {nom_fonction}({params});", args)

                cursor.callproc(nom_fonction, list(args))

                result = cursor.fetchall()
                
                return result
            
            except Exception as e:

                print(f"Erreur lors de l'exécution de la fonction {nom_fonction}: {e}")
                return result 


    def insert_dataframe_into_postgresql_table(dataframe, table_name):
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


    def check_nulls(columns, meta_table, nom_bd, diagnostic) : 

        meta_col_instances = list()
        #supprimer la colonne avec le nom_bd+ _id
        columns = [col for col in list(columns) if col != f"{nom_bd}_id"]
        for i in range(len(list(columns))) :

            col = list(columns)[i]

            meta_colonne = MetaColonne()
            meta_colonne.nom_colonne = col
            res_diagnostic_nulls = DBFunctions.exec_function_postgresql_get_all('DiagnoticDeNULLs', nom_bd, col)
            #get type of column
            result_type_col = DBFunctions.executer_fonction_postgresql('TypeDesColonne', str(nom_bd).lower(), str(col).lower())
            type_colonne = None
            if type(result_type_col) != int :
                if result_type_col[0] :
                    meta_colonne.type_donnees = result_type_col[0]
                    type_colonne = result_type_col[0]
        
            #insert into DiagnosticDetail
            for result in res_diagnostic_nulls:
                DataGuardianDiagnostic.insert_diagnostic_details(result[0], col, None, "VALEUR_NULL", "La valeur est NULL", "VALEUR_NULL", diagnostic, type_colonne)
            result_nb_nulls = len(res_diagnostic_nulls)

            meta_colonne.nombre_valeurs_manquantes = result_nb_nulls
            meta_colonne.meta_table = meta_table

            meta_colonne.nombre_valeurs = meta_table.nombre_lignes
            meta_colonne.save()

            meta_col_instances.append(meta_colonne)

        return meta_col_instances


    def check_constraints(columns, nom_bd, diagnostic, columns_types = {}, df = None) : 

        new_columns_instance = list()

        for col_instance in columns :

            if col_instance.type_donnees == "integer":
                pass
            elif col_instance.type_donnees == "date":
                pass
            elif col_instance.type_donnees == "character varying":
                
                #type semantique numerique
                if columns_types[col_instance.nom_colonne] == "numerique":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_NUMERIQUE',
                        'anomalie': 'VALEUR_NUMERIQUE_INCORRECTE',
                        'commentaire' : "La valeur numérique est incorrecte", 
                        'code_correction': "CODE_CORRECTION_NUMERIQUE",
                        'type_donnee': 'numerique'
                    }
                    col_instance = SemanticFunctions.check_constraints_for_semantics_types(col_instance, nom_bd, diagnostic, infos_diagnostic)
                     
                #type semantique email
                elif columns_types[col_instance.nom_colonne] == "email":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_EMAIL',
                        'anomalie': 'EMAIL_INCORRECTE',
                        'commentaire' : "L'adresse email est incorrecte", 
                        'code_correction': "CODE_CORRECTION_EMAIL",
                        'type_donnee': 'email'
                    }
                    col_instance = SemanticFunctions.check_constraints_for_semantics_types(col_instance, nom_bd, diagnostic, infos_diagnostic)
                
                #type semantique date
                elif columns_types[col_instance.nom_colonne] == "date":
                    infos_diagnostic = {
                        'categorie' : 'FORMAT_DATE',
                        'anomalie': 'FORMAT_DATE_INCORRECTE',
                        'commentaire' : "Le format de la date est incorrect", 
                        'code_correction': "CODE_CORRECTION_FORMAT_DATE",
                        'type_donnee': 'date'
                    }
                    col_instance = SemanticFunctions.check_date_format(df, col_instance, nom_bd, diagnostic, infos_diagnostic)
                
                elif columns_types[col_instance.nom_colonne] == "phone":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_TELEPHONE',
                        'anomalie': 'FORMAT_NUMERO_TELEPHONE_INCORRECTE',
                        'commentaire' : "Le format du numéro de téléphone est incorrect", 
                        'code_correction': "CODE_CORRECTION_PHONE",
                        'type_donnee': 'phone'
                    }
                    col_instance = SemanticFunctions.check_constraints_for_semantics_types(col_instance, nom_bd, diagnostic, infos_diagnostic)
                elif columns_types[col_instance.nom_colonne] == "adresse":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_ADRESSE',
                        'anomalie': 'FORMAT_ADRESSE_INCORRECTE',
                        'commentaire' : "Le format adresse est incorrecte", 
                        'code_correction': "CODE_CORRECTION_ADRESSE",
                        'type_donnee': 'adresse'
                    }
                    col_instance = SemanticFunctions.check_constraints_for_semantics_types(col_instance, nom_bd, diagnostic, infos_diagnostic)


                elif columns_types[col_instance.nom_colonne] == "pays":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_PAYS',
                        'anomalie': 'PAYS_INCONNU_OU_MAL_ECRIT',
                        'commentaire' : "Ce pays est non reconnu dans notre base des faits", 
                        'code_correction': "CODE_CORRECTION_PAYS",
                        'type_donnee': 'pays'
                    }
                    SemanticFunctions.check_anomalies_based_on(col_instance, nom_bd, diagnostic, infos_diagnostic=infos_diagnostic, base_faits='bf_pays_continent', col_base_faits='nom_pays_fr')

                    

                elif columns_types[col_instance.nom_colonne] == "ville":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_VILLE',
                        'anomalie': 'VILLE_INCONNU_OU_MAL_ECRIT',
                        'commentaire' : "Cette ville est non reconnu dans notre base des faits", 
                        'code_correction': "CODE_CORRECTION_VILLE",
                        'type_donnee': 'ville'
                    }
                    SemanticFunctions.check_anomalies_based_on(col_instance, nom_bd, diagnostic, infos_diagnostic=infos_diagnostic, base_faits='bf_ville', col_base_faits='nom_ville_fr')

                elif columns_types[col_instance.nom_colonne] == "continent":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_CONTINENT',
                        'anomalie': 'CONTINENT_INCONNU_OU_MAL_ECRIT',
                        'commentaire' : "Ce continent est non reconnu dans notre base des faits", 
                        'code_correction': "CODE_CORRECTION_CONTINENT",
                        'type_donnee': 'ville'
                    }
                    SemanticFunctions.check_anomalies_based_on(col_instance, nom_bd, diagnostic, infos_diagnostic=infos_diagnostic, base_faits='bf_pays_continent', col_base_faits='nom_continent_fr')

                elif columns_types[col_instance.nom_colonne] == "groupe_sanguin":
                    infos_diagnostic = {
                        'categorie' : 'TYPE_GROUPE_SANGUIN',
                        'anomalie': 'GROUPE_SANGUIN_INCONNU',
                        'commentaire' : "Ce groupe sanguin est non reconnu dans notre base des faits", 
                        'code_correction': "CODE_CORRECTION_GROUPE_SANGUIN",
                        'type_donnee': 'groupe_sanguin'
                    }
                    SemanticFunctions.check_anomalies_based_on(col_instance, nom_bd, diagnostic, infos_diagnostic=infos_diagnostic, base_faits='bf_groupe_sanguin', col_base_faits='groupe')

                else:
                    pass
                   
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
    
    
    def check_outliers(columns, nom_bd,connected_user,df, columns_types={}) : 

        new_columns_instance = list()
        #supprimer la colonne avec le nom_bd+ _id
        columns = [col for col in columns if col.nom_colonne != f"{nom_bd}_id"]
        for col_instance in columns :

            result_type_col = DBFunctions.executer_fonction_postgresql('TypeDesColonne',str(nom_bd).lower(), str(col_instance.nom_colonne).lower())
            col_instance.nombre_outliers = 0
            if result_type_col[0] in DataGuardianDiagnostic.types_numeriques:
                id_col_name= str(nom_bd).lower() + "_id"
                res =DataGuardianDiagnostic.chechk_column_outliers_python(df, str(col_instance.nom_colonne), id_col_name)
                print("outliers",res)
                result_outliers = len(res)
                col_instance.nombre_outliers = result_outliers

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

    def check_general_constraints(columns, nom_bd, diagnostic, columns_types = {}):
        new_columns_instance = list()

        for col_instance in columns :

            if col_instance.type_donnees == "character varying" and columns_types[col_instance.nom_colonne] == "UNKNOWN":
                col_instance = SemanticFunctions.check_constraints_for_unknown(col_instance, nom_bd, diagnostic)
            
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

        score = score * 100 / (len(columns)-1)
        #save it 
        score_diagnostic = ScoreDiagnostic()
        score_diagnostic.valeur = 100-score
        score_diagnostic.bdd = bdd
        score_diagnostic.save()

        return score_diagnostic
       

    def save_number_of_anomalie_in_meta_colonne(col_instance):
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
        return col_instance
    # Fonction pour nettoyer les noms de colonnes
    def clean_column_name(name):
        new_name = name.strip() 
        res = re.sub(r'[^0-9a-zA-Z_]', '_', new_name)
        res.replace('', '_')
        res.replace('__', '_')
        return res
    
    def save_number_of_anomalies(nom_anomalie, valeur_trouvee):
        anomalie = MetaAnomalie()
        anomalie.nom_anomalie = nom_anomalie
        anomalie.valeur_trouvee = valeur_trouvee
        anomalie.save()
        return anomalie
     
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
        
       # update dataframe
        dataframe = pd.DataFrame(data)
        if not isinstance(dataframe, pd.DataFrame):
            print("The provided 'dataframe' argument is not a pandas DataFrame")
            return -1, None, None

        # Générer les clés primaires en utilisant les indices du DataFrame comme valeurs entières
        dataframe[f"{table_name}_id"] = dataframe.index + 1  # +1 pour commencer l'indexation à 1 au lieu de 0
        # Déplacer la colonne de clé primaire au début du DataFrame
        cols = dataframe.columns.tolist()
        cols = cols[-1:] + cols[:-1]
        dataframe = dataframe[cols]

        return DBFunctions.insert_dataframe_into_postgresql_table(dataframe, db_name), dataframe, db_name
    
    
    def separateur (separateur) : 
        if separateur == "Virgule" : 
            return ","
        elif separateur == "Point virgule" : 
            return ";"
        elif separateur == "Tabulation" : 
            return "\t"
        else : 
            return ","



class DBTypesDetection :

    BASE_DIR = settings.BASE_DIR
    gc = geonamescache.GeonamesCache()
    credential_path = os.path.join(BASE_DIR, 'DataGuardian/DataGuardianApp/db_configs/even-envoy-415900-c08ec858fa9b.json')
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path
    PARENT = f"projects/even-envoy-415900"


    def check_text_spelling(text):
        api_url = "https://api.languagetoolplus.com/v2/check"
        headers = {"Content-Type": "application/x-www-form-urlencoded"}
        data = {
            "text": text,
            "language": "fr",
        }
        
        response = requests.post(api_url, headers=headers, data=data)
        result = response.json()

        return result


    def verifier_format(chaine):

        patterns = [
            r'^[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ\s]+$',
            r'^[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ\s,]+$',
            r'^[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ,]+$',
            r'^[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ\s,\-]+$',
            r'^[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ\s-]+$',
            r'^[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ,-]+$',
        ]
    
        for pattern in patterns:
            if re.match(pattern, chaine):
                return True

        return False


    def decouper_chaine(chaine):
        
        separateurs = [' ', ',', '-']
        mots = []

        if DBTypesDetection.verifier_format(chaine):
            mots = re.split(r'[, \-]+', chaine)
            return mots

        else:
            return None


    def translate_text(text: str, target_language_code: str) -> translate.Translation:
        client = translate.TranslationServiceClient()
        
        if text and isinstance(text, str) :

            response = client.translate_text(
                parent = DBTypesDetection.PARENT,
                contents = [str(text)],
                target_language_code = target_language_code,
            )

            return response.translations[0]
        else :

            response = client.translate_text(
                parent = DBTypesDetection.PARENT,
                contents = ['None'],
                target_language_code = target_language_code,
            )

            return response.translations[0]
        
    
    def get_currencies(url):
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            
            return [details['currencyCode'] for code, details in data["supportedCurrenciesMap"].items()]
        else:
            print("Erreur lors de la récupération des données")
            return []
    

    def is_amount(text):
    
        cleaned_text = str(text).replace(" ", "")
        currencies = DBTypesDetection.get_currencies("https://api.currencyfreaks.com/v2.0/supported-currencies")
        
        currencies_symboles = (CurrencySymbols.get_symbol(currency) for currency in currencies)
        currencies_symboles_cleaned = [symbole for symbole in currencies_symboles if symbole is not None]        
        regex = "|".join(re.escape(s) for s in set(currencies_symboles_cleaned))
        pattern = re.compile(rf"^\d+\s*({regex})$")
        
        return bool(pattern.match(cleaned_text))

        
    def is_country(country_name):

        if isinstance(country_name, str):
            country_name = DBTypesDetection.translate_text(country_name, "en").translated_text
            try:
                pycountry.countries.lookup(country_name)
                return True
            except LookupError:
                return False
        else :
            False


    def is_city(chaine):
        
        if isinstance(chaine, str) :
            villes = DBTypesDetection.gc.get_cities()

            for ville_id in villes:
                ville = villes[ville_id]
                if chaine.lower() == ville['name'].lower():
                    return True

            return False
        else : 
            False


    def is_address(chaine):

        address_meta = MetaTousContraintes.objects.filter(
            category = 'TYPE_ADRESSE'
        ).first()

        regex = address_meta.contrainte

        if isinstance(chaine, str):
            regex = re.compile(
                regex,
                re.IGNORECASE)      
            return bool(regex.search(chaine))
        else :
            return False
        

    def is_email(chaine):

        email_meta = MetaTousContraintes.objects.filter(
            category = 'TYPE_EMAIL'
        ).first()

        regex = email_meta.contrainte
        compiled_regex = re.compile(regex)

        if isinstance(chaine, str):

            if compiled_regex.match(chaine) :
                return True
            else :
                return False
        
        else :
            return False
        

    def is_phone_number(chaine):

        phone_meta = MetaTousContraintes.objects.filter(
            category = 'TYPE_TELEPHONE'
        ).first()

        regex = phone_meta.contrainte
        compiled_regex = re.compile(regex)

        if isinstance(chaine, str):

            if compiled_regex.match(chaine) :
                return True
            else :
                return False
        
        else :
            return False
        

    def is_numeric(chaine):

        numeric_meta = MetaTousContraintes.objects.filter(
            category = 'TYPE_NUMERIQUE'
        ).first()

        regex = numeric_meta.contrainte
        compiled_regex = re.compile(regex)

        if isinstance(chaine, str):

            if compiled_regex.match(chaine) :
                return True
            else :
                return False
        
        else :
            return False


    def is_date(chaine):

        date_meta = MetaTousContraintes.objects.filter(
            category = 'TYPE_DATE'
        ).first()

        regex = date_meta.contrainte

        return bool(re.match(regex, str(chaine)))
        
    

    def check_type_in_column(df, column_name, check_function):

        """
        Vérifie le type de données dans une colonne d'un DataFrame en utilisant une fonction de vérification spécifiée.

        Parameters:
        - df (pd.DataFrame): Le DataFrame contenant la colonne à vérifier.
        - column_name (str): Le nom de la colonne à vérifier.
        - check_function (callable): La fonction de vérification à utiliser (ex: DBTypesDetection.is_country).

        Returns:
        Tuple[int, float]: Le nombre et le pourcentage de valeurs correspondant au type spécifié.
        """

        random_sample = df[column_name].dropna().sample(n=20, random_state=42)
        results = random_sample.apply(check_function)
        count_true = results.sum()
        percentage_true = (count_true / len(results)) * 100

        return count_true, percentage_true
    

    def determine_majority_type(columns):

        result = {}
        for column, types in columns.items():
            sorted_types = sorted(types.items(), key=lambda x: x[1], reverse=True)
            if sorted_types[0][1] > 50.0:
                result[column] = sorted_types[0][0]
            else:
                result[column] = 'UNKNOWN'
        return result


    def detect_columns_type(df):

        result = {}
        for column in df.columns:


            _, numeric_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_numeric)
            if numeric_percentage > 60.0:
                result[column] = {'numerique': numeric_percentage}
                continue

            _, amount_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_amount)
            if amount_percentage > 60.0:
                result[column] = {'montant': amount_percentage}
                continue

            _, date_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_date)
            if date_percentage > 60.0:
                result[column] = {'date': date_percentage}
                continue

            _, phone_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_phone_number)
            if phone_percentage > 60.0:
                result[column] = {'phone': phone_percentage}
                continue

            _, email_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_email)
            if email_percentage > 60.0:
                result[column] = {'email': email_percentage}
                continue

            _, countries_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_country)
            if countries_percentage > 60.0:
                result[column] = {'pays': countries_percentage}
                continue

            _, cities_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_city)
            if cities_percentage > 60.0:
                result[column] = {'ville': cities_percentage}
                continue

            _, address_percentage = DBTypesDetection.check_type_in_column(df, column, DBTypesDetection.is_address)
            if address_percentage > 60.0:
                result[column] = {'adresse': address_percentage}
                continue

            result[column] = {
                'pays': countries_percentage,
                'ville': cities_percentage,
                'adresse': address_percentage,
                'email': email_percentage,
                'phone': phone_percentage,
                'numerique': numeric_percentage,
                'montant': amount_percentage,
                'date': date_percentage
            }

            final_types = DBTypesDetection.determine_majority_type(result)


        return final_types


class DataGuardianDiagnostic :
        # Liste des types de données considérés comme numériques
    types_numeriques = ['smallint', 'integer', 'bigint', 'decimal', 'numeric', 'real', 'double precision', 'smallserial', 'serial', 'bigserial']
   
    # @transaction.atomic
    def insert_diagnostic_details(id_ligne, nom_colonne, valeur, anomalie, commentaire, code_correction,diagnostic,type_colonne):
        try:
            detail = DiagnosticDetail()
            detail.id_ligne = id_ligne
            detail.nom_colonne = nom_colonne
            detail.valeur = valeur
            detail.anomalie = anomalie
            detail.commentaire = commentaire
            detail.code_correction = code_correction
            detail.diagnostic = diagnostic
            detail.type_colonne = type_colonne
            detail.save()
            return 0
        except Exception as e:
            print(f"Error inserting diagnostic details: {e}")
            return -1      
    
    def chechk_column_outliers_python(df, col_name, id_col_name):
        """
        Identify outliers in a DataFrame column based on the Interquartile Range (IQR) method.
        Returns the id_col_name and col_name values of the outliers.
        """
        col_value = df[col_name].values
        id_col_value = df[id_col_name].values

        Q1 = np.percentile(col_value, 25)
        Q3 = np.percentile(col_value, 75)
        IQR = Q3 - Q1

        # Define bounds for outliers
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        outliers = []
        zip_iterator = zip(col_value, id_col_value)

        for col, id_col in zip_iterator:
            if col < lower_bound or col > upper_bound:
                outliers.append((id_col, col))

        return outliers
    
    def extraire_id(tuple_input):
        # Extraire la chaîne du tuple
        input_str = tuple_input[0]
        print("input_str",input_str)

        # Enlever les caractères externes pour isoler 'X,Y'
        clean_str = input_str[2:-3]

        # Séparer sur la virgule pour obtenir X et Y
        x_str, _ = clean_str.split(',')
        
        # Tenter de convertir X en nombre entier
        try:
            x = int(x_str)
            return x
        except ValueError:
            print("La partie 'X' de la chaîne ne contient pas un nombre valide.")
            return None

class SemanticFunctions:

    def check_constraints_for_semantics_types(col_instance, nom_bd, diagnostic, infos_diagnostic):
        contraintes = MetaTousContraintes.objects.filter(category__icontains=infos_diagnostic["categorie"])
        for constraint in contraintes : 
            result_values_not_matching_regex = DBFunctions.exec_function_postgresql_get_all('values_not_matching_regex', nom_bd, col_instance.nom_colonne, constraint.contrainte)
            count_anomalies = len(result_values_not_matching_regex)
            #insérer le nombre d'anomalies détectés
            if count_anomalies > 0 :
                anomalie = DBFunctions.save_number_of_anomalies(constraint.nom_contrainte, count_anomalies)
                col_instance.meta_anomalie.add(anomalie)
            #insérer les résultats dans détail diagnostic
            for result in result_values_not_matching_regex:
                DataGuardianDiagnostic.insert_diagnostic_details(result[0], result[1], result[2], infos_diagnostic["anomalie"], infos_diagnostic["commentaire"], infos_diagnostic["code_correction"], diagnostic, infos_diagnostic["type_donnee"])
                
        col_instance.contraintes.add(*contraintes)
        col_instance = DBFunctions.save_number_of_anomalie_in_meta_colonne(col_instance)
        return col_instance
    
    def check_anomalies_based_on(col_instance, nom_bd, diagnostic, infos_diagnostic, base_faits, col_base_faits):
        anomalies_based_on = DBFunctions.exec_function_postgresql_get_all('GetAnomaliesBasedOn', nom_bd, col_instance.nom_colonne, base_faits, col_base_faits)
        count_anomalies = len(anomalies_based_on)
        #insérer le nombre d'anomalies détectés
        if count_anomalies > 0 :
            anomalie = DBFunctions.save_number_of_anomalies("Pays non reconnu", count_anomalies)
            col_instance.meta_anomalie.add(anomalie)
        #insérer les résultats dans détail diagnostic
        for result in anomalies_based_on:
            DataGuardianDiagnostic.insert_diagnostic_details(result[0], col_instance.nom_colonne, result[1], infos_diagnostic["anomalie"], infos_diagnostic["commentaire"], infos_diagnostic["code_correction"], diagnostic, infos_diagnostic["type_donnee"])


    
    def check_constraints_for_unknown(col_instance, nom_bd, diagnostic):
        contraintes = MetaTousContraintes.objects.filter(category__icontains="string")
        for constraint in contraintes : 
            result_values_not_matching_regex = DBFunctions.exec_function_postgresql_get_all('values_not_matching_regex', nom_bd, col_instance.nom_colonne, constraint.contrainte)
            count_anomalies = len(result_values_not_matching_regex)
            #insérer le nombre d'anomalies détectés
            if count_anomalies > 0 :
                anomalie = DBFunctions.save_number_of_anomalies(constraint.nom_contrainte, count_anomalies)
                col_instance.meta_anomalie.add(anomalie)
            #insérer les résultats dans détail diagnostic
            for result in result_values_not_matching_regex:
                DataGuardianDiagnostic.insert_diagnostic_details(result[0], result[1], result[2], constraint.nom_contrainte, constraint.nom_contrainte, "CODE_CORRECTION_GENERAL_CONSTRAINST", diagnostic, "UNKNOWN")
                
        col_instance.contraintes.add(*contraintes)
        col_instance = DBFunctions.save_number_of_anomalie_in_meta_colonne(col_instance)
        return col_instance



    def get_date_format(date_string):
        # List of common date formats to check against
        date_formats = {
        r'\d{4}-\d{2}-\d{2}': 'YYYY-MM-DD',
        r'\d{2}-\d{2}-\d{4}': 'MM-DD-YYYY',
        r'\d{2}/\d{2}/\d{4}': 'MM/DD/YYYY',
        r'\d{4}/\d{2}/\d{2}': 'YYYY/MM/DD',
        r'\d{2}\.\d{2}\.\d{4}': 'MM.DD.YYYY',
        r'\d{4}\.\d{2}\.\d{2}': 'YYYY.MM.DD',
        r'\d{2}\s[A-Z][a-z]{2}\s\d{4}': 'MM Mon YYYY',  
        r'[A-Z][a-z]{2}\s\d{2},\s\d{4}': 'Mon DD, YYYY', 
        r'\d{2}\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}': 'DD Mon YYYY (English)', 
        r'\d{2}\s(janv\.|févr\.|mars|avr\.|mai|juin|juil\.|août|sept\.|oct\.|nov\.|déc\.)\s\d{4}': 'DD Mon YYYY (French)',
        r'\d{2}/\d{2}/\d{2}': 'DD/MM/YY',
        r'\d{2}-\d{2}-\d{2}': 'DD-MM-YY',
    }
        
        if date_string != None:
            for date_format, label in date_formats.items():
                if re.match(date_format, date_string):
                    return label
        
        
        return "Format de date inconnu"
    

    def check_date_format(df, col_instance, nom_bd, diagnostic, infos_diagnostic):
        df_copy = df.copy()
        df_copy[col_instance.nom_colonne] = pd.to_datetime(df_copy[col_instance.nom_colonne], errors='coerce')
        incorrect_formats = df_copy[df_copy[col_instance.nom_colonne].isna()]

        df_bad_format = df[df.index.isin(incorrect_formats.index)]
        # df_good_format = df[~df.index.isin(incorrect_formats.index)]
        #df_bad_format[col_instance.nom_colonne + '_date_format'] = df[col_instance.nom_colonne].apply(SemanticFunctions.get_date_format)
        
        for row in df_bad_format[[nom_bd+'_id', col_instance.nom_colonne]].itertuples(index=False):
            id_ligne = row[0]
            valeur = row[1]
            DataGuardianDiagnostic.insert_diagnostic_details(id_ligne, col_instance.nom_colonne, valeur, infos_diagnostic["anomalie"], infos_diagnostic["commentaire"], infos_diagnostic["code_correction"], diagnostic, infos_diagnostic["type_donnee"])

        col_instance = DBFunctions.save_number_of_anomalie_in_meta_colonne(col_instance)
        return col_instance


    def replace_outliers(df, column, outliers, method='moyenne'):
        
        if method == 'mediane':
            replacement_value = df[column].median()
        else:
            replacement_value = df[column].mean()
        
        df[column] = df[column].apply(
            lambda x: replacement_value if x in outliers else x)
        
        return df
    

    def convert_date_format(date_str, output_format="%m-%d-%Y", input_format=None):

        if input_format:
            try:
                date_obj = datetime.strptime(date_str, input_format)
                return date_obj.strftime(output_format)
            except ValueError:
                return "Format de date inconnu ou incorrect."
        else:
            
            possible_formats = [
                "%Y-%m-%d", "%d-%m-%Y", "%m-%d-%Y",
                "%Y/%m/%d", "%d/%m/%Y", "%m/%d/%Y",
                "%Y.%m.%d", "%d.%m.%Y", "%m.%d.%Y",
                "%Y %m %d", "%d %m %Y", "%m %d %Y",
                "%b %d, %Y", "%d %b %Y",
            ]
            
            for format_ in possible_formats :
                try:
                    date_obj = datetime.strptime(date_str, format_)
                    return date_obj.strftime(output_format)
                except ValueError:
                    continue 
            
            return "Format de date inconnu."
        

    def remove_currency_symbol(amount):

        numeric_amount = re.sub(r'[^\d.]+', '', amount)
        return numeric_amount
    

    def convert_currency(amount, conversion_rate, new_currency_symbol=None):

        numeric_amount = float(re.sub(r'[^\d.]+', '', amount))
        converted_amount = numeric_amount * conversion_rate
        
        if new_currency_symbol:
            return f"{new_currency_symbol}{converted_amount:,.2f}"
        else:
            return f"{converted_amount:,.2f}"
        

    def drop_duplicates_column(df):
        
        colonnes_a_supprimer = set()
        for i in range(len(df.columns)):
            for j in range(i+1, len(df.columns)):
                if df.iloc[:,i].equals(df.iloc[:,j]):
                    colonnes_a_supprimer.add(df.columns[j])
        df_reduit = df.drop(columns=colonnes_a_supprimer)
        return df_reduit
        


    #TODO : fonction pour corriger l'écriture des pays et villes (ref : GetAnomaliesSuggestions, GetAnomaliesBasedOn, TranslateCountryName)
    #TODO : fonction pour corriger les numéros de téléphone ou les supprimer (ref : table des faits)
    #TODO : fonction pour corriger les adresses email : supprimer ou pas
        

    def apply_correction(df, nom_colonne, fonction_correction):
        
        """
        Applique une fonction de correction sur une colonne spécifique d'un DataFrame.

        Parameters:
        - df (pd.DataFrame): Le DataFrame sur lequel appliquer la correction.
        - nom_colonne (str): Le nom de la colonne sur laquelle appliquer la fonction de correction.
        - fonction_correction (function): La fonction de correction à appliquer sur la colonne.

        Returns:
        pd.DataFrame: Le DataFrame avec la colonne corrigée.
        """
        
        df[nom_colonne] = df[nom_colonne].apply(fonction_correction)
        return df
