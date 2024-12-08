function gaze_density_ellipse(time_series, eye)
    % Extract position data
    x = time_series(:, 2); % horizontal gaze positions
    y = time_series(:, 3); % vertical gaze positions
    t = time_series(:, 1); % time points

    % Compute mean gaze and standard deviations
    mean_x = mean(x);
    mean_y = mean(y);
    std_x = std(x);
    std_y = std(y);
    
    % Calculate the correlation coefficient
    r = corrcoef(x, y);
    r = r(1, 2);

    % Calculate the BCEA (assuming k = 1 for simplicity)
    k_value = 1; % Adjust k_value as needed
    radii_factor = sqrt(1 / (2 * pi * k_value));
    BCEA_radius_x = radii_factor * std_x * sqrt(1 - r^2);
    BCEA_radius_y = radii_factor * std_y * sqrt(1 - r^2);
    BCEA = pi * BCEA_radius_x * BCEA_radius_y; % Area of the BCEA ellipse
    
    % Figure setup with BCEA in the title
    figure("Name", "Gaze Density Ellipse - " + eye + " Eye")
    title({eye + " Eye", "BCEA: " + num2str(BCEA, '%.2f') + " (deg²)"});

    % Plot the gaze points
    scatter(x, y, 10, t, 'filled'); % Scatter plot of gaze points colored by time
    hold on;

    % Estimate the density using Kernel Density Estimation (KDE)
    [density, xi, yi] = ksdensity([x, y]);

    % Create a meshgrid for xi and yi
    [X, Y] = meshgrid(xi, yi); % Creating the meshgrid

    % Reshape the density vector into a 2D matrix
    Z = reshape(density, length(yi), length(xi)); % Reshaping density to match the meshgrid dimensions

    % Plot density contours directly from the reshaped density
    contour(X, Y, Z, [0.95*max(Z(:)), 0.95*max(Z(:))], 'LineWidth', 2, 'LineColor', 'r');

    % Plot the mean gaze point (center of the density region)
    scatter(mean_x, mean_y, 'red', 's', 'filled'); % mean gaze point as a red square
    
    % Formatting and labels
    xlabel('Horizontal position (degrees)');
    ylabel('Vertical position (degrees)');
    colorbar;
    colormap winter;
    ylabel(colorbar, 'Density');
    
    % Formatting and legend
    legend("Gaze Points", "Density Contour (95%)", "Mean Gaze Point");
    hold off;
end
