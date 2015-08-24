function stamp = epochTimeStamp(varargin)
% This function returns a numerical time stamp that is simply the number of
% seconds since ~ 1970 (i.e. Unix or 'epoch' time).  Default return value
% is a string containing the number, but if the number itself is desired,
% simply pass the string 'num' into the function.

stamp = int32(floor(86400 * (now - datenum('01-Jan-1970'))));
stamp = num2str(stamp);

if nargin > 0
    if strcmp(varargin{1}, 'num')
        stamp = str2num(stamp);
    end
end

return