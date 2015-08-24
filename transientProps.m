%***********************************************************************%
%   transientProps.m                                                    %
%   Date Started: 5/20/09
%   Author: Stuart Campbell
%   Description: This function takes a transient, defined by a vector of
%   time points and a vector of y values and calculates the following
%   properties, if possible, returning them in a struct:
%       t_up - The approximate moment of first rise, 1% of range is thresh.
%       t_peak - Time to peak
%       t_D50  - Time from peak to 50% decay
%       t_D90  - Time from peak to 90% decay
%       y_min  - Minimum y value of transient
%       y_max  - Maximum y value of transient
%***********************************************************************%

function props = transientProps(Traw, Yraw)

% Linear interpolation to 10000 points
T = 0:(Traw(end) / 10000):Traw(end);
Y = linInterp(T, Traw, vnorm(Yraw));    % Note that Y is also normalized to range [0 1]

% Determine t_peak and y_max
[junk i_max] = max(Y);
props.t_peak = T(i_max);
props.y_max  = max(Yraw);

% Determine y_min
props.y_min = min(Yraw);

% Determine t_up
upmap       = Y > 0.01;
i_up        = find(upmap(2:end) - upmap(1:end-1));
props.t_up  = T(i_up(1)); % Note, takes only first non-zero element

% Determine if t_D50 and t_D90 exist
isD50 = Y(end) <= 0.5;
isD90 = Y(end) <= 0.1;

% Determine t_D50 and t_D90 if they exist
Ydecay = Y(i_max:end);
if isD50
    D50map = Ydecay <= 0.5;
    i_D50  = find(D50map(2:end) - D50map(1:end-1));
    props.t_D50 = T(i_D50(1));
end

if isD90
    D90map = Ydecay <= 0.1;
    i_D90  = find(D90map(2:end) - D90map(1:end-1));
    props.t_D90 = T(i_D90(1));
end

return
