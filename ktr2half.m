% Converts ktr values (units: time^-1) to half-times, the time required to
% reach half-maximal force.

function halftime = ktr2half(ktr)

halftime = -log(1/2) ./ ktr;

return