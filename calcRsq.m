%------------------------------------------------------------------------%
%   Function: calcRsq.m
%   This function accepts two pairs of vectors:
%       xd - Data x values
%       yd - Data y values corresponding to xd
%       xm - Model x values
%       ym - Model y values corresponding to xm
%
%   The output of the model is rsq, the coefficient of determination of the
%   model fit to the data.  This scalar value essentially describes the
%   goodness of fit of the model to the data points.
%
%   It provides two other useful measures in the returned structs, the
%   rmserror, and the normalized rmserror, which has been divided by the
%   mean data y value and multiplied by 100.  Basically estimates the
%   average % error or difference between two sequences.
%
%   Note that it will be generally preferable to pass in the sparser
%   sequence as the 'data' sequence, so that the linear interpolation
%   looses as little information as possible.  This doesn't matter
%   obviously, if the sets have the same resolution.
%-------------------------------------------------------------------------%

function result = calcRsq(xd, yd, xm, ym)

% Sort xd and yd if necessary so that xd is monotonically increasing
[xd i_sort] = sort(xd);
yd = yd(i_sort);

% Find model values to correspond to data values using linear interpolation
if length(xd) ~= length(xm)     % If the x vectors are not identical
    ym = linInterp(xd, xm, ym);
elseif xd ~= xm
    ym = linInterp(xd, xm, ym);
end

% Calculate means
ydbar = sum(yd) / length(yd);

% Calculate RMS error
rmserr = norm(yd - ym) / sqrt(length(yd));

% Calculate the pct relative RMS error, normalized to the mean
pct_rmserr = 100 * (rmserr / ydbar);

% Calculate sums of squares
sstot = norm(yd - ydbar);   % Note that norm is the built-in MATLAB function
sserr = norm(yd - ym);

rsq = 1 - sserr / sstot;

result.rsq        = rsq;
result.rmserr     = rmserr;
result.pct_rmserr = pct_rmserr;


return