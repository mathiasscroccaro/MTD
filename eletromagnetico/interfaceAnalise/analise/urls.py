from django.urls import path

from . import views

urlpatterns = [
    path('',views.index, name='index'),
    path('busca/',views.index, name='busca'),
    path('carregar/',views.carregar, name='carregar')
]
