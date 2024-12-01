function [swjs,finish,sac,swjdata,difff] = swj4menu(sac,gaze,eye,PLOT)
    min_ampl = 0.3;
    sacc_similarity = 0.6;
    max_duration = 400;
    min_duration = 60;
    t = gaze(:,1);
    
    ampl = sqrt((sac(:,6).^2)+(sac(:,7).^2));
    bigampl = ampl(ampl>min_ampl);
    [~,indx] = intersect(ampl,bigampl);
    sac = horzcat(sac,ampl);
    sac = sac(indx,:);
    sac = sortrows(sac,1);
    tsac = t(sac(:,1));
    swjs= zeros(1,length(sac));
    finish = swjs;
    swjdata = zeros(size(sac));
    y = gaze(:,3);
    
    difff = y(sac(:,2))-y(sac(:,1));
    
    for i = 1:height(sac)-1
        if tsac(i+1,1)-tsac(i,1)<= max_duration && tsac(i+1,1)-tsac(i,1)>= min_duration
            if sac(i,4)*sac(i+1,4)<0
               if (abs(sac(i,9)-sac(i+1,9))/(sac(i,9)+sac(i+1,9)))<=sacc_similarity
                       swjs(i) = sac(i,2);
                       finish(i) = sac(i+1,1);
                       swjdata(i,:) = sac(i,:);
                       swjdata(i+1,:)= sac(i+1,:);
               end
            end
        end
    end
    
    
    swjs = nonzeros(swjs);
    if isempty(swjs)
        disp("No SWJs detected.")
        figure('Name','Gaze')
        set(0,'DefaultFigureWindowStyle','docked')
        plot(t,gaze(:,2))
        xlabel("milliseconds")
        ylabel("degrees")
    else 
        finish = nonzeros(finish);
        swjdataempty = any(swjdata==0,2);
        swjdata = swjdata(~swjdataempty,:);
        if nargin>3 && contains(PLOT,"plot",'IgnoreCase',true)
            figure('Name','SWJ')
            set(0,'DefaultFigureWindowStyle','docked')
            plot(t,gaze(:,2))
            xlabel("milliseconds")
            ylabel("degrees")
            hold on
            xline(t(swjs))
            xline(t(finish),'r')
        end
        disp("Number of Square Wave Jerks (" + eye + " Eye): " + height(swjs))
       
    end
end
    