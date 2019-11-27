function envelope = maxfilt(data)

    n = length(data);
    maxdata = [1,data(1)];
    for ii = 2:n-1
        if data(ii) > data(ii-1) && data(ii) > data(ii+1)
            maxdata = [maxdata;ii,data(ii)];
        end
    end
    maxdata = [maxdata;n,data(end)];
  
    xx = (1:n)';
    envelope = interp1(maxdata(:,1),maxdata(:,2),xx,'linear');

end