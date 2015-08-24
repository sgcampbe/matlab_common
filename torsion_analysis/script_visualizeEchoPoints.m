%-------------------------------------------------------------------------%
% Script: script_visualizeEchoPoints.m
% Author: Stuart Campbell
% Date Started: 3/8/2012
% 
% Description: This script loads tracked points from raw .csv files for
% apex and base views, makes a movie of the points, and then plots
% timecourses for the standard deviations in an attempt to easily identify
% end-diastole.
%-------------------------------------------------------------------------%

cls

agegroup    = '6mo';
animalnum   = '486458';
flipflag    = true;         % Set to true if probe was flipped

basedatadir = '/Users/stuart/data/F344NIA_material_points_export/';
reportdir   = '/Users/stuart/data/F344NIA_reports_WITH_HR_and_APEX-BASE_DIST/';

%--------------------%
% Load Data from CSV %
%--------------------%

data_apex = importVeVoStrainData(sprintf('%s%s/%s_APEX.csv', basedatadir, agegroup, animalnum));
data_base = importVeVoStrainData(sprintf('%s%s/%s_BASE.csv', basedatadir, agegroup, animalnum));
report    = importVeVoData(sprintf('%s%s/%s.csv', reportdir, agegroup, animalnum));

numFrames = min([data_apex.numFrames data_base.numFrames]); % Use minimum

%------------------------------------------------%
% Find Average of Traced Points and Apply Offset %
%------------------------------------------------%

offset_apex = mean(data_apex.tracepoints.data);
offset_base = mean(data_base.tracepoints.data);

x_apex = data_apex.X.data - offset_apex(1);
y_apex = data_apex.Y.data - offset_apex(2);

x_base = data_base.X.data - offset_base(1);
y_base = data_base.Y.data - offset_base(2);


%--------------------%
% Flip Y Coordinates %
%--------------------%

y_apex  = y_apex * -1;
y_base  = y_base * -1;


%----------------------------%
% Flip X coords if necessary %
%----------------------------%

if flipflag
    x_apex = x_apex * -1;
    x_base = x_base * -1;
end

%----------------%
% Animate Points %
%----------------%

figure(1)

for i = 1:numFrames
    plot(x_apex(:,i), y_apex(:,i), 'r.')
    hold on
    plot(x_base(:,i), y_base(:,i), 'b.')
    hold off
    xlim([-150 150])
    ylim([-150 150])
    drawnow()
    pause(0.3)
end


%------------------%
% Draw Points Path %
%------------------%

figure(2)
numPts = min([data_apex.numPts data_base.numPts]);
hold on
    
for i = 1:numPts
    plot(x_apex(i,:), y_apex(i,:), 'r')
    plot(x_base(i,:), y_base(i,:), 'b')
    xlim([-150 150])
    ylim([-150 150])
    drawnow()
end


%--------------------------------%
% Convert Points to Polar Coords %
%--------------------------------%

[theta_apex r_apex] = cart2pol(x_apex, y_apex);
[theta_base r_base] = cart2pol(x_base, y_base);

% Regularize signs using cos, acos cycle
cos_theta_apex = cos(theta_apex);
theta_apex     = acos(cos_theta_apex);
cos_theta_base = cos(theta_base);
theta_base     = acos(cos_theta_base);

% Convert radians to degrees
theta_apex = rad2deg(theta_apex);
theta_base = rad2deg(theta_base);


%------------------------%
% Check timing alignment %
%------------------------%

figure(3)
subplot(211)
hold on
plot(data_apex.time.data, mean(r_apex), 'r')
plot(data_base.time.data, mean(r_base), 'b')

subplot(212)
hold on
plot(data_apex.time.data, vnorm(mean(r_apex)), 'r')
plot(data_base.time.data, vnorm(mean(r_base)), 'b')


%------------------------------%
% Compute and Display Torsions %
%------------------------------%

twist =   (theta_base(1:numPts, 1:numFrames)  ...
         - theta_apex(1:numPts, 1:numFrames));

twist = twist - repmat(twist(:,1), 1, numFrames);   % Apply offset for initial angle differences

torsion = twist / report.baseapexdist.val;

%------------------------%
% Plot Torsion Timelines %
%------------------------%

figure(4)
plot(data_apex.time.data(1:numFrames), torsion)

