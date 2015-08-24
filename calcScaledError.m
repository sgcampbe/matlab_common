function err = calcScaledError(guess, actual, varargin)
%-----------------------------------------------------------------------%
%   Compute relative error between paired values of supplied vectors.
%   Author: Stuart Campbell
%   Date Started: 12/29/2011
%   
%   Description: This function takes vectors 'guess' and 'actual' (must have the same
%   length) and computes the sum of pair-wise errors.  The main feature of
%   this function is that it computes a SCALED error, that is, it scales
%   the difference between guess and actual by the magnitude of actual in
%   order to more accurately weight contributions to error from each
%   component.  There are two options for handling the sign of each error
%   term.  The default is a squared error, but it is also possible to use
%   the absolute value of the scaled difference between actual and guess.
%   Sign handling can be specified using parameter-value pairs after the
%   first two function arguements:
%   err = calcScaledError(guess, actual, 'signhandling', 'abs') or
%   err = calcScaledError(guess, actual, 'signhandling', 'square')
%
%   I have also added an option, in_range_boost, that will lower the
%   scaled error when it falls within the SEM of the data.  For instance,
%   if the fit comes within the SEM of a certain measure, that criterium's
%   error will be cut by 1/num_criteria prior to sign handling.  The
%   purpose of this is to encourage the optimizer to choose solutions that
%   fall within the SEM of all factors, and hopefully not get stuck on
%   solutions that fit the means of some criteria perfectly but push other
%   fits out of the SEM range.
%-----------------------------------------------------------------------%

params.signhandling   = 'square';
params.in_range_boost = false;      % Switch to true in order to cut error for guesses that are within the SEM of data (as determined by params.is_within_sem    
params.is_within_sem  = [];         % Boolean vector with an entry for each fit criterium indicating if it is with the SEM of data

params = parse_pv_pairs(params, varargin);  % Overwrite default, if needed

% Input check
if length(guess) ~= length(actual)
    error('guess and actual vectors must have the same length!');
end

% Compute scaled differences
diffs = (actual - guess) ./ actual;

% Apply in-range boost, if selected
if params.in_range_boost
    diffs = diffs .* ~params.is_within_sem + (diffs ./ length(diffs)) .* params.is_within_sem;
end

% Force positive sign for each error entry
switch params.signhandling
    case 'square'
        diffs = diffs.^2;
    case 'abs'
        diffs = abs(diffs);
end

% Sum error
err = sum(diffs);

return
