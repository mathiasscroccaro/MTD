close all;
clear all;

arquivo = fopen('arquivosRelatorio.txt');

dados = textscan(arquivo,'%s %f %f');

dadosMedidas = dados(1)
fMinimas = dados(2);
fMaximas = dados(3);

nMedidas = size(char(dadosMedidas))(1)

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
  
  plot(x,y);
  
endfor

fMinima = min(cell2mat(fMinimas));
fMaxima = max(cell2mat(fMaximas));

title("Espectro Eletromagnetico")
xlabel("Frequencias [Hz]")
ylabel("Potencia [dBm]")

%print(pFigure,"relatorio.pdf","-dpdflatexstandalone");
%system("pdflatex relatorio");

print relatorio.pdf
sleep(2)
system("mv relatorio.pdf media/relatorio.pdf")
