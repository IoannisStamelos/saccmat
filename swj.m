function [swj_onset, swj_finish, swj_data, sac, dot_products, swj_dots, swj_onset_intervals] = swj(sac, time_series)

    % Parameters
    min_ampl = 0.4;
    sacc_similarity = 1;
    max_duration = 0.4;
    min_duration = 0.1;

    % Extract time column and compute amplitude
    t = time_series(:,1);
    ampl = sqrt(sac(:,6).^2 + sac(:,7).^2);
    
    % Filter saccades by amplitude
    valid_idx = ampl > min_ampl;
    sac = [sac(valid_idx,:), ampl(valid_idx)];
    sac = sortrows(sac, 1); % Sort by timestamp
    tsac = t(sac(:,1));


    % Initialize outputs
    num_saccades = size(sac, 1);
    swj_onset = [];
    swj_finish = [];
    swj_data = [];
    swj_onset_intervals = zeros(num_saccades - 1, 1);
    

    % Iterate through saccades to detect SWJs
    for i = 1:num_saccades - 1
        % Define successive saccades
        sacc1 = [sac(i,4), sac(i,5)];
        sacc2 = [sac(i+1,4), sac(i+1,5)];
        

        % Temporal and spatial constraints
        time_diff = tsac(i+1) - tsac(i);
        amplitude_similarity = abs(sac(i,end) - sac(i+1,end)) / (sac(i,end) + sac(i+1,end));

        if min_duration <= time_diff && time_diff <= max_duration
            if sac(i,4) * sac(i+1,4) < 0 % Opposite directions
                if amplitude_similarity <= sacc_similarity
                   if  isempty(swj_data) || ~any(swj_finish == sac(i,1))
                    % Mark as SWJ
                    swj_onset = [swj_onset; sac(i,1)];
                    swj_finish = [swj_finish; sac(i+1,1)];
                    swj_data = [swj_data; sac(i,:); sac(i+1,:)];
                    swj_onset_intervals(i) = time_diff;
                   end

                  
                end
            end
        end
    end

    % Finalize outputs
    swj_onset_intervals = nonzeros(swj_onset_intervals);
    swj_onset = nonzeros(swj_onset);
    swj_finish = nonzeros(swj_finish);
end
