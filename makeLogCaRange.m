%***********************************************************************%
%   Markov model of thin filament activation                            %
%   Function: makeLogCaRange                                            %
%   Date Started: 8/27/2008                                             %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function creates a vector of Ca concentrations that
%   are evenly spaced on a log scale.  This makes simulations at multiple
%   Ca concentrations look nice on semilog plots.
%***********************************************************************%

function Ca_range = makeLogCaRange(Ca_min, Ca_max, numPts)

Ca_range = exp(log(Ca_min):((log(Ca_max) - log(Ca_min))/(numPts-1)):log(Ca_max))';

return