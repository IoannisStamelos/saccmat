function [BCEA,interval] = compute_BCEA(time_series,conf_int)
buffer = 500;

k = [1.13943,3.079,5.80914];
intervals = {'65','95','99.7'};

    x = time_series(:,2);
    x = x(buffer:end);
    y = time_series(:,3);
    y = y(buffer:end);
    std_hor = std(x);
    std_ver = std(y);
    r = corrcoef(x,y);
    
    BCEA = 2*k(conf_int)*pi*std_hor*std_ver*sqrt(1-r(1,2).^2);
   

interval = intervals{conf_int};

end