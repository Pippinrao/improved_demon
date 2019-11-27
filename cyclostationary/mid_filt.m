function mid_data = mid_filt(data,point)

    n = length(data);
    mid_data = data;
    for ii = 1:n
        left = max(1,ii-point);
        right = min(n,ii+point);
        tmp = data(left:right);
        mid_data(ii) = median(tmp);        
    end   

end