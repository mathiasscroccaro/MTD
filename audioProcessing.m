%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
clear all;
close all;

pkg load signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rawData,fs,nbits] = wavread('file.wav');

printf("Sampling rate: %i [Hz]\n",fs)
printf("Wav vector size: %i [samples]\n",size(rawData(:,1))(1))
printf("File size: %i [bytes]\n",nbits/8)

samples = 1:size(rawData(:,1))(1);
frequencys = samples.*fs./size(rawData(:,1))(1);
frequencys = frequencys';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fc = 100;
coefFilter = fir1(200,fc/(fs/2),"high");
filteredData = filter(coefFilter,1,rawData);

fft_filteredData = abs(fft(filteredData));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = 1e3;
patternSignal = sin(2.*pi.*(0:1/fs:1).*f);
filledPatternSignal = [patternSignal zeros(1,length(filteredData)-length(patternSignal))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%csvwrite("output.csv",[frequencys fft_filteredData]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot(filteredData(:,1));
axis([0 length(filteredData) -0.02 0.02])
title("Sinal base + ruido")
xlabel("Amostras [n]")
ylabel("Amplitude [V]")

figure
plot(filledPatternSignal(1:100));
title("Sinal base 1 kHz")
xlabel("Amostras [n]")
ylabel("Amplitude [V]")

figure
plot(frequencys,fft_filteredData(:,1));
title("Energia do espectro");
xlabel("Frequencias [Hz]");
ylabel("Energia");

figure
plot(xcorr(filteredData(:,1),filledPatternSignal))
title("Correlacao crusada");
xlabel("Amostra [n]");
ylabel("Amplitude [V]")

toc
