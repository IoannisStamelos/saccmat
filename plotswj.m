function plotswj(time_series, sacctimes, eye)
    t = time_series(:,1);
    
    if isempty(sacctimes)
        disp("No SWJs detected.")
        figure('Name','Horizontal')
        title("Horizontal " + eye)
        set(0,'DefaultFigureWindowStyle','docked')
        plot(t,time_series(:,2))
        xlabel("seconds")
        ylabel("degrees")
    else 
        set(0,'DefaultFigureWindowStyle','docked')
        nexttile
        hold on
        plot(t, time_series(:, 2), 'k-', 'LineWidth', 1.5); 
        plot(t,time_series(:, 3), 'k--','LineWidth', 0.5);
        
        % Find indices of saccade start and end times
        [~, idx_start_1] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,1));
        [~, idx_end_1] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,2));
        [~, idx_start_2] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,3));
        [~, idx_end_2] = arrayfun(@(x) min(abs(t - x)), sacctimes(:,4));
        
        % Horizontal
        plot(t(idx_start_1), time_series(idx_start_1, 2), 'b*', 'MarkerSize', 5, 'LineWidth', 1); % Starts of saccade 1
        plot(t(idx_end_1), time_series(idx_end_1, 2), 'b>', 'MarkerSize', 5, 'LineWidth', 1);   % Ends of saccade 1
        plot(t(idx_start_2), time_series(idx_start_2, 2), 'r*', 'MarkerSize', 5, 'LineWidth', 1); % Starts of saccade 2
        plot(t(idx_end_2), time_series(idx_end_2, 2), 'r>', 'MarkerSize', 5, 'LineWidth', 1);   % Ends of saccade 2
        % Vertical
        plot(t(idx_start_1), time_series(idx_start_1, 3), 'b*', 'MarkerSize', 3, 'LineWidth', 1); % Starts of saccade 1
        plot(t(idx_end_1), time_series(idx_end_1, 3), 'b>', 'MarkerSize', 3, 'LineWidth', 1);   % Ends of saccade 1
        plot(t(idx_start_2), time_series(idx_start_2, 3), 'r*', 'MarkerSize', 3, 'LineWidth', 1); % Starts of saccade 2
        plot(t(idx_end_2), time_series(idx_end_2, 3), 'r>', 'MarkerSize', 3, 'LineWidth', 1);   % Ends of saccade 2

        % Add counting labels for the starts of saccades
        arrayfun(@(i) text(t(idx_start_1(i)), time_series(idx_start_1(i), 2) + (3/2*mean(time_series(:,2))), ...
            sprintf('%d', i), 'Color', 'black','FontSize',7), 1:length(idx_start_1));

        title(eye + " eye")
        subtitle(size(sacctimes,1) + " SWJ")
        
        % Add a legend to clarify the visualization
        legend({'Horizontal Position', 'Vertical Position' ...
                'Saccade 1 Start (*)', 'Saccade 1 End (>)', ...
                'Saccade 2 Start (*)', 'Saccade 2 End (>)'});
        hold off
    end
end
