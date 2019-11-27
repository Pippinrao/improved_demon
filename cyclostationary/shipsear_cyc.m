clc;clear;close 'all';

th = 3;
% [data,fs] = audioread('D:\workspace\SEU\shipsear\95__A__Draga_3.wav');
% n = fs*16;
% data = data(n*0+1:n*1);
name = [string('95__A__Draga_3');string('6__10_07_13_marDeCangas_Entra');...
    string('7__10_07_13_marDeCangas_Espera');string('8__10_07_13_marDeOnza_Entra');...
    string('9__10_07_13_marDeOnza_Espera');string('10__10_07_13_marDeOnza_Sale');...
    string('11__10_07_13_minhoUno_Entra');];
% data_snr = [0,-3,-6,-9,-12,-15,-18];    
line_sub = [];
line_cyc = [];

data_N = length(name);

for ni = 1:data_N
    
    [data,fs] = audioread(char(strcat(string('D:\workspace\SEU\shipsear\'),name(ni),string('.wav'))));
    n = fs*16;
    data = data(n*0+1:n*1);
%%
%分频带
    df = fs/n;fc = 62;fcn = floor(fc/df);
    step = fs/8;band_width = fs/8;
    band_num = int32((fs/2-band_width)/step + 1);
    sub_d = zeros(band_num,fcn);
    f_band = step*(0:band_num-1);
    f = df*(0:n/2-1);
    f_demon = df*(0:fcn-1);
    for ii = 1:band_num

        fl = (ii-1)*step;
        fh = fl+band_width;
        tmp = sub_demon(data,fl,fh,fs);
        tmp = 20*log10(abs(fft(tmp)));
        tmp(1:floor(0.2/df)) = tmp(floor(0.2/df)+1);
        sub_d(ii,:) = tmp(1:fcn);
        sub_d(ii,:) = sub_d(ii,:) - midfilt(sub_d(ii,:),floor(2/df));

    end


    sub_band_demon = sum(sub_d)/double(band_num);
    sigma_sub = sqrt(sum((sub_band_demon(1:fcn)-mean(sub_band_demon(1:fcn))).^2)/fcn);
    sub_band_demon = sub_band_demon/sigma_sub;
    sub_band_demon(sub_band_demon < 0) = 0;
    th_sub = up_envelope_threshold(sub_band_demon,th,floor(2/df));%取上包络
%     th_sub = 3*ones(fcn,1);
    
    
    
    for ii = 2:fcn-1
        if(sub_band_demon(ii) >= th_sub(ii)  && sub_band_demon(ii) >sub_band_demon(ii-1) && sub_band_demon(ii) > sub_band_demon(ii+1))
            line_sub = [line_sub;(ii-1)*df,sub_band_demon(ii)];%线谱检测
        end
    end
        


    %%
    %循环谱
    df = 256;dalpha = fs/n;

    [scd,alpha,f] = autofam_low(data,fs,df,dalpha);
%     scd = 20*log10(scd);
    scd(isinf(scd) == 1) = 0;
    [xl,yl] = size(scd);
    %%
    %背景均衡
    for ii = 1:xl
        
        scd(ii,1:floor(0.5/dalpha)) = scd(ii,floor(0.5/dalpha)+1);
        scd(ii,:) = scd(ii,:) ./ midfilt(scd(ii,:),floor(2/dalpha));
    end
    
    scd(end,:) = scd(end-1,:);


    demon = sum(scd)/length(scd(:,1));
    demon = demon(1:fcn);
    demon = 20*log10(demon);
    demon = demon-mean(demon);
    sigma = sqrt(sum((demon).^2)/fcn);
    demon = demon/sigma;
    demon(demon < 0) = 0;
    f_alpha = alpha(1:fcn);
    th_cyc = up_envelope_threshold(demon,th,floor(2/dalpha));
%     th_cyc = 3*ones(fcn,1);
    
    
    
    for ii = 2:fcn-1
        if(demon(ii) >= th_cyc(ii) &&  demon(ii) >demon(ii-1) && demon(ii) > demon(ii+1))
            line_cyc = [line_cyc;(ii-1)*dalpha,demon(ii)];
        end
    end


    figure(2*ni)
    subplot(2,1,1)
    plot(f_demon,sub_band_demon(1:fcn));xlim([0,50]);
    hold on;plot(f_demon,th_sub);hold off;
    title('分频带DEMON谱');xlabel('频率/Hz');ylabel('幅度/\sigma');grid on;
    subplot(2,1,2)
    plot(f_alpha,demon);xlim([0,50]);
    hold on;plot(f_alpha,th_cyc);hold off;
    title('循环DEMON谱');xlabel('频率/Hz');ylabel('幅度/\sigma');
    grid on;
    figure(2*ni-1)
    imagesc(alpha,f,scd);xlim([0,fc]);
    title('白化后的循环谱');xlabel('循环频率/Hz');ylabel('频率/Hz');zlabel('幅度/dB');
    pause(0.1);
end



