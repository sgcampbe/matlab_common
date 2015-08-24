% Converts prolpts (lambda, mu, theta columns) into cartesian coordinates
% given a focal length d

function cartpts = prol2cart(prolpts, d)

cartpts = zeros(size(prolpts));

lambda = prolpts(:,1);
mu     = prolpts(:,2);
theta  = prolpts(:,3);

cartpts(:,1) = d * cosh(lambda) .* cos(mu);
cartpts(:,2) = d * sinh(lambda) .* sin(mu) .* cos(theta);
cartpts(:,3) = d * sinh(lambda) .* sin(mu) .* sin(theta);

return

