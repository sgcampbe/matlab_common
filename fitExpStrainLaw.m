%***********************************************************************%
%   General Purpose Code                                                %
%   File:   fitExpStrainLaw.m                                           %
%   Date Started: 10/18/2010                                            %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function takes a vector of 'x' points and 
%   corresponding function values and fits them using a simple exponential 
%   function.  It returns three parameters: sigma (scaling coefficient), L
%   (the time constant), and x_offset (an offset to the independent
%   variable).
%***********************************************************************%

function [sigma L x_offset] = fitExpStrainLaw(x, F)



params_0 = [3000, 25, 1000];         % sigma, L, x_offset

params = fminsearch(@(params) exp_func(params, x, F), params_0);

sigma    = params(1);
L        = params(2);
x_offset = params(3);

return


function diff = exp_func(params, x, F)
sigma    = params(1);
L        = params(2);
x_offset = params(3);

guess    = makeExpIncrease(x, sigma, L, x_offset);

diff = norm(F - guess);
