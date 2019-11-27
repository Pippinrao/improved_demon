function [SxL,alphao,fo]=autofam_low(x,fs,df,dalpha)

% 计算0~df频域范围内的循环谱

% x：原信号
% fs：采样率
% df：频域分辨率
% dalpha：循环频率分辨率

% df >> dalpha
% fs/dalpha为实际计算数据长度
% x长度应大于等于fs/dalpha，否则会填零

% 输出SxL为0~df的循环谱
% alphao为循环频率轴
% fo为频谱轴

if nargin ~= 4
    error('Wrong number of arguments.');
end
Np=pow2(nextpow2(fs/df));          
L=Np/4;                   
P=pow2(nextpow2(fs/dalpha/L));
                                
N=P*L;  
if length(x) < N
    x(N)=0;
elseif length(x) > N
    x=x(1:N);
end

NN=(P-1)*L+Np;
xx=x;
xx(NN)=0;
xx=xx(:);
X=zeros(Np,P);
for k=0:P-1
    X(:,k+1)=xx(k*L+1:k*L+Np);
end
a=hamming(Np);
XW=diag(a)*X;
XF1=fft(XW);
XF1=fftshift(XF1, 1);
E=zeros(Np,P);
for k=-Np/2:Np/2-1
    for m=0:P-1
        E(k+Np/2+1,m+1)=exp(-1i*2*pi*(k*m*L)/Np);
    end
end


XD=XF1.*E;
XD=transpose(XD);  
XML = (XD.*conj(XD));


XFL2 = fft(XML);

% XFL2 = fftshift(XFL2,1);
% 
% XFL2=XFL2(P/2+1:3*P/4, :);
XFL2 = XFL2(1:P/4,Np/2+1:end);
ML =  abs(XFL2);

alphao = 0:fs/N:(P/4-1)*fs/N;
fo = 0:fs/Np:fs/2-fs/Np;

SxL = ML';


