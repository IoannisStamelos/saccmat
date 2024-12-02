function [swj_onset,swj_finish,swj_data] = swj(sac,time_series)

    min_ampl = 0.3;
    sacc_similarity = 0.5;
    max_duration = 0.4;
    min_duration = 0.06;
    t = time_series(:,1);
   
 
    ampl = sqrt((sac(:,6).^2)+(sac(:,7).^2));
    bigampl = ampl(ampl>min_ampl);
    [~,indx] = intersect(ampl,bigampl);
    sac = horzcat(sac,ampl);
    sac = sac(indx,:);
    sac = sortrows(sac,1);
    tsac = t(sac(:,1));
    swj_onset= zeros(1,length(sac));
    swj_finish = swj_onset;
    swj_data = zeros(size(sac));
    
    
 
    
    for i = 1:height(sac)-1
        if tsac(i+1,1)-tsac(i,1)<= max_duration && tsac(i+1,1)-tsac(i,1)>= min_duration
            if sac(i,4)*sac(i+1,4)<0
               if (abs(sac(i,9)-sac(i+1,9))/(sac(i,9)+sac(i+1,9)))<=sacc_similarity                   
                       swj_onset(i) = sac(i,2);
                       swj_finish(i) = sac(i+1,1);
                       swj_data(i,:) = sac(i,:);
                       swj_data(i+1,:)= sac(i+1,:);
               end
            end
        end
    end
    
   swj_data = swj_data(~all(swj_data == 0, 2),:);
   swj_onset = nonzeros(swj_onset);
   swj_finish = nonzeros(swj_finish);
   

end
    