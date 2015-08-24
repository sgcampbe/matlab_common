function i_matches = findCellEntriesContainingTargetStr(cell_array_of_strs, target_str)
% Given a cell array of strings, this function finds the indices in that
% array that contain instances of the target text, target_str.

i_matches = [];   % Return empty if there are no matches

numentries = length(cell_array_of_strs);

raw_matches = strfind(cell_array_of_strs, target_str);

ctr = 1;
for i = 1:numentries
    if ~isempty(raw_matches{i})
        i_matches(ctr) = i;
        ctr = ctr + 1;
    end
end

