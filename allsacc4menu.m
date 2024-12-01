function [rsac,lsac,rswj,lswj,rfinish,lfinish,rswjdata,lswjdata,gazer,gazel,gazes] = allsacc4menu(gaze_arrays,position,PLOT)

  
    if nargin>2 && contains(PLOT,'PLOT')
        [rswj,rfinish,rswjdata] = swj4menu(rsac,gazer,"Right" ,'plot');
        title("Right Eye")
        set(gcf, 'Name', "SWJ, Right Eye, Gaze " + position)
        subtitle(position)
        [lswj,lfinish,lswjdata] = swj4menu(lsac,gazel,"Left",'plot');
        title("Left Eye")
        set(gcf, 'Name', "SWJ, Left Eye, Gaze " + position)
        subtitle(position)
    else 
        [rswj,rfinish,rswjdata] = swj4menu(rsac,gazer,"Right");
        [lswj,lfinish,lswjdata] = swj4menu(lsac,gazel,"Left");
    end
    disp("Number of saccades (Right Eye): " + height(rsac))
    disp("Number of saccades (Left Eye): " + height(lsac))

end
%{%}
