%***********************************************************************%
% Function: makeSig.m
% Author: Stuart Campbell
% Date Started: 7/14/09
% Description: Returns values of the the sigmoid function corresponding to
% input vector x according to parameters:
%       x50 - The value of x at which the function is at half-maximal (0.5)
%       n   - The 'Hill coefficient' or adjustment of the slope
%       mag - A scaling factor for the magnitude - defaults to +1 if not passed in
%       yoff- An optional y offset - defaults to zero if not passed in
%
%***********************************************************************%

function y = makeSig(x, x50, n, varargin)

if nargin == 4
    mag = varargin{1};
    yoff = 0;
elseif nargin == 5
    mag = varargin{1};
    yoff = varargin{2};
else
    mag = 1;
    yoff = 0;
end

y = mag ./ (1 + exp(-n * (x - x50))) + yoff;

return