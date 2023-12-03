from django.db import models
from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator, FileExtensionValidator, RegexValidator
from django.utils.timezone import now
from django.contrib.auth.hashers import make_password
import os
import datetime
from django.utils import timezone

class Compte(models.Model):

    identifiant = models.CharField(max_length = 100, unique=True)
    mot_de_passe = models.CharField(max_length = 100)

    def save(self, *args, **kwargs):
        self.mot_de_passe = make_password(self.mot_de_passe)
        super(Compte, self).save(*args, **kwargs)

    def __str__(self):
        return str(self.identifiant)

    __repr__=__str__
    

class Role(models.Model):

    ADMINISTRATEUR = 'Administrateur'
    CLIENT = 'Client'

    CHOIX_ROLE = [
        (ADMINISTRATEUR, 'Administrateur'),
        (CLIENT, 'Client')
    ]

    nom_role = models.CharField(
        max_length = 100,
        choices=CHOIX_ROLE
    )
    creation = models.DateTimeField(auto_now_add=True)
    modification = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return str(self.nom_role)

    __repr__=__str__


class Utilisateur(models.Model):

    phone_regex=RegexValidator(regex=r'^([+]){0,}[- ]{0,}([0-9{1,}])[- ]{0,}([0-9]{1,})[- ]{0,}([0-9]{1,}[- ]{0,}){1,}$', message="le numero de telephone est invalide!") #phone number validator
    telephone = models.CharField(validators=[phone_regex],max_length = 100)
    email = models.CharField(max_length = 100, null=True, blank=True)
    prenom = models.CharField(max_length = 100)
    nom = models.CharField(max_length = 100)
    organisation = models.CharField(max_length = 100, null=True, blank=True)
    is_email_verified = models.BooleanField(default=False)
    date_creation = models.DateTimeField(auto_now_add=True)
    date_mise_a_jour = models.DateTimeField(default=datetime.datetime.now)
    role = models.ForeignKey(Role,related_name="utilisateur", on_delete=models.CASCADE)
    compte = models.ForeignKey(Compte,related_name="utilisateur", on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return str(self.prenom)

    __repr__=__str__


class Critere(models.Model):

    VAL_MANQ = 'VAL_MANQ'
    VAL_MANQ_CONTRAINTS = 'VAL_MANQ_CONTRAINTS'
    VAL_MANQ_CONTRAINTS_FN = 'VAL_MANQ_CONTRAINTS_FN'
    VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS = 'VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS'
    ALL = 'ALL'

    CHOIX_PARAMETRE = [
        (VAL_MANQ, 'VAL_MANQ'),
        (VAL_MANQ_CONTRAINTS, 'VAL_MANQ_CONTRAINTS'),
        (VAL_MANQ_CONTRAINTS_FN, 'VAL_MANQ_CONTRAINTS_FN'),
        (VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS, 'VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS'),
        (ALL, 'ALL'),
    ]

    parametre_diagnostic = models.CharField(max_length=100, choices=CHOIX_PARAMETRE)

    def __str__(self):
        return str(self.parametre_diagnostic)

    __repr__=__str__
    

class Projet(models.Model):

    nom_projet = models.CharField(max_length=100)
    date_creation = models.DateTimeField(auto_now_add=True)
    date_mise_a_jour = models.DateTimeField(default=datetime.datetime.now)
    descriptif = models.TextField(null=True, blank=True)
    utilisateur = models.ForeignKey(Utilisateur, related_name="projet", on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return self.nom_projet

    __repr__ = __str__


   
class BaseDeDonnees(models.Model):

    SQL = 'SQL'
    TEXT = 'TEXT'
    JSON = 'JSON'
    CSV ='CSV'
    XML = 'XML'

    CHOIX_FICHIER = [
        (SQL, 'SQL'),
        (TEXT, 'TEXT'),
        (JSON, 'JSON'),
        (CSV, 'CSV'),
        (XML, 'XML'),
    ]


    TABULAIRE = 'Tabulaire'
    ORIENTE_OBJET = 'Oriente objet'
    EN_COLONNE = 'En colonne'

    CHOIX_FORMAT_FICHIER = [
        (TABULAIRE, 'Tabulaire'),
        (ORIENTE_OBJET, 'Oriente objet'),
        (EN_COLONNE, 'En colonne')
    ]


    VIRGULE = 'Virgule'
    POINT_VIRGULE = 'Point virgule'
    TABULATION = 'Tabulation'

    CHOIX_SEPARATEUR_FICHIER = [
        (VIRGULE, 'Virgule'),
        (POINT_VIRGULE, 'Point virgule'),
        (TABULATION, 'Tabulation')
    ]

    nom_base_de_donnees = models.CharField(max_length=100)
    date_creation = models.DateTimeField(auto_now_add=True)
    date_mise_a_jour = models.DateTimeField(default=datetime.datetime.now)
    descriptif = models.TextField(null=True, blank=True)
    type_fichier = models.CharField(max_length=100, choices=CHOIX_FICHIER)
    nom_fichier = models.CharField(max_length=100, blank=True)
    taille_fichier = models.CharField(max_length=100, blank=True)
    format_fichier = models.CharField(max_length=100, choices=CHOIX_FORMAT_FICHIER)
    separateur = models.CharField(max_length=100, choices=CHOIX_SEPARATEUR_FICHIER)
    avec_entete = models.BooleanField(default=True)
    fichier_bd = models.FileField(
            upload_to='uploaded_db/',
            validators=[
                FileExtensionValidator(
                    allowed_extensions=["xlsx", "xls", "csv", "sql", "txt", "json", "xml"]
                )
            ],
        )
    
    Projet = models.ForeignKey(Projet,related_name="base_de_donnees", on_delete=models.CASCADE, null=True, blank=True)


    def __str__(self):
        return self.nom_base_de_donnees
    
    __repr__=__str__


class Diagnostic(models.Model):

    TERMINE = 'Termine'
    AVORTE = 'Avorte'
    ECHEC = 'Echec'

    CHOIX_STATUS = [
        (TERMINE, 'Termine'),
        (AVORTE, 'Avorte'),
        (ECHEC, 'Echec')
    ]


    date_analyse = models.DateTimeField(auto_now_add=True)
    status = models.CharField(
        max_length = 100,
        choices=CHOIX_STATUS
    )
    Utilisateur = models.ForeignKey(Utilisateur,related_name="diagnostic", on_delete=models.CASCADE, null=True, blank=True)
    parametre_diagnostic = models.ForeignKey(Critere, related_name='diagnostic', on_delete=models.CASCADE, blank=True)
    base_de_donnees = models.ForeignKey(BaseDeDonnees,related_name="diagnostic", on_delete=models.CASCADE, null=True, blank=True)
    

    def __str__(self):
        return str(self.date_analyse)

    __repr__=__str__


class MetaTable(models.Model):

    base_de_donnees = models.ForeignKey(BaseDeDonnees,related_name="meta_table", on_delete=models.CASCADE, null=True, blank=True)
    nom_table = models.CharField(max_length=100)
    date_creation = models.DateTimeField(auto_now_add=True)
    nombre_colonnes = models.IntegerField(null=True, blank=True)
    nombre_lignes = models.IntegerField(null=True, blank=True)
    commentaire = models.TextField(null=True, blank=True)

    def __str__(self):
        return self.nom_table


# class MetaSpecialCar(models.Model):

#     caracteres_speciaux = models.CharField(max_length=500)

#     def __str__(self):
#         return self.caracteres_speciaux
    
class MetaTousContraintes(models.Model):
    nom_contrainte = models.CharField(max_length=100)
    category = models.CharField(max_length=300, null=True, blank=True)
    contrainte = models.CharField(max_length=500, null=True, blank=True)
    commentaire = models.CharField(max_length=300, null=True, blank=True)

    def __str__(self):
        return self.nom_contrainte
    

class MetaAnomalie(models.Model):
    nom_anomalie = models.CharField(max_length=50)
    valeur_trouvee = models.CharField(max_length=300, null=True, blank=True)

    def __str__(self):
        return self.nom_anomalie
    

class MetaColonne(models.Model):
    
    nom_colonne = models.CharField(max_length=200)
    type_donnees = models.CharField(max_length=200)
    date_creation = models.DateTimeField(auto_now_add=True)
    date_diagnostic = models.DateField(null=True, blank=True)
    nombre_valeurs = models.IntegerField(null=True, blank=True)
    nombre_valeurs_manquantes = models.IntegerField(null=True, blank=True)
    nombre_outliers = models.IntegerField(null=True, blank=True)
    semantique = models.CharField(max_length=100, null=True, blank=True)
    langue = models.CharField(max_length=100, null=True, blank=True)
    nombre_anomalies = models.IntegerField(null=True, blank=True)
    nombre_majuscules = models.IntegerField(null=True, blank=True)
    nombre_minuscules = models.IntegerField(null=True, blank=True)
    nombre_init_cap = models.IntegerField(null=True, blank=True)
    col_min = models.CharField(max_length=100, null=True, blank=True)
    col_max = models.CharField(max_length=100, null=True, blank=True)
    meta_table = models.ForeignKey(MetaTable,related_name="meta_colonne", on_delete=models.CASCADE, null=True, blank=True)
    #meta_special_car = models.ForeignKey(MetaSpecialCar,related_name="meta_colonne", on_delete=models.CASCADE, null=True, blank=True)
    meta_anomalie = models.ForeignKey(MetaAnomalie,related_name="meta_colonne", on_delete=models.CASCADE, null=True, blank=True)
    contraintes = models.ManyToManyField(MetaTousContraintes, related_name='meta_colonne', symmetrical=False, blank=True)

    def __str__(self):
        return self.nom_colonne
    
    

