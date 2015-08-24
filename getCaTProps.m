 function varargout = getCaTProps(varargin)
%**********************************************************************%
% General Use Code
% Author: Stuart Campbell
% Date Started: 1/4/10
% Function: getCaTProps.m
%  
%  This function handles processing of all the Ca transient
%  characteristics, including:
%     - rmag - ratio of fluorescence intensity CHANGE over twitch cycle,
%       (f340max-f340min)/(f380max-f380min).
%     - t_peak - Time to minimum f380 (it's the quietest channel)
%       corresponding to max of Ca transient
%     - tau - Time constant of Ca transient decay.  Computed on the portion
%       of the curve after the Ca transient peak.  Probably will use f380
%  NOTE!!!! If you add fields to props, you must put them in the prototype
%  struct at the top of this function, or problems could crop up.  
%
%  USAGE:
%   Calls to this function can have a variety of input/output arguments
%   depending on the desired behavior.  Call the function without args to
%   retrieve a valid (but empty) props or info struct.  This is useful for
%   growing arrays of property structs in scripting; calling w/o args makes
%   it possible to initialize the array of structs and grow it inside a
%   loop. Examples:
%   [props info] = getCaTProps(Traw, Yraw340, Yraw380, Yrawratio)
%   [props info] = getCaTProps(Traw, Yraw340, Yraw380, Yrawratio, 'Prop1', 'Val1', ...) 
%   To plot values:
%   [props info markers] = getCaTProps(Traw, Yraw340, Yraw380, Yrawratio, 'visualize', true)
%   Axes handle can also be passed in as PV pair.
%   [props info markers] = getCaTProps(Traw, Yraw340, Yraw380, Yrawratio)
%   The above call will return markers, an array of LineMaker instances
%   that will allow plotting of markers by the calling function. Markers
%   are scaled to be plotted over YRATIO.
%
%  CHANGE LOG 
%  
%  10/18/2011: Adding options for specifying a stimulus offset and
%  visualization of properties. Also, savitzky-golay smoothing can now be
%  specified via param-value pairs
%  
%  11/04/2011: Altering visualization options to allow creation of
%  LineMaker instances instead of directly plotting, in case the markers
%  are desired but immediate plotting is not.
%**********************************************************************%



% Create empty struct with the prop
props = struct('t_peak', [], ...
               'rmag', [], ...
               'min_ratio', [], ...
               'max_ratio', [], ...
               'tau', [], ...
               't_D50', [], ...
               't_D90', [], ...
               't_pt50', [], ...
               't_pt90', [] ...
               );
info.formattednames = { ...
                'TTP-Ca (ms)', ...
                'Mag-Ca', ...
                'Ratio-Diastolic', ...
                'Ratio-Peak', ...
                '\tau_{decay} (ms)', ...
                'Time to 50% decay', ...
                'Time to 90% decay', ...
                'TP50-T (ms)', ...
                'Time from peak to 90% decay', ...
                };
                
info.longnames = { ...
                'Time to Peak Fluorescence', ...
                'Peak Ratio of Systolic Fluorescence Change', ...
                'Fluorescence Ratio at diastole', ...
                'Fluorescence Ratio at peak', ...
                '\tau', ...
                'Time to 50% decay', ...
                'Time to 90% decay', ...
                'Time from peak to 50% decay', ...
                'Time from peak to 90% decay', ...
                };
            
info.InspectorNames = { ...
                'Time to Peak Fluorescence', ...
                'Peak Ratio of Systolic Fluorescence Change', ...
                'Fluorescence Ratio at diastole', ...
                'Fluorescence Ratio at peak', ...
                'Decay Time Const.', ...
                'Time to 50% decay', ...
                'Time to 90% decay', ...
                'Time from peak to 50% decay', ...
                'Time from peak to 90% decay', ...
                };
            
info.ylabels = { ... 
                'Time (ms)', ...
                '\Delta F340 / \Delta F380', ...
                'Ratio', ...
                'Ratio', ...
                'Time (ms)', ...
                's.', ...
                's.', ...
                's.', ...
                's.', ...
                };
            
markers = [];   % Default is empty
            
            
% This structure indicates which properties can be visualized as horizontal
% or vertical lines on a plot of the fura-2 RATIO.
plot_info.proptype = { ...  % Indicate whether the property is a 'time' point, a 'magnitude' point, or 'none' (doesn't really fit into either category).
                      'none', ...
                      'none', ...
                      'magnitude', ...
                      'magnitude', ...
                      'none', ...
                      'time_stim_offset', ...
                      'time_stim_offset', ...
                      'none', ...
                      'none', ...
                      };
               
outvars = {'props', 'info', 'markers'}; % This indicates vars that will be output (in this order)
            
if nargin == 0
    for i = 1:nargout
        varargout{i} = eval(outvars{i});
    end
    return
else
    Traw      = varargin{1};
    Yraw340   = varargin{2};
    Yraw380   = varargin{3};
    Yrawratio = varargin{4};
    
    % Set up extra parameters
    extra_params.visualize = false;   % Flag for visualization options
    extra_params.axh       = 0;       % Axes handle for visualization - starts empty until it's confirmed that visualize is on so that plots don't randomly pop up...
    extra_params.stim      = 1;       % Stimulus timecourse OR time (relative to Traw) OR index into Traw indicating stim time
    extra_params.stimtype  = 'istim'; % raw: stim is timecourse of stim channel; tstim: stim is time of stimulus in same units and reference as Traw; istim: stim is index into Traw indicating point of stimulus
    extra_params.sgfilt    = 1;       % Frame size of SG filter: if set to 1 (default) then the filter is not applied.  Must be odd integer.
    extra_params.propcolor = 'g';     % Color for overlaid properties
    
    extra_params.fract_diastolic = 0.1; % Fraction of record (taken from record ending) used to calculate the diastolic value
    
    extra_params.rawtracecolor    = 'b';    % Color for raw trace plot
    extra_params.smoothtracecolor = 'k';    % Color for smoothed trace plot
    
    if nargin > 4
        extra_params = parse_pv_pairs(extra_params, varargin(5:end));
        if (~sum(strcmp(varargin(5:end), 'axh'))) && extra_params.visualize
            extra_params.axh = gca;
        end
    end
    
    
        
end

% Determine stimulus time
switch extra_params.stimtype
    case 'tstim'    % tstim is given
        tstim = extra_params.stim;
    case 'istim'    % Index to stim time is given (index into Traw)
        tstim = Traw(extra_params.stim);
    case 'raw'      % the stimulus waveform (with timepoints given by Traw) is provided in extra_params.stim
        if length(Traw) == length(extra_params.stim)
            [istim tstim] = findStim(extra_params.stim, Traw);
        else
            error('raw stimtype is specified, but stim waveform length does not match Traw!')
        end
end



% Optional filtering
filtwidth = extra_params.sgfilt;
if filtwidth > 1
    fprintf('Applying Savitzky-Golay filter of width %d\n', filtwidth)
    % Yraw340 = sgolayfilt(Yraw340,   0, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
    % Yraw380 = sgolayfilt(Yraw380,   0, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
    % Yratio  = sgolayfilt(Yrawratio, 0, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
    Yraw340 = savfilt(Yraw340, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
    Yraw380 = savfilt(Yraw380, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
    Yratio  = savfilt(Yrawratio, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
else
    Yratio = Yrawratio;
end




% Linear interpolation to 10000 points
T      = 0:(Traw(end) / 10000):Traw(end); 
Y340   = linInterp(T, Traw, Yraw340);    
Y380   = linInterp(T, Traw, Yraw380); 
Yratio = linInterp(T, Traw, Yratio); 

% Work out diastolic sample indices
numavgpts = round(length(T) * extra_params.fract_diastolic); % Averages last 'fract_diastolic'th of record to get diastolic normalization factor
range_diast_avg = (length(T) - numavgpts:length(T));         % Range of traces to be used to get mean diastolic trace value

% Do some clean-up on fluorescence traces
Y340 = Y340 - mean(Y340(range_diast_avg));     % Subtract out diastolic fluorescence
Y380 = mean(Y380(range_diast_avg)) - Yraw380;  % Invert F380, while subtracting out diastolic fluorescence


% Determine t_peak 
[f380max i_380max]     = max(Y380);
[fratiomax i_ratiomax] = max(Yratio);
props.t_peak           = T(i_ratiomax) - tstim;

% Determine peak ratio of wavelengths
[f340max i_340max] = max(Y340); 
% props.rmag = f340max / f380max;   % This may be an interesting
% measurement, but I don't think it's right for CaT magnitude

% Determine ratio magnitudes min and max
props.min_ratio = mean(Yratio(range_diast_avg));    % Uses averaging of diastolic portion of record
[props.max_ratio i_max] = max(Yratio);


% Create normalized trace of ratio for 50/90 decay measurements
mag = props.max_ratio - props.min_ratio;
Y   = (Yratio - props.min_ratio) / mag;

% Also store rmag (max change in ratio, diastolic to systolic)
props.rmag = mag;

% Determine if t_D50 and t_D90 exist
isD50 = mean(Y(range_diast_avg)) <= 0.5;
isD90 = mean(Y(range_diast_avg)) <= 0.1;

% Determine t_D50 and t_D90 if they exist
Ydecay = Y(i_max:end);
Tdecay = T(i_max:end);
if isD50
    D50map = Ydecay <= 0.5;
    i_D50  = find(D50map(2:end) - D50map(1:end-1));
    props.t_D50 = Tdecay(i_D50(1)) - tstim;
end

if isD90
    D90map = Ydecay <= 0.1;
    i_D90  = find(D90map(2:end) - D90map(1:end-1));
    props.t_D90 = Tdecay(i_D90(1)) - tstim;
end

props.t_pt50 = props.t_D50 - props.t_peak;
props.t_pt90 = props.t_D90 - props.t_peak;


%-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-%
%----------------%
% Set up Markers %
%----------------%

% Raw ratio
markers = LineMaker(Traw, Yrawratio, 'Color', extra_params.rawtracecolor);

% Smoothed ratio
markers(end+1) = LineMaker(T, Yratio, 'color', extra_params.smoothtracecolor);

% Make Other Property markers:
trange = [min(T), max(T)];              % For plotting magnitude properties
Yrange = [min(Yratio), max(Yratio)];    % For plotting time properties
propnames = fieldnames(props);
for i = 1:length(propnames)
    type = plot_info.proptype{i};
    val = props.(propnames{i});
    switch type
        case 'time'
            markers(end+1) = LineMaker([val val], Yrange, 'color', extra_params.propcolor); 
        case 'time_stim_offset'     % For time properties that need to have tstim re-introduced to plot correctly
            markers(end+1) = LineMaker([val val] + tstim, Yrange, 'color', extra_params.propcolor); 
        case 'magnitude'
            markers(end+1) = LineMaker(trange, [val val], 'color', extra_params.propcolor);
    end
end


% Stimulus
markers(end+1) = LineMaker([tstim tstim], Yrange, 'color', extra_params.propcolor);

% Time to peak
markers(end+1) = LineMaker([tstim tstim] + props.t_peak, Yrange, 'color', extra_params.propcolor);

%-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-%


% Plot outputs, if selected
if extra_params.visualize
    hold(extra_params.axh, 'on')
    for i = 1:length(markers)
        markers(i).draw(extra_params.axh);
    end
    hold(extra_params.axh, 'off')
end

[props.tau, ~, markers(end+1)] = fitTransientDecay(T, Yratio, 'visualize', extra_params.visualize, 'axh', extra_params.axh);

for i = 1:nargout
    varargout{i} = eval(outvars{i});
end






return