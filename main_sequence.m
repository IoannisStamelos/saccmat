function [ampl, vpeak, duration, mse_duration, mse_vpeak] = main_sequence(time_series, sac, eye, tsac, samplerate)
    % Calculate amplitude, peak velocity, and duration
    ampl = sqrt(sac(:,6).^2 + sac(:,7).^2);
    vpeak = sac(:,3);
    t = time_series(:,1);

    duration = t(sac(:,2))-t(sac(:,1));
    duration2 = (1/samplerate)*(sac(:,2)-sac(:,1));
    

    duration = t(sac(:,2)) - t(sac(:,1));
    duration2 = (1 / samplerate) * (sac(:,2) - sac(:,1));


    % First subplot: Amplitude vs. Duration
    nexttile

    
    scatter(ampl,duration,15,tsac,'filled')
    set(gca,'Color','k')

    scatter(ampl, duration2, 15, tsac, 'filled')
    set(gca, 'Color', 'k')

    cbar = colorbar;
    colormap spring
    ylabel(cbar, "Time (milliseconds)");
    xlabel("Amplitude (deg)")
    ylabel("Duration (ms)")

    p = polyfit(ampl,duration,2);

    % Linear fit and equation display
    p = polyfit(ampl, duration2, 1);
    eqn = poly2sym(p);
    

    % Calculate MSE for duration
    yfit = polyval(p, ampl);
    mse_duration = mean((duration2 - yfit).^2);

    % Plot linear fit
    xest = linspace(min(ampl), max(ampl), 75);
    yest = polyval(p, xest);
    hold on
    plot(xest, yest, '-w');

    title(eye + " eye")
    subtitle(char(vpa(eqn, 2))+ ", MSE: "+ mse_duration)

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
    eqn2 = poly2sym(p2);
    
    yfit2 = polyval(p2, ampl);
    mse_vpeak = mean((vpeak - yfit2).^2);


   
    % Plot linear fit
    xest2 = linspace(min(ampl), max(ampl), 75);
    yest2 = polyval(p2, xest2);
    hold on
    plot(xest2, yest2, '-w');

    subtitle(char(vpa(eqn2, 2)) +", MSE: " + mse_vpeak)

    title(eye + " eye")
    
end
