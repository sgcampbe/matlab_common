% 'Super' clear script - clears and closes everything for a nice, fresh
% MATLAB start.


% Clear classes while preserving breakpoints (from MATHWORKS)
current_breakpoints = dbstatus('-completenames');
save('temp.mat', 'current_breakpoints');
evalin('base', 'clear classes');
% get around bug where red icons are not displayed
% by pausing for a short time
pause(0.1)
load('temp.mat');
dbstop(current_breakpoints );
delete('temp.mat')

% Clear workspace
clear

% Close figures
close all

% Clear command window
clc
