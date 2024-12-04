function gaze_ellipse(time_series, BCEA, eye, pos, k_value)
    % Define positions of screen points (assuming a specific screen layout)
    posdegshorz = [0, -23, 23, 0, 0]; % horizontal positions (degrees)
    posdegsvert = [0, 0, 0, 13, -13]; % vertical positions (degrees)
    
    % Extract position data and remove buffer data
    x = time_series(:,2); % horizontal gaze positions
    y = time_series(:,3); % vertical gaze positions
    t = time_series(:,1); % time points

    % Figure setup
    figure("Name", "Gaze Ellipse - " + eye + " Eye")
    title(eye + " Eye")
    subtitle("BCEA: " + BCEA + " (deg²)")
    
    % Plot the gaze points
    scatter(x, y, 10, t, 'filled'); % Scatter plot of gaze points colored by time
    hold on;

    
    % Calculate the mean gaze point (for center of the ellipse)
    mean_x = mean(x); 
    mean_y = mean(y);

    % Calculate the covariance matrix and eigenvalues/eigenvectors
    covariance_matrix = cov(x, y);
    [eigenvectors, eigenvalues] = eig(covariance_matrix);
    
    % Compute correlation coefficient from the covariance matrix
    r = covariance_matrix(1, 2) / (sqrt(covariance_matrix(1, 1)) * sqrt(covariance_matrix(2, 2)));
    
    % Compute radii from BCEA formula
    BCEA_radius_x = sqrt(BCEA * eigenvalues(1, 1) / (2 * pi * k_value * sqrt(1 - r^2)));
    BCEA_radius_y = sqrt(BCEA * eigenvalues(2, 2) / (2 * pi * k_value * sqrt(1 - r^2)));
    
    % Generate the angles for plotting the ellipse
    theta = 0 : 0.01 : 2 * pi;
    x_ellipse = BCEA_radius_x * cos(theta);
    y_ellipse = BCEA_radius_y * sin(theta);
    
    % Rotate the ellipse based on the eigenvectors
    rotated_ellipse = eigenvectors * [x_ellipse; y_ellipse];
    
    % Plot the BCEA ellipse centered at the mean gaze position
    plot(rotated_ellipse(1, :) + mean_x, rotated_ellipse(2, :) + mean_y, 'LineWidth', 1);
    
    % Plotting the mean gaze point (center of the BCEA ellipse)
    scatter(mean_x, mean_y, 'red', 's', 'filled'); % mean gaze point in blue
    
    % Plot the pointer indicating the screen position
    scatter(posdegshorz(pos), posdegsvert(pos), 'magenta', 'v', 'filled');
        % Make the axes consistent
    %axis equal; % Ensure that both axes have the same scaling
    %xlim([min(x)-5, max(x)+5]); % Set x-axis limits based on data range
    %ylim([min(y)-5, max(y)+5]); % Set y-axis limits based on data range
    
    cbar = colorbar;
    colormap winter
    ylabel(cbar,"Time (seconds)")
    
    % Formatting and labels
    xlabel('Horizontal position (degrees)');
    ylabel('Vertical position (degrees)');
    
    % Correct legend
    legend("Gaze Points","BCEA Ellipse", "Mean Gaze Point", "Screen Pointer", 'Location', 'best');
    hold off;
end
