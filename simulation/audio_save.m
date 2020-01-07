clc;clear;close 'all';
filename = '../data/low_demon.bin';
FS = 32000;
fid = fopen(filename,'rb');
wav_data = fread(fid,'float32');
wav_data = wav_data/max(max(wav_data),abs(min(wav_data)));
audiowrite('../data/wav_sim_data.wav',wav_data,FS);
filename = '../data/wav_sim_data.wav';
[data_time,fs] = audioread(filename);
N=fs*16;
data_time = data_time(N*0+1:N*1);
figure
plot(data_time);
figure
f = (0:N-1)/N*fs;
plot(f,10*log10(abs(fft(data_time))));