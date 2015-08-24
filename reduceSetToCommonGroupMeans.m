function [meanvals uniquegroups semvals numvals] = reduceSetToCommonGroupMeans(vals,   ...  Dependent variable values
                                                                               groups)    % MATLAB grouping cell array (see grouping specification used in anovan, for example)
                                 
                              
% This function takes a vector of values (vals) and grouping information
% (groups, which is the standard data structure MATLAB uses for grouping
% observations for stats functions, see help anovan for example) and
% calculates the mean value for each unique repeated group.  For example,
% if you have a data set with measured values from epi and endo cells, with
% several measurements for each cell type, this function will take the mean
% value of all epi cells and all endo cells and return the means with a new
% grouping data structure.

% Will optionally return the standard error of the mean (semvals)

% Will also optionally return the number of total samples in each unique
% group (sample 'n's)

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

% Loop over unique ids, take mean values of repeats, and store outputs
meanvals     = zeros(numcommonfacs, 1);             % Initialize vars
semvals      = zeros(numcommonfacs, 1);             % Initialize vars
numvals      = zeros(numcommonfacs, 1);             % Initialize 'n' for each group
newgroups    = cell(1, numcommonfacs);
uniquegroups = {};

for i = 1:numcommonfacs
    commondex   = find(strcmp(allids, uniqueids{i})); % Indices to common group tag
    tempvals    = vals(commondex);
    commonvals  = tempvals(~isnan(tempvals));       % Ignore NaNs
    
    meanvals(i) = mean(commonvals);
    semvals(i)  = calcStdErr(commonvals);
    numvals(i)  = length(commonvals);       
    
    % Make reduced grouping data structure
    parts           = split(uniqueids{i}, delim);
    for j = 1:numfacs
        uniquegroups{j}{i} = parts{j};
    end
end


return