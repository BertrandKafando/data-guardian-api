import datetime
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='BaseDeDonnees',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom_base_de_donnees', models.CharField(max_length=100)),
                ('date_creation', models.DateTimeField(auto_now_add=True)),
                ('date_mise_a_jour', models.DateTimeField(default=datetime.datetime.now)),
                ('descriptif', models.TextField(blank=True, null=True)),
                ('type_fichier', models.CharField(choices=[('SQL', 'SQL'), ('TEXT', 'TEXT'), ('JSON', 'JSON'), ('CSV', 'CSV'), ('XML', 'XML')], max_length=100)),
                ('nom_fichier', models.CharField(blank=True, blank=True, max_length=100)),
                ('taille_fichier', models.CharField(blank=True, blank=True, max_length=100)),
                ('format_fichier', models.CharField(choices=[('Tabulaire', 'Tabulaire'), ('Oriente objet', 'Oriente objet'), ('En colonne', 'En colonne')], max_length=100)),
                ('separateur', models.CharField(choices=[('Virgule', 'Virgule'), ('Point virgule', 'Point virgule'), ('Tabulation', 'Tabulation')], max_length=100)),
                ('avec_entete', models.BooleanField(default=True)),
                ('fichier_bd', models.FileField(upload_to='uploaded_db/', validators=[django.core.validators.FileExtensionValidator(allowed_extensions=['xlsx', 'xls', 'csv', 'sql', 'txt', 'json', 'xml'])])),
                ('fichier_bd', models.FileField(upload_to='uploaded_db/', validators=[django.core.validators.FileExtensionValidator(allowed_extensions=['xlsx', 'xls', 'csv', 'sql', 'txt', 'json', 'xml'])])),
            ],
        ),
        migrations.CreateModel(
            name='Compte',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('identifiant', models.CharField(max_length=100, unique=True)),
                ('mot_de_passe', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Critere',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('parametre_diagnostic', models.CharField(choices=[('VAL_MANQ', 'VAL_MANQ'), ('VAL_MANQ_CONTRAINTS', 'VAL_MANQ_CONTRAINTS'), ('VAL_MANQ_CONTRAINTS_FN', 'VAL_MANQ_CONTRAINTS_FN'), ('VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS', 'VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS'), ('ALL', 'ALL')], max_length=100)),
                ('parametre_diagnostic', models.CharField(choices=[('VAL_MANQ', 'VAL_MANQ'), ('VAL_MANQ_CONTRAINTS', 'VAL_MANQ_CONTRAINTS'), ('VAL_MANQ_CONTRAINTS_FN', 'VAL_MANQ_CONTRAINTS_FN'), ('VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS', 'VAL_MANQ_CONTRAINTS_FN_DUPLICATIONS'), ('ALL', 'ALL')], max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='MetaAnomalie',
            name='MetaAnomalie',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom_anomalie', models.CharField(max_length=50)),
                ('valeur_trouvee', models.CharField(blank=True, max_length=300, null=True)),
                ('nom_anomalie', models.CharField(max_length=50)),
                ('valeur_trouvee', models.CharField(blank=True, max_length=300, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='MetaTousContraintes',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom_contrainte', models.CharField(max_length=100)),
                ('nom_contrainte', models.CharField(max_length=100)),
                ('category', models.CharField(blank=True, max_length=300, null=True)),
                ('contrainte', models.CharField(blank=True, max_length=500, null=True)),
                ('commentaire', models.CharField(blank=True, max_length=300, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Role',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom_role', models.CharField(choices=[('Administrateur', 'Administrateur'), ('Client', 'Client')], max_length=100)),
                ('creation', models.DateTimeField(auto_now_add=True)),
                ('modification', models.DateTimeField(default=django.utils.timezone.now)),
            ],
        ),
        migrations.CreateModel(
            name='Utilisateur',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('telephone', models.CharField(max_length=100, validators=[django.core.validators.RegexValidator(message='le numero de telephone est invalide!', regex='^([+]){0,}[- ]{0,}([0-9{1,}])[- ]{0,}([0-9]{1,})[- ]{0,}([0-9]{1,}[- ]{0,}){1,}$')])),
                ('email', models.CharField(blank=True, max_length=100, null=True)),
                ('prenom', models.CharField(max_length=100)),
                ('nom', models.CharField(max_length=100)),
                ('organisation', models.CharField(blank=True, max_length=100, null=True)),
                ('is_email_verified', models.BooleanField(default=False)),
                ('date_creation', models.DateTimeField(auto_now_add=True)),
                ('date_mise_a_jour', models.DateTimeField(default=datetime.datetime.now)),
                ('compte', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='utilisateur', to='DataGuardianApp.compte')),
                ('role', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='utilisateur', to='DataGuardianApp.role')),
            ],
        ),
        migrations.CreateModel(
            name='Projet',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom_projet', models.CharField(max_length=100)),
                ('date_creation', models.DateTimeField(auto_now_add=True)),
                ('date_mise_a_jour', models.DateTimeField(default=datetime.datetime.now)),
                ('descriptif', models.TextField(blank=True, null=True)),
                ('utilisateur', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='projet', to='DataGuardianApp.utilisateur')),
            ],
        ),
        migrations.CreateModel(
            name='MetaTable',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom_table', models.CharField(max_length=100)),
                ('date_creation', models.DateTimeField(auto_now_add=True)),
                ('nombre_colonnes', models.IntegerField(blank=True, null=True)),
                ('nombre_lignes', models.IntegerField(blank=True, null=True)),
                ('commentaire', models.TextField(blank=True, null=True)),
                ('base_de_donnees', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='meta_table', to='DataGuardianApp.basededonnees')),
            ],
        ),
        migrations.CreateModel(
            name='MetaColonne',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom_colonne', models.CharField(max_length=200)),
                ('type_donnees', models.CharField(max_length=200)),
                ('date_creation', models.DateTimeField(auto_now_add=True)),
                ('date_diagnostic', models.DateField(blank=True, null=True)),
                ('nombre_valeurs', models.IntegerField(blank=True, null=True)),
                ('nombre_valeurs_manquantes', models.IntegerField(blank=True, null=True)),
                ('nombre_outliers', models.IntegerField(blank=True, null=True)),
                ('semantique', models.CharField(blank=True, max_length=100, null=True)),
                ('langue', models.CharField(blank=True, max_length=100, null=True)),
                ('nombre_anomalies', models.IntegerField(blank=True, null=True)),
                ('nombre_majuscules', models.IntegerField(blank=True, null=True)),
                ('nombre_minuscules', models.IntegerField(blank=True, null=True)),
                ('nombre_init_cap', models.IntegerField(blank=True, null=True)),
                ('col_min', models.CharField(blank=True, max_length=100, null=True)),
                ('col_max', models.CharField(blank=True, max_length=100, null=True)),
                ('contraintes', models.ManyToManyField(blank=True, related_name='meta_colonne', to='DataGuardianApp.MetaTousContraintes')),
                ('meta_anomalie', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='meta_colonne', to='DataGuardianApp.metaanomalie')),
                ('meta_anomalie', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='meta_colonne', to='DataGuardianApp.metaanomalie')),
                ('meta_table', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='meta_colonne', to='DataGuardianApp.metatable')),
            ],
        ),
        migrations.CreateModel(
            name='Diagnostic',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_analyse', models.DateTimeField(auto_now_add=True)),
                ('status', models.CharField(choices=[('Termine', 'Termine'), ('Avorte', 'Avorte'), ('Echec', 'Echec')], max_length=100)),
                ('Utilisateur', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='diagnostic', to='DataGuardianApp.utilisateur')),
                ('base_de_donnees', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='diagnostic', to='DataGuardianApp.basededonnees')),
                ('parametre_diagnostic', models.ForeignKey(blank=True, on_delete=django.db.models.deletion.CASCADE, related_name='diagnostic', to='DataGuardianApp.critere')),
                ('parametre_diagnostic', models.ForeignKey(blank=True, on_delete=django.db.models.deletion.CASCADE, related_name='diagnostic', to='DataGuardianApp.critere')),
            ],
        ),
        migrations.AddField(
            model_name='basededonnees',
            name='Projet',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='base_de_donnees', to='DataGuardianApp.projet'),
        ),
    ]
