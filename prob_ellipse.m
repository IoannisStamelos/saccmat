function [plots,average] =  prob_ellipse(x,y,t)
% Plotting probability ellipses of the bivariate normal distribution
buffer = 500;
% Create data sets 
Horizontal_Position = x(buffer:end);
Vertical_Position = y(buffer:end);
t = t(buffer:end);
% Calculate movements of the data sets
% Observed
Horizontal_mean = trimmean(Horizontal_Position,95); % x Position mean
Vertical_mean= trimmean(Vertical_Position,95); % y Position mean
CV = cov(Horizontal_Position,Vertical_Position); % covariance of x and y
[Evec, Eval]=eig(CV); % Eigen values and vectors of covariance matrix
% Plot observed multivariate contours
% Observed data
xCenter = Horizontal_mean; % ellipses centered at sample averages
yCenter = Vertical_mean;
theta = 0 : 0.01 : 2*pi; % angles used for plotting ellipses
% compute angle for rotation of ellipse
% rotation angle will be angle between x axis and first eigenvector
x_vec= [1 ; 0]; % vector along x-axis
cosrotation =dot(x_vec,Evec(:,1))/(norm(x_vec)*norm(Evec(:,1))); 
rotation =pi/2-acos(cosrotation); % rotation angle
R = [sin(rotation) cos(rotation); ...
      -cos(rotation) sin(rotation)]; % create a rotation matrix
% create chi squared vector
chisq = [2.291 6.158]; % percentiles of chi^2 dist df=2
% size ellipses for each quantile
xRadius = zeros(1,2);
yRadius = xRadius; 
a = cell(1,2);
b = a;
rotated_Coords = a;
x_plot = a;
y_plot = a;
for i = 1:length(chisq)
    % calculate the radius of the ellipse
    xRadius(i)=(chisq(i)*Eval(1,1))^.5; % primary
    yRadius(i)=(chisq(i)*Eval(2,2))^.5; % secondary
    % lines for plotting ellipse
    a{i} = xRadius(i)* cos(theta);
    b{i} = yRadius(i) * sin(theta);
    % rotate ellipse
    rotated_Coords{i} = R*[a{i} ; b{i}];
    % center ellipse
    x_plot{i}=rotated_Coords{i}(1,:)'+xCenter;
    y_plot{i}=rotated_Coords{i}(2,:)'+yCenter;
end
% Set up plot
%figure
%xlabel('Horizontal position (pixels)')
%ylabel('Vertical position (pixels)')
hold on
% Plot Gaze points
plots = scatter(Horizontal_Position,Vertical_Position,[],t);
cbar = colorbar;
colormap winter
ylabel(cbar,"Time (seconds)")
% Plot contours
for j = 1:length(chisq)
    plot(x_plot{j},y_plot{j})
end
% Plot Center point
average = scatter(mean(Horizontal_Position),mean(Vertical_Position),'red','^','filled');

%legend('Gaze points','68.2%', '95.4%', 'Center point')
hold on
end