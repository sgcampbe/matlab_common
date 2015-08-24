%***********************************************************************%
%   Markov model of thin filament activation                            %
%   Function: makeExpIncrease.m                                         %
%   Date Started: 10/18/2010                                            %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function evaluates the monoexponential response
%       x = 1 - exp(-t/tau)
%   for an input vector of timepoints, t.  Obviously t and tau should have
%   equivalent units.
%***********************************************************************%

function y = makeExpIncrease(x, sigma, L, x_offset)

y = sigma * exp((x - x_offset) / L);

return