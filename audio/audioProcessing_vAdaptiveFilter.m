%% Processamento de audio por filtro adaptativo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pkg load signal;

[rawData,fs,nbits] = wavread('audio.wav');

rawData = rawData(:,1) + rawData(:,2);

fc = [8000 12000];
coefFilter = fir1(200,fc/(fs/2),'bandpass');
filteredData = filter(coefFilter,1,rawData);

if( max( filter(csvread('coef.csv'),1,filteredData)(200:end)) > 0.1 )
  quit(-1)
endif
quit(0)
