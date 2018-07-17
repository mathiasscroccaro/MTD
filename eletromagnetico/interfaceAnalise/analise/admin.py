from django.contrib import admin

from .models import Medidor
from .models import MedidaEletromagnetica
from .models import MedidaTermica

admin.site.register(Medidor)
admin.site.register(MedidaEletromagnetica)
admin.site.register(MedidaTermica)

# Register your models here.
