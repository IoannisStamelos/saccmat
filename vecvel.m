function v = vecvel(xx,SAMPLING,TYPE)
%------------------------------------------------------------
%
%  VELOCITY MEASURES
%  - EyeLink documentation, p. 345-361
%  - Engbert, R. & Kliegl, R. (2003) Binocular coordination in
%    microsaccades. In:  J. HyšnŠ, R. Radach & H. Deubel (eds.) 
%    The Mind's Eyes: Cognitive and Applied Aspects of Eye Movements. 
%    (Elsevier, Oxford, pp. 103-117)
%
%  (Version 1.2, 01 JUL 05)
%-------------------------------------------------------------
%
%  INPUT:
%
%  xy(1:N,1:2)     raw data, x- and y-components of the time series
%  SAMPLING        sampling rate
%
%  OUTPUT:
%
%  v(1:N,1:2)     velocity, x- and y-components
%
%-------------------------------------------------------------
N = length(xx(:,1));            % length of the time series
M = length(xx(1,:));
v = zeros(N,M);
switch TYPE
    case 1
        v(2:N-1,:) = SAMPLING/2*[xx(3:end,:) - xx(1:end-2,:)];
    case 2
        v(3:N-2,:)	= SAMPLING/6 * [xx(5:end,:) + xx(4:end-1,:) - xx(2:end-3,:) - xx(1:end-4,:)];
        v(2,:)		= SAMPLING/2 * [xx(3,:) - xx(1,:)];
        v(N-1,:)	= SAMPLING/2 * [xx(end,:) - xx(end-2,:)];
end
end