function [duration] = main_sequence(time_series, sac, eye, tsac)
    % Calculate amplitude, peak velocity, and duration
    ampl = sqrt(sac(:,6).^2 + sac(:,7).^2);
    vpeak = sac(:,3);
    t = time_series(:,1);
    duration = t(sac(:,2)) - t(sac(:,1));
    
    % Calculate Z-scores
    zampl = (ampl - mean(ampl)) / std(ampl);
    zvpeak = (vpeak - mean(vpeak)) / std(vpeak);
    zdur = (duration - mean(duration)) / std(duration);
    
    % Identify and remove outliers (Z-score threshold = 3)
    threshold = 3;
    valid_indices = abs(zampl) < threshold & abs(zvpeak) < threshold & abs(zdur) < threshold;
    ampl = ampl(valid_indices);
    vpeak = vpeak(valid_indices);
    duration = duration(valid_indices);
    tsac = tsac(valid_indices);

    % First subplot: Amplitude vs. Duration
    nexttile
    scatter(ampl, duration, 15, tsac, 'filled')
    set(gca, 'Color', 'k')
    cbar = colorbar;
    colormap spring
    ylabel(cbar, "Time (milliseconds)");
    xlabel("Amplitude (deg)")
    ylabel("Duration (ms)")

    % Linear fit and equation display
    p = polyfit(ampl, duration, 1);
    err_1 = immse((ampl - mean(ampl)) / std(ampl), (duration - mean(duration)) / std(duration));

    % Plot linear fit
    xest = linspace(min(ampl), max(ampl), 75);
    yest = polyval(p, xest);
    hold on
    plot(xest, yest, '-w');
    title(eye + " eye")
    subtitle("NMSE: " + err_1)

    % Second subplot: Amplitude vs. Peak Velocity
    nexttile   
    scatter(ampl, vpeak, 15, tsac, 'filled')
    set(gca, 'Color', 'k')
    colormap spring
    ylabel(cbar, "Time (milliseconds)");
    xlabel("Amplitude (deg)")
    ylabel("Peak velocity (deg/s)")

    % Linear fit and equation display
    p2 = polyfit(ampl, vpeak, 1);
    err_2 = immse((ampl - mean(ampl)) / std(ampl), (vpeak - mean(vpeak)) / std(vpeak));

    % Plot linear fit
    xest2 = linspace(min(ampl), max(ampl), 75);
    yest2 = polyval(p2, xest2);
    hold on
    plot(xest2, yest2, '-w');
    subtitle("NMSE: " + err_2)
    title(eye + " eye")
end
