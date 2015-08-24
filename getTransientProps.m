%  This function handles processing of all the major twitch
%  characteristics, including:
%       T_peak - peak systolic tension
%       t_peak - Time to peak tension
%       t_dTdt_max - Time to maximum pos. rate of tension generation
%       dTdt_min - Maximum positive rate of tension gen
%       t_dTdt_min - Time to maximum neg. rat of tension generation
%       dTdt_min - Maximum negative rate of tension gen
%       t_pt90 - Time from peak to 90% decay of tension
%  And some others...
%  NOTE!!!! If you add fields to props, you must put them in the prototype
%  struct at the top of this function, or problems could crop up.  

function varargout = getTransientProps(varargin)

% Create empty struct with the prop
props = struct('t_peak', [], ...
               'T_peak', [], ...
               't_dTdt_max', [], ...
               'dTdt_max', [], ...
               't_dTdt_min', [], ...
               'dTdt_min', [], ...
               't_D50', [], ...
               't_D90', [], ...
               't_pt50', [], ...
               't_pt90', []);
info.formattednames = { ...
                'TTP-T (ms)', ...
                'Peak Twitch Tension (kPa)', ...
                'Time to dT/dt_{max}', ...
                'dT/dt_{max}', ...
                'Time to dT/dt_{min}', ...
                'dT/dt_{min}', ...
                'Time to 50% relaxation', ...
                'Time to 90% relaxation', ...
                'TP50-T (ms)', ...
                'Time from peak to 90% relaxation'};
                
info.longnames = { ...
                'Time to Peak Tension (kPa)', ...
                'Peak Twitch Tension', ...
                'Time to dT/dt_{max}', ...
                'dT/dt_{max}', ...
                'Time to dT/dt_{min}', ...
                'dT/dt_{min}', ...
                'Time to 50% relaxation', ...
                'Time to 90% relaxation', ...
                'Time from peak to 50% relaxation', ...
                'Time from peak to 90% relaxation'};
                

info.ylabels = { ... 
                'sec.', ...
                'kPa', ...
                'sec.', ...
                'Rel. Tension s^{-1}', ...
                'sec.', ...
                'Rel. Tension s^{-1}', ...
                'sec.', ...
                'sec.', ...
                'sec.', ...
                'sec.'};
               
outvars = {'props', 'info'};
            
if nargin == 0
    for i = 1:nargout
        varargout{i} = eval(outvars{i});
    end
    return
else
    Traw    = varargin{1};
    Yraw    = varargin{2};
    dYdtraw = varargin{3};
end

% Linear interpolation to 10000 points
T    = 0:(Traw(end) / 10000):Traw(end);  
Y    = linInterp(T, Traw, vnorm(Yraw));    % Note that Y is also normalized to range [0 1]
dYdt = linInterp(T, Traw, dYdtraw); 

T    = T * 1000;    % Note conversion to ms

% Determine t_peak and y_max
[junk i_max] = max(Y);
props.t_peak = T(i_max);
props.T_peak = max(Yraw);

% Determine max rate and time of max rate
[junk i_maxdYdt] = max(dYdt);
props.t_dTdt_max = T(i_maxdYdt);
props.dTdt_max   = max(dYdt);

% Determine min rate and time of min rate
[junk i_min] = min(dYdt);
props.t_dTdt_min = T(i_min);
props.dTdt_min   = min(dYdt);

% Determine if t_D50 and t_D90 exist
isD50 = Y(end) <= 0.5;
isD90 = Y(end) <= 0.1;

% Determine t_D50 and t_D90 if they exist
Ydecay = Y(i_max:end);
Tdecay = T(i_max:end);
if isD50
    D50map = Ydecay <= 0.5;
    i_D50  = find(D50map(2:end) - D50map(1:end-1));
    props.t_D50 = Tdecay(i_D50(1));
end

if isD90
    D90map = Ydecay <= 0.1;
    i_D90  = find(D90map(2:end) - D90map(1:end-1));
    props.t_D90 = Tdecay(i_D90(1));
end

props.t_pt50 = props.t_D50 - props.t_peak;
props.t_pt90 = props.t_D90 - props.t_peak;

for i = 1:nargout
    varargout{i} = eval(outvars{i});
end

return