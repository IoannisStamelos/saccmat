function plotswj(time_series,swjons,swjfin,eye)
    t = time_series(:,1);
    if isempty(swjons)
        disp("No SWJs detected.")
        figure('Name','Horizontal')
        title("Horizontal" + eye)
        set(0,'DefaultFigureWindowStyle','docked')
        plot(t,time_series(:,2))
        xlabel("seconds")
        ylabel("degrees")
    else 
        figure('Name','SWJ ' + eye)
        set(0,'DefaultFigureWindowStyle','docked')
        plot(t,time_series(:,2))
        xlabel("seconds")
        ylabel("degrees")
        title("SWJ " + eye)
        hold on
        xline(t(swjons))
        xline(t(swjfin),'r')
        yline(mode(time_series(:,2)),'-')
        disp("Number of Square Wave Jerks:")
        disp(numel(swjons))
        hold off
    end
end