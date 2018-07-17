from django import forms

class BuscaForm(forms.Form):
    MEDIDORES = (
        ('MARCA','L01-M01'),
        ('MARCA','L01-M02'),
        ('MARCA','L01-M03'),
        ('MARCA','L01-M04'),
        ('MARCA','L01-M05'),
        ('MARCA','L01-M06'),
        ('MARCA','L01-M07'),
        ('MARCA','L01-M08'),
        ('MARCA','L01-M09'),
        ('MARCA','L01-M10'),
        ('MARCA','L01-M11'),
        ('MARCA','L01-M12'),
        ('MARCA','L01-M13'),
        ('MARCA','L02-M01'),
        ('MARCA','L02-M02'),
        ('MARCA','L02-M03'),
        ('MARCA','L02-M04'),
        ('MARCA','L02-M05'),
        ('MARCA','L02-M06'),
        ('MARCA','L02-M07'),
        ('MARCA','L02-M08'),
        ('MARCA','L02-M09'),
        ('MARCA','L02-M10'),
        ('MARCA','L02-M11'),
        ('MARCA','L02-M12'),
        ('MARCA','L02-M13'),
        ('MARCA','L02-M14'),
        ('MARCA','L02-M15'),
        ('MARCA','L02-M16'),
        ('MARCA','L02-M17'),
        ('MARCA','L02-M18'),
        ('MARCA','L02-M19'),
        ('MARCA','L02-M20'), 
    )
    medidor = forms.ChoiceField(label="Nome do medidor:",choices=MEDIDORES)
    fraudado = forms.BooleanField(label="É fraudado?")
    data = forms.DateField(label="Data da medida")
