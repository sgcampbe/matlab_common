function bigstr = file2str(fname, varargin)

% file2str.m
% As suggested by the name, this function takes the name of a text file,
% and returns a string containing the contents of the file.  This is what
% you would get in python by going f.read() on a valid file pointer.
% RETURNS bigstr = -1 if the file fails to open properly

f = fopen(fname);

% Check for opening error
if f == -1
    bigstr = -1;
    return
end


if nargin == 1
    bigstr = fread(f, '*char')'; % Read entire file in as a big string - transpose too so that it comes out right 
else
    size = varargin{1}; % Specifies how many chars to read from the file (for speed)
    bigstr = fread(f, size, '*char')'; % Read entire file in as a big string - transpose too so that it comes out right
end

fclose(f);

return