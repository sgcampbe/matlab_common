function i_names = namesToListIndices(list, names)
% This function accepts a cell array of strings ('list') and string or cell
% array of strings containing names or selections that are thought to
% appear in 'list' and returns their indices within list, if they exist.
% NOTE: i_names does not necessarily correspond in order with the entries in 'names'

i_names = find(ismember(list, names));