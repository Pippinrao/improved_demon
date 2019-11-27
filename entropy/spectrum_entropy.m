clc;clear;close 'all';

% N =  524288;
% fs = 16384;%fs/dalpha最好为2的幂，否则频率不准
% filename = '../data/sim_data_0.2_0.bin';
% fid = fopen(filename,'rb');
% data_time = fread(fid,[N,1],'float32');
% fclose(fid);

% filename = 'D:\workspace\SEU\shipsear\95__A__Draga_3.wav';
filename = 'D:\workspace\SEU\shipsear\9__10_07_13_marDeOnza_Espera.wav';
% filename = 'D:\workspace\SEU\shipsear\7__10_07_13_marDeCangas_Espera.wav';
[data_time,fs] = audioread(filename);
N=fs*16;
data_time = data_time(N*0+1:N*1);


df = 64;dalpha = fs/N;fc = 50;

[scd,alpha,f] = autofam_low(data_time,fs,df,dalpha);

[xl,yl] = size(scd);


%%
% scd = scd.*scd;
H = zeros(1,xl);
for ii = 1:xl
    sum_i = sum(scd(ii,:));
    p_i = scd(ii,:)/sum_i;
    H(ii) = -sum(p_i.*log(p_i));
end




%%
scd = 10*log10(scd);
scd(isinf(scd) == 1) = 0;


for ii = 1:xl
    scd(ii,:) = scd(ii,:) - midfilt(scd(ii,:),floor(1/dalpha));
end
scd(:,1:3) = [scd(:,4),scd(:,4),scd(:,4)];
scd(end,:) = scd(end-1,:);
% scd(scd<0) = 0;
figure
subplot(2,1,1)
imagesc(f,alpha,scd');
subplot(2,1,2)
plot(f,H);

%%
demon_scare = [0, 3000];

demon = sum(scd(1+floor(demon_scare(1)/df):floor(demon_scare(2)/df),:));
demon = demon-mean(demon);
sigma = sqrt(sum((demon).^2)/xl);
demon = demon/sigma;
demon(demon < 0) = 0;
figure
plot(alpha,demon);




