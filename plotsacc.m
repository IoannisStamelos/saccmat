function plotsacc(time_series, sacc, eye, samplerate)

% Convert indices to time (milliseconds)
sacc_time_start = (sacc(:,1) / samplerate) * 1000; % Start times in ms
sacc_time_end = (sacc(:,2) / samplerate) * 1000;   % End times in ms

t = time_series(:,1);

% Create plot

plot(t, time_series(:,2), 'b', 'DisplayName', 'Horizontal Position'); % Horizontal position
hold on
plot(t, time_series(:,3), 'r', 'DisplayName', 'Vertical Position');   % Vertical position

% Plot start points for both horizontal and vertical positions
plot(sacc_time_start, time_series(sacc(:,1), 2), 'b*', 'MarkerSize', 5, 'DisplayName', 'Start Horizontal'); % Start (Horizontal)
plot(sacc_time_start, time_series(sacc(:,1), 3), 'r*', 'MarkerSize', 5, 'DisplayName', 'Start Vertical');   % Start (Vertical)

% Plot end points for both horizontal and vertical positions
plot(sacc_time_end, time_series(sacc(:,2), 2), 'b>', 'MarkerSize', 5, 'DisplayName', 'End Horizontal');   % End (Horizontal)
plot(sacc_time_end, time_series(sacc(:,2), 3), 'r>', 'MarkerSize', 5, 'DisplayName', 'End Vertical');     % End (Vertical)

% Add subtitle and legend
subtitle(eye + " eye, " + height(sacc) + " saccades");
legend('Location', 'best');
hold off 

end