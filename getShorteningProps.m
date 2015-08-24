function varargout = getShorteningProps(varargin)
%**********************************************************************%
% General Use Code
% Author: Stuart Campbell
% Date Started: 1/4/10
% Function: getShorteningProps.m
%  
%  This function handles processing of all the major unloaded SL shortening
%  characteristics, including:
%       SH_peak - peak systolic tension
%       t_peak - Time to peak tension
%       t_dSHdt_max - Time to maximum pos. rate of tension generation
%       dSHdt_min - Maximum positive rate of tension gen
%       t_dSHdt_min - Time to maximum neg. rat of tension generation
%       dSHdt_min - Maximum negative rate of tension gen
%       t_pt90 - Time from peak to 90% decay of tension
%  And some others...
%  NOTE!!!! If you add fields to props, you must put them in the prototype
%  struct at the top of this function, or problems could crop up.  

%  USAGE:
%   Calls to this function can have a variety of input/output arguments
%   depending on the desired behavior.  Call the function without args to
%   retrieve a valid (but empty) props or info struct.  This is useful for
%   growing arrays of property structs in scripting; calling w/o args makes
%   it possible to initialize the array of structs and grow it inside a
%   loop. Examples:
%   [props info] = getShorteningProps(Traw, Yraw)
%   [props info] = getShorteningProps(Traw, Yraw, 'Prop1', 'Val1', ...) 
%   To plot values:
%   [props info markers] = getShorteningProps(Traw, Yraw, 'visualize', true)
%   Axes handle can also be passed in as PV pair.
%   [props info markers] = getShorteningProps(Traw, Yraw)
%   The above call will return markers, an array of LineMaker instances
%   that will allow plotting of markers by the calling function.
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
               'SH_peak', [], ...
               't_dSHdt_max', [], ...
               'dSHdt_max', [], ...
               't_dSHdt_min', [], ...
               'dSHdt_min', [], ...
               't_D50', [], ...
               't_D90', [], ...
               't_pt50', [], ...
               't_pt90', [], ...
               'SL_diastolic', [], ...
               'SL_systolic',  [] ...
               );
           
info.formattednames = { ...
                'TTP-T (ms)', ...
                'Peak SL shortening (% rest)', ...
                'Time to dSH/dt_{max}', ...
                'dSH/dt_{max}', ...
                'Time to dSH/dt_{min}', ...
                'dSH/dt_{min}', ...
                'Time to 50% relaxation', ...
                'Time to 90% relaxation', ...
                'TP50-T (ms)', ...
                'Time from peak to 90% relaxation', ...
                'SL_{diastolic}', ...
                'SL_{systolic}', ...
                };
                
info.longnames = { ...
                'Time to Peak Tension', ...
                'Peak Twitch Shortening', ...
                'Time to dSH/dt_{max}', ...
                'dSH/dt_{max}', ...
                'Time to dSH/dt_{min}', ...
                'dSH/dt_{min}', ...
                'Time to 50% relaxation', ...
                'Time to 90% relaxation', ...
                'Time from peak to 50% relaxation', ...
                'Time from peak to 90% relaxation', ...
                'Diastolic SL', ...
                'Peak Systolic SL', ...
                };

info.InspectorNames = { ...
                'Time to Peak Tension', ...
                'Peak Twitch Shortening', ...
                'Time to dSH/dt_max', ...
                'dSH/dt_max', ...
                'Time to dSH/dt_min', ...
                'dSH/dt_min', ...
                'Time to 50% relaxation', ...
                'Time to 90% relaxation', ...
                'Time from peak to 50% relaxation', ...
                'Time from peak to 90% relaxation', ...
                'Diastolic SL', ...
                'Peak Systolic SL', ...
                };
                

info.ylabels = { ... 
                's.', ...
                '% slack SL', ...
                's.', ...
                's^{-1}', ...
                's.', ...
                's^{-1}', ...
                's.', ...
                's.', ...
                's.', ...
                's.', ...
                '\mum', ...
                '\mum', ...
                };
            
plot_info.proptype = {...
                      'time_stim_offset', ...
                      'none', ...
                      'time_stim_offset', ...
                      'none', ...
                      'time_stim_offset', ...
                      'none', ...
                      'time_stim_offset', ...
                      'time_stim_offset', ...
                      'none', ...
                      'none', ...
                      'magnitude', ...
                      'magnitude', ...
                      };

markers = [];    % Default is empty

outvars = {'props', 'info', 'markers'};  % This indicates vars that will be output (in this order)
            
if nargin == 0
    for i = 1:nargout
        varargout{i} = eval(outvars{i});
    end
    return
else
    Traw    = varargin{1};
    Yraw    = varargin{2};
    
    % Set up extra parameters
    extra_params.visualize = false;   % Flag for visualization options
    extra_params.axh       = 0;       % Axes handle for visualization - starts empty until it's confirmed that visualize is on so that plots don't randomly pop up...
    extra_params.stim      = 1;       % Stimulus timecourse OR time (relative to Traw) OR index into Traw indicating stim time
    extra_params.stimtype  = 'istim'; % raw: stim is timecourse of stim channel; tstim: stim is time of stimulus in same units and reference as Traw; istim: stim is index into Traw indicating point of stimulus
    extra_params.sgfilt    = 1;       % Frame size of SG filter: if set to 4 or less (default) then the filter is not applied.  Must be odd integer.
    extra_params.propcolor = {'g', ...
                              'g', ...
                              'g', ...
                              'g', ...
                              'g', ...
                              'g', ...
                              'r', ...
                              'r', ...
                              'g', ...
                              'g', ...
                              'g', ...
                              'g', ...
                              };     % Color for overlaid properties
    
    extra_params.rawtracecolor    = 'b';    % Color for raw trace plot
    extra_params.smoothtracecolor = 'm';    % Color for smoothed trace plot
    extra_params.fract_diastolic  = 0.1;    % Fraction of record (taken from record ending) used to calculate the diastolic value
    extra_params.is_sim           = false;  % If it's a sim, then use the first points of the record to calculate diastolic value
        
    if nargin > 2
        extra_params = parse_pv_pairs(extra_params, varargin(3:end));
        if (~sum(strcmp(varargin(3:end), 'axh'))) && extra_params.visualize
            extra_params.axh = gca;
        end
    end
end

% Optional filtering
filtwidth = extra_params.sgfilt;
if filtwidth > 4
    fprintf('Applying Savitzky-Golay filter of width %d\n', filtwidth)
    % Y = sgolayfilt(Yraw,   2, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
    Y = savfilt(Yraw, filtwidth);   % Apply SG filter to make sure that noise doesn't mess up properties
else
    Y = Yraw;
end

Ysmooth = Y;    % Keep copy for plotting

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

% Work out diastolic sample indices - NON NORMALIZED & INTERPOLATED VERSION
numavgpts       = round(length(Traw) * extra_params.fract_diastolic); % Averages last 'fract_diastolic'th of record to get diastolic normalization factor

range_diast_avg = (length(Traw) - numavgpts:length(Traw));            % Range of traces to be used to get mean diastolic trace value

if extra_params.is_sim
    range_diast_avg = 1:2;  % For simulations!
end

% Determination of min and max absolute values
props.SL_diastolic = mean(Y(range_diast_avg));
props.SL_systolic  = min(Y);



% Linear interpolation to 10000 points
T    = 0:(Traw(end) / 10000):Traw(end);
Y    = 100 * (mean(Ysmooth(range_diast_avg)) - Ysmooth) / mean(Ysmooth(range_diast_avg));   % Transform absolute SL into pct shortening
Y    = linInterp(T, Traw, Y);    

% Work out diastolic sample indices
numavgpts       = round(length(T) * extra_params.fract_diastolic); % Averages last 'fract_diastolic'th of record to get diastolic normalization factor
range_diast_avg = (length(T) - numavgpts:length(T));               % Range of traces to be used to get mean diastolic trace value

if extra_params.is_sim
    range_diast_avg = 1:2;  % For simulations!
end

% Calc of NORMALIZED derivative by finite differences
dYdtraw = diff(Y) / (T(2) - T(1));
dYdtraw(end + 1) = dYdtraw(end);    % Recover lost point
dYdt = dYdtraw; 

% Determine t_peak and y_max
[junk i_max] = max(Y);
props.t_peak = T(i_max) - tstim;
props.SH_peak = max(Y);

% Determine max rate and time of max rate
[junk i_maxdYdt] = max(dYdt);
props.t_dSHdt_max = T(i_maxdYdt) - tstim;
props.dSHdt_max   = max(dYdt);

% Determine min rate and time of min rate
[junk i_min] = min(dYdt);
props.t_dSHdt_min = T(i_min) - tstim;
props.dSHdt_min   = min(dYdt);

% Determine if t_D50 and t_D90 exist
isD50 = mean(Y(range_diast_avg)) <= 0.5 * props.SH_peak;
isD90 = mean(Y(range_diast_avg)) <= 0.1 * props.SH_peak;

% Determine t_D50 and t_D90 if they exist
Ydecay = Y(i_max:end);
Tdecay = T(i_max:end);
if isD50
    D50map = Ydecay <= 0.5 * props.SH_peak;
    i_D50  = find(D50map(2:end) - D50map(1:end-1));
    if ~isempty(i_D50)
        props.t_D50 = Tdecay(i_D50(1)) - tstim;
    else
        props.t_D50 = NaN;
    end
else
    props.t_D50 = NaN;
end

if isD90
    D90map = Ydecay <= 0.1 * props.SH_peak;
    i_D90  = find(D90map(2:end) - D90map(1:end-1));
    if ~isempty(i_D90)
        props.t_D90 = Tdecay(i_D90(1)) - tstim;
    else
        props.t_D90 = NaN;
    end
else
    props.t_D90 = NaN;
end

props.t_pt50 = props.t_D50 - props.t_peak;
props.t_pt90 = props.t_D90 - props.t_peak;


%-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-%
%----------------%
% Set up Markers %
%----------------%
% Plot raw SL
markers = LineMaker(Traw, Yraw, 'color', extra_params.rawtracecolor);

% Plot smoothed ratio
markers(end+1) = LineMaker(Traw, Ysmooth,   'color', extra_params.smoothtracecolor);

% Plot property markers:
trange = [min(Traw), max(Traw)];              % For plotting magnitude properties
Yrange = [min(Yraw), max(Yraw)];              % For plotting time properties
propnames = fieldnames(props);
for i = 1:length(propnames)
    type = plot_info.proptype{i};
    val = props.(propnames{i});
    switch type
        case 'time'
            markers(end+1) = LineMaker([val val], Yrange, 'color', extra_params.propcolor{i}); 
        case 'time_stim_offset'     % For time properties that need to have tstim re-introduced to plot correctly
            markers(end+1) = LineMaker([val val] + tstim, Yrange, 'color', extra_params.propcolor{i}); 
        case 'magnitude'
            markers(end+1) = LineMaker(trange, [val val], 'color', extra_params.propcolor{i});
    end
end

% Stimulus
markers(end+1) = LineMaker([tstim tstim], Yrange, 'color', extra_params.propcolor{1});
%-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-%


%-------------------------------------------------------------------------%
% Plot outputs, if selected
if extra_params.visualize
    hold(extra_params.axh, 'on')
    for i = 1:length(markers)
        markers(i).draw(extra_params.axh);
    end
    hold(extra_params.axh, 'off')
end
%-------------------------------------------------------------------------%

% Convert time-based properties to ms IF specified in units, and assuming Traw is
% in seconds
pnames = fieldnames(props);
for i = 1:length(info.ylabels)
    if strcmp(info.ylabels{i}, 'ms.')
        props.(pnames{i}) = props.(pnames{i}) * 1000;   % CONVERT TO MS!!!
    end
end

for i = 1:nargout
    varargout{i} = eval(outvars{i});
end

return