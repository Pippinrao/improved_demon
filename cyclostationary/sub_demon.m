function demon_data = sub_demon(data,fl,fh,fs)
    
    n = length(data);
    df = fs/n;
    freq_data = fft(data);
    freq_data(1:floor(fl/df)) = 0;
    freq_data(n-floor(fl/df)+2:n) = 0;
    freq_data(floor(fh/df):n-floor(fh/df+2)) = 0;
    demon_data = ifft(freq_data);
    demon_data = abs(demon_data).^2;    

end