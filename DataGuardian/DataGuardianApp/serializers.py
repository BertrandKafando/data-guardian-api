from rest_framework import serializers 
from .models import *
from django.contrib.auth.models import User, Permission
from django.contrib.contenttypes.models import ContentType
from rest_framework.exceptions import  NotFound
from drf_extra_fields.fields import Base64ImageField
import base64
import pandas as pd
import os
import pytz
from django.utils import timezone
from .utils import Base64
from django.core.files.base import ContentFile
from uuid import uuid4
import re



utc = pytz.UTC
now = timezone.now()
BASE_DIR = settings.BASE_DIR


class RoleSerializer(serializers.ModelSerializer):
    
    class Meta:
        model=Role
        fields=["nom_role","creation", "modification"]

class CompteSerializer(serializers.ModelSerializer):

    mot_de_passe=serializers.CharField(
        style={'input_type': 'password'}
    )

    class Meta:
        model=Compte
        fields=["identifiant","mot_de_passe"]
        extra_kwargs = {
            'identifiant': {'validators': []}
        }

    def create(self, validated_data):
        
        if not Compte.objects.filter(identifiant=validated_data.get("identifiant")).exists():

            user=User.objects.create_user(username=validated_data.get('identifiant'), password=validated_data.get('mot_de_passe'))
            content_type = ContentType.objects.get_for_model(Compte)
            permission = Permission.objects.filter(codename='is_customer').first()
            if permission:
                user.user_permissions.add(permission)
            else:
                created_permission = Permission.objects.create(codename='is_customer', name='is_customer', content_type=content_type)
                user.user_permissions.add(created_permission)

            return super(CompteSerializer,self).create(validated_data)
        else :
            raise serializers.ValidationError('Ce compte existe déja')


    def update(self, instance, validated_data, *args, **kwargs):

        if validated_data.get("identifiant")!=instance.identifiant and Compte.objects.filter(identifiant=validated_data.get("identifiant")).exists():
            raise serializers.ValidationError("Ce compte existe déja")

        user=User.objects.filter(username = instance.identifiant).first()
        compte_model=Compte.objects.filter(identifiant = instance.identifiant).first()

        if user :

            if 'mot_de_passe' in validated_data :

                if validated_data.get("mot_de_passe", None) != compte_model.mot_de_passe :
                    user.set_password(validated_data.get("mot_de_passe", None))
                    compte_model.mot_de_passe = make_password(validated_data.get("mot_de_passe"))
            
            if 'identifiant' in validated_data :

                user.username = validated_data.get("identifiant", compte_model.identifiant)
                compte_model.identifiant = validated_data.get("identifiant", compte_model.identifiant)
                
            user.save()
            compte_model.save()

        else :
            raise NotFound("cet utilisateur n\'existe pas!")

        return super(CompteSerializer, self).update(instance,validated_data)
    

class UtilisateurSerializer(serializers.ModelSerializer):
    
    compte = CompteSerializer(required=False)
    role= RoleSerializer()

    class Meta:
        model=Utilisateur
        fields=["id","compte","role","telephone","organisation","email","prenom","nom"]


    def create(self, validated_data):

        compte = None
        role = None

        if 'compte' in validated_data :
            compte = validated_data.pop('compte')
            compte_serializer= CompteSerializer(data=compte)
            if compte_serializer.is_valid():
                compte=compte_serializer.save()
        
        if Utilisateur.objects.filter(telephone=validated_data.get("telephone")).exists() :
            raise serializers.ValidationError({"detail" : 'Cet utilisateur existe déja'})

        if  Utilisateur.objects.filter(email=validated_data.get("email")).exists() :
            raise serializers.ValidationError({"detail" : 'Cet utilisateur existe déja'})


        if 'role' in validated_data :
            role = validated_data.pop("role")
            if Role.objects.filter(nom_role=role["nom_role"]).exists():
                role = Role.objects.filter(nom_role=role["nom_role"]).first()
            else :
                role  = Role.objects.create(**role)

        
        if compte is not None :

            identifiant = compte.identifiant
            user=User.objects.get(username=identifiant)
            content_type = ContentType.objects.get_for_model(Utilisateur)

            if role.nom_role == "Administrateur" :
                permission = Permission.objects.filter(codename='is_admin').first()
                if permission:
                    user.user_permissions.add(permission)
                else:
                    created = Permission.objects.create(codename='is_admin', name='is_admin', content_type=content_type)
                    user.user_permissions.add(created)

            elif role.nom_role == "Client" :
                permission = Permission.objects.filter(codename='is_customer').first()
                if permission:
                    user.user_permissions.add(permission)
                else:
                    created = Permission.objects.create(codename='is_customer', name='is_customer', content_type=content_type)
                    user.user_permissions.add(created)

            else :
                raise serializers.ValidationError({"detail" : 'Role invalide!'})



        utilisateur = Utilisateur.objects.create(
            compte=compte,
            role=role,
            date_mise_a_jour=now,
            **validated_data
        )

        return utilisateur



    def update(self, instance, validated_data,*args, **kwargs):  

        compte=None
        role=None

        if validated_data.get('telephone')!=instance.telephone and Utilisateur.objects.filter(telephone=validated_data.get("telephone")).exists():
            raise serializers.ValidationError('Ce numéro de téléphone existe déja existe déja')
        
        if validated_data.get('email')!=instance.email and Utilisateur.objects.filter(email=validated_data.get("email")).exists():
            raise serializers.ValidationError('Cette adresse email existe déja existe déja')

        if 'compte' in validated_data :
            compte = validated_data.pop('compte')
            compte.pop("mot_de_passe")

        if 'role' in validated_data :
            role = validated_data.pop('role')
        

        compte_serializer = CompteSerializer(data = compte, partial=True) 
        role_serializer = RoleSerializer(data = role, partial=True) 

        if compte_serializer.is_valid():
            compte_serializer.update(instance=instance.compte, validated_data=compte_serializer.validated_data)     
        
        if role_serializer.is_valid():
            role_serializer.update(instance=instance.role, validated_data=role_serializer.validated_data)  

        return super(UtilisateurSerializer,self).update(instance, validated_data)


class CritereSerializer(serializers.ModelSerializer):
    
    class Meta:
        model=Critere
        fields=["parametre_diagnostic"]



class BaseDeDonneesSerializer(serializers.ModelSerializer):
    class Meta:
        model = BaseDeDonnees
        fields = '__all__'


    EXT_MAPPING = {
        "xlsx": BaseDeDonnees.CSV,
        "xls": BaseDeDonnees.CSV,
        "csv": BaseDeDonnees.CSV,
        "sql": BaseDeDonnees.SQL,
        "txt": BaseDeDonnees.TEXT,
        "json": BaseDeDonnees.JSON,
        "xml": BaseDeDonnees.XML
    }

    def get_file_type(ext):
        return BaseDeDonneesSerializer.EXT_MAPPING.get(ext.lower(), None)


    def get_file_format(fichier_type):

        if fichier_type.upper() in ['CSV', 'SQL']:
            return 'Tabulaire'
        elif fichier_type.upper() in ['JSON', 'XML']:
            return 'Orienté objet'
        elif fichier_type.upper() == 'TEXT':
            return 'En colonne'
        else:
            return 'Format inconnu'
        
    def clean_table_name(name):
        # Remove all non-alphanumeric characters
        name = re.sub(r'[^0-9a-zA-Z_]', '_', name)
        print(name)
        return name
    
    


    def create(self, validated_data):

        fichier = validated_data.pop('fichier_bd', None)

        if fichier : 
            validated_data['nom_fichier'] = fichier.name
            validated_data['taille_fichier'] = str(round(fichier.size / (1024 * 1024), 6)) + "MB"
            time = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    ).replace(":", "").replace(".", "").replace(" ", "").replace("-", "")
            
            table_name = str(fichier.name.split('.')[0]) + "_" + time
            validated_data['nom_base_de_donnees'] = BaseDeDonneesSerializer.clean_table_name(table_name)
            extension = str(fichier.name.split('.')[-1])
            validated_data['type_fichier'] = BaseDeDonneesSerializer.get_file_type(extension)
            validated_data['format_fichier'] = BaseDeDonneesSerializer.get_file_format(extension)

        base_de_donnees = BaseDeDonnees.objects.create( 
            fichier_bd = fichier, 
            **validated_data
        )

        return base_de_donnees
    

    def update(self, instance, validated_data):
        
        fichier = validated_data.pop('fichier_bd', None)
         
        if fichier:
            validated_data['nom_fichier'] = fichier.name
            validated_data['taille_fichier'] = str(round(fichier.size / (1024 * 1024), 6)) + "MB"

        instance.nom_base_de_donnees = validated_data.get('nom_base_de_donnees', instance.nom_base_de_donnees)
        instance.descriptif = validated_data.get('descriptif', instance.descriptif)
        instance.type_fichier = validated_data.get('type_fichier', instance.type_fichier)
        instance.format_fichier = validated_data.get('format_fichier', instance.format_fichier)
        instance.separateur = validated_data.get('separateur', instance.separateur)
        instance.avec_entete = validated_data.get('avec_entete', instance.avec_entete)

        if fichier:
            instance.fichier_bd = fichier 

        instance.save()
        return instance
    

class DiagnosticSerializer(serializers.Serializer):

    parametre_diagnostic = serializers.CharField(required=False)
    base_de_donnees = BaseDeDonneesSerializer(required=False)

    class Meta:
        fields='__all__'


    def update(self, instance, validated_data):

        instance.parametre_diagnostic.set(validated_data.get('parametre_diagnostic', instance.criteres.all()))
        base_de_donnees_data = validated_data.get('base_de_donnees', None)

        if base_de_donnees_data :

            if base_de_donnees_data.get("fichier_bd", None) :

                instance.base_de_donnees = validated_data.get('base_de_donnees', instance.base_de_donnees)

            else :
                # On a un select de la BD et non un upload
                # TODO : récuperer la base de données grace à son nom et l'utilisateur qui l'avait uploadé : query on Diagnostic -> base_de_donnees & utilisateur
                pass


        instance.save()

        return instance
    

class MetaTableSerializer(serializers.ModelSerializer):

    class Meta:
        model = MetaTable
        fields = '__all__'


class MetaAnomalieSerializer(serializers.ModelSerializer):

    class Meta:
        model = MetaAnomalie
        fields = '__all__'


class MetaTousContraintesSerializer(serializers.ModelSerializer):

    class Meta:
        model = MetaTousContraintes
        fields = '__all__'


class MetaColonneSerializer(serializers.ModelSerializer):

    meta_anomalie = MetaAnomalieSerializer(many=True)
    contraintes = MetaTousContraintesSerializer(many=True)

    class Meta:
        model = MetaColonne
        fields = '__all__'
        
class ProjetSerializer(serializers.ModelSerializer):

    class Meta:
        model = Projet
        fields = '__all__'
