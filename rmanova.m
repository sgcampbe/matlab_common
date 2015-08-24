function results = rmanova(x, groups)
% This function calls the MATLAB file exchange function MANOVA (don't
% confuse with the built-in MATLAB manova - it's different).  
% http://www.mathworks.com/matlabcentral/fileexchange/27080-mixed-betweenwithin-subjects-anova
% This function is merely a wrapper to make the function look more like
% anovan with grouping as per other MATLAB stats functions.  The file
% exchange MANOVA requires numerical codes inserted into a matrix along
% with the dependent variable values.  This function converts the standard
% groups coding (cell array of cell arrays) into numerical codes
% automatically.

% Convert groups to numerical codes
num_grouping_vars = length(groups);
num_observations  = length(groups{1});
numeric_grouping  = zeros(num_observations, num_grouping_vars);
for g = 1:num_grouping_vars
    group = groups{g};
    codes = unique(group);  % Get the unique group names
    for j = 1:num_observations
        entry = group{j};
        num   = find(strcmp(codes, entry)); % Turns the entry into a number
        
        numeric_grouping(j,g) = num;        % Store in matrix
    end
end

% Join Dependent Var with grouping:
x = reshape(x, numel(x), 1);    % Make sure it's a column vector

X = [x, numeric_grouping];

% Perform repeated measures anova
[SSQs, DFs, MSQs, Fs, Ps] = manova(X);  % Table will print to command line


% Store results
results.SSQs = SSQs;
results.DFs  = DFs;
results.MSQs = MSQs;
results.Fs   = Fs;
results.Ps   = Ps;

return