function  [lsac, rsac] = saccades( samples, samplerate, maxmag, Overshoot_Time, MINDUR, VFAC , isInTrial, blinks )
%-------------------------------------------------------------------
%
%  FUNCTION saccades.m
%
%   Detects all the saccades in an eye movement recording
%
%   Distinctive Features of Saccadic Intrusions and Microsaccades in
%   Progressive Supranuclear Palsy. Otero-Millan, Leigh, Serra, Troncoso,
%   Macknik, Martinez-Conde. Journal of Neuroscience (under review).
%
%-------------------------------------------------------------------
%
%  INPUT:
%
%  samples(:,1)     timestamps of the recording
%  samples(:,2)     horizontal position of the left eye   
%  samples(:,3)     vertical position of the left eye  
%  samples(:,4)     horizontal position of the right eye     
%  samples(:,5)     vertical position of the right eye  
%  samplerate       samplerate of the recording
%  maxmag           maximum magnitude of the (micro)saccades (default 5 deg)
%  Overshoot_Time   minimum interval between saccades (default 20 ms)
%  MINDUR           minimum duration of saccades (default 3 samples)
%  VFAC             threshold factor used by Engbert and Kliegl's algorithm (default 6)
%  isInTrial        binary vector indicating for each sample if it
%                   belons to a trial (1) or not (0)
%  blinks           binary vector indicating for each sample if it
%                   belons to a blink (1) or not (0)
%
%  OUTPUT:
%
%  lsac(:,1)    indices of the start of all saccades in the left eye
%  lsac(:,2)    indices of the end of all saccades in the left eye
%  rsac(:,1)    indices of the start of all saccades in the right eye
%  rsac(:,2)    indices of the end of all saccades in the right eye   
%
%---------------------------------------------------------------------


%% - Set Defaults
if ( ~exist('maxmag', 'var') || isempty( maxmag ) )
    maxmag = 5;
end
if ( ~exist('Overshoot_Time', 'var') || isempty( Overshoot_Time ) )
    Overshoot_Time = 20;
end
if ( ~exist('MINDUR', 'var') || isempty( MINDUR ) )
    MINDUR = 3;
end
if ( ~exist('VFAC', 'var') || isempty( VFAC ) )
    VFAC = 3;
end
if ( ~exist('isInTrial', 'var') || isempty( isInTrial ) )
    isInTrial = ones(size(samples(:,1)));
end
if ( ~exist('blinks', 'var') || isempty( blinks ) )
    blinks = zeros(size(samples(:,1)));
end


LEFT =  ~any(isnan(samples(:,2)));
RIGHT = ~any(isnan(samples(:,4)));
lsac = [];
rsac = [];

%% - Basic saccade detection
if ( LEFT )
    left_eyedat = zeros(size(samples,1), 4);
    v = vecvel( samples(:,[2,3]), samplerate, 2 );
    left_eyedat( :, [1 2] ) = samples(:,[2,3]);
    left_eyedat( :, [3 4] ) = v;
    
    [lsac] = findSaccades( left_eyedat, isInTrial, blinks, MINDUR, VFAC );
end
if ( RIGHT )
    right_eyedat = zeros(size(samples,1), 4);
    v = vecvel( samples(:,[4 5]), samplerate, 2 );
    right_eyedat( :, [1 2] ) = samples(:,[4,5]);
    right_eyedat( :, [3 4] ) = v;
    
    [rsac] = findSaccades( right_eyedat, isInTrial, blinks, MINDUR, VFAC );
end

%% - Remove monoculars (overlap threshold)
if ( LEFT && RIGHT )
    [left_monoculars_idx right_monoculars_idx]  = findMonoculars( lsac, rsac );
    lsac(left_monoculars_idx,:)    = [];
    rsac(right_monoculars_idx,:)  = [];
end

%% - Remove overshoots
if ( LEFT && RIGHT )
    % if monoculars have been removed we can find overshoots  binocularly
    [overshoots_idx] = findOvershoots( lsac, rsac, samplerate,  Overshoot_Time );
    lsac(overshoots_idx,:)   = [];
    rsac(overshoots_idx,:)  = [];
    left_overshoots_idx = overshoots_idx;
    right_overshoots_idx = overshoots_idx;
elseif ( LEFT )
    [left_overshoots_idx] = findOvershoots( lsac, [], samplerate, Overshoot_Time );
    lsac(left_overshoots_idx,:)   = [];
elseif ( RIGHT )
    [right_overshoots_idx] = findOvershoots( [], rsac, samplerate, Overshoot_Time );
    rsac(right_overshoots_idx,:)  = [];
end
if ( LEFT )
    if ( ~isempty( left_overshoots_idx ) )
        for i=1:size(lsac,1)
            ovidx = find(left_overshoots_idx(:,1)>=lsac(i,2) & left_overshoots_idx(:,1)<=lsac(i,2)+ Overshoot_Time);
            if  (~isempty(ovidx)) 
                lsac(i,2) = left_overshoots_idx(ovidx(end),2);    
            end
        end
    end
end
if ( RIGHT )
    if ( ~isempty( right_overshoots_idx  ) )
        for i=1:size(rsac,1)
            ovidx = find(right_overshoots_idx(:,1)>=rsac(i,2) & right_overshoots_idx(:,1)<=rsac(i,2)+ Overshoot_Time);
            if ( ~isempty(ovidx) )
                rsac(i,2) = right_overshoots_idx(ovidx(end),2);
            end
        end
    end
end

%% - Apply the maximum magnitude threshold
if ( LEFT && RIGHT )
    lmags = sqrt(lsac(:,6).^2+lsac(:,7).^2);
    rmags = sqrt(rsac(:,6).^2+rsac(:,7).^2);
    usac_idx = find( lmags > maxmag | rmags > maxmag );
    lsac(usac_idx,:)   = [];
    rsac(usac_idx,:)  = [];
elseif ( LEFT )
    lmags = sqrt(lsac(:,6).^2+lsac(:,7).^2);
    [lusac_idx] = find( lmags > maxmag );
    lsac(lusac_idx,:)   = [];
elseif ( RIGHT )
    rmags = sqrt(rsac(:,6).^2+rsac(:,7).^2);
    [rusac_idx] = find( rmags > maxmag );
    rsac(rusac_idx,:)  = [];
end

end


%% findSaccades
function sac = findSaccades( eyedat, isInTrial, blinks, MINDUR, VFAC )

trial_begin_idx = find(diff([0;isInTrial])>0);
trial_end_idx   = find(diff([isInTrial;0])<0);

num_sac = 0;
% for each trial process the data
for iTrial = 1:length(trial_begin_idx)
    trial = trial_begin_idx(iTrial);
    trial_end = trial_end_idx(iTrial);
    xy = eyedat(trial:trial_end,1:2);
    v = eyedat(trial:trial_end,3:4);
    
    [sac] = microsacc(xy, v ,VFAC,MINDUR, blinks(trial:trial_end),2*pi);

    if (~isempty( sac ) )
        sac(:,1:2) = sac(:,1:2) + trial-1;
        total_sac(num_sac+1:num_sac+size(sac,1),:) = sac;
        num_sac = num_sac + size(sac,1);
    end
end
sac = total_sac(1:num_sac,:);

%-- remove usacc in intertrials and in blinks just in case
good_samples = isInTrial & ~ blinks;
if ( ~isempty( sac ) )
    
    is_good = zeros(size(sac,1),1);
    for i=1:length(is_good)
        is_good(i) = sum( ~good_samples( sac(i,1):sac(i,2)) ) == 0;
    end
    
    sac = sac( is_good==1, :);
    
end

end


%% RemoveMonoculars
function [left_monoculars_idx, right_monoculars_idx] = findMonoculars( lsac, rsac )
ls = lsac(:,1);
le = lsac(:,2);
rs = rsac(:,1);
re = rsac(:,2);

binocs2 = [];
ss2 = [];
% for each microsaccade in the left eye
for i=1:length(ls)
    e = ones(size(re))*le(i);
    s = ones(size(rs))*ls(i);
    row = max(min( re, e) - max(rs, s),0);
    % row has the overlap of this left microsaccade with all the right
    % microsaccades
    if( sum(row) > 0 )
        % we get the right microsaccade that overlaps more with the
        % left one and we check that the left one is also the one that
        % overlaps more with the right one.
        [v, max_index_r] = max( row );
        e = ones(size(le))*re(max_index_r);
        s = ones(size(ls))*rs(max_index_r);
        col = max( min( le, e) - max(ls, s), 0 );
        [v, max_index_l] = max( col );
        if (max_index_l == i )
            binocs2(end+1, : ) = [max_index_l;max_index_r];
            ss2(end+1) = v;
        end
    end
end
left_monoculars_idx = setdiff(1:length(lsac),binocs2(:,1));
right_monoculars_idx = setdiff(1:length(rsac),binocs2(:,2));
end


%% findOvershoots
function overshoots_idx = findOvershoots( lsac, rsac, samplerate, Overshoot_Time )
MIN_ISI = Overshoot_Time*samplerate/1000;
if ( ~isempty(lsac) && ~isempty( rsac) )
    lmags = sqrt(lsac(:,6).^2+lsac(:,7).^2);
    rmags = sqrt(rsac(:,6).^2+rsac(:,7).^2);
elseif( ~isempty(lsac) )
    lmags = sqrt(lsac(:,6).^2+lsac(:,7).^2);
    rmags = lmags;
    rsac = lsac;
elseif (~isempty(rsac) )
    rmags = sqrt(rsac(:,6).^2+rsac(:,7).^2);
    lmags = rmags;
    lsac = rsac;
end

mean_mag = mean([lmags rmags],2);
bad_index =[];
too_close_group = [];
for j = 1:length(mean_mag(:,1))
    % finds the microsaccades that are too close to the current
    % one
    too_close_idx = find(...
        (lsac(:,1) - lsac(j,2) <= MIN_ISI & ...
        lsac(:,1) - lsac(j,2) > 0) | ...
        (rsac(:,1) - rsac(j,2) <= MIN_ISI & ...
        rsac(:,1) - rsac(j,2) > 0) );
    
    if ( ~isempty(too_close_idx) )
        % if there is any microsaccade too close
        if( isempty(too_close_group) )
            % if there is no current group, start a new one
            too_close_group =  union(j,too_close_idx);
        else
            % if there is already a group, add these
            % microsaccades to the group
            too_close_group =  union(too_close_group,too_close_idx);
        end
    else
        % if the current microsaccade is not too close and
        % there is a current group, deal with it
        if ( ~isempty(too_close_group) )
            % keep only the largest microsaccade
            [max_mag,max_idx] = max(mean_mag(too_close_group));
            bad_index = union(bad_index, too_close_group(setdiff(1:length(too_close_group),max_idx)));
            
            % initialize the current group
            too_close_group = [];
        end
    end
end
overshoots_idx = bad_index;
end