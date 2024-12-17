function [leftsacc,rightsacc] = plotsacc()
path = uigetdir();
[left,right,~] = preprocess(path);
[leftsacc,rightsacc,~,~,~,~] = get_saccade_data(left,right,100);
t = left(:,1);
tsaccleft1 = t(leftsacc(:,1));
tsaccright1 = t(rightsacc(:,1));
tsaccleft2 = t(leftsacc(:,2));
tsaccright2 = t(rightsacc(:,2));
figure
plot(t,left(:,2));
hold on

[~, idx_start_1] = arrayfun(@(x) min(abs(t - x)), tsaccleft1);
[~, idx_end_1] = arrayfun(@(x) min(abs(t - x)), tsaccleft2);
        plot(t(idx_start_1), left(idx_start_1, 2), 'b*', 'MarkerSize', 5, 'LineWidth', 1); % Starts of saccade 1
        plot(t(idx_end_1), left(idx_end_1, 2), 'b>', 'MarkerSize', 5, 'LineWidth', 1);   % Ends of saccade 1
        
end

