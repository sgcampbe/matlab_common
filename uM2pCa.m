%***********************************************************************%
%   Markov model of thin filament activation                            %
%   Function: uM2pCa                                                    %
%   Date Started: 8/27/2008                                             %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function converts a pCa value into a µM
%   concentration.  pCa2uM does the opposite.
%***********************************************************************%

function pCa = uM2pCa(Ca)

pCa = -log10(Ca) + 6; % Minus 6 converts to µM

return