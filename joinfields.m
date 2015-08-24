function outstr = joinfields(input, delimiter)
% Recreate functionality of python string.joinfields

if iscellstr(input)
    outstr = input{1};
    if length(input) > 1
        for i = 2:length(input)
            outstr = [outstr delimiter input{i}];
        end
    end
elseif isnumeric(input)
    outstr = regexprep(mat2str(input), ' ', delimiter);
elseif ischar(input)
    outstr = input; % Just send straight through
else
    error('input must be either a cell array of strings, a 1-D array of numbers, or a single string');
end

outstr = sprintf(outstr);


                