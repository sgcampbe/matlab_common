function varargout = findStim(varargin)
%*************************************************************************%
% General Purpose Code - findStim.m
% Author: Stuart Campbell
% Date Started: 10/19/2011
%
% This function accepts a vector of values representing a stimulus
% waveform.  If just this waveform is supplied, it returns istim, the index
% to the first detectable stimulus event.  If desired, a second argument
% can be supplied that is a vector of time points corresponding to the stim
% waveform.  In that case, a second value is returned which indicates the
% stimulus time in the same units as the time arguement.
%  Example:
%  [istim tstim] = findStim(stim, time)
% NOTE: This is NOT a fancy peak-detection algorithm.  It is designed to
% work on a very clean signal, probably even just the command vector used
% for pacing (which will have no noise at all).  Also, it only detects the
% first point of the first stimulus event.
%*************************************************************************%

stim = varargin{1};

if nargin == 1
    time = 1:length(stim);
elseif nargin == 2
    time = varargin{2};
end

thresh = mean([min(stim) max(stim)]);   % Create a very simple threshold

istim = find(stim > thresh);            % Takes the first stim event

istim = istim(1);
tstim = time(istim);

if nargout > 0
    varargout{1} = istim;
end
    
if nargout > 1
    varargout{2} = tstim;
end

if nargout > 2
    error('This function only puts out two args!')
end



