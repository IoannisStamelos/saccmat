function  plotsacc(time_series,sacc,eye)

t = time_series(:,1);
tsacc1 = t(sacc(:,1));
tsacc2 = t(sacc(:,2));
nexttile
plot(t,time_series(:,2));
hold on

[~, idx_start_1] = arrayfun(@(x) min(abs(t - x)), tsacc1);
[~, idx_end_1] = arrayfun(@(x) min(abs(t - x)), tsacc2);
        plot(t(idx_start_1), time_series(idx_start_1, 2), 'b*', 'MarkerSize', 5, 'LineWidth', 1); % Starts of saccade 1
        plot(t(idx_end_1), time_series(idx_end_1, 2), 'b>', 'MarkerSize', 5, 'LineWidth', 1);   % Ends of saccade 1
        subtitle(eye + " eye, " + height(sacc) + " saccades")
hold off
        
end

