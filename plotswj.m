function plotswj(time_series,sacctimes,eye)
    t = time_series(:,1);
    if isempty(sacctimes)
        disp("No SWJs detected.")
        figure('Name','Horizontal')
        title("Horizontal" + eye)
        set(0,'DefaultFigureWindowStyle','docked')
        plot(t,time_series(:,2))
        xlabel("seconds")
        ylabel("degrees")
    else 
        
        set(0,'DefaultFigureWindowStyle','docked')
        nexttile
        hold on
        plot(t, time_series(:, 2), 'k-', 'LineWidth', 1); % Original time series
        class(sacctimes(:,1))
    [~, idx_start_1] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,1));
    [~, idx_end_1] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,2));
    [~, idx_start_2] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,3));
    [~, idx_end_2] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,4));
        % Plot all starts and ends of saccades in valid pairs
        class(sacctimes)
    plot(t(idx_start_1), time_series(idx_start_1, 2), 'bo', 'MarkerSize', 5, 'LineWidth', 1.5); % Starts of saccade 1
    plot(t(idx_end_1), time_series(idx_end_1, 2), 'b*', 'MarkerSize', 5, 'LineWidth', 1.5);   % Ends of saccade 1
    plot(t(idx_start_2), time_series(idx_start_2, 2), 'ro', 'MarkerSize', 5, 'LineWidth', 1.5); % Starts of saccade 2
    plot(t(idx_end_2), time_series(idx_end_2, 2), 'r*', 'MarkerSize', 5, 'LineWidth', 1.5);   % Ends of saccade 2
    subtitle(height(sacctimes(:,1))+ " SWJ")
    % Add a legend to clarify the visualization
    legend({'Horizontal Position', ...
            'Saccade 1 Start (o)', 'Saccade 1 End (*)', ...
            'Saccade 2 Start (o)', 'Saccade 2 End (*)'}, ...
            'Location', 'best');
    hold off
    end
end