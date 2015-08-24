%***********************************************************************%
% stuBar.m  A simple bar graphing function                              %
% Author: Stuart Campbell                                               %
% Date Started: 4/26/2008                                               %
% Input arguements: ax - axes handle
%                   data - bar data as a vector.
%                   colors - cell array with entries matching the number of
%                          data rows; determines the face color of bars.
%                   lbls - cell array containing strings for x axis labels
%***********************************************************************%

function h = stuBar(ax, data, colors, lbls)

x = 1:length(data);


for i = x
    h = bar(data(i), 'Parent', ax);
    hold on
    set(h, 'FaceColor', colors{i});
    set(h, 'XData', i)
end

set(ax, 'XTick', 1:length(lbls), ...
        'XLim',  [0.4 length(lbls)+0.5],...
        'XTickLabel', lbls, ...
        'box', 'off')
    
return