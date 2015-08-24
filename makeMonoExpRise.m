%***********************************************************************%
%   Markov model of thin filament activation                            %
%   Function: makeMonoExpRise                                           %
%   Date Started: 11/26/2008                                            %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function evaluates the monoexponential response
%       x = 1 - exp(-t/tau)
%   for an input vector of timepoints, t.  Obviously t and tau should have
%   equivalent units.
%***********************************************************************%

function x = makeMonoExpRise(t, tau)

x = 1 -  exp(-t/tau);

return