function parts = split(in_str, varargin)

% split.m
% Emulates python string split method.  Pass in a string and a delimiter,
% and it returns a cell array with each entry being a portion of the string
% separated by delimiters.  For example, split('Hi how are you', ' ')
% returns {'Hi', 'how', 'are', 'you'}.

if nargin > 1
    delim = varargin{1};
    len_delim = length(delim);
    if (len_delim > 1) && (delim(1) == '\')
        delim = sprintf(delim);
        len_delim = length(delim);
    end
    delimdex = strfind(in_str,delim);
else  % Assume split by whitespace
    spaces    = isspace(in_str);
    delimdex  = find(spaces);
    len_delim = 1;
end
    


delimdex = [1-len_delim, delimdex, length(in_str)+1];

num_parts = length(delimdex) - 1;
parts = cell(1,num_parts);

good_vals = 0;
for i = 1:num_parts
    raw = in_str(delimdex(i)+len_delim:delimdex(i+1)-1);
    if ~isempty(raw)  % If it's not empty, add it to parts
        good_vals = good_vals + 1;
        parts{good_vals} = raw;
    end
end

parts = parts(1:good_vals);
return

