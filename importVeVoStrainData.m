function props = importVeVoStrainData(fname)
% This function retrieves data from exported VeVo2100 STRAIN files (CSV is
% the format).  It does so by looking at the first column of each row to 
% determine a list of candidate properties for extraction. 
% Because the data are highly heterogenous in structure, the code specifies
% which candidate properties it would like to extract, and for each one a
% specific extractor sequence must be coded in a switch statement.  There's
% nothing elegant about it.


props    = struct('time',        struct('key_str', 'TimeProgr.', ...
                                        'data',    [],  ...
                                        'row',     []), ...
                  'tracepoints', struct('key_str', 'TracePointsEndoXYpixel', ...
                                        'data',    [],  ...
                                        'row',     []), ...
                  'pixeldim',    struct('key_str', 'PixelDimension', ...
                                        'data',    [],  ...
                                        'row',     []), ...
                  'X',           struct('key_str', 'tX (pixel coord)', ...
                                        'data',    [],  ...
                                        'row',     []), ...
                  'Y',           struct('key_str', 'tY (pixel coord)', ...
                                        'data',    [],  ...
                                        'row',     []));
                  
%---------------------------%
% Build List of Target Keys %
%---------------------------%
targs = fieldnames(props);
targkeys = cell(size(targs));
for i = 1:length(targs)
    targkeys{i} = props.(targs{i}).key_str;
end


%-------------------------%
% Open File as Big String %
%-------------------------%

try
    bigstr = file2str(fname);
catch msg
    fprintf(2, msg.message);
end


%------------------------------------------------------%
% Split into Lines and Loop Over to Find Relevant Rows %
%------------------------------------------------------%

lines    = split(bigstr, '\n');
numlines = length(lines);
rowlbls  = cell(numlines, 1);       % Store the entry for the first column of each row, which is useful later
for r = 1:length(lines)
    line  = regexprep(lines{r}, '"', '');   % Remove annoying double quote char
    parts = split(line, ',');
    if ~isempty(parts)
        label = parts{1};
    else
        label = '';
    end
    
    rowlbls{r} = label;
    
    targ_match = find(strcmp(targkeys, label));
    if ~isempty(targ_match)
        
        % Register row index
        props.(targs{targ_match}).row = r;
        
    end
end

% Determine 'blank' row numbers to find ends of data blocks
blank_rows = find(strcmp(rowlbls, char(13)));


%-------------------------------------%
% Loop Over Prop Extraction Functions %
%-------------------------------------%

props.time.data        = extract_time(props, lines, blank_rows);
props.tracepoints.data = extract_tracepoints(props, lines, blank_rows);
props.pixeldim.data    = extract_pixeldim(props, lines, blank_rows);
props.X.data           = extract_X(props, lines, blank_rows);
props.Y.data           = extract_Y(props, lines, blank_rows);


%------------------------------------------------%
% Add Some Extra Props Like Number of Frames etc %
%------------------------------------------------%

props.numTracePts = length(props.tracepoints.data);

[props.numPts props.numFrames] = size(props.X.data);





%--------------------------------------%
% Individual Property Import Functions %
%--------------------------------------%

% Each function is named according to the pattern 'extract_???' where ???
% is the FIELDNAME of the corresponding property in the props structure.
% For example, extract_time is called to retrieve the data that will
% ultimately be stored under props.time.data

%-------------------------------------------------------------------------%
function data = extract_time(props, lines, blank_rows)

r     = props.time.row;
raw   = lines{r};
parts = split(raw, ',');
data  = zeros(1,length(parts) - 2);

for c = 1:length(data)
    data(c) = str2double(parts(c+1));
end

return


%-------------------------------------------------------------------------%
function data = extract_tracepoints(props, lines, blank_rows)

r_start = props.tracepoints.row + 1;    % Skip down one from the label
r_end   = blank_rows(find((blank_rows > r_start), 1)) - 1;

% Dimension tracepoints
data = zeros((r_end - r_start + 1), 2);

% Loop over row range
rctr  = 1;  % row counter to place in output 
for r = r_start:r_end

    raw   = lines{r};
    parts = split(raw, ',');
    
    % Loop over avail. columns
    for c = 1:2
        data(rctr,c) = str2double(parts{c});
    end
    
    rctr = rctr + 1;    % Increment!
    
end

return


%-------------------------------------------------------------------------%
function data = extract_pixeldim(props, lines, blank_rows)

r     = props.time.row;
raw   = lines{r};
parts = split(raw, ',');
data  = str2double(parts{2});

return


%-------------------------------------------------------------------------%
function data = extract_X(props, lines, blank_rows)

r_start = props.X.row + 2;    % Skip down two from the label; one down is the frame label row
r_end   = blank_rows(find((blank_rows > r_start), 1)) - 1;

% Dimension tracepoints
raw  = split(lines{r_start}, ',');
if raw{end} == char(13)
    numframes = length(raw) - 2;
else
    numframes = length(raw) - 1;
end
data = zeros((r_end - r_start + 1), numframes);

% Loop over row range
rctr  = 1;  % row counter to place in output 
for r = r_start:r_end

    raw   = lines{r};
    parts = split(raw, ',');
    
    % Loop over avail. columns
    for c = 1:numframes
        data(rctr,c) = str2double(parts{c+1});
    end
    
    rctr = rctr + 1;    % Increment!
    
end

return


%-------------------------------------------------------------------------%
function data = extract_Y(props, lines, blank_rows)

r_start = props.Y.row + 2;    % Skip down two from the label; one down is the frame label row
r_end   = blank_rows(find((blank_rows > r_start), 1)) - 1;

% Dimension tracepoints
raw  = split(lines{r_start}, ',');
if raw{end} == char(13)
    numframes = length(raw) - 2;
else
    numframes = length(raw) - 1;
end
data = zeros((r_end - r_start + 1), numframes);

% Loop over row range
rctr  = 1;  % row counter to place in output 
for r = r_start:r_end

    raw   = lines{r};
    parts = split(raw, ',');
    
    % Loop over avail. columns
    for c = 1:numframes
        data(rctr,c) = str2double(parts{c+1});
    end
    
    rctr = rctr + 1;    % Increment!
    
end

return


    