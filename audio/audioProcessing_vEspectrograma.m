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

treshold = 0.05;
maxValuesIdx = [500];

idx = 0;
for i = filteredData'
  idx = idx+1;
  if (i > treshold && idx > maxValuesIdx(end) + 1000)
    maxValuesIdx = [maxValuesIdx idx];
  endif
endfor

releIdx = [];

for maxValue = maxValuesIdx
  %figure
  [S,f,t] = specgram (rawData(maxValue-200:maxValue+1000),256,fs);
  S = abs(S);
  S = S/mean([S(19,1) S(53,1) S(69,1)]);
  
  if (sum([S(19,1) S(53,1) S(69,1)]) > 1.7 && sum([S(19,2) S(53,2)]) > 0.5)
    quit(-1)
  endif
  if (sum([S(34,1) S(53,1) S(68,1)]) > 3 && sum([S(44,2) S(68,2)]) > 0.9)
    quit(-1)
  endif  
endfor

quit(0)