function [leftsacc, rightsacc, left, right, samples,samplerate] = get_saccade_data(left,right,samplerate)

samples = horzcat(left(:,1),left(:,2),left(:,3),right(:,2),right(:,3));

[leftsacc,rightsacc] = saccades(samples,samplerate,'VFAC', 6);


end