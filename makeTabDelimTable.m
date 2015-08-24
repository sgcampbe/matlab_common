%***********************************************************************%
%   General Purpose Function                                            %
%   Function: makeTabDelimTable.m                                       %
%   Date Started: 12/2/2009                                             %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function takes a cell array containing table
%   elements, as well as a filename (can include the path, if not using the
%   current directory) and creates a .txt file with tab-delimited elements
%   of the cell array.  Basically, it's used to make tables.  An optional
%   third argument can be used to specify number formatting.  To set the
%   number of decimal places equally for all numbers, specify an integer
%   (e.g. 2).  To specify the format of individual numbers, pass in a cell
%   array identical in dimension to the data but containing conversion
%   specifiers, e.g. '%.2e'.  If no specifier is used for a given place in
%   the cell array, (location is empty, []) default settings are used.
%
%   NOTE: THE ELEMENTS OF THE CELL ARRAY MUST EITHER BE DOUBLES OR STRINGS,
%   NOTHING ELSE WILL WORK!!!
%***********************************************************************%

function makeTabDelimTable(data, fname, varargin)

[nrows,ncols]= size(data);

fid = fopen(fname, 'w');

default_fmt = '%.2f';  % format for printing floats (default value)
fmt_exceptions = cell(nrows, ncols);

% Replace defaults with optional arg, if any present
if nargin > 2
    if isnumeric(varargin{1}) 
        default_fmt = varargin{1};
    elseif iscell(varargin{1})
        fmt_exceptions = varargin{1};
    else
        error('Optional arg must be a cell array or integer!')
    end
end


for row = 1:nrows
    fmtstr = '';
    for col = 1:ncols
        entry = data{row,col};
        format_exception = fmt_exceptions{row, col};
        if ischar(entry)                    % If it's a string, just deal with it
            fmtstr = strcat(fmtstr, '%s\t');
        elseif ~isempty(format_exception)   % If specific formatting is requested, do that
            fmtstr = [fmtstr format_exception '\t'];
        else                                % Else, just figure it out
            if isinteger(entry)
                fmtstr = strcat(fmtstr,'%d\t');
            elseif isfloat(entry)
                % see if it could be represented as an int
                if (entry - floor(entry)) > 0.0
                    fmtstr = strcat(fmtstr, default_fmt, '\t');
                else
                    data{row,col} = floor(entry);
                    fmtstr = strcat(fmtstr, '%d\t');
                end
            end
        end
    end
    fmtstr = strcat(fmtstr(1:end-2), '\n'); % Prune last tab and add a CR
        
    fprintf(fid, fmtstr, data{row,:});
end

fclose(fid);