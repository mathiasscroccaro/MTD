arg_list = argv();
file = char(arg_list(1));

data = dlmread(file)(5:end,1);

freqRange = [0 2e9];

freqs = 1:length(data);
freqs = freqs.*(freqRange(2) - freqRange(1))./length(freqs);

pFigure = figure;
plot(freqs,data);
title("Espectro eletromagnetico")
xlabel("Frequencia [Hz]")
ylabel("Potencia [dBm]")
axis([freqRange(1) freqRange(2) -80 -15]);

pdfFile = strcat(file(1:end-3),"pdf")
print(pFigure,pdfFile,"-dpdflatexstandalone");
system(sprintf("pdflatex %s",pdfFile(1:end-4)));


