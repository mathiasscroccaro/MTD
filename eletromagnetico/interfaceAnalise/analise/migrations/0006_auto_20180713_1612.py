# Generated by Django 2.0.7 on 2018-07-13 16:12

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('analise', '0005_auto_20180713_1610'),
    ]

    operations = [
        migrations.AlterField(
            model_name='medidor',
            name='foto',
            field=models.FilePathField(default='/', path='/', recursive=True),
        ),
    ]
