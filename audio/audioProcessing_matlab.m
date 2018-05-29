%% Obtendo sinal + ruido %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rawData,fs] = audioread('rele_batendo_soltando_diferentes_distancias.wav');

rawData = rawData(:,1) + rawData(:,2);

fc = [8000 12000];
coefFilter = fir1(200,fc/(fs/2),'bandpass');
filteredData = filter(coefFilter,1,rawData);

%% Gerando sinal de referencia %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ref = zeros(1,length(rawData));

ref(6.8898e4) = 1;
ref(1.55449e5) = 1;
ref(2.35224e5) = 1;
ref(3.38981e5) = 1;
ref(4.28455e5) = 1;
ref(5.15037e5) = 1;
ref(6.13434e5) = 1;
ref(7.0084e5) = 1;
ref(7.64063e5) = 1;
ref(8.36238e5) = 1;
ref(8.86e5) = 1;
ref(1.026333e6) = 1;
ref(1.129964e6) = 1;
ref(1.21054e6) = 1;
ref(1.339038e6) = 1;
ref(1.405774e6) = 1;
ref(1.490471e6) = 1;
ref(1.585744e6) = 1;
ref(1.678785e6) = 1;
ref(1.769145e6) = 1;
ref(1.865699e6) = 1;

ref = ref.*10;

%% Criando filtro adaptativo e obtendo coeficientes W %%%%%%%%%%%%%%%%%%%%%%%%%%

lms = dsp.LMSFilter

lms.Length = 200;

[y,err,w1] = lms(filteredData,ref');

figure;
plot(y)

csvwrite('coef.csv',w1);

w1 = fliplr(w1);
