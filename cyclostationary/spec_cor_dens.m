clc;clear;close 'all';

% N =  524288;
% fs = 16384;%fs/dalpha最好为2的幂，否则频率不准
% filename = '../data/sim_data_0.2_0.bin';
% fid = fopen(filename,'rb');
% data_time = fread(fid,[N,1],'float32');
% fclose(fid);

filename = 'D:\workspace\SEU\shipsear\95__A__Draga_3.wav';
% filename = 'D:\workspace\SEU\shipsear\7__10_07_13_marDeCangas_Espera.wav';
[data_time,fs] = audioread(filename);
N=fs*16;
data_time = data_time(N*0+1:N*1);


df = 64;dalpha = fs/N;fc = 50;

[scd,alpha,f] = autofam_low(data_time,fs,df,dalpha);
scd = 10*log10(scd);
scd(isinf(scd) == 1) = 0;
[xl,yl] = size(scd);
%%
%背景均衡
% scd = scd(:,floor(yl/2)+1:floor(yl/2)+1+floor(fc/dalpha));
% for jj = 2:yl
%     scd(:,jj) = scd(:,jj) - scd(:,1);    
% end

for ii = 1:xl
    scd(ii,:) = scd(ii,:) - midfilt(scd(ii,:),floor(1/dalpha));
end
scd(:,1:3) = [scd(:,4),scd(:,4),scd(:,4)];
scd(end,:) = scd(end-1,:);
scd(scd<0) = 0;

%%
demon_scare = [0, fs/2];

demon = sum(scd(1+floor(demon_scare(1)/df):floor(demon_scare(2)/df),:));
demon = demon-mean(demon);
sigma = sqrt(sum((demon).^2)/xl);
demon = demon/sigma;
demon(demon < 0) = 0;
figure
plot(alpha,demon);

%%
all_line = [];
line = [0;0];
while ~isempty(line)
    max_ele = max(max(scd));
    scd = scd/max_ele*256;
%     figure
%     imagesc(alpha,f,scd);
    bw = scd;
    bw(bw <182) = 0;
    figure
    imshow(bw);

    new_d = sum(bw);
    dalpha = alpha(2);
    line =line_detec(new_d, 10);
    for jj = 1:length(line)
        scd(:, line(jj)-1:line(jj)+1) = [scd(:, line(jj)-2), scd(:, line(jj)-2), scd(:, line(jj)-2)];
    end    
    all_line = [all_line;(line-1)*dalpha];
%     figure
%     plot(alpha, new_d);

end



%%

figure(2)
mesh(alpha,f,scd)

demon_scare = [0, 3000];

demon = sum(scd(1+floor(demon_scare(1)/df):floor(demon_scare(2)/df),:));
demon = demon-mean(demon);
sigma = sqrt(sum((demon).^2)/xl);
demon = demon/sigma;
demon(demon < 0) = 0;
figure(3)
plot(alpha,demon);





