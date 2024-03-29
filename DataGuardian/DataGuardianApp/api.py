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
from .utils import Base64, DBFunctions, DataInsertionStep
import os
from .utils import Base64, DBFunctions, DBTypesDetection,DBCorrection
import os
import datetime
from django.core.files.base import ContentFile
from rest_framework.views import APIView
from django.db.models import Q
from django.conf import settings
import environ
import json
from django.db import transaction
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from langdetect import detect, LangDetectException
from collections import Counter
import re
import pandas as pd
from sqlalchemy import create_engine, text
from django.http import HttpResponse
import csv



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
        project_id = self.request.query_params.get('project_id') # Ajout du paramètre project_id

        queryset = BaseDeDonnees.objects.all()

        if base_de_donnees:
            
            queryset = queryset.filter(nom_base_de_donnees__icontains=base_de_donnees)   
            
        if project_id:  # Filtrer par project_id s'il est présent

            queryset = queryset.filter(projet_id=int(project_id))   

        return queryset


    def destroy(self, request, *args, **kwargs):

        base_de_donnees = self.get_object()
        if base_de_donnees.fichier_bd :
            
            file_path = base_de_donnees.fichier_bd.path
            if os.path.exists(file_path):
                os.remove(file_path)

        base_de_donnees.delete()

        return Response(status=status.HTTP_204_NO_CONTENT) 
    

    def create(self, request, *args, **kwargs):
            
            fichier_bd = request.data.get("fichier_bd", None)
            project_id = request.data.get("projet", None)  # Récupérer l'ID du projet
            base_de_donnees_serializer=BaseDeDonneesSerializer(data=request.data)
            
            if not base_de_donnees_serializer.is_valid():
                return Response({'detail': 'Données invalides'}, status = status.HTTP_400_BAD_REQUEST)
            #TODO
            # Vérifier si l'ID du projet est présent dans la requête
            
            return Response(base_de_donnees_serializer.data, status=status.HTTP_201_CREATED)
    


class DiagnosticViewSet(APIView):

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "POST":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "PUT" or self.request.method == "PATCH":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     elif self.request.method == "DELETE":
    #         self.permission_classes= [IsCustomerAuthenticated | IsAdminAuthenticated ]
    #     return [permission() for permission in self.permission_classes]

    serializer_class = DiagnosticSerializer 


    def exec_val_manq_logic():
        pass


    def exec_val_manq_constraints_logic():
        pass


    def exec_val_manq_constraints_fn_logic():
        pass


    def exec_val_manq_constraints_fn_duplications_logic():
        pass


    def exec_all_params_logic():
        pass


    def get(self, request):

        bd_id = int(self.request.query_params.get('bd_id'))
        if bd_id : 

            bd_instance = BaseDeDonnees.objects.get(id=bd_id)
            queryset = Diagnostic.objects.filter(base_de_donnees=bd_instance)
        
        else : 

            queryset = Diagnostic.objects.all()

        serializer = DiagnosticSerializer(queryset, many=True)
        response_data = serializer.data

        return Response(response_data,status=status.HTTP_200_OK)
        

    @swagger_auto_schema(request_body=DiagnosticSerializer)
    def post(self, request, *args, **kwargs):

        diagnostic_serializer=DiagnosticSerializer(data=request.data)

        if not diagnostic_serializer.is_valid():
            return Response({'detail': 'Données invalides'}, status = status.HTTP_400_BAD_REQUEST)

        diagnostic_data = diagnostic_serializer.data

        parametre_diagnostic = diagnostic_data.pop("parametre_diagnostic")

        diagnostic_data = DBFunctions.extract_nested_data(request)

        connected_user = request.user

        base_de_donnees_data = diagnostic_data.pop('base_de_donnees', None)

        if base_de_donnees_data :
            if fichier_bd :

                base_de_donnees_serializer = BaseDeDonneesSerializer(
                        data=base_de_donnees_data
                    )
                base_de_donnees_serializer.is_valid(raise_exception=True)
                base_de_donnees = base_de_donnees_serializer.save()
            else : 
                
                # On a un select de la BD et non un upload
                # TODO : récuperer la base de données grace à son nom et l'utilisateur qui l'avait uploadé : query on Diagnostic -> base_de_donnees & utilisateur
                pass

            critere_instance = Critere.objects.get_or_create(
                parametre_diagnostic=parametre_diagnostic
            )

            if isinstance(critere_instance, tuple):
                critere_instance = critere_instance[0]
             
            diagnostic = Diagnostic.objects.create(
                base_de_donnees=base_de_donnees,
                parametre_diagnostic = critere_instance
            )
            chemin_fichier_csv = base_de_donnees.fichier_bd.path
            separateur = DataInsertionStep.separateur(
                base_de_donnees.separateur)
            # chemin_fichier, sep, header=False, table_name='', type_file='CSV'
            table_creation_result, df, db_name = DataInsertionStep.data_insertion(
                chemin_fichier_csv, separateur, base_de_donnees.avec_entete, base_de_donnees.nom_base_de_donnees, base_de_donnees.type_fichier)


            if table_creation_result == 0 :

                nom_bd = base_de_donnees.nom_base_de_donnees
                meta_table = MetaTable()
                meta_table.base_de_donnees = base_de_donnees
                meta_table.nom_table = base_de_donnees.nom_base_de_donnees

                result_nb_rows = DBFunctions.executer_fonction_postgresql('NombreDeLignes', base_de_donnees.nom_base_de_donnees)
                result_nb_cols = DBFunctions.executer_fonction_postgresql('NombreDeColonnes', base_de_donnees.nom_base_de_donnees)

                if type(result_nb_rows) != int :
                    meta_table.nombre_lignes = result_nb_rows[0]

                if type(result_nb_cols) != int :
                    meta_table.nombre_colonnes = result_nb_cols[0]

                meta_table.save()


                """récupérer les types sémantiques"""
                columns_types =  DBTypesDetection.detect_columns_type(df[df.columns[1:]])
                # print(columns_types)
                #columns_types = {'Column_0': 'UNKNOWN', 'Column_1': 'civilite', 'Column_2': 'UNKNOWN', 'Column_3': 'UNKNOWN', 'Column_4': 'UNKNOWN', 'Column_5': 'numerique', 'Column_6': 'UNKNOWN', 'Column_7': 'numerique', 'Column_8': 'ville', 'Column_9': 'pays', 'Column_10': 'email', 'Column_11': 'phone', 'Column_12': 'date', 'Column_13': 'date', 'Column_14': 'groupe_sanguin', 'Column_15': 'UNKNOWN'}
                #columns_types = {'Employee': 'UNKNOWN', 'Amount':'numerique'}

                #Diagnostic concernant tous les types
                #vérifier les valeurs manquantes
                
                #compter les doublons

                #ok
                if parametre_diagnostic == "VAL_MANQ" :
                    meta_cols_instance_nulls = DBFunctions.check_nulls(df.columns, meta_table, nom_bd,diagnostic)
                    DBFunctions.compute_score(meta_cols_instance_nulls, base_de_donnees)
                    DBFunctions.updateType(meta_cols_instance_nulls, columns_types)


                if parametre_diagnostic == "VAL_MANQ_CONTRAINTS" :

                    meta_cols_instance_nulls = DBFunctions.check_nulls(df.columns, meta_table, nom_bd,diagnostic)

                    meta_cols_instances_with_constraints = DBFunctions.check_constraints(meta_cols_instance_nulls, nom_bd,diagnostic=diagnostic, columns_types=columns_types, df=df)

                    DBFunctions.compute_score(meta_cols_instances_with_constraints, base_de_donnees)

                    DBFunctions.updateType(meta_cols_instances_with_constraints, columns_types)


                if parametre_diagnostic == "VAL_MANQ_CONTRAINTS_FN" :

                    meta_cols_instance_nulls = DBFunctions.check_nulls(df.columns, meta_table, nom_bd,diagnostic)

                    meta_cols_instances_with_constraints = DBFunctions.check_constraints(meta_cols_instance_nulls, nom_bd,diagnostic=diagnostic, columns_types=columns_types, df=df)

                    meta_cols_instances_fn = DBFunctions.check_1FN(meta_cols_instances_with_constraints, nom_bd)

                    DBFunctions.compute_score(meta_cols_instances_fn, base_de_donnees)

                    DBFunctions.updateType(meta_cols_instances_fn, columns_types)


                if parametre_diagnostic == "VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS" :

                    meta_cols_instance_nulls = DBFunctions.check_nulls(df.columns, meta_table, nom_bd,diagnostic)

                    meta_cols_instances_with_constraints = DBFunctions.check_constraints(meta_cols_instance_nulls, nom_bd,diagnostic=diagnostic, columns_types=columns_types, df=df)

                    meta_cols_instances_fn = DBFunctions.check_1FN(meta_cols_instances_with_constraints, nom_bd)

                    attributsCles = ', '.join(df.columns)

                    DBFunctions.count_doublons_with_pandas(meta_table, df, nom_bd, diagnostic)

                    # TODO COUNT SIMILAIRE

                    DBFunctions.compute_score(meta_cols_instances_fn, base_de_donnees)

                    DBFunctions.updateType(meta_cols_instances_fn, columns_types)


                if parametre_diagnostic == "ALL" :                    
                    # All
                    """
                    - check_nulls
                    - doublons & similaires
                    - 1FN   
                    - repetition de colonnes
                    """
                    
                    # Number if
                    """
                    - check_outliers
                    """

                    # Date
                    """
                     - format incohérent
                     - valeurs hors limite
                    """

                    # String
                    """
                    check_contraints:espaces superflus, repitions de lettres
                    - Get Semantics (EMAIL,NUMERIC,DATE,TELEPHONE,PAYS,VILLE,ADRESSE,CONTIENT)
                        - EMAIL : 
                            check format
                            check_contraints:Email
                            repitions de lettres
                        - NUMERIC :
                            check les types
                        - DATE :
                            format incohérent
                        - TELEPHONE :
                            check format
                            check_contraints:Telephone
                        - PAYS :
                            check fction anomalie
                        - VILLE :
                            check fction anomalie
                        - CONTINENT :
                            check fction anomalie
                        - ADRESSE :

                        - MONTANT :
                            check fction anomalie

                        -UNKNOWN :
                            - get_other_stats
                            - check_contraints
                        
                    """

                    #all types
                    meta_cols_instance_nulls = DBFunctions.check_nulls(df.columns, meta_table, nom_bd,diagnostic)

                    meta_cols_instances_with_constraints = DBFunctions.check_constraints(meta_cols_instance_nulls, nom_bd,diagnostic=diagnostic, columns_types=columns_types, df=df)

                    meta_cols_instances_fn = DBFunctions.check_1FN(meta_cols_instances_with_constraints, nom_bd)

                    meta_cols_repetitions = DBFunctions.check_cols_repetitions(meta_cols_instances_fn, nom_bd)
                    
                    meta_cols_outliers = DBFunctions.check_outliers(meta_cols_repetitions, nom_bd,diagnostic,df, columns_types)


                    attributsCles = ', '.join(df.columns)

                    DBFunctions.count_doublons_with_pandas(meta_table, df, nom_bd, diagnostic)
                    
                    meta_cols_others = DBFunctions.get_other_stats(meta_cols_outliers, nom_bd)

                    meta_cols_general_constraints = DBFunctions.check_general_constraints(meta_cols_others, nom_bd, diagnostic, columns_types = columns_types)


                    DBFunctions.compute_score(meta_cols_general_constraints, base_de_donnees)

                    DBFunctions.updateType(meta_cols_general_constraints, columns_types)

                    #DBFunctions.check_funtional_dependancies(meta_cols_others, nom_bd)


                

                diagnostic.status = Diagnostic.TERMINE
                diagnostic_data = DiagnosticSerializer(diagnostic).data

                return Response({
                    "diagnostic" : diagnostic_data
                }, status=status.HTTP_200_OK)

            else :
                diagnostic.status = Diagnostic.ECHEC
                diagnostic_data = DiagnosticSerializer(diagnostic).data

                return Response({
                    "diagnostic" : diagnostic_data
                }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


 


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

        bd_id = self.request.query_params.get('bd_id')

        if bd_id:
            queryset = MetaTable.objects.filter(base_de_donnees=bd_id)
        else:
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
    
class ScoreDiagnosticViewSet(ModelViewSet):
    serializer_class= ScoreDiagnosticSerializer

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

        bd_id = self.request.query_params.get('bd_id')

        if bd_id:
            queryset = ScoreDiagnostic.objects.filter(bdd=bd_id)
        else:
           queryset = ScoreDiagnostic.objects.all()
        
    
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

        meta_table_id = self.request.query_params.get('meta_table_id')

        if meta_table_id:
            queryset = MetaColonne.objects.filter(meta_table=meta_table_id)
        else:
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

        token, _ = Token.objects.get_or_create(user = user)

        #token_expire_handler will check, if the token is expired it will generate new one
        is_expired, token = token_expire_handler(token)   
        user_serialized = UtilisateurSerializer(user_instance)
        permission = list(user.get_all_permissions())[0]
        user_instance_data = user_serialized.data
        user_instance_data["identifiant"]=authentication_serializer.data.get("identifiant")
        user_instance_data.pop('compte', None)
        user_instance_data.pop('email', None)
        user_instance_data.pop('telephone', None)

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

        user = self.request.user
        current_user = Utilisateur.objects.filter(
            compte__identifiant=user.username
        ).first()
 
        if current_user:
            queryset = Projet.objects.filter(utilisateur=current_user)
        else:
            queryset = Projet.objects.all()

        return queryset


class DiagnosticDetailViewSet(ModelViewSet):
    http_method_names = ["head","get"]
    serializer_class= DiagnosticDetailSerializer
    pagination_class = None

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
        
       bd_id = self.request.query_params.get('bd_id')
       if bd_id:
           bd = BaseDeDonnees.objects.filter(id=bd_id).first()
           diagnostic = Diagnostic.objects.filter(base_de_donnees=bd).first()
           diagnostic_id = diagnostic.id

           if diagnostic_id:
             queryset = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id)
           else:
                queryset = DiagnosticDetail.objects.all()
           return queryset


class GetUserDataView(APIView):
    http_method_names = ["head","get"]

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsAuthenticated]


    def get(self, request, *args, **kwargs):


        from sqlalchemy import create_engine, text
        from urllib.parse import quote

        db_id = self.request.query_params.get('db_id')
        #diagnostic_id = self.request.query_params.get('diagnostic_id')

        if db_id :

            user_db = BaseDeDonnees.objects.filter(id=db_id).first()
            if user_db:
                pwd = quote(env('POSTGRES_LOCAL_DB_PASSWORD'))  
                connection_string = f"postgresql+psycopg2://{env('POSTGRES_LOCAL_DB_USERNAME')}:{pwd}@{env('DATABASE_LOCAL_HOST')}:{env('DB_PORT')}/{env('POSTGRES_DB')}"
                engine = create_engine(connection_string)
                conn = engine.connect()
                query = text(f'SELECT * FROM {user_db.nom_base_de_donnees} ORDER BY {user_db.nom_base_de_donnees}_id ASC')
                df = pd.read_sql_query(query, conn)

                # Convertir le DataFrame en chaîne JSON, puis en objet Python
                data_json = df.to_json(orient='records', lines=False)
                data = json.loads(data_json)

                return Response(data, status=status.HTTP_200_OK)
            else:
                return Response({'detail': 'Base de données introuvable.'}, status=status.HTTP_404_NOT_FOUND)

        return Response({'detail': 'Paramètre db_id manquant.'}, status=status.HTTP_400_BAD_REQUEST)
    


class ApplyCorrectionView(APIView):
    http_method_names = ["head","get"]
    serializer_class= DiagnosticDetailSerializer
    pagination_class = None

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

    def get(self, request, *args, **kwargs):
        
       bd_id = self.request.query_params.get('bd_id')
       if bd_id:
           bd = BaseDeDonnees.objects.filter(id=bd_id).first()

           # copy la base de données orginale
           DBCorrection.copy_database(bd.nom_base_de_donnees)
           diagnostic = Diagnostic.objects.filter(base_de_donnees=bd).first()
           diagnostic_id = diagnostic.id

           if diagnostic_id:
             queryset_nulls = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="VALEUR_NULL")
             df = pd.DataFrame(list(queryset_nulls.values()))
             DBCorrection.update_database_null_value(df, bd.nom_base_de_donnees)

             queryset_outliers = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="DETECTION_VALEUR_ABERANTE")
             df = pd.DataFrame(list(queryset_outliers.values()))
             DBCorrection.update_database_outlier_by_mean(df, bd.nom_base_de_donnees)

             queryset_spaces = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="ESPACES_SUPERFLUS")
             df = pd.DataFrame(list(queryset_spaces.values()))
             DBCorrection.update_database_remove_spaces(df, bd.nom_base_de_donnees)

             queryset_doublons = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="DOUBLONS")
             df = pd.DataFrame(list(queryset_doublons.values()))
             DBCorrection.update_database_delete_doublons(df, bd.nom_base_de_donnees)

             queryset_special_caracteres = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="CARACTERES_SPECIAUX")
             df = pd.DataFrame(list(queryset_special_caracteres.values()))
             DBCorrection.removes_speciales_caracteres(df, bd.nom_base_de_donnees)




             queryset_email = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="EMAIL_INCORRECTE")
             df = pd.DataFrame(list(queryset_email.values()))
             DBCorrection.removes_invalid_emails(df, bd.nom_base_de_donnees)
             DBCorrection.string_to(df, bd.nom_base_de_donnees, DBCorrection.string_to_lower)



             queryset_countries = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="PAYS_INCONNU_OU_MAL_ECRIT")
             df = pd.DataFrame(list(queryset_countries.values()))
             DBCorrection.fix_countries_errors(df, bd.nom_base_de_donnees)
             

             queryset_cities = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="VILLE_INCONNU_OU_MAL_ECRIT")
             df = pd.DataFrame(list(queryset_cities.values()))
             DBCorrection.fix_errors_based_on(df, bd.nom_base_de_donnees, 'bf_ville', 'nom_ville_fr')
             DBCorrection.string_to(df, bd.nom_base_de_donnees, DBCorrection.string_to_capitalize)



             queryset_civilities = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="CIVILITE_INCONNU")
             df = pd.DataFrame(list(queryset_civilities.values()))
             DBCorrection.fix_errors_based_on(df, bd.nom_base_de_donnees, 'bf_civilite', 'civilite')
             DBCorrection.string_to(df, bd.nom_base_de_donnees, DBCorrection.string_to_capitalize)


             queryset_blood_group = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="GROUPE_SANGUIN_INCONNU")
             df = pd.DataFrame(list(queryset_blood_group.values()))
             DBCorrection.fix_errors_based_on(df, bd.nom_base_de_donnees, 'bf_groupe_sanguin', 'groupe')
             DBCorrection.string_to(df, bd.nom_base_de_donnees, DBCorrection.string_to_upper)

           

             queryset_invalides_numerics_values = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, anomalie="VALEUR_NUMERIQUE_INCORRECTE")
             df = pd.DataFrame(list(queryset_invalides_numerics_values.values()))
             DBCorrection.fix_invalides_numerical_values(df, bd.nom_base_de_donnees)

             # homogénisation des types inconnus:
             # les colonnes de type string et non reconnu dans les types sémantiques seront en init cap
             queryset_unknown_type = DiagnosticDetail.objects.filter(diagnostic=diagnostic_id, type_colonne="UNKNOWN")
             df = pd.DataFrame(list(queryset_unknown_type.values()))
             DBCorrection.string_to(df, bd.nom_base_de_donnees, DBCorrection.string_to_capitalize)



             # retourner la table corrigé
             conn = DBCorrection.connect_to_database()
             query = text(f'SELECT * FROM {bd.nom_base_de_donnees} ORDER BY {bd.nom_base_de_donnees}_id ASC')
             df = pd.read_sql_query(query, conn)

                # Convertir le DataFrame en chaîne JSON, puis en objet Python
             data_json = df.to_json(orient='records', lines=False)
             data = json.loads(data_json)

             conn.close()

             return Response(data, status=status.HTTP_200_OK)

           else:
                queryset = DiagnosticDetail.objects.all()
           return queryset
       

class DownloadDataView(APIView):
    http_method_names = ["head","get"]

    # def get_permissions(self):
    #     if self.request.method == "GET":
    #         self.permission_classes = [IsAuthenticated]


    def get(self, request, *args, **kwargs):


        from sqlalchemy import create_engine, text
        from urllib.parse import quote

        db_id = self.request.query_params.get('bd_id')
        #diagnostic_id = self.request.query_params.get('diagnostic_id')

        if db_id :

            user_db = BaseDeDonnees.objects.filter(id=db_id).first()
            if user_db:
                pwd = quote(env('POSTGRES_LOCAL_DB_PASSWORD'))  
                connection_string = f"postgresql+psycopg2://{env('POSTGRES_LOCAL_DB_USERNAME')}:{pwd}@{env('DATABASE_LOCAL_HOST')}:{env('DB_PORT')}/{env('POSTGRES_DB')}"
                engine = create_engine(connection_string)
                conn = engine.connect()
                query = text(f'SELECT * FROM {user_db.nom_base_de_donnees} ORDER BY {user_db.nom_base_de_donnees}_id ASC')
                df = pd.read_sql_query(query, conn)

                df = df[df.columns[1:]]

                filename = user_db.nom_base_de_donnees.split('_')[0] + "_correction.csv"

                response = HttpResponse(content_type='text/csv')
                response['Content-Disposition'] = f"attachment; filename={filename}"  # Correct header name


                df.to_csv(path_or_buf=response, index=False, quoting=csv.QUOTE_ALL)


                return response
            else:
                return Response({'detail': 'Base de données introuvable.'}, status=status.HTTP_404_NOT_FOUND)

        return Response({'detail': 'Paramètre db_id manquant.'}, status=status.HTTP_400_BAD_REQUEST)
    
