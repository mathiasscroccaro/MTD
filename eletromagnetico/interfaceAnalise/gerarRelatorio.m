% Arquivo utilizado para plotar todos os dados selecionados na interface web
% de maneira junta

close all;
clear all;

arquivo = fopen('arquivosRelatorio.txt');

dados = textscan(arquivo,'%s %f %f %s %s');

dadosMedidas = dados(1);
fMinimas = dados(2);
fMaximas = dados(3);
medidores = dados(4);
periodo = dados(5);

nMedidas = size(char(dadosMedidas))(1);
legenda = {};

pFigure = figure();
hold all;

for medida = 1:nMedidas

  caminhoDado = char(dadosMedidas)(medida,1:end);
  
  fMinima = cell2mat(fMinimas)(medida);
  fMaxima = cell2mat(fMaximas)(medida);
  
  dado = dlmread(char(textscan(caminhoDado,'%s')))(5:end,1);
  
  excursao = fMaxima - fMinima;
  
  x = excursao.*(1:size(dado)(1))./size(dado)(1) + fMinima;
  y = dado;

  legenda{medida} = strcat(char(medidores)(medida,1:end),"--",char(periodo)(medida,1:end));
  
  plot(x,y);
  
endfor

fMinima = min(cell2mat(fMinimas));
fMaxima = max(cell2mat(fMaximas));

title("Espectro Eletromagnetico")
xlabel("Frequencia [MHz]")
ylabel("Potencia [dBm]")
axis([fMinima fMaxima -90 -30])
legend(legenda)

%print(pFigure,"relatorio.pdf","-dpdflatexstandalone");
%system("pdflatex relatorio");

print relatorio.pdf
sleep(2)
system("mv relatorio.pdf media/relatorio.pdf")
