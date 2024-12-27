function BCEA = compute_BCEA(time_series, conf_int)
    % buffer to discard initial samples
    buffer = 200; 
    k = -log(1-conf_int);
    % Extract positions
    x = time_series(:, 2); 
    y = time_series(:, 3); 
    x = x(buffer:end); 
    y = y(buffer:end);

    % Calculate statistics
    std_hor = std(x); % Standard deviation in horizontal direction (now in minarc)
    std_ver = std(y); % Standard deviation in vertical direction (now in minarc)
    r = corrcoef(x, y); 
    rho = r(1, 2); % Correlation coefficient

  
    BCEA = 2 * k * pi * std_hor * std_ver * sqrt(1 - rho^2);  

end
