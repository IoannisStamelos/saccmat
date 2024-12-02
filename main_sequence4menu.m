function [ampl,vpeak,duration] = main_sequence4menu(gaze,sac,eye,position)
    ampl = sqrt(sac(:,6).^2+sac(:,7).^2);
    vpeak = sac(:,3);
    t = gaze(:,1);
    duration = t(sac(:,2))-t(sac(:,1));

    figure("Name","Ampl-Dt, " + eye + " eye, Gaze " + position)
    
    scatter(ampl,duration)
    xlabel("Amplitude (deg)")
    ylabel("Duration (ms)")
    p = polyfit(ampl,duration,2);
    eqn = poly2sym(p);
    subtitle(char(vpa(eqn,2)))
    xest = linspace(min(ampl), max(ampl), 75);
    yest = polyval(p, xest);
    hold on
    plot(xest, yest, '-b');
  
    title(eye + " eye, Gaze " + position)
    
       
    figure("Name","Ampl-Vpeak, " + eye + " eye, Gaze " + position)
    scatter(ampl,vpeak)
    xlabel("Amplitude (deg)")
    ylabel("Peak velocity (deg/s)")
    p2 = polyfit(ampl,vpeak,2);
    eqn2 = poly2sym(p2);
    subtitle(char(vpa(eqn2,2)))
    xest2 = linspace(min(ampl), max(ampl), 75);
    yest2 = polyval(p2, xest2);
    hold on
    plot(xest2, yest2, '-b');
  
    title(eye + " eye, " + position+" position")
end
