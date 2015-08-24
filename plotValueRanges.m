function varargout = plotValueRanges(x, y, yerr, varargin)

%------------------------------------------------------------------------%
%   Common Use Function - Plot shaded boxes to show means +/- uncertainty%
%   Author: Stuart Campbell
%   Date Started: 02/02/2012
%
%   Description: This function works kind of like errorbar, but just plots
%   rectangles centered about the mean value +/- the supplied error term. 
%
%   The rectangles are centered about each supplied x-y pair.  The
%   dimension in the x-direction is set as a fraction of the mean distance 
%   between x points (default is 1/10 but can be set through the
%   property 'BoxWidthRatio').  If the parameter 'xerr' is supplied, then
%   BoxWidthRatio is ignored and the x-direction width is set literally by 
%   The error range supplied.  The dimension in the y direction is set
%   by the corresponding values in yerr vector.  The color of the
%   rectangles can be set by the property 'Color'.  If you want the
%   rectangles to have an edge line, then hack the code.  I don't think
%   that will look very good, so I'm leaving it out for now.
%
%   If you don't want to bother specifying x points, just pass in an empty
%   matrix, [], and it will automatically space them out evenly.
%------------------------------------------------------------------------%

varargout = {}; % Initialize

%----------------------%
% Setup Default Values %
%----------------------%

params.xerr              = [];               % If xerr is non-empty, BoxWidthRatio is ignored and xerr determines box width.  If supplied, length(xerr) == length(x) is a must. 
params.BoxWidthRatio     = 1/10;             % Sets how wide the boxes are, as a fraction of the x range of the data
params.Color             = graycolor(0.5);   % Sets the color of rectangles, pass in a matrix with rows = numpts for each patch to be a different color
params.BoundingLines     = true;             % Line on top and bottom of box to emphasize yerr range
params.BoundingLineColor = 'k';              % Color of bounding lines
params.LineWidth         = 1.5;              % Width of bounding lines
params.Parent            = gca;              % Parent axes


%------------------------%
% Unpack Property Values %
%------------------------%

params = parse_pv_pairs(params,varargin);


%------------------------------------------------%
% Cursory Error Checking - Obvious Problems Only %
%------------------------------------------------%

% if ((sum(size(x) == size(y) == size(yerr))) ~= 3) && ~isempty(x) 
%     error('Input vectors must be indentical size/length!')
% end


%------------------------------------%
% Setup Data Structures For Plotting %
%------------------------------------%

numpts    = length(y);

if isempty(x)       % Allow the user to pass in an empty matrix for x
    x = 1:numpts;
end

rect_data = zeros(numpts, 4);                                         % Matrix of rectangle data, each row has x, y, w, and h for each rectangle to be plotted

% Handle with selection
if isempty(params.xerr)
    width     = ones(1, numpts) * params.BoxWidthRatio * (max(x) - min(x)) / (numpts - 1);  % Sets box width to something convenient
else
    width     = params.xerr;
end

% Compute rectangle lower left hand corners from centroids (x and y)
xll = x - 0.5 * width;
yll = y - yerr;

% Pack results in rect_data
rect_data(:,1) = xll;
rect_data(:,2) = yll;
rect_data(:,3) = width;
rect_data(:,4) = 2 * yerr;


%---------------------------%
% Loop Over Points and Plot %
%---------------------------%

h   = zeros(1, numpts);
blh = zeros(1, numpts * 2);

for i = 1:numpts
    % Check for multiple rows of color information
    [rcolors ccolors] = size(params.Color);
    if rcolors > 1
        if rcolors == numpts
            i_colors = i;
        else
            i_colors = 1;
            fprintf(2, 'Warning, if you want to cycle through target colors, you must supply one row of color numbers per data point!\n\n')
        end
    else
        i_colors = 1;
    end
        
    % Check for multiple rows of bounding line colors
    [rcolors ccolors] = size(params.BoundingLineColor);
    if rcolors > 1
        if rcolors == numpts
            i_blcolors = i;
        else
            i_blcolors = 1;
            fprintf(2, 'Warning, if you want to cycle through target colors, you must supply one row of color numbers per data point!\n\n')
        end
    else
        i_blcolors = 1;
    end
        
    
    % Draw target patch
    h(i) = rectangle('Position', rect_data(i,:), ...
                     'FaceColor', params.Color(i_colors, :), ...
                     'LineStyle', 'none', ...
                     'Parent',    params.Parent);
                 
    % Draw bounding lines, if selected
    if params.BoundingLines
        blh((2*i) - 1) = line([xll(i) xll(i) + width(i)], yll(i) * [1 1], ... 
                              'Color', params.BoundingLineColor(i_blcolors,:), ...
                              'LineWidth', params.LineWidth, ...
                              'Parent', params.Parent);
        blh(2*i)       = line([xll(i) xll(i) + width(i)], (yll(i) + 2 * yerr(i)) * [1 1], ... 
                              'Color', params.BoundingLineColor(i_blcolors,:), ...
                              'LineWidth', params.LineWidth, ...
                              'Parent', params.Parent);
                          
       
    end
end


if nargout > 0
    varargout{1} = h;
end

if nargout > 1
    varargout{2} = blh;
end



