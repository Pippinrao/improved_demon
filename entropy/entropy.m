function H = entropy(spec)
    [xl,yl] = size(spec);
    H = zeros(xl,1);
    for ii = 1:xl
        sum_i = sum(spec(ii,:));
        p_i = spec(ii,:)/sum_i;
        H(ii) = -sum(p_i.*log(p_i));
    end
    H = H./double(yl);
end