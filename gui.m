
while true
        path = uigetdir();
        if isequal(path,0)
            disp('User cancelled. Exiting.');
            break
        else
            disp(['File folder: ', path]);
            disp("1")
            [left,right,samplerate] = preprocess(path);
        
        end
        
       [leftsacc, rightsacc, left, right, samples, samplerate] = get_saccade_data(left,right,samplerate);
       clearvars -except left right samplerate rightsacc leftsacc 
        
    
       [swjons_left,swjfin_left,swjdata_left] = swj(leftsacc,left);
       [swjons_right,swjfin_right,swjdata_right] = swj(rightsacc,right);
       
       
       
       
       
       
      break      



end