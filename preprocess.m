function [left, right, samplerate] = preprocess(path, method)
    % Set default interpolation method
    if nargin < 2 & isempty(method)
        method = 'nearest';
    end
    
    % Load data from CSV files
    left_data = readtable(fullfile(path, "EyePositionData Left.csv"));
    right_data = readtable(fullfile(path, "EyePositionData Right.csv"));
    
    % Extract time, X, and Y columns
    left = table2array(left_data(:, [1, 3, 6]));
    right = table2array(right_data(:, [1, 3, 6]));
    
    % Normalize time to start at zero
    left(:, 1) = left(:, 1) - left(1, 1);
    right(:, 1) = right(:, 1) - right(1, 1);
    
    % Remove duplicates
    [t1, ia1] = unique(left(:, 1), 'stable');
    x1 = left(ia1, 2);
    y1 = left(ia1, 3);
    
    [t2, ia2] = unique(right(:, 1), 'stable');
    x2 = right(ia2, 2);
    y2 = right(ia2, 3);
    
    % Calculate sampling rates
    fs1 = 1 / mean(diff(t1));
    fs2 = 1 / mean(diff(t2));
    %fs1 = 0.1;
    %fs2 = 0.1;
    
    % Define common sampling rate and time vector
    fs_common = min(fs1, fs2);
    dt_common = 1 / fs_common;
    t_start = max(min(t1), min(t2));
    t_end = min(max(t1), max(t2));
    t_common = t_start:dt_common:t_end;
    
    % Interpolate data to common time vector
    x1_common = interp1(t1, x1, t_common, method);
    y1_common = interp1(t1, y1, t_common, method);
    x2_common = interp1(t2, x2, t_common, method);
    y2_common = interp1(t2, y2, t_common, method);
    

left = [t_common', x1_common', y1_common'];


right = [t_common', x2_common', y2_common'];



samplerate = fs_common*1000; %Herz

  
    
    % Plot results
%     figure;
%     plot(t1, x1, '.', 'DisplayName', 'Original Left X');
%     hold on;
%     plot(t2, x2, '.', 'DisplayName', 'Original Right X');
%     plot(t_common, x1_common, '-', 'DisplayName', 'Interpolated Left X');
%     plot(t_common, x2_common, '-', 'DisplayName', 'Interpolated Right X');
%     legend;
%     xlabel('Time (s)');
%     ylabel('Horizontal Position (X)');
%     title('Interpolated and Original Eye Positions');
%     grid on;
%     hold off;
end
