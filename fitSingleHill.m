%***********************************************************************%
%   Markov model of thin filament activation                            %
%   File:   fitSingleHill                                               %
%   Author: Stuart Campbell                                             %
%   Date Started: 8/26/2008                                             %
%   Description: This function accepts a set of arbitrary values as a
%   function of Ca and uses a single Hill function to fit the data.  It
%   includes an offset parameter to fit curves that do not approach zero
%   as Ca goes to zero.  If optional parameters are included, the curve fit
%   is plotted.
%   Inputs:     Ca_range-   A vector containing values of [Ca] for which
%                           peak force values have been calculated.
%               X       -   A matrix containing peak isometric force for 
%                           a given [Ca].
%               
%   OPTIONAL INPUTS (if any are included, all must be provided):
%               ax      -   handle to current axes
%               color   -   line color for plot of fit
%               style   -   line style for plot of fit
%               width   -   line width for plot of fit
%   Outputs:    hill_fit-   A vector containing the coefficients of the
%                           Hill equation fit to data in X.  
%*************************************************************************%

function hill_fit = fitSingleHill(varargin)

Ca_range = varargin{1};
X        = varargin{2};

if nargin > 2   % Used if you want to plot the fit
    ax    = varargin{3};
    color = varargin{4};
    style = varargin{5};
    width = varargin{6};
end

% Fix Ca_range input vector if row vector
[r c] = size(Ca_range);
if c > r
    Ca_range = Ca_range';
end

% Fix X input vector if row vector
[r c] = size(X);
if c > r
    X = X';
end


hill_fit_0 = [0.2, 1.5, 7 0];    % Initialize solver values

options = optimset('Display', 'notify');    % Use less cluttering output

hill_fit = lsqnonlin(@(hill_fit) hill_func(hill_fit, Ca_range, X), ...
                                 hill_fit_0, ... Initial guess
                                 [], ... Lower bounds
                                 [], ... Upper bounds
                                 options);


X_max  = hill_fit(1);
Ca_50  = hill_fit(2);
n      = hill_fit(3);
offset = hill_fit(4);

Ca_range = makeLogCaRange(Ca_range(1), Ca_range(end), 50);

hill_eqn = makeSynthHill(Ca_range, offset, X_max, n, Ca_50);

if nargin > 2
    pCaPlot(Ca_range, hill_eqn, ax, color, style, width)
end

return

%*************************************************************************%
%   Crossbridge Kinetics Model: Active force generation in cardiomyocytes %
%   File:   hill_func.m                                                   %
%   Author: Stuart Campbell                                               %
%   Date Started: 9/5/2006                                                %
%   Description: This function accepts a set of Hill equation parameters
%   and a vector containing F-Ca data and the corresponding values of
%   Ca.  Then it calculates the hill function for those values of [Ca]
%   and the difference between it and the F-Ca data, returning that
%   difference.
%*************************************************************************%

function f_diff = hill_func(hill_fit, Ca_range, X_max_data)

%Unpack parameters
X_max  = hill_fit(1);
Ca_50  = hill_fit(2);
n      = hill_fit(3);
offset = hill_fit(4);

hill_eqn = makeSynthHill(Ca_range, offset, X_max, n, Ca_50);

f_diff = X_max_data - hill_eqn;