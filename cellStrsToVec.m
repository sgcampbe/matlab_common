function vec = cellStrsToVec( cellstrs )
% This function turns a cell array of strings into a vector of numbers,
% where each cell array entry is a string representation of an integer.

num = length(cellstrs);
vec = zeros(num, 1);
for i = 1:num
    vec(i) = str2double(cellstrs{i});
end
