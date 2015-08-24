% Computes the linear distance between two sets of cartsian points
% EXAMPLE: distance = calcCartDist(P1, P2)
% 
% The values P1 and P2 are N X 3 matrices where each row contains 3D
% cartesian values describing a point (x,y,z).  When P1 and P2 contain more
% than one row, the distance between points in corresponding rows is
% returned.

function distance = calcCartDist(P1, P2)

distance = sqrt((P2(:,1)-P1(:,1)).^2 + (P2(:,2)-P1(:,2)).^2 + (P2(:,3)-P1(:,3)).^2);