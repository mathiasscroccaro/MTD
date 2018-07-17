from django.db import models

import os

# Create your models here.

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

class Medidor(models.Model):
    MEDIDORES = (
        ('L01-M01','L01-M01'),
        ('L01-M02','L01-M02'),
        ('L01-M03','L01-M03'),
        ('L01-M04','L01-M04'),
        ('L01-M05','L01-M05'),
        ('L01-M06','L01-M06'),
        ('L01-M07','L01-M07'),
        ('L01-M08','L01-M08'),
        ('L01-M09','L01-M09'),
        ('L01-M10','L01-M10'),
        ('L01-M11','L01-M11'),
        ('L01-M12','L01-M12'),
        ('L01-M13','L01-M13'),
        ('L02-M01','L02-M01'),
        ('L02-M02','L02-M02'),
        ('L02-M03','L02-M03'),
        ('L02-M04','L02-M04'),
        ('L02-M05','L02-M05'),
        ('L02-M06','L02-M06'),
        ('L02-M07','L02-M07'),
        ('L02-M08','L02-M08'),
        ('L02-M09','L02-M09'),
        ('L02-M10','L02-M10'),
        ('L02-M11','L02-M11'),
        ('L02-M12','L02-M12'),
        ('L02-M13','L02-M13'),
        ('L02-M14','L02-M14'),
        ('L02-M15','L02-M15'),
        ('L02-M16','L02-M16'),
        ('L02-M17','L02-M17'),
        ('L02-M18','L02-M18'),
        ('L02-M19','L02-M19'),
        ('L02-M20','L02-M20'), 
    )
    medidor = models.CharField(primary_key=True,max_length=30,choices=MEDIDORES)
    fraudado = models.BooleanField(default=False)
    foto = models.FilePathField(path=BASE_DIR,default='/',recursive=True)

class MedidaEletromagnetica(models.Model):
    medidor = models.ForeignKey(Medidor, on_delete=models.CASCADE)
    data = models.DateField()
    dado = models.FilePathField(path=BASE_DIR,default='/',recursive=True)
    fMinima = models.FloatField(default=0)
    fMaxima = models.FloatField(default=3e9)
    RBW = models.FloatField(default=200e3)
    PA = models.BooleanField(default=False)
    fonteChaveada = models.BooleanField(default=False)
    correnteFonte = models.PositiveSmallIntegerField(default=0)
    comentarios = models.TextField(max_length=500)

class MedidaTermica(models.Model):
    
    medidor = models.ForeignKey(Medidor, on_delete=models.CASCADE)
    data = models.DateField()
    dado = models.FilePathField(path='/',default='/')
    correnteFonte = models.PositiveSmallIntegerField(default=0)
    comentarios = models.TextField(max_length=500)
