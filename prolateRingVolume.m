% Calculates volume of a prolate spheroid shell with lambdas 1 and 2 (endo
% and epi, respectively) and focal length d.

function volume = prolateRingVolume(l1, l2, mu1, mu2, d)

vol1 = (2/3) * pi * d^3 * ((cos(mu1)-cos(mu2)) * (cosh(l1)^3) - cosh(l1) * (cos(mu1)^3-cos(mu2)^3));
vol2 = (2/3) * pi * d^3 * ((cos(mu1)-cos(mu2)) * (cosh(l2)^3) - cosh(l2) * (cos(mu1)^3-cos(mu2)^3));

volume = vol2-vol1;


return