% Build some fake torsion data

numFrames   = 50;
numPts      = 12;

r_base_0 = 1 * ones(numPts, 1);
r_apex_0 = 0.75 * ones(numPts, 1);

delta_angle  = deg2rad(15);
delta_radius = -0.2;

base_offset = deg2rad(-5);

incr = (2 * pi) / numPts;

theta_apex_0  = (0:incr:(2 * pi) - incr)';
theta_base_0  =  theta_apex_0 + base_offset;


% Check initial points
figure(1)
[x y] = pol2cart(theta_apex_0, r_apex_0);
plot(x, y, 'r.')
hold on
[x y] = pol2cart(theta_base_0, r_base_0);
plot(x, y, 'b.')


% Make timecourses
time = 0:(pi / (numFrames - 1)):pi;

angle_perturb = delta_angle * sin(time);
rad_perturb   = delta_radius * sin(time);

theta_base = repmat(theta_base_0, 1, numFrames) + repmat(angle_perturb, numPts, 1);
theta_apex = repmat(theta_apex_0, 1, numFrames) - repmat(angle_perturb, numPts, 1);

r_base = repmat(r_base_0, 1, numFrames) + repmat(rad_perturb, numPts, 1);
r_apex = repmat(r_apex_0, 1, numFrames) + repmat(rad_perturb, numPts, 1);


% Convert to cartesian and plot

[x_apex y_apex] = pol2cart(theta_apex, r_apex);
[x_base y_base] = pol2cart(theta_base, r_base);

plot(x_apex', y_apex')
plot(x_base', y_base')
