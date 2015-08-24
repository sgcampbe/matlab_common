function [vals_sorted group_sorted] = sortValsByGroup(vals, groups)
% This function takes a grouping variable such as those used by statistics
% functions (cell array of cell arrays) and sorts the associated vector of
% values so that values with common group desigations are contiguous.

% NOTE!!!!!! The grouping output of this function (group_sorted) will be
% flattened and unsuitable for further statistical calls! This function is
% mainly for table output of raw data.

% FOR NOW, VALS MUST BE AN ARRAY, MATRIX CALLS NOT ALLOWED YET

delim = '|';    % A delimiter for temporary use in joining and splitting group ids

numobs  = length(vals);
numfacs = length(groups);

% Make id list for each value by merging group entries
allids = cell(numobs,1);
for i = 1:numobs
    rawid = {};
    for j = 1:numfacs
        rawid{end+1} = groups{j}{i};
    end
    allids{i} = joinfields(rawid, delim);
end

% Find ids of all replications (reduce allids to just unique entries)
uniqueids     = unique(allids);
numcommonfacs = length(uniqueids);

% Loop over unique ids, gather all values matching the id, and place in
% sorted order
vals_sorted  = zeros(numobs, 1);             % Initialize vars
group_sorted = cell(numobs, 1);              % Initialize group_sorted
ctr          = 1;

for i = 1:numcommonfacs
    fac = uniqueids{i};
    for j = 1:numobs
        if strcmp(fac, allids{j})
            vals_sorted(ctr) = vals(j);
            group_sorted{ctr} = fac;
            ctr = ctr + 1;
        end
    end
end