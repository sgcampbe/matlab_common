%This function normalizes all values of the vector y to take on values
%between 0 and 1.  It enables timecourse comparisons of distinct quantities

% Optional extra term may be passed in, varargin{1} = normwindow.  If
% specified, min and max vals will be computer by averaging over a 'window' of values specified in
% terms of the relative record length (normwindow, [0 1]).  The window is
% centered around the location of the min/max values, as long as these
% values are valid, otherwise that portion of the window is simply
% truncated.

function norm_y = vnorm(y, varargin)

numpts = length(y);
    
if nargin > 1
    normwindow = varargin{1};
    numavgpts  = round(numpts * normwindow);
else
    numavgpts  = 1;
end

halfi = 0.5 * numavgpts;

[~, i_min] = min(y);
minrange   = ceil(i_min - halfi):floor(i_min + halfi);
minrange   = minrange(minrange > 0);
minrange   = minrange(minrange <= numpts);

[~, i_max] = max(y);
maxrange   = ceil(i_max - halfi):floor(i_max + halfi);
maxrange   = maxrange(maxrange > 0);
maxrange   = maxrange(maxrange <= numpts);

min_y = mean(y(minrange));
max_y = mean(y(maxrange));

norm_y = (y - min_y) / (max_y - min_y);

return
