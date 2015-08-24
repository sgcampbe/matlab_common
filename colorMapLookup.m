function color = colorMapLookup(varargin)

% Author: Stuart Campbell
% Date started: 10/4/2010
%
% This function provides color information based on the desired colormap.
% The caller provides a value, and this function returns a color vector
% (R,G,B) for the color corresponding to the value.  In order to determine
% the color mapping, it's necessary to know min/max values for the scaling.
% The default scaling is between 0 and 1.  Default scaling is used when the
% function is called with only one arguement.  If three args are provided,
% and they're both numerical values, it assumes the 2nd and 3rd are for 
% min and max values to scale the map.  If desired, one of the alternate
% MATLAB colormaps may be specified in the last argument, like 'hot' or
% 'winter'.  
% If a vector of points is provided, the output of the function is a matrix
% of RGB values, one RGB row vector for each input value.  If automatic 
% scaling is desired, pass the string 'auto' as the second arguement and
% the limits will be determined by min(values) and max(values).

if nargin == 0
    color = colormap(); % Just returns the default 64 by 3 matrix
    return
end

% Set up defaults
values   = varargin{1};
mapname  = 'default';
colormap(mapname);   % Reset the colormap just in case 

switch nargin
    
    case 0
        
        
    case 1      % Called with just values, assume 0 to 1 scaling
        vmin   = 0;
        vmax   = 1;
        
    case 2      % Called with values and either 'auto' scaling or colormap specification
        if strcmp(varargin{2}, 'auto')
            vmin = min(values);
            vmax = max(values);
        else
            vmin = 0;
            vmax = 1;
            mapname = varargin{2};
        end
        
    case 3      % Called with values and either min/max (numerical) or 'auto' and map spec (two strings)
        if isnumeric(varargin{2})   % Must be min/max pair
            vmin = varargin{2};
            vmax = varargin{3};
        else
            vmin = min(values);
            vmax = max(values);
            mapname = varargin{3};
        end
        
    case 4      % Called with values, min/max pair, and map spec
        vmin = varargin{2};
        vmax = varargin{3};
        mapname = varargin{4};
end

% Trim out extreme values
values(values < vmin) = vmin;
values(values > vmax) = vmax;

numvals = length(values);
color   = zeros(numvals, 3);                        % Pre-dimension color output
colormap(mapname);                        % Get the colormap
cm      = colormap;
divs    = length(cm);                               % The number of map entries
dv      = ((vmax - vmin) / (divs - 1)) * (0:divs-1) + vmin; % Apply scaling

for i = 1: numvals
    r = linInterp(values(i), dv, cm(:,1));
    g = linInterp(values(i), dv, cm(:,2));
    b = linInterp(values(i), dv, cm(:,3));
    color(i,:) = [r g b];
end

return