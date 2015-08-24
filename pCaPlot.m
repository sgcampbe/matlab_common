% pCaPlot.m
% Plots arbitrary values as a function of pCa
% Accepts input arguements: (if any optional arg is used, all optionals
% must be provided)
%       Ca - vector of Ca points in uM
%       Y  - vector of generic y axis points corresponding to Ca points
%       ax - handle to desired axes
%       OPTIONAL:
%       color - line color
%       style - line style
%       width - line width

function hh = pCaPlot(varargin)

% Defaults
color = 'k';
style = '-';
width = 1.0;
marker = 'none';

func_argkey = {'Ca', 'Y', 'ax', 'color', 'style', 'width'};
for i = 1:nargin
    eval(strcat(func_argkey{i}, ' = varargin{i};'))
end

if nargin > 3
    [style,C,marker] = colstyle(varargin{5});
    if strcmp(marker, '')
        marker = 'none';
    end
    if strcmp(style, '')
        style = 'none';
    end
end

pCa_range = -log10(1e-6*Ca);

h = line(pCa_range, Y, ...
    'Parent', ax,...
    'Color', color,...
    'LineStyle', style,...
    'Marker', marker, ...
    'LineWidth', width);

set(ax, 'XDir', 'reverse');

if nargout > 0
    hh = h;
end

return
