%***********************************************************************%
%   General Purpose Code                                                %
%   File:   fitTransientDecay.m                                         %
%   Date Started: 12/14/2009                                            %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function takes a vector of time points and 
%   corresponding function values from a transient event and attempts to
%   fit a time constant (tau) describing decay rate. The function works by
%   adjusting two parameters: The time contant tau, and i_diff, specifying
%   the interval i_diff:end of the timecourse that is to be fit by the
%   decaying exponential function.  The min and max values of the
%   exponential decay are set to the last point of the timecourse and peak
%   value of the timecourse, respectively.
%
%   Update: 10/20/2011 - Added better plot options for compatibility with
%   getCaTProps.m
%
%   11/04/2011 - Changed further to generate a LineMaker object during
%   visualization and return it.
%***********************************************************************%

function [tau i_diff marker] = fitTransientDecay(t, y, varargin)

% Set up extra parameters
extra_params.visualize = false;   % Flag for visualization options
extra_params.axh       = 0;       % Axes handle for visualization - starts empty until it's confirmed that visualize is on so that plots don't randomly pop up...
extra_params.fract_diastolic = 0.1; % Fraction of record (taken from record ending) used to calculate the diastolic value
if nargin > 2
    extra_params = parse_pv_pairs(extra_params, varargin);
    if (~sum(strcmp(varargin, 'axh'))) && extra_params.visualize
        extra_params.axh = gca;
    end
end

% Peform normalization to assist in fit
numavgpts = round(length(t) * extra_params.fract_diastolic); % Averages last 'fract_diastolic'th of record to get diastolic normalization factor
ydiast = mean(y(end - numavgpts:end));
yraw = y;
y = (y - ydiast) / (max(y) - ydiast); 


[~, i_max] = max(y);
params0 = 1;        

opt    = optimset('Display', 'off');
params = lsqnonlin(@(params) diff_func(params, t, y, i_max), params0, [], [], opt);

tau    = params(1);
i_diff = i_max;

% Make marker
ttrunc = t(i_diff:end) - t(i_diff);
ytrunc = makeMonoExpDecay(ttrunc,tau);
ymax   = mean(yraw(i_diff:i_diff + 4));
ymin   = mean(yraw(end-15:end));
ytrunc = (ymax - ymin) * ytrunc + ymin;
marker = LineMaker(ttrunc + t(i_diff), ytrunc, 'LineStyle', '--', 'Color', 'r');

if extra_params.visualize
    hold(extra_params.axh, 'on')
    marker.draw(extra_params.axh);
    hold(extra_params.axh, 'off')
    % title(['\tau = ' num2str(tau)])
end

return


function diff = diff_func(params, t, y, i_diff)

tau = params(1);

ttrunc = t(i_diff:end) - t(i_diff);

ytrunc = y(i_diff:end);

diff = ytrunc - makeMonoExpDecay(ttrunc,tau);
