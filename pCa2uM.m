%***********************************************************************%
%   Markov model of thin filament activation                            %
%   Function: pCa2uM                                                    %
%   Date Started: 8/27/2008                                             %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function converts a pCa value into a �M
%   concentration.  uM2pCa does the opposite.
%***********************************************************************%

function Ca = pCa2uM(pCa)

Ca = 10.^(-pCa + 6); % Plus 6 converts to �M

return