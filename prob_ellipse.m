function [plots, average, plotted_area] = prob_ellipse(x, y, t, k_value)
    buffer = 500; % Discard initial samples
    x = x(buffer:end);
    y = y(buffer:end);
    t = t(buffer:end);

    % Calculate mean and covariance
    Horizontal_mean = mean(x);
    Vertical_mean = mean(y);
    CV = cov(x, y); % Covariance matrix
    [Evec, Eval] = eig(CV); % Eigenvalues and eigenvectors

    % Semi-axes lengths for the ellipse
    xRadius = sqrt(k_value * Eval(1, 1)); % Semi-major axis
    yRadius = sqrt(k_value * Eval(2, 2)); % Semi-minor axis

    % Compute the rotation angle (from eigenvectors)
    rotation = atan2(Evec(2, 1), Evec(1, 1));

    % Compute ellipse area
    plotted_area = pi * xRadius * yRadius;

    % Plotting the ellipse
    theta = linspace(0, 2 * pi, 100); % Angles for ellipse
    ellipse = [xRadius * cos(theta); yRadius * sin(theta)];
    R = [cos(rotation), -sin(rotation); sin(rotation), cos(rotation)]; % Rotation matrix
    rotated_ellipse = R * ellipse; % Rotate the ellipse
    x_plot = rotated_ellipse(1, :) + Horizontal_mean;
    y_plot = rotated_ellipse(2, :) + Vertical_mean;

    % Plot gaze points and ellipse
    hold on;
    plots = scatter(x, y, [], t);
    colormap winter;
    colorbar;
    plot(x_plot, y_plot, 'r', 'LineWidth', 1.5);

    % Plot mean point
    average = scatter(Horizontal_mean, Vertical_mean, 'red', '^', 'filled');
end
