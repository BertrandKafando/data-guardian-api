# Generated by Django 3.2.5 on 2023-12-09 22:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('DataGuardianApp', '0002_auto_20231209_2047'),
    ]

    operations = [
        migrations.AlterField(
            model_name='metaanomalie',
            name='valeur_trouvee',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]