function [sac, radius] = microsacc(x, vel, VFAC, MINDUR, blink, ANGTHRESH)
%-------------------------------------------------------------------
%
%  FUNCTION microsacc.m
%
%  (Version 1.0, 22 FEB 01)
%  (Version 2.0, 18 JUL 05)
%  (Version 2.1, 03 OCT 05)
%
%-------------------------------------------------------------------
%
%  INPUT:
%
%  x(:,1:2)         position vector
%  vel(:,1:2)       velocity vector
%  VFAC             relative velocity threshold
%  MINDUR           minimal saccade duration
%
%  OUTPUT:
%
%  sac(1:num,1)   onset of saccade
%  sac(1:num,2)   end of saccade
%  sac(1:num,3)   peak velocity of saccade (vpeak)
%  sac(1:num,4)   horizontal component     (dx)
%  sac(1:num,5)   vertical component       (dy)
%  sac(1:num,6)   horizontal amplitude     (dX)
%  sac(1:num,7)   vertical amplitude       (dY)
%  ADDED BY JORGE OTERO-MILLAN 
%  sac(1:num,8)   mean velocity of the saccade
%  ADDED BY IOANNIS STAMELOS
%  sac(1:num,9)   saccade angle (in deg) (theta)
%
%---------------------------------------------------------------------


% compute threshold (modified by Jorge Otero-Millan to ignore blinks)
vel2 = vel(~blink, :);
msdx = sqrt(median(vel2(:,1).^2) - (median(vel2(:,1)))^2);
msdy = sqrt(median(vel2(:,2).^2) - (median(vel2(:,2)))^2);
radiusx = VFAC * msdx;
radiusy = VFAC * msdy;
radius = [radiusx, radiusy];

% Test criterion: ellipse equation
if radiusy == 0
    test = (vel(:,1) / radiusx).^2;
elseif radiusx == 0
    test = (vel(:,2) / radiusy).^2;
else
    test = (vel(:,1) / radiusx).^2 + (vel(:,2) / radiusy).^2;
end

indx = find(test > 1); % Points where velocity exceeds threshold

% Detect saccades with direction change splitting
N = length(indx);
sac = [];
nsac = 0;
dur = 1;
a = 1;

% Iterate through velocity threshold crossings
for k = 2:N
    if indx(k) - indx(k-1) > 1
        % End of a saccade candidate
        if dur >= MINDUR
            nsac = nsac + 1;
            sac(nsac, :) = [indx(a), indx(k-1)];
        end
        a = k;
        dur = 1;
    else
        % Check cumulative direction change
        v1 = x(indx(a)+1, :) - x(indx(a), :); % Start vector
        v2 = x(indx(k)+1, :) - x(indx(k), :); % Current vector
        
        angle = acos(dot(v1, v2) / (norm(v1) * norm(v2) + eps));
        if angle > ANGTHRESH
            % Split saccade due to direction change
            if dur >= MINDUR
                nsac = nsac + 1;
                sac(nsac, :) = [indx(a), indx(k-1)];
            end
            a = k; % Start new saccade
            dur = 1;
        else
            dur = dur + 1;
        end
    end
end

% Final check for last saccade
if dur >= MINDUR
    nsac = nsac + 1;
    sac(nsac, :) = [indx(a), indx(end)];
end

% Ensure we have at least 7 columns in the saccade data
for s = 1:nsac
    a = sac(s, 1);
    b = sac(s, 2);
    vpeak = max(sqrt(vel(a:b,1).^2 + vel(a:b,2).^2)); % Peak velocity
    dx = x(b,1) - x(a,1);
    dy = x(b,2) - x(a,2);
    sac(s, 3:5) = [vpeak, dx, dy];
    
    % Horizontal and vertical amplitudes
    i = sac(s, 1):sac(s, 2);
    [minx, ix1] = min(x(i,1));
    [maxx, ix2] = max(x(i,1));
    [miny, iy1] = min(x(i,2));
    [maxy, iy2] = max(x(i,2));
    dX = sign(ix2-ix1)*(maxx-minx);
    dY = sign(iy2-iy1)*(maxy-miny);
    sac(s, 6:7) = [dX dY];  
    % Optionally, include more columns
    sac(s, 8) = mean(sqrt(vel(a:b, 1).^2 + vel(a:b, 2).^2));  % Mean velocity
    sac(s,9) = rad2deg(atan2(dy, dx)); 
end
end
