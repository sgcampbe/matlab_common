function cellstrs = vecToCellStrs( vec )
% This function turns a vector of numbers into a cell array of strings,
% where each cell array entry is the corresponding vector entry converted
% to string representation.  Very useful in GUI programming.

num = length(vec);
cellstrs = cell(num, 1);
for i = 1:num
    cellstrs{i} = num2str(vec(i));
end
