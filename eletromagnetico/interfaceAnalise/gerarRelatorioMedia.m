clear all;
close all;

medidores = {"L01_M07","L01_M12","L02_M01","L02_M02","L02_M04","L02_M05","L02_M15","L02_M20"};
tipos = {"spectrum","floor"};
periodos = {"manha","tarde","noite"};

iMedidor = 1;
iPeriodo = 1;

dados = zeros(700,1);
dadoPeriodo = [];

x = [1:700]./700;
x = x.*400 + 100;
x = x';

manha = [];
tarde = [];
noite = [];

for periodo = periodos
    iMedidor = 1;
    for medidor = medidores
        dado = dlmread(strcat("medidas/17-07-2018/",char(periodo),"/",char(medidor),"/floor_100-500.asc"))(5:end,1);
        if (char(periodo) == "manha")        
            manha = [manha dado];
        endif
        if (char(periodo) == "tarde")
            tarde = [tarde dado];        
        endif
        if (char(periodo) == "noite")
            noite = [noite dado];        
        endif
        dados = dado + dados;
        iMedidor = iMedidor + 1;
    endfor
    dados = dados/(iMedidor-1);
    dadoPeriodo = [dadoPeriodo dados];
    dados = zeros(700,1);

    iPeriodo = iPeriodo + 1;

endfor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = 1;
for medidor = medidores
    figure;
    hold all;
    i = 1;
    for periodo = periodos
        for tipo = tipos
            dado = dlmread(cstrcat("medidas/17-07-2018/",char(periodo),"/",char(medidor),"/",char(tipo),"_100-500.asc"))(5:end,1);
            plot(x,dado);
            legenda{i} = cstrcat(char(periodo)," - ",char(tipo));
            i = i+1;            
        endfor    
    endfor
    l = legend(legenda);
    set(l,'interpreter','none')
    title(cstrcat("Espectro eletromagnetico e floor - ",char(medidor)),'interpreter','None')
    xlabel("Frequencias [MHz]")
    ylabel("Potencia [dBm]")
    axis([100 500 -80 -30]);
    print(cstrcat("Espectro eletromagnetico e floor - ",char(medidor),".png"))
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legenda = {};
i = 1;
for medidor = medidores
    figure;
    hold all;
    i = 1;
    for periodo = periodos
        for tipo = tipos
            if (strcmp(char(tipo),"floor"))
                dadoFloor = dlmread(cstrcat("medidas/17-07-2018/",char(periodo),"/",char(medidor),"/",char(tipo),"_100-500.asc"))(5:end,1);
            endif
            if (strcmp(char(tipo),"spectrum"))
                dadoSpectrum = dlmread(cstrcat("medidas/17-07-2018/",char(periodo),"/",char(medidor),"/",char(tipo),"_100-500.asc"))(5:end,1);
            endif          
        endfor
        plot(x,dadoSpectrum - dadoFloor);
        legenda{i} = char(periodo);
        i = i+1;    
    endfor
    l = legend(legenda);
    set(l,'interpreter','none')
    title(cstrcat("Diferenca entre espectro eletromagnetico e floor - ",char(medidor)),'interpreter','None')
    xlabel("Frequencias [MHz]")
    ylabel("Potencia [dB]")
    axis([100 500 -15 15]);
    print(cstrcat("Diferenca entre espectro eletromagnetico e floor - ",char(medidor),".png"))
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(x,manha);
title("Floor manha")

figure;
plot(x,tarde);
title("Floor tarde");

figure;
plot(x,noite);
title("Floor noite");

figure;
hold all;

plot(x,dadoPeriodo(:,1));
plot(x,dadoPeriodo(:,2));
plot(x,dadoPeriodo(:,3));
title("Espectro eletromagnetico - comparacao de periodos")
xlabel("Frequencia [MHz]")
ylabel("Amplitude [dBm]")
legend("Media manha","Media tarde","Media noite");
axis([100 500 -80 -30]);
print(strcat("Espectro eletromagnetico - comparacao de periodos","mmmtmn",".png"))

%figure;
%hold all;

%plot(x,dadoPeriodo(:,1));
%plot(x,dadoPeriodo(:,2));
%title("Espectro eletromagnetico - comparacao de periodos")
%xlabel("Frequencia [MHz]")
%ylabel("Amplitude [dBm]")
%legend("Media manha","Media tarde");
%axis([100 500 -80 -30]);
%print(strcat("Espectro eletromagnetico - comparacao de periodos","mmmt",".png"))

%figure;
%hold all;

%plot(x,dadoPeriodo(:,1));
%plot(x,dadoPeriodo(:,3));
%title("Espectro eletromagnetico - comparacao de periodos")
%xlabel("Frequencia [MHz]")
%ylabel("Amplitude [dBm]")
%legend("Media manha","Media noite");
%axis([100 500 -80 -30]);
%print(strcat("Espectro eletromagnetico - comparacao de periodos","mmmn",".png"))

figure;
hold all;

psd = dadoPeriodo(:,1)-dadoPeriodo(:,2);
psd = psd.*psd;
plot(x,psd);
title("Densidade espectral de potencia do ruido entre periodo da manha e tarde")
xlabel("Frequencia [MHz]")
ylabel("Amplitude [dB]")
legend("Diferenca da media dos espectros");
axis([100 500 0 20]);
print(strcat("Espectro eletromagnetico - comparacao de periodos","dif_mmmt",".png"))

figure;
hold all;
psd = dadoPeriodo(:,1)-dadoPeriodo(:,3);
psd = psd.*psd;
plot(x,psd);
title("Densidade espectral de potencia do ruido entre periodo da manha e noite")
xlabel("Frequencia [MHz]")
ylabel("Amplitude [dB]")
legend("Diferenca da media dos espectros");
axis([100 500 0 20]);
print(strcat("Espectro eletromagnetico - comparacao de periodos","dif_mmmn",".png"))

figure;
hold all;

psd = dadoPeriodo(:,2)-dadoPeriodo(:,3);
psd = psd.*psd;
plot(x,psd);
title("Densidade espectral de potencia do ruido entre periodo da tarde e noite")
xlabel("Frequencia [MHz]")
ylabel("Amplitude [dB]")
legend("Diferenca da media dos espectros");
axis([100 500 0 20]);
print(strcat("Espectro eletromagnetico - comparacao de periodos","dif_mtmn",".png"))

figure;
hold all;

CA = dlmread("medidas/19-07-2018/CA_CL_0-500.asc")(5:end,1);
CF = dlmread("medidas/19-07-2018/CF_CL_0-500.asc")(5:end,1);

plot(x,CA - CF);
title("Diferenca do floor entre mini camara fechada e aberta")
xlabel("Frequencia [MHz]")
ylabel("Amplitude [dB]")
legend("Diferenca da media dos espectros");
axis([100 500 -15 20]);
print("Espectro eletromagnetico - caixa aberta e fechada.png")


