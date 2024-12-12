function [valid_pairs, dot_products] = classify_swj(sac, time_series)

    % Parameters for SWJ classification
    min_ampl = 0.3;            % Minimum amplitude threshold
    max_duration = 0.4;        % Maximum time interval between saccades (seconds)
    min_duration = 0.1;        % Minimum time interval between saccades (seconds)
    dot_threshold = -0.8;      % Threshold for negative dot product
    ampl_similarity_threshold = 0.7; % Threshold for amplitude similarity (ratio of amplitudes)
    
    % Extract relevant data
    t = time_series(:, 1);     % Time vector
    saccades = sac(:, 4:5);    % X and Y displacement components
    
    % Compute amplitude of saccades
    ampl = sqrt(sum(saccades.^2, 2));
    
    % Filter out saccades with small amplitude
    valid_indices = ampl > min_ampl; 
    sac = sac(valid_indices, :); 
    saccades = saccades(valid_indices, :);
    stimes = t(sac(:, 1));      % Start times of saccades
    etimes = t(sac(:, 2));      % End times of saccades
    
    % Normalize the saccade vectors
    norm_factors = sqrt(sum(saccades.^2, 2));
    saccades_normalized = saccades ./ norm_factors;
    
    % Initialize variables for pair storage
    N = size(saccades, 1);      % Number of filtered saccades
    dot_products = zeros(N, N); % Dot product matrix
    valid_pairs = [];           % Store valid SWJ pairs
    
    % Compute dot products and classify SWJ pairs
    for i = 1:N-1
        for j = i+1:N
            % Calculate time difference
            time_diff = abs(stimes(j) - etimes(i));
            
            % Apply time filter
            if time_diff >= min_duration && time_diff <= max_duration
                % Compute dot product of the normalized vectors
                dot_products(i, j) = dot(saccades_normalized(i, :), saccades_normalized(j, :));
                
                % Check for opposite directions and classify as SWJ
                if dot_products(i, j) < dot_threshold
                    % Check for amplitude similarity
                    ampl_ratio = min(ampl(i), ampl(j)) / max(ampl(i), ampl(j));
                    if ampl_ratio >= ampl_similarity_threshold
                        % Check if this pair is already added
                        if isempty(valid_pairs) || ~any(valid_pairs(:, 1) == i) && ~any(valid_pairs(:, 2) == i) && ...
                           ~any(valid_pairs(:, 1) == j) && ~any(valid_pairs(:, 2) == j)
                            valid_pairs = [valid_pairs; i, j, dot_products(i, j), stimes(i), stimes(j), etimes(i), etimes(j)];
                        end    
                    end
                end
            end
        end
    end
    
    % Sort valid pairs for better visualization
    valid_pairs = sortrows(valid_pairs, 1);

    % Set up the figure
    figure;
    set(0, 'DefaultFigureWindowStyle', 'docked');
    plot(t, time_series(:, 2), 'k-', 'LineWidth', 1); % Original time series
    xlabel("Time (seconds)");
    ylabel("Amplitude (degrees)");
    title("Square Wave Jerks (SWJs)");
    hold on;

    % Extract start and end times of all saccades in valid pairs
    start_times_1 = valid_pairs(:, 4); % Start times of saccade 1
    end_times_1 = valid_pairs(:, 6);   % End times of saccade 1
    start_times_2 = valid_pairs(:, 5); % Start times of saccade 2
    end_times_2 = valid_pairs(:, 7);   % End times of saccade 2;

    % Match times to closest indices in the time vector
    [~, idx_start_1] = arrayfun(@(x) min(abs(t - x)), start_times_1);
    [~, idx_end_1] = arrayfun(@(x) min(abs(t - x)), end_times_1);
    [~, idx_start_2] = arrayfun(@(x) min(abs(t - x)), start_times_2);
    [~, idx_end_2] = arrayfun(@(x) min(abs(t - x)), end_times_2);

    % Plot all starts and ends of saccades in valid pairs
    plot(t(idx_start_1), time_series(idx_start_1, 2), 'bo', 'MarkerSize', 8, 'LineWidth', 1.5); % Starts of saccade 1
    plot(t(idx_end_1), time_series(idx_end_1, 2), 'b*', 'MarkerSize', 8, 'LineWidth', 1.5);   % Ends of saccade 1
    plot(t(idx_start_2), time_series(idx_start_2, 2), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5); % Starts of saccade 2
    plot(t(idx_end_2), time_series(idx_end_2, 2), 'r*', 'MarkerSize', 8, 'LineWidth', 1.5);   % Ends of saccade 2

    % Add a legend to clarify the visualization
    legend({'Original Time Series', ...
            'Saccade 1 Start (o)', 'Saccade 1 End (*)', ...
            'Saccade 2 Start (o)', 'Saccade 2 End (*)'}, ...
            'Location', 'best');

    % Display the total number of SWJs
    disp("Number of Square Wave Jerks:");
    disp(height(valid_pairs));

    hold off;
    
end
