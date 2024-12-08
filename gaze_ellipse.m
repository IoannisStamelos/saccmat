function gaze_ellipse(data, confidence)
       % Plots a BCEA ellipse for eye position data
    % 
    % Parameters:
    % data: Nx3 array where columns are [t, x, y]
    % confidence: Confidence level for the ellipse (e.g., 0.95 for 95%)
    
    if nargin < 2
        confidence = 0.95; % Default to 95% confidence
    end

    % Extract x and y positions from the data
    x = data(:, 2);
    y = data(:, 3);

    % Calculate the mean and covariance matrix
    mu = [mean(x), mean(y)];
    cov_matrix = cov(x, y);

    % Eigen decomposition to get the axes of the ellipse
    [eigvec, eigval] = eig(cov_matrix);
    
    % Calculate the lengths of the ellipse's axes (major and minor)
    major_axis = sqrt(max(diag(eigval)));
    minor_axis = sqrt(min(diag(eigval)));
    
    % Calculate the chi-square value for the desired confidence level
    chi_square_val = chi2inv(confidence, 2); % 2 degrees of freedom
    scale_factor = sqrt(chi_square_val);  % Scale the axes by this factor
    
    % Scale the axes of the ellipse
    major_axis = scale_factor * major_axis;
    minor_axis = scale_factor * minor_axis;
    
    % Angle of rotation of the ellipse (from the eigenvectors)
    angle = atan2(eigvec(2, 1), eigvec(1, 1));

    % Generate the points of the ellipse
    theta = linspace(0, 2*pi, 100);
    ellipse_points = [cos(theta); sin(theta)]' * diag([major_axis, minor_axis]);
    
    % Rotate the ellipse points using the eigenvector direction
    rotation_matrix = [cos(angle), -sin(angle); sin(angle), cos(angle)];
    ellipse_rot = ellipse_points * rotation_matrix';
    
    % Translate the ellipse points to the mean position
    ellipse_rot = bsxfun(@plus, ellipse_rot, mu); 

    % Create a figure for the plot
    figure;
    
    % Plot the eye position data
    plot(x, y, '.', 'MarkerSize', 8); 
    hold on;  % Keep the points visible while plotting the ellipse

    % Plot the BCEA ellipse
    plot(ellipse_rot(:, 1), ellipse_rot(:, 2), 'r-', 'LineWidth', 2);

    % Plot the center of the ellipse (mean of x and y)
    plot(mu(1), mu(2), 'ko', 'MarkerFaceColor', 'k'); 

    % Set axis properties
    axis equal;
    xlabel('X Position');
    ylabel('Y Position');
    title(['BCEA Ellipse (Confidence: ' num2str(confidence * 100) '%)']);
    grid on;
    
    % Optionally, set axis limits for better visualization
    % xlim([min(x)-1, max(x)+1]);
    % ylim([min(y)-1, max(y)+1]);

    % Show the plot
    hold off;
end