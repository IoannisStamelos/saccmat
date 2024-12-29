function [sacctimes, swj_data, sac,tsac_start] = swj(sac, time_series,horizontal)

    % Parameters
    min_ampl = 0.4; %in degrees
    max_ampl = 5;
    amplitude_difference_threshold = 0.2; %(ampl_1 - ampl_2) /(ampl_1 + ampl_2)
    angle_opposition_threshold = 150; %in degrees
    max_duration = 500; %in milliseconds
    min_duration = 100;  %in milliseconds
    if nargin>2 && contains(horizontal,'horizontal','IgnoreCase',true)
        amplitude = sac(:,6);
    else
        amplitude = sqrt(sac(:,6).^2 + sac(:,7).^2);
    end


    
    t = time_series(:,1);
   
    
    % Filter saccades by amplitude
    orig_number = height(sac);
    valid_idx = amplitude > min_ampl & amplitude <= max_ampl;
    sac = [sac(valid_idx,:), amplitude(valid_idx)]; %amplitude in last column of sac
    sac = sortrows(sac, 1); 
    tsac_start = t(sac(:,1)); %start times of saccades 
    tsac_end = t(sac(:,2)); %end times of saccades


   
    num_saccades = size(sac, 1);
    start1 = [];
    start2 = [];
    end1 = [];
    end2 = [];
    swj_data = [];
    discarded_minampl = orig_number - height(sac);
    discarded_time = 0;
    discarded_angle = 0;
    discarded_ampldiff = 0;
    discarded_consecutive = 0;

for i = 1:num_saccades - 1
    
    saccwOvershoot1 = [sac(i,6), sac(i,7)];
    saccwOvershoot2 = [sac(i+1,6), sac(i+1,7)];
    ISI = tsac_start(i+1) - tsac_end(i);
    amplitude_difference = abs(sac(i,end) - sac(i+1,end)) / (sac(i,end) + sac(i+1,end));
    
    % Check Intersaccadic interval
    if ISI < min_duration || ISI > max_duration
        discarded_time = discarded_time + 1;
        continue;
    end
    
    % Check Angle Opposition
    if nargin>2 && contains(horizontal,'horizontal','IgnoreCase',true)
        cos_theta = dot([sac(i,6), 0],[sac(i+1,6),0]) / (norm([sac(i,6), 0]) * norm([sac(i+1,6),0]));
        cos_theta = max(-1, min(1, cos_theta)); % Clamp values
        angle = rad2deg(acos(cos_theta));
    else 
        cos_theta = dot(saccwOvershoot1, saccwOvershoot2) / (norm(saccwOvershoot1) * norm(saccwOvershoot2));
        cos_theta = max(-1, min(1, cos_theta)); % Clamp values
        angle = rad2deg(acos(cos_theta));
    end
    
    if angle < angle_opposition_threshold
        discarded_angle = discarded_angle + 1;
        continue;
    end
    
    % Check Amplitude Difference
    if amplitude_difference > amplitude_difference_threshold
        discarded_ampldiff = discarded_ampldiff + 1;
        continue;
    end
    
    % Discard oscillations 
    if ~isempty(swj_data) && any(start2 == sac(i,1))
        discarded_consecutive = discarded_consecutive +1;
        continue
    else
        start1 = [start1; sac(i,1)];
        end1 = [end1; sac(i,2)];
        start2 = [start2; sac(i+1,1)];
        end2 = [end2; sac(i+1,2)];
        swj_data = [swj_data; sac(i,:); sac(i+1,:)];
    end
end
sacctime = {start1, end1, start2 end2};
sacctimes = [];
for i = 1:length(sacctime)
    sacctime{i} = nonzeros(t(sacctime{i}));
    sacctimes = horzcat(sacctimes,sacctime{i}); % (n,4) matrix
    
end
%discarded = {discarded_minampl,discarded_time,discarded_angle,discarded_ampldiff,discarded_consecutive}
discarded = table(discarded_minampl, discarded_time, discarded_angle, discarded_ampldiff, discarded_consecutive, ...
    'VariableNames',["wrong size", "wrong timing", "wrong angle", "too different", "consecutive"])
swj_data = array2table(swj_data,"VariableNames",["SaccadeStartIdx","SaccadeEndIdx","Vpeak","dx","dy","dx_max","dy_max", "Vmean","Angle","Amplitude"]);
%disp([discarded_minampl discarded_time discarded_angle discarded_ampldiff discarded_consecutive])

end
