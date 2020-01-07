%15.08.11 Cal AR model para
clear all;
clc;
% close all;

%----------------------para init---------------------------
FS=32000;
CellNum=1;
SigPara=[1,
    -1.01365294573197,
    0.00153106053480279,
    0.00140187462467824,
    0.0331194827855336];%32000Hz
SigPower=123.405045722641;%132dB@1kHz

% PsdPara = [0,1;0,0]
PsdPara=[21.5, 45,    140,    241,  297,   473;%Hz
        160, 160,    165,    160,  150,    145];%dB
        
DemPara=[1.2,	2.4,	3.6,    7.2;
        10*[0.01,    0.01,    0.012,	0.01]];

SimLen=8192;
zf=zeros(1,length(SigPara)-1);
zi=zeros(1,length(SigPara)-1);
zf2=zeros(1,length(SigPara)-1);
zi2=zeros(1,length(SigPara)-1);
filter_order = 10;
dzf = zeros(1,filter_order);
dzi = zeros(1,filter_order);

 fid=fopen('../data/power_3.3Hz.bin','wb');
 
%cnt=1;
for cnt=1:64
%     cnt
    %----------------------连续谱仿真----------------

    tt=((cnt-1)*SimLen+1):(cnt*SimLen);

    nn=randn(SimLen,1);

    xn=randn(1,SimLen);
    % xn=sin(2*pi*100*(1:tw*FS)/FS);
    [cn,zf]=filter(SigPower,SigPara,xn,zi);    %求得平稳连续谱时域信号  
    [dn,zf2]=filter(0*SigPower,SigPara,xn,zi2); 
    F1 = band_pass(FS,10,3000,10000);
    [b,a] = tf(F1);
    [dn,dzf] = filter(b,a,dn,dzi);
    zi=zf;
    zi2=zf2;
    dzi = dzf;

    PsdParaA=PsdPara;
    PsdParaA(2,:)=10.^(PsdParaA(2,:)./20-6).*1.414;
    ln=PsdParaA(2,:)*cos(2*pi/FS*PsdParaA(1,:).'*tt);%
    mn=(1+DemPara(2,:)*cos(2*pi/FS*DemPara(1,:).'*tt));
    yn=cn.*mn+ln+dn;
%     plot(ln);

%     [psd_data,psd_data_f]=func_PSD(yn,1,FS,1);
   
    fwrite(fid,yn,'float32');
   
   
%     dataInfo=[CellNum;SimLen;FS;cnt];

%     pause(0.01);

end
 fclose(fid);
f0=200;%500;
