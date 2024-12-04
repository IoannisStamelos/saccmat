function [BCEA, interval] = compute_BCEA(time_series, conf_int, k_value)
    buffer = 500; % Discard initial samples

    % Extract positions
    x = time_series(:, 2);
    y = time_series(:, 3);
    x = x(buffer:end);
    y = y(buffer:end);

    % Calculate statistics
    std_hor = std(x);
    std_ver = std(y);
    r = corrcoef(x, y);
    rho = r(1, 2); % Correlation coefficient

    % Compute BCEA
    BCEA = 2 * k_value * pi * std_hor * std_ver * sqrt(1 - rho^2);

    % Confidence interval labels
    intervals = {'65', '95', '99.7'};
    interval = intervals{conf_int};
end
