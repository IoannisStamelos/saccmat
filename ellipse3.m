function ellipse3(time_series)
% Step 1: Compute the mean and covariance matrix
t = time_series(:,1);
x = time_series(:,2);
y = time_series(:,3);
mu = mean([x, y]);  % Mean of the x and y data
covMatrix = cov(x, y);  % Covariance matrix of the x and y data

% Step 2: Eigenvalue decomposition
[Evecs, Eval] = eig(covMatrix);

% Step 3: Compute the angle of the ellipse
angle = atan2(Evecs(2,1), Evecs(1,1));  % Angle of the ellipse

% Step 4: Get the axes lengths (scaled by sqrt of eigenvalues)
axesLengths = 2 * sqrt(diag(Eval));  % 95% coverage (2 standard deviations)

% Calculate the area of the ellipse
ellipse_area = pi * axesLengths(1) * axesLengths(2);

% Step 5: Plot the ellipse
theta = linspace(0, 2*pi, 100);  % Parametric angles for the ellipse
ellipseX = axesLengths(1) * cos(theta);  % X coordinates of the ellipse
ellipseY = axesLengths(2) * sin(theta);  % Y coordinates of the ellipse

% Rotate the ellipse by the angle
rotatedEllipseX = cos(angle) * ellipseX - sin(angle) * ellipseY;
rotatedEllipseY = sin(angle) * ellipseX + cos(angle) * ellipseY;

% Plot the points and the ellipse
figure;
hold on;
scatter(x, y, 10, t, 'filled');  % Scatter plot of the points
plot(mu(1) + rotatedEllipseX, mu(2) + rotatedEllipseY, 'r', 'LineWidth', 2);  % Ellipse plot
axis equal;
xlabel('X');
ylabel('Y');
title(['Gaze Ellipse - Area: ' num2str(ellipse_area, '%.2f') ' (deg²)']);  % Add area to title
cbar = colorbar;
colormap winter
ylabel(cbar, "Time (seconds)");

hold off;
end
