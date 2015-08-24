%----------------------------------------------------------------------%
% Make Graphical Table
% Author: Stuart Campbell
% Date Started: 12/10/2009
% Function Name: makeGraphicalTable.m
% Description: This function takes a cell array and places each entry in a
% grid (table) on the current figure according to alignment and spacing
% information provided by the calling function or script.  The user must
% supply spacing.
%----------------------------------------------------------------------%

function h = makeGraphicalTable(entries, ... a cell array of table entries
                                hspac,   ... horizontal spacing between cells
                                vspac,   ... vertical spacing between cells
                                hoff,    ... horizontal offset to lower-left corner of top left cell
                                voff,    ... vertical offset ''
                                fontsize,... font size for all entries
                                lineflag,... flag to draw line after top row of table,
                                fmt,     ... format string for floats
                                fig)       % Handle to desired figure the table will go on
                            
% Some default settings
color = 'k';
% fmt   = '%.2f'; % Default display format for floats

% Determine table size
[rows cols] = size(entries);

xcur = hoff;    % Initialize current cell position
ycur = voff;

h = zeros(rows, cols);

for i = 1:rows
    for j = 1:cols
        entry = entries{i,j};
        if isinteger(entry)
            entry = num2str(entry);
        elseif isfloat(entry)
            % see if it could be represented as an int
            if (entry - floor(entry)) > 0.0
                entry = num2str(entry,fmt);
            else
                entry = num2str(floor(entry));
            end
        end
        
        % Create textbox
        h(i,j) = annotation(fig,'textbox',[xcur ycur 0.05 0.05],...
            'String',entry,...
            'FontWeight','normal',...
            'FontSize',fontsize,...
            'FitBoxToText','on',...
            'LineStyle','none',...
            'Color',color);
        
        xcur = xcur + hspac;
    end
    xcur = hoff;    % Reset xcur
    ycur = ycur - vspac;
end

% Create a single line under the header column
if lineflag
    endboxpos = get(h(1,end), 'Position');
    lineend = endboxpos(1) + endboxpos(3);
    annotation(fig,'line', ...
        [hoff lineend],...
        [voff voff]);
end

