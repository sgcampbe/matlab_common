%-------------------------------------------------------------------------%
% Script: script_recalcTorsions.m
% Author: Stuart Campbell
% Date Started: 3/21/2012
% 
% Description: This script loads TorsionRecord classes previously created
% by the GUI and initiates a recalculation of torsion.  It was created to
% enable an update of the torsion from deg/mm to deg/cm (which is more
% standard).
%-------------------------------------------------------------------------%

cls

%---------------------------%
% User Specified Parameters %
%---------------------------%

basedatadir     = '/Users/stuart/data/F344NIA_processed_echo_results/';


%------------------------------------------------%
% Looop Over Files to Load, Re-calc, and Re-save %
%------------------------------------------------%

filelist = findfiles('mat', basedatadir, true);
numRecs  = length(filelist);

% Loop over records
for i = 1:numRecs
    load(filelist{i})
    disp(['Re-calculating torsion in file: ' filelist{i}])
    
    % Call calcTorsion method
    TR.calcTorsion();
    
    % Re-save file
    save(filelist{i}, 'TR')
    
end
