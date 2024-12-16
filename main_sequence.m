function [ampl,vpeak,duration] = main_sequence(time_series,sac,eye,tsac,samplerate)
    ampl = sqrt(sac(:,6).^2+sac(:,7).^2);
    vpeak = sac(:,3);
    t = time_series(:,1);
    duration = t(sac(:,2))-t(sac(:,1));
    duration2 = (1/samplerate)*(sac(:,2)-sac(:,1));
    duration - duration2
    

    nexttile
    
    scatter(ampl,duration2,15,tsac,'filled')
    set(gca,'Color','k')
    cbar = colorbar;
    colormap spring
    ylabel(cbar, "Time (seconds)");

    xlabel("Amplitude (deg)")
    ylabel("Duration (ms)")
    p = polyfit(ampl,duration2,2);
    eqn = poly2sym(p);
    subtitle(char(vpa(eqn,2)))
    xest = linspace(min(ampl), max(ampl), 75);
    yest = polyval(p, xest);
    hold on
    plot(xest, yest, '-w');
  
    title(eye + " eye")
    
    nexttile   
    
    scatter(ampl,vpeak,15,tsac,'filled')
    set(gca,'Color','k')
    colormap spring
    ylabel(cbar, "Time (seconds)");
    xlabel("Amplitude (deg)")
    ylabel("Peak velocity (deg/s)")
    p2 = polyfit(ampl,vpeak,2);
    eqn2 = poly2sym(p2);
    subtitle(char(vpa(eqn2,2)))
    xest2 = linspace(min(ampl), max(ampl), 75);
    yest2 = polyval(p2, xest2);
    hold on
    plot(xest2, yest2, '-w');
  
    title(eye + " eye")
end
