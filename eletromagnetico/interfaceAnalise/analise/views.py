import re, os, glob, datetime
from django.shortcuts import render,redirect
from django.http import HttpResponse, HttpResponseRedirect

from .forms import BuscaForm
from .models import Medidor, MedidaEletromagnetica, MedidaTermica

from scanf import scanf

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def gerarRelatorio(lista):
    arquivo = open('arquivosRelatorio.txt','w')
    for item in lista:
        try:
            medida = MedidaEletromagnetica.objects.get(id=int(item[0]))
            arquivo.write(str(medida.dado) + "\t" + str(medida.fMinima) + "\t" + str(medida.fMaxima) + "\t" + str(medida.medidor.medidor) + "\t" + str(medida.periodo) + "\n")
        except:
            pass
    arquivo.close()
    os.system('octave gerarRelatorio.m')

def index(request):
    if request.method == 'POST':
        gerarRelatorio(list(request.POST.items()))
        return redirect('/media/relatorio.pdf')
    else:
        medidas = MedidaEletromagnetica.objects.order_by('data')
    return render(request,'busca.html',{'medidas':medidas})

def encontrarPadrao(arquivo):
    caminho = list(re.split('/',arquivo))[1:]

    #padrao = ["\d+-\d+-\d+","L\d+","M\d+","\s_\d+_d\+"]
    #padrao = ["%d-%d-%d","L%s","M%s","%s_%d_%d"]
    padrao = ["%d-%d-%d","%s","L%s_M%s","%s_%f-%f"]
    data = None
    medidor = None
    lote = None
    fMinimo = None
    fMaximo = None
    tipo = None
    periodo = None    
    for subcaminho in caminho:
        for contador,subpadrao in enumerate(padrao):
            if (scanf(subpadrao,subcaminho)):
                dados = scanf(subpadrao,subcaminho)
                if (contador == 0):
                    data = datetime.date(dados[2],dados[1],dados[0])
                if (contador == 1):
                    temp = dados[0]
                    if (temp == "manha" or temp == "tarde" or temp == "noite"):
                        periodo = temp
                if (contador == 2):
                    #medidor = dados[0]
                    lote = dados[0]
                    medidor = dados[1]
                if (contador == 3):
                    comentario = dados[0]
                    fMinimo = dados[1]
                    fMaximo = dados[2]

def encontrarPadrao2(arquivo):
    caminho = list(re.split('/',arquivo))[1:]
    padrao = ["%d-%d-%d","L%s","M%s","%s_%d_%d"]
    data = None
    medidor = None
    lote = None
    fMinimo = None
    fMaximo = None
    tipo = None
    periodo = None    
    for subcaminho in caminho:
        for contador,subpadrao in enumerate(padrao):
            if (scanf(subpadrao,subcaminho)):
                dados = scanf(subpadrao,subcaminho)
                if (contador == 0):
                    data = datetime.date(dados[2],dados[1],dados[0])
                if (contador == 1):
                    lote = dados[0]
                if (contador == 2):
                    medidor = dados[0]
                    medidor = dados[1]
                if (contador == 3):
                    comentario = dados[0]
                    fMinimo = dados[1]
                    fMaximo = dados[2]


    if (data==None or medidor==None or lote==None or fMinimo==None or fMaximo==None or periodo==None):
        return
    else:
        try:       
            medidor = Medidor.objects.get(medidor = "L%s-M%s"%(lote,medidor))
            MedidaEletromagnetica.objects.update_or_create(medidor=medidor,data=data,dado=arquivo,fMinima=fMinimo,fMaxima=fMaximo,comentarios=comentario,periodo=periodo)
        except:
            print("erro ao adicionar L%s-M%s" % (lote,medidor))               

def carregar(request):
    for arquivo in glob.iglob('medidas/**/*.asc', recursive=True):
        if (len(re.split('/',arquivo)) == 5):
            encontrarPadrao(arquivo)            
            #print(arquivo)
    return render(request,'carregar.html')

# Create your views here.
