%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
clear all;
close all;

pkg load signal

[refRawData,refFs,refNBits] = wavread('ref.wav');
[rawData,fs,nbits] = wavread('audio.wav');

printf("\n\n-->> Reference signal\n")
printf("Sampling rate: %i [Hz]\n",refFs)
printf("Wav vector size: %i [samples]\n\n",size(refRawData(:,1))(1))

printf("-->> Recorded signal\n")
printf("Sampling rate: %i [Hz]\n",fs)
printf("Wav vector size: %i [samples]\n\n",size(rawData(:,1))(1))

refRawData = refRawData(:,1) + refRawData(:,2);
rawData = rawData(:,1) + rawData(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samples = 1:length(rawData);
frequencys = samples.*fs./length(rawData);
frequencys = frequencys';

fc = 100;
coefFilter = fir1(200,fc/(fs/2),"high");
filteredData = filter(coefFilter,1,rawData);

fft_filteredData = abs(fft(filteredData));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

refSamples = 1:length(refRawData);
refFrequencys = refSamples.*refFs./length(refRawData);
refFrequencys = refFrequencys';

coefFilter = fir1(200,fc/(refFs/2),"high");
refFilteredData = filter(coefFilter,1,refRawData);

ref_fft_filteredData = abs(fft(refFilteredData));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filledPatternSignal = [refFilteredData' zeros(1,length(filteredData)-length(refFilteredData))];


corr = xcorr(filteredData,filledPatternSignal);

corr = corr.^2;

figure;
hist(corr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%csvwrite("output.csv",[frequencys fft_filteredData]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figure
%plot(filteredData(:,1));
%axis([0 length(filteredData) -0.02 0.02])
%title("Sinal base + ruido")
%xlabel("Amostras [n]")
%ylabel("Amplitude [V]")

%figure
%plot(filledPatternSignal(1:100));
%title("Sinal base 1 kHz")
%xlabel("Amostras [n]")
%ylabel("Amplitude [V]")

%figure
%plot(frequencys,fft_filteredData(:,1));
%title("Energia do espectro");
%xlabel("Frequencias [Hz]");
%ylabel("Energia");

figure
plot(corr)
title("Correlacao crusada");
xlabel("Amostra [n]");
ylabel("Amplitude [V]")

toc
