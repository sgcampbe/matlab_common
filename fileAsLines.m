function lines = fileAsLines(fname)

% fileAsLines.m
% This function takes the name of a text file, and returns its contents as
% a cell array where each entry is a line in the file.  Empty lines are
% eliminated from the cell array.

lines = split(file2str(fname), '\n');


