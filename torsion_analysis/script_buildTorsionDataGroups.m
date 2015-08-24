%-------------------------------------------------------------------------%
% Script: script_buildTorsionDataGroups.m
% Author: Stuart Campbell
% Date Started: 3/14/2012
% 
% Description: This script loads the finalized average torsion records,
% aggregates them into a single data structure, and constructs the
% appropriate grouping variables for conducting statistical analysis.
%-------------------------------------------------------------------------%

cls


%---------------------------%
% User Specified Parameters %
%---------------------------%

stat_points = 19;   % The first beat will be thinned to this many points (in time)

basedatadir     = '/Users/stuart/data/F344NIA_processed_echo_results/';
jmp_export_file = 'exported_torsions.txt';
output_file     = 'F344NIA_torsion_data.mat';   % Specify the path and filename for saving the binary results from grouping torsion (for plotting scripts)

%----------------------------------%
% Load and Extract Data from Files %
%----------------------------------%

filelist = findfiles('mat', basedatadir, true);
numRecs  = length(filelist);

% Open first file for dimensioning purposes
load(filelist{1})
numFrames = length(TR.cycle_time);

% Dimension storage
alltorsion        = zeros(numRecs, numFrames);
agegroup          = cell(numRecs, 1);
animalnum         = cell(numRecs, 1);
numFrames_each    = zeros(numRecs,1);
baseapexdist      = zeros(numRecs,1);

% Loop over records
hold on
for i = 1:numRecs
    load(filelist{i})
    disp(filelist{i})
    disp(TR.agegroup)
    disp(TR.numFrames)
    fprintf('Base-apex distance: %f\n\n', TR.report.baseapexdist.val)
    switch TR.agegroup
        case '6mo'
            color = 'r';
        case '18mo'
            color = 'g';
        case '22mo'
            color = 'b';
    end
    
    % Store
    alltorsion(i,:)        = TR.avg_torsion;
    agegroup{i}            = TR.agegroup;
    animalnum{i}           = TR.animalnum;
    numFrames_each(i)      = TR.numFrames;
    baseapexdist(i)        = TR.report.baseapexdist.val;
    
    plot(TR.avg_torsion, 'Color', color)
    
    time = TR.cycle_time;   % Grab a copy of the time (same for all TR's)
end


%-----------------------------------------------------------%
% Thin to Smaller number of Time Points and First Beat Only %
%-----------------------------------------------------------%

interval = round((numFrames / 2) / (stat_points - 1));
t_stats  = (0:interval:round(numFrames / 2)) + 1;

thinned_torsion = alltorsion(:,t_stats);
thinned_time    = time(t_stats);


% Loop over agegroups, computing and plotting means and SEM
ages    = unique(agegroup);
numAges = length(ages);
avg_torsoin = struct();

figure(2)
for a = 1:numAges
    age = ages{a};
    
    agedex = namesToListIndices(agegroup, age);
    
    % Full versions
    grouped_torsions                 = alltorsion(agedex, :);
    avg_torsion.(['age_' age])       = mean(grouped_torsions);
    sem_torsion.(['age_' age])       = calcStdErr(grouped_torsions);
    
    % Thinned versions
    grouped_torsions_thinned = thinned_torsion(agedex, :);
    avg_torsion_thin.(['age_' age])  = mean(grouped_torsions_thinned);
    sem_torsion_thin.(['age_' age])  = calcStdErr(grouped_torsions_thinned);
    
    % Calcs for normalization
    beat_end_dex = round(numFrames / 2);
    first_beat_max = max(avg_torsion.(['age_' age])(1:beat_end_dex));
    
    switch age
        case '6mo'
            color = 'r';
        case '18mo'
            color = 'g';
        case '22mo'
            color = 'b';
    end
    
    figure(2)
    subplot(2,1,1)
    hold on
    plot(avg_torsion.(['age_' age]), 'Color', color)
    
    subplot(2,1,2)
    hold on
    plot(avg_torsion.(['age_' age]) / first_beat_max, 'Color', color)
    
    figure(3)
    hold on
    plot(thinned_time, avg_torsion_thin.(['age_' age]), '.-', 'Color', color)
    
end


%------------------------------%
% Build Main Matrix and Export %
%------------------------------%
% This export is intended for use in JMP statistical software

age    = cell(stat_points,1);
animal = cell(stat_points,1);

offset = 1;

% Transform to cell matrices for export
thinned_torsion = num2cell(thinned_torsion');   % Note transpose to make things easier to concatenate below
timepoint_code  = num2cell(1:length(t_stats))'; % Statistical coding for timepoints

data_with_codes = cell((numRecs * stat_points), 4);
% Col 1: Data, Code columns: Between factor, within factor, subject factor
for i = 1:numRecs
    
    % Expand animal and age codes to full columns
    for j = 1:stat_points
        age{j} = agegroup{i};
        animal{j} = animalnum{i};
    end
    
    data_with_codes(offset:(offset+stat_points-1), :) = [thinned_torsion(:,i), age, timepoint_code, animal];
    offset = offset + stat_points;
end

% Add a header row
data_with_codes = [{'Torsion', 'Age Group', 'Timepoint', 'AnimalID'}; data_with_codes];

dlmcell(jmp_export_file, data_with_codes, ',')


%-------------------------------------------%
% Save Grouped Data for Use in Other Scrpts %
%-------------------------------------------%

save(output_file, 'alltorsion', ...
                  'avg_torsion', ...
                  'avg_torsion_thin', ...
                  'sem_torsion', ...
                  'sem_torsion_thin', ...
                  'time', ...
                  'thinned_time', ...
                  'agegroup', ...
                  'animalnum')


%-------------------%
% Run MATLAB MANOVA %
%-------------------%

% Change codes to numbers
thinned_torsion = alltorsion(:,t_stats)'; % Note transpose
timepoint_code  = (1:length(t_stats))';   % Statistical coding for timepoints

offset = 1;

data_with_codes = zeros((numRecs * stat_points), 4);
% Col 1: Data, Code columns: Between factor, within factor, subject factor
for i = 1:numRecs
    
    % Expand animal and age codes to full vectors
    age = agegroup{i};
    switch age
        case '6mo'
            agenum = 1;
        case '18mo'
            agenum = 2;
        case '22mo'
            agenum = 3;
    end
    age = agenum * ones(stat_points, 1);
    
    animal = i * ones(stat_points, 1);
    
    
    data_with_codes(offset:(offset+stat_points-1), :) = [thinned_torsion(:,i), age, timepoint_code, animal];
    offset = offset + stat_points;
end


% Run the anova with repeated measures
[SSQs, DFs, MSQs, Fs, Ps] = manova(data_with_codes);


%-----------------------------------%
% Check ANOVA of Base-Apex Distance %
%-----------------------------------%

p_abdist = anova1(baseapexdist, agegroup);
fprintf('The p-value of ANOVA for apex-base distance as a function of age group is:\n%f\n\n', p_abdist)
