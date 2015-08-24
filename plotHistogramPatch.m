function [hh lh] = plotHistogramPatch(Y,   ... A vector of data points
                                 varargin)% Many special options


%*************************************************************************%
% General Purpose Function
% Author: Stuart Campbell
% Date Started: 2/9/12
%
% This function generates a patch on the current axes, or axes specified by
% params.Parent.  The patch is the simple outline of a histogram definied
% by the input dataset, Y.  Among other options, the histogram patch can be
% plotted sideways by specifying params.sideways = true.
%*************************************************************************%

%-----------------%
% Set Up Defaults %
%-----------------%

params.Parent = gca;
params.LineWidth = 1;
params.MeanLineWidth = 1.5;
params.MeanLineMin = 2;
params.MeanLineMax = 6;
params.MeanLineColor = 'w';
params.LineStyle = '-';
params.EdgeColor = 'k';
params.FaceColor = graycolor(0.75);
params.FaceAlpha = 0.25;
params.sideways  = false;
params.num_bins  = 11;
params.plot_mean = true;      % 

params.bin_increment   = 1;         % Only used if bin_size_method = 'fixed', ignored otherwise
params.bin_size_method = 'range';   % Options: 'fixed': use a fixed bin size, specified by params.bin_size, which will have units that match Y
                                    %          'stddev': uses bin_size = 2*stddev / num_bins, nice because it self-normalizes to the range of Y, roughly
                                    %          'range': (default) takes the Y axis limits of the parent axes and divides by num_bins to determine the bin increment.

%------------------------%
% Unpack Property Values %
%------------------------%

params = parse_pv_pairs(params,varargin);


%-----------------------------------%
% Remove Values Outside Axes Limits %
%-----------------------------------%

m = mean(Y);    % Get mean before any trimming

y_limits = get(params.Parent, 'YLim');

Y = Y(Y >= y_limits(1));    % Keep only values above y axis min
Y = Y(Y <= y_limits(2));    % Keep only values less than y axis min


%--------------------------------%
% Handle Increment Determination %
%--------------------------------%

% Compute mean and stddev
stddev = std(Y);

% bin_increment adjustments
switch params.bin_size_method
    case 'fixed'
        bin_increment = params.bin_increment;
        
        % Make bin centers, and ensure zero bins on top and bottom, to make a patch with a smooth zero edge
        bin_centers   = (min(Y) - bin_increment):bin_increment:(max(Y) + 2 * bin_increment);
    
    case 'range'
        bin_increment = (y_limits(2) - y_limits(1)) / (params.num_bins + 1);
        
        % Make bin centers, made to coincide with axes ranges nicely
        half_increm   = 0.5 * bin_increment;
        bin_centers   = (y_limits(1) + half_increm):bin_increment:(y_limits(2) - half_increm);
    
    case 'stddev'
        bin_increment = (2 * stddev) / params.num_bins;
        
        % Make bin centers, and ensure zero bins on top and bottom, to make a patch with a smooth zero edge
        bin_centers   = (min(Y) - bin_increment):bin_increment:(max(Y) + 2 * bin_increment);
end




%-------------------------%
% Generate Histogram Data %
%-------------------------%

[n bin] = hist(Y, bin_centers);
n_orig   = n;   % Keep copies
bin_orig = bin;

%---------------------------------------%
% Post-Process to Give Square Bin Edges %
%---------------------------------------%

% Double up n values
n = [n;n];
n = reshape(n, 1, []);

% Double up and offset bin values
adj = 0.5 * bin_increment;
bin = [bin - adj; bin + adj];
bin = reshape(bin, 1, []);


%---------------------%
% Create Patch Points %
%---------------------%

% Close patch outline by adding points
switch params.bin_size_method
    case 'range'
        n   = [0 n 0];                  % Pad with zero on either end
        bin = [bin(1) bin bin(end)];    % Pad ends with duplicate vals
        
    case {'stddev', 'fixed'}
        n   = [n n(1)];
        bin = [bin bin(1)];
end

% Create data for line showing mean
mn = [params.MeanLineMin params.MeanLineMax];


% Handle sideways conditions
if params.sideways
    x = n;
    y = bin;
    
    mx = mn;
    my = [m m];
else
    x = bin;
    y = n;
    
    mx = [m m];
    my = mn;
end


%------------%
% Plot Patch %
%------------%

hh = patch(x, y, 'b');

set(hh, 'LineWidth', params.LineWidth, ...
        'LineStyle', params.LineStyle, ...
        'EdgeColor', params.EdgeColor, ...
        'FaceColor', params.FaceColor, ...
        'FaceAlpha', params.FaceAlpha, ...
        'Parent',    params.Parent);
    

%-----------%
% Plot Mean %
%-----------%

if params.plot_mean
    lh = line(mx, my,...
        'LineWidth', params.MeanLineWidth, ...
        'Color',     params.MeanLineColor, ...
        'LineStyle', params.LineStyle, ...
        'Parent',    params.Parent);
end