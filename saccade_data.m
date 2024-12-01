function [leftsacc, rightsacc, left, right, samples,samplerate] = get_sacc_data(left,right,samplerate,PLOT)

samples = horzcat(left(:,1),left(:,2),left(:,3),right(:,2),right(:,3));

[leftsacc,rightsacc] = saccades(samples,samplerate);

    if nargin>3 && contains(PLOT,'PLOT')
        [right_swj,right_finish,right_swj_data] = swj4menu(rsac,gazer,"Right" ,'plot');
        title("Right Eye")
        set(gcf, 'Name', "SWJ, Right Eye, Gaze " + position)
        subtitle(position)
        [left_swj,left_finish,left_swj_data] = swj4menu(lsac,gazel,"Left",'plot');
        title("Left Eye")
        set(gcf, 'Name', "SWJ, Left Eye, Gaze " + position)
        subtitle(position)
    else 
        [right_swj,right_finish,right_swj_data] = swj4menu(rsac,gazer,"Right");
        [left_swj,left_finish,left_swj_data] = swj4menu(lsac,gazel,"Left");
    end
    disp("Number of saccades (Right Eye): " + height(rightsacc))
    disp("Number of saccades (Left Eye): " + height(leftsacc))


end