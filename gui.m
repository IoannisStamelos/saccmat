
while true
        path = uigetdir();
        if isequal(path,0)
            disp('User cancelled. Exiting.');
            break
        end
           disp(['File folder: ', path]);
           
    % 1.Preprocess    
        [left,right,samplerate] = preprocess(path,"nearest");
        positions =  [" Center", " Left", " Right", " Up", " Down"];
        [~, folderName] = fileparts(path);  
        folderName = string(folderName);

        for i = 1:length(positions)
            if contains(folderName,positions(i),'IgnoreCase', true)
                pos = i;
            else
                pos = 1;
            end
        end
       
    % 2.Saccades
    [leftsacc, rightsacc, left, right, ~, samplerate] = get_saccade_data(left,right,samplerate);
    close all
    set(0,'DefaultFigureWindowStyle','docked')
    figure(1); set(gcf, 'Name', "Saccades");
    tiledlayout(2,1);nexttile
    plotsacc(left,leftsacc,"Left",samplerate);nexttile
    plotsacc(right,rightsacc,"Right",samplerate);

    figure; set(gcf, 'Name', "Angles");
    tiledlayout(1,2);nexttile
    anglesLeft = anglesacc(leftsacc,"Left");nexttile
    anglesRight = anglesacc(rightsacc,"Right");

    
       
    % 3.Square Wave Jerks  
    [sacctimes_left,swjdata_left,leftsacc,tsacleft] = swj(leftsacc,left,"horizontal");
    [sacctimes_right,swjdata_right,rightsacc,tsacright] = swj(rightsacc,right,"horizontal");
    
    figure
    set(gcf, 'Name', "Square Wave Jerks"); 
    tiledlayout(2,1)
    plotswj(left,sacctimes_left,"Left")
    plotswj(right,sacctimes_right,"Right")
       
    
    % 4.BCEA
    BCEA_left = compute_BCEA(left, 0.95);
    BCEA_right = compute_BCEA(right, 0.95);
    
    % 5.Density Ellipses
    figure('Name',"Fixation Ellipse")
    tiledlayout(1,2)
    gazeEllipse(left, BCEA_left, "left", pos)
    gazeEllipse(right, BCEA_right, "right", pos)
    
  
    %6.Main Sequence

    figure('Name',"Main Sequence")
    tiledlayout(2,2)
    [duration_L] = main_sequence(left,leftsacc,"Left",tsacleft);
    [duration_R] = main_sequence(right,rightsacc,"Right",tsacright);

    %clearvars -except left right samplerate rightsacc leftsacc swjons_left swjfin_left swjdata_left swjons_right swjfin_right swjdata_right
    patient = split(path,'\');
    disp(path)
    if any(contains(patient, '_'))
    patient = patient(contains(patient, '_'));
    else
    patient = path;
    end
    tab = table(string(patient), length(leftsacc), length(rightsacc),length(sacctimes_left), length(sacctimes_right),... 
    BCEA_left, BCEA_right, VariableNames=["Name","Left Saccades","Right Saccades","Left SWJ","Right SWJ","Left BCEA","Right BCEA"])

    leftsacc = array2table(leftsacc,"VariableNames",["SaccadeStartIdx","SaccadeEndIdx","Vpeak","dx","dy","dx_max","dy_max", "Vmean","Angle","Amplitude"]);
    rightsacc = array2table(rightsacc,"VariableNames",["SaccadeStartIdx","SaccadeEndIdx","Vpeak","dx","dy","dx_max","dy_max","Vmean","Angle","Amplitude"]);
    figure(1);
    filename = input("file name");
    folder = uigetdir();
    name = fullfile(folder, filename+".xlsx");
    writetable(tab, name);
    clear i interval_right interval_left folderName samples k_value pos positions 
      break      
    
    

end