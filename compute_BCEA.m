function [BCEA, interval] = compute_BCEA(time_series, conf_int, k_value)
    % buffer to discard initial samples
    buffer = 200; 

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

    % Compute BCEA in minarc^2 (since x and y are in minarc)
    BCEA = 2 * k_value * pi * std_hor * std_ver * sqrt(1 - rho^2);  % Now BCEA is in minarc^2

    % Confidence interval labels
    intervals = {'65', '95', '99.7'}; 
    interval = intervals{conf_int};
end
