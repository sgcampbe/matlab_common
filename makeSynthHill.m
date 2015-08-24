%***********************************************************************%
%   Markov model of thin filament activation                            %
%   Function: makeSynthHill                                             %
%   Date Started: 9/2/2008                                              %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function generates a single Hill curve based on
%   input parameters.  This is a four parameter version that includes
%   X_max, X_min, the Hill coefficient, and a half-activation value.
%***********************************************************************%

function y = makeSynthHill(x_range, ... % A vector of x values at which the function will be evaluated
                           y_min,   ... % Asymptotic minium function value
                           y_max,   ... % Asymptotic maximum function value
                           n,       ... % The Hill coefficient
                           x_50)        % The half-activation value

y = (y_max * x_range.^n) ./ (x_50^n + x_range.^n)...
          + y_min * (1 - x_range.^n ./ (x_50^n + x_range.^n));
      
return