function shiftAxes(axh, xoff, yoff, varargin)
% This function takes an axes handle or vector of axes handles and shifts
% all of them by xoff and yoff in the x and y directions, respectively.
% The units of the shift are whatever the units of the corresponding figure
% are set to.  Optionally, the args xdim and ydim may be passed in; these
% will set objects in axh to have the new x and y dimensions specified.

  

for ax = axh
    currpos = get(ax, 'Position');
    
    if nargin > 3
        xdim = varargin{1};
        ydim = varargin{2};
    else
        xdim = currpos(3);
        ydim = currpos(4);
    end

    
    set(ax, 'Position', [currpos(1) + xoff currpos(2) + yoff xdim ydim])
end