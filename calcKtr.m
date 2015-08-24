%***********************************************************************%
%   Markov model of thin filament activation                            %
%   Function: calcKtr                                                   %
%   Date Started: 11/26/2008                                            %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function uses the 'half-time to F_ss' method of
%   calculating the rate of force redevelopment following slack/restretch
%   (ktr).
%
%   Inputs:     t       -   [ms] A vector containing timepoints
%               f       -   A vector containing function values at
%                           timepoints
%               f_ss    -   Steady-state force   
%               
%   OPTIONAL INPUTS (if any are included, all must be provided):
%               ax      -   handle to current axes
%               color   -   line color for plot of fit
%               style   -   line style for plot of fit
%               width   -   line width for plot of fit
%   Outputs:    ktr     -   [s^-1] (this is the standard unit of ktr)
%***********************************************************************%

function ktr = calcKtr(varargin)

t    = varargin{1};
f    = varargin{2};
f_ss = varargin{3};

if nargin > 3   % Used if you want to plot the fit
    ax    = varargin{4};
    color = varargin{5};
    style = varargin{6};
    width = varargin{7};
end

%-------------------------%
% Initialize Coefficients %
%-------------------------%

f_resid = min(f);   % Determine residual force following re-stretch
f_half  = 0.5 * (f_ss + f_resid);
t_mask  = f > f_half;
i       = find(t_mask(1:end-1) - t_mask(2:end));
t_half  = linInterp(f_half, f(i:i+1), t(i:i+1));

ktr = -1e3 * log(0.5) / t_half; % 1e3 converts to 1/s

if nargin > 3
    xfit = f_resid + (f_ss - f_resid) * makeMonoExpRise(t, 1e3/ktr);
    line(t, xfit, 'Parent', ax, 'Color', color, 'LineStyle', style, 'LineWidth', width);
end

return