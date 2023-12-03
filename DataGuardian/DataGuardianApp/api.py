from rest_framework.viewsets import ModelViewSet
from .serializers import *
from rest_framework.response import Response
from .models import *
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .permissions import *
from django.contrib.auth import authenticate, login
from .authentication import *
from django.contrib.auth import logout
from .utils import Base64, DBFunctions
import os
from django.core.files.base import ContentFile
from rest_framework.views import APIView
from django.db.models import Q
import pandas as pd
from django.conf import settings
import environ
import json
from django.db import transaction
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from sqlalchemy import create_engine, text as sql_text
from langdetect import detect, LangDetectException
import spacy
from collections import Counter
import re
import pandas as pd


env = environ.Env()
environ.Env.read_env()
BASE_DIR = settings.BASE_DIR


class RoleViewSet(ModelViewSet):
    serializer_class= RoleSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):
        queryset= Role.objects.all()
        return queryset
    

class CompteViewSet(ModelViewSet):
    serializer_class= CompteSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):
        queryset= Compte.objects.all()
        return queryset
    
    def destroy(self, request, *args, **kwargs):

        compte = self.get_object()
        User.objects.get(username=compte.identifiant).delete()
        compte.delete()
        return Response(status=status.HTTP_204_NO_CONTENT) 


class UtilisateurViewSet(ModelViewSet):
    serializer_class= UtilisateurSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):

        telephone = self.request.query_params.get('telephone')
        role = self.request.query_params.get('role')

        if telephone and role:
            
            queryset = Utilisateur.objects.filter(role__nom_role=role).filter(telephone__icontains=telephone)
            return queryset

        if self.request.user.has_perm("APA_APP.is_admin") :

            queryset= Utilisateur.objects.all()

        else :

            queryset= Utilisateur.objects.all().exclude(role__nom_role='Administrateur')

        # TODO :remove this following line it's just for test
        queryset= Utilisateur.objects.all()

        return queryset


    def destroy(self, request, *args, **kwargs):

        utilisateur=self.get_object()
        if utilisateur.compte is not None:
            User.objects.get(username=utilisateur.compte.identifiant).delete()
            Compte.objects.get(identifiant=utilisateur.compte.identifiant).delete()
        utilisateur.delete()
        return Response(status=status.HTTP_204_NO_CONTENT) 
    

class CritereViewSet(ModelViewSet):
    serializer_class= CritereSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):
        queryset= Critere.objects.all()
        return queryset
    

fichier_bd = openapi.Parameter('fichier_bd', in_=openapi.IN_QUERY,
                           type=openapi.TYPE_FILE, description="Fichier de la base de données")

class BaseDeDonneesViewSet(ModelViewSet):
    serializer_class= BaseDeDonneesSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    @swagger_auto_schema(
        manual_parameters=[fichier_bd],
    )
    def get_queryset(self):

        base_de_donnees = self.request.query_params.get('base_de_donnees')
        queryset = BaseDeDonnees.objects.all()

        if base_de_donnees:
            
            queryset = queryset.filter(nom_base_de_donnees__icontains=base_de_donnees)        

        return queryset


    def destroy(self, request, *args, **kwargs):

        base_de_donnees = self.get_object()
        if base_de_donnees.fichier_bd :
            
            file_path = base_de_donnees.fichier_bd.path
            print(file_path)
            if os.path.exists(file_path):
                os.remove(file_path)

        base_de_donnees.delete()

        return Response(status=status.HTTP_204_NO_CONTENT) 
    

    def create(self, request, *args, **kwargs):
            
            fichier_bd = request.data.get("fichier_bd", None)
            base_de_donnees_serializer=BaseDeDonneesSerializer(data=request.data)
            
    
            if not base_de_donnees_serializer.is_valid():
                return Response({'detail': 'Données invalides'}, status = status.HTTP_400_BAD_REQUEST)
            # get file in base_de_donnees_serializer.data.get("fichier_bd") and transform it to dataframe
             # TODO : get the file and convert it to dataframe
            data = pd.read_csv(fichier_bd)
            # TODO : create the table in the database
            DBFunctions.insert_dataframe_into_postgresql_table(data, base_de_donnees_serializer.data.get("nom_base_de_donnees"))
    
            return Response(base_de_donnees_serializer.data, status=status.HTTP_201_CREATED)
    


class DiagnosticViewSet(APIView):

    def get_permissions(self):
        if self.request.method == "GET":
            self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated ]
        elif self.request.method == "POST":
            self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
        elif self.request.method == "PUT" or self.request.method == "PATCH":
            self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
        elif self.request.method == "DELETE":
            self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
        return [permission() for permission in self.permission_classes]

    serializer_class = DiagnosticSerializer 


    def get(self, request):

        user = request.user
        print(user)
        current_user = Utilisateur.objects.filter(
            compte__identifiant=user.username
        ).first()

        if current_user :
            
            queryset = Diagnostic.objects.filter(Utilisateur=current_user)
        
        else : 

            queryset = Diagnostic.objects.all()

        serializer = DiagnosticSerializer(queryset , many=True)
        response_data = serializer.data

        return Response(response_data,status=status.HTTP_200_OK)
        

    @swagger_auto_schema(request_body=DiagnosticSerializer)
    def post(self, request, *args, **kwargs):


        result_nb_rows = DBFunctions.executer_fonction_postgresql('NombreDeLignes', 'Clients')
        result_nb_nulls = DBFunctions.executer_fonction_postgresql('NombreDeNULLs','Clients','ADNCLI')
        print(result_nb_rows)
        print(result_nb_nulls)




        print(request.data)

        diagnostic_serializer=DiagnosticSerializer(data=request.data)

        if not diagnostic_serializer.is_valid():
            return Response({'detail': 'Données invalides'}, status = status.HTTP_400_BAD_REQUEST)
        
        print(diagnostic_serializer.data)
        
        user = request.user
        utilisateur = Utilisateur.objects.filter(
            compte__identifiant=user.username
        ).first()

        base_de_donnees_data = diagnostic_serializer.data.pop('base_de_donnees', None)

        if base_de_donnees_data :
            if base_de_donnees_data.get("fichier_bd", None) :
                base_de_donnees_serializer = BaseDeDonneesSerializer(data=base_de_donnees_data)
                base_de_donnees_serializer.is_valid(raise_exception=True)
                base_de_donnees = base_de_donnees_serializer.save()
            else : 
                
                # On a un select de la BD et non un upload
                # TODO : récuperer la base de données grace à son nom et l'utilisateur qui l'avait uploadé : query on Diagnostic -> base_de_donnees & utilisateur
                pass


            if 'utilisateur' in diagnostic_serializer.data :
                utilisateur =  Utilisateur.objects.filter(compte__identifiant=diagnostic_serializer.data.pop("utilisateur")).first()
            else :
                utilisateur = utilisateur.compte.identifiant

            diagnostic = Diagnostic.objects.create(
                base_de_donnees=base_de_donnees,
                utilisateur=utilisateur, 
                **diagnostic_serializer.data
            )

            # TODO : créer les objets criteres et les ajouter à l'objet diagnostic
            criteres = diagnostic_serializer.data.pop("criteres")

            #for critere_elt in criteres :
                #print(critere_elt)
                # get or create a new instance of critere named critere
                #diagnostic.criteres.add(critere)
                #diagnostic.save()

            # TODO convertir le fichier en Dataframe et créer la table à partir du Dataframe exécuter les procédures et fonctions stockées : créer une fonction run diagnostic

            # ICI je teste avec la table client créée pour cela

        result_nb_rows = DBFunctions.executer_fonction_postgresql('NombreDeLignes', 'Clients')
        print(result_nb_rows)


        return Response({
                "diagnostic" : diagnostic,
            }, status=status.HTTP_200_OK)
 


class MetaTableViewSet(ModelViewSet):
    serializer_class= MetaTableSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):

        queryset = MetaTable.objects.all()
        return queryset
    

class MetaAnomalieViewSet(ModelViewSet):
    serializer_class= MetaAnomalieSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):

        queryset = MetaAnomalie.objects.all()
        return queryset
    

class MetaTousContraintesViewSet(ModelViewSet):
    serializer_class= MetaTousContraintesSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):

        queryset = MetaTousContraintes.objects.all()
        return queryset
    

class MetaColonneViewSet(ModelViewSet):
    serializer_class= MetaColonneSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):

        queryset = MetaColonne.objects.all()
        return queryset
    

class LoginView(APIView):

    serializer_class= CompteSerializer
    http_method_names = ["post","head"]

    def post(self, request, *args, **kwargs):

        authentication_serializer=CompteSerializer(data=request.data)

        if not authentication_serializer.is_valid():
            return Response({'detail': 'Données invalides'}, status = status.HTTP_400_BAD_REQUEST)

        user_instance = Utilisateur.objects.filter(compte__identifiant=authentication_serializer.data.get("identifiant")).first()


        user = authenticate(
            username = authentication_serializer.data.get("identifiant"),
            password = authentication_serializer.data.get("mot_de_passe")
        )

        if not user:
            return Response({'detail': 'informations de connexion invalides.'}, status=status.HTTP_404_NOT_FOUND)
        
        login(request, user)


        #TOKEN
        token, _ = Token.objects.get_or_create(user = user)

        #token_expire_handler will check, if the token is expired it will generate new one
        is_expired, token = token_expire_handler(token)   
        user_serialized = UtilisateurSerializer(user_instance)
        permission=list(user.get_all_permissions())[0]
        user_instance_data = user_serialized.data
        user_instance_data["identifiant"]=authentication_serializer.data.get("identifiant")
        user_instance_data.pop('compte',None)
        user_instance_data.pop('email',None)
        user_instance_data.pop('telephone',None)

        return Response({
            'user': user_instance_data, 
            'expires_in': expires_in(token),
            'created_at': token.created,
            'is_expired': is_expired,
            'token': token.key,
            'userType':permission.split(".")[1]
        }, status=status.HTTP_200_OK)


class LogoutView(APIView):
    http_method_names = ["head","post"]


    # def get_permissions(self):
    #     if self.request.method == "POST":
    #         self.permission_classes = [IsAuthenticated]


    def post(self, request, *args, **kwargs):

        Token.objects.filter(user=request.user).delete()
        logout(request)

        return Response({'detail':'utilisateur deconnecté'},status=status.HTTP_200_OK)



class ProjetViewSet(ModelViewSet):
    serializer_class= ProjetSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):

        queryset = Projet.objects.all()
        return queryset
    
    
    






class ProjetViewSet(ModelViewSet):
    serializer_class= ProjetSerializer

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated ]
    #     return [permission() for permission in self.permission_classes]


    def get_queryset(self):

        queryset = Projet.objects.all()
        return queryset
    
    
    





class SemanticInferenceView(APIView):

    http_method_names = ["head","post"]

    nlp_fr = spacy.load("fr_core_news_md")
    nlp_en = spacy.load("en_core_web_md")

    def determine_type_by_regex(texte, regex_patterns):
        for type_entite, pattern in regex_patterns.items():
            if re.search(pattern, texte, re.IGNORECASE):
                return type_entite
        return None
    

    def post(self, request, *args, **kwargs):


        engine = create_engine(f'postgresql://{env("POSTGRES_USER")}:{env("POSTGRES_PASSWORD")}/{env("POSTGRES_DB")}')
        conn = engine.connect()

        # Définition des expressions régulières
        regex_patterns = {
            'EMAIL': r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
            'PHONE': r'\b\d{10}\b',
            'DATE': r'\b\d{1,2}/\d{1,2}/\d{4}\b|\b\d{4}-\d{1,2}-\d{1,2}\b|\b\d{1,2} (Janvier|Février|Mars|Avril|Mai|Juin|Juillet|Août|Septembre|Octobre|Novembre|Décembre) \d{4}\b',
            'ADDRESS': r'\b(?:Rue|Avenue|Boulevard|Place|Allée|Chemin|Voie|Quai|Square|Impasse)\s[A-Z][a-z]+(?:\s[A-Z][a-z]+)*\b',
            'POSTAL_CODE': r'\b\d{4,5}\b',
            'GENRE': r'\b(Femme|F|femme|f|Homme|H|homme|h|M|Mâle|male|Femelle|femelle|Unspecified|unspecified|Non-binary|non-binary|NB|nb)\b'
        }

        df = pd.read_sql_query(con=conn, sql=sql_text("SELECT * FROM CLIENTS"))

        # Compteur pour chaque type d'entité par colonne
        entites_par_colonne = {col: Counter() for col in df.columns}

        # Analyse des colonnes
        for col in df.columns:
            for item in df[col].dropna():
                texte = str(item).strip()
                if texte:

                    # Vérifier avec les regex
                    regex_type = SemanticInferenceView.determine_type_by_regex(texte, regex_patterns)
                    if regex_type:
                        entites_par_colonne[col][regex_type] += 1
                        continue

                    # Sinon, utiliser l'analyse NER
                    try:
                        langue = detect(texte) 
                        if langue != 'fr' and langue != 'en' :
                            langue = 'fr'
                    except LangDetectException:
                        langue = 'en'  

                    nlp = SemanticInferenceView.nlp_fr if langue == 'fr' else SemanticInferenceView.nlp_en
                    doc = nlp(texte)
                    for ent in doc.ents:
                        entites_par_colonne[col][ent.label_] += 1

        type_dominant_par_colonne = {col: entites.most_common(1)[0][0] if entites else 'Aucun' for col, entites in entites_par_colonne.items()}

        return Response({'result':type_dominant_par_colonne}, status=status.HTTP_200_OK)