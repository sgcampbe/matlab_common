function pctChange = calcPctChange(baseline, perturbed)

% This function calculates the percent change between two scalars. Very
% useful when writing up results.

pctChange = 100 * (perturbed - baseline) / baseline;