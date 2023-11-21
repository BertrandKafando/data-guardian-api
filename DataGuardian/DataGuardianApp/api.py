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
from .utils import Base64
import os
from django.core.files.base import ContentFile
from rest_framework.views import APIView
from django.db.models import Q
import pandas as pd
from django.conf import settings
import environ
import json
from django.db import transaction



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


    def get_queryset(self):

        base_de_donnees = self.request.query_params.get('base_de_donnees')

        if base_de_donnees:
            
            queryset = BaseDeDonnees.objects.filter(nom_base_de_donnees__icontains=base_de_donnees)

            return queryset

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
    


class DiagnosticViewSet(ModelViewSet):
    serializer_class= DiagnosticSerializer

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

        user = self.request.user
        print(user)
        current_user = Utilisateur.objects.filter(
            compte__identifiant=user.username
        ).first()

        if current_user :
            
            queryset = Diagnostic.objects.filter(Utilisateur=current_user)
        
        else : 

            queryset = Diagnostic.objects.all()


        return queryset
    

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
    

class MetaSpecialCarViewSet(ModelViewSet):
    serializer_class= MetaSpecialCarSerializer

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

        queryset = MetaSpecialCar.objects.all()
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