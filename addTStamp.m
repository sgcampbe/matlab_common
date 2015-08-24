% This function returns the provided string with a time stamp attached to
% it, with precision to the closest second.  This provides a quick way of
% making a unique and somewhat meaningful filename.  The user may
% optionally provide a file extension (sans '.') to create a complete save
% name, if desired.

function stamped_str = addTStamp(varargin)

if nargin > 1
    ext = ['.' varargin{2}];
else
    ext = '';
end

tstamp = sprintf('%11.0f',now*1e5);
stamped_str = [varargin{1} tstamp ext];

return