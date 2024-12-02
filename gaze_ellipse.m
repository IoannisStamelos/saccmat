function  gaze_ellipse(time_series,BCEA,eye,pos)

    posdegshorz = [0,-23,23,0,0];
    posdegsvert = [0,0,0,13,-13];
    
        x = time_series(:,2);
        y = time_series(:,3);
        t = time_series(:,1);
        figure("Name","Gaze Ellipse, " + eye + " eye")
        title(eye + " eye")
        subtitle("BCEA: " + BCEA + " (deg^2)")
        
        [~,average] = prob_ellipse(x,y,t); 
        pointer = scatter(posdegshorz(pos),posdegsvert(pos),'magenta','v','filled');
        subset = [average,pointer];
        legend(subset,["Mean gaze point","Screen pointer"])
        xlabel('Horizontal position (degrees)')
        ylabel('Vertical position (degrees)')
    
end