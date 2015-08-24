%***************************************************************************%
% General Purpose Code: linInterp.m                                       % 
% Author: Stuart Campbell                                                   %
% Date Started: 12/3/07                                                     %
%                                                                           %
% Description: This function accepts a vector of desired timepoints (t_new) %
% as well as another time vector (t) and corresponding  y values (y).  The  %
% function then linearly interpolates between t/y pairs to come up with a   %
% new y vector (y_new) that approximates y at timepoints contained in       %
% t_new.                                                                    %
%***************************************************************************%

function y_new = linInterp(t_new, t, y)

y_new = zeros(size(t_new));

if t(1) > t_new(1)  % To catch start missmatch case
    t(end+1) = 0;
    t(2:end) = t(1:end-1);
    t(1)     = t_new(1);    % DONT ASK!
    
    y(end+1) = 0;
    y(2:end) = y(1:end-1);  % DONT ASK!
end

t(end+1) = t_new(end)*1.01;
y(end+1) = y(end);

for i = 1:length(t_new)
%     % New Code
%     i_tnew     = find(t >= t_new(i), 1); % Gets index
%     if isempty(i_tnew)  % t_new is greater than all t vals, so set equal to last y
%         y_new(i) = y(end);
%     elseif i_tnew == 1; % t_new is less than the starting t value, so set equal to first y element
%         y_new(i) = y(1);
%     else                % Interpolate!
%         j          = i_tnew;
%         y_new(i)   = y(j-1)+((y(j)-y(j-1))/(t(j)-t(j-1)))*(t_new(i) - t(j-1));
%     end
    
    % Old Code - actually still tests as more efficient!
    j = 1; while (t_new(i) >= t(j)); j = j+1; end 
    y_new(i) = y(j-1)+((y(j)-y(j-1))/(t(j)-t(j-1)))*(t_new(i) - t(j-1));
end

return