
while true
        path = uigetdir();
        if isequal(path,0)
            disp('User cancelled. Exiting.');
            break
        else
            disp(['File folder: ', path]);
            [left,right,samplerate] = preprocess(path);
        
        end
        
       [leftsacc, rightsacc, left, right, samples,samplerate] = get_saccade_data(left,right,samplerate);
       clearvars -except left right samplerate rightsacc leftsacc 
        
    
       [swj_left,swjdata_left] = swj(rleftsacc,left,PLOT);
       [swj_right,swjdata_right] = swj(rightsacc,right,PLOT);
       
       
      break      



end