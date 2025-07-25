function gazeEllipse(time_series, BCEA, eye, pos)
% Step 1: Compute the mean and covariance matrix
    posdegshorz = [0,-23,23,0,0];
    posdegsvert = [0,0,0,13,-13];
    
buffer = 200;
t = time_series(:,1);
x = time_series(:,2);
y = time_series(:,3);
t = t(buffer:end);
x = x(buffer:end);  
y = y(buffer:end);

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
nexttile
hold on;
scatter(posdegshorz(pos),posdegsvert(pos),'magenta','v','filled');


scatter(x, y, 10, t);  % Scatter plot of the points
plot(mu(1) + rotatedEllipseX, mu(2) + rotatedEllipseY, '-k', 'LineWidth', 1);  % Ellipse plot
meanpoint = scatter(mean(x), mean(y), 50,'r','s','filled');
uistack(meanpoint,'top')

%axis equal;
xlabel('Horizontal');
ylabel('Vertical');
title(['Gaze Ellipse - Area: ' num2str(ellipse_area, '%.2f') ' (deg²)'], "BCEA: " + BCEA + ', '+ eye +" eye");  % Add area to title
cbar = colorbar;
colormap winter
ylabel(cbar, "Time (milliseconds)");
legend("Screen Pointer","Eye position","Density Ellipse","Mean Gaze Point")

hold off;
end
