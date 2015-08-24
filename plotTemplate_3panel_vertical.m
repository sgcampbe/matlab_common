%-------------------------------------------------------------------------%
% Project Title
% Author: Stuart Campbell
% Date Started: 
%
% plotScript_.m
%
% This script is a template for a vertical, three-panel figure with shared
% y axes.
%-------------------------------------------------------------------------%

cls

%*********** Load File(s) Block ***********%



%********************************************%

% Common plot parameters
linestyle = 'r';
linewidth        = 1.5;

figure_height   = 5.5;
figure_width    = 5;

ax_x_off        = 0.25;
ax_x_dim        = 0.6;
ax_y_off        = 0.075;
ax_y_dim_a      = 0.33;
ax_y_dim_b      = 0.12;
ax_y_dim_c      = 0.38;

ax_y_panel_off_a  = 0.55;
ax_y_panel_off_b  = 0.417;

x_label_offset  = -0.10;
x_tick_label_vertical_offset = -0.1;

panel_label_x_offset  = -1.1;
panel_label_y_offset  = 0.0;
panel_label_font_size = 14;

y_label_offset = -0.25;


% General pre-processing/sorting of data


%*************%
% Make Figure %
%*************%

f = figure(1);
set(f, ...
    'Units', 'inches', ...
    'Color', 'w', ...
    'Position', [2 2 figure_width figure_height])

% Panel A
axh(1) = axes('Position', [ax_x_off ax_y_off+ax_y_panel_off_a ax_x_dim ax_y_dim_a]);

hold on
plot([1 1],    'LineWidth', linewidth)

improve_axes('axis_handle', axh(1), ...
             'y_tick_decimal_places', 0, ... 
             'x_tick_decimal_places', 0, ...
             'x_axis_label', 'Time (s)', ...
             'y_axis_label', 'Force\newline(kN m^{-2})', ...
             'y_label_offset', y_label_offset, ...
             'tick_font_size', 10, ...
             'font_name', 'Arial', ...
             'panel_label', 'A', ...
             'x_label_offset', x_label_offset, ...
             'panel_label_font_size', panel_label_font_size, ...
             'panel_label_x_offset', panel_label_x_offset, ...
             'panel_label_y_offset', panel_label_y_offset, ...
             'y_axis_only', true)

% Panel B
axh(2) = axes('Position', [ax_x_off ax_y_off+ax_y_panel_off_b ax_x_dim ax_y_dim_b]);

hold on
plot([1 1],    'LineWidth', linewidth)



improve_axes('axis_handle', axh(2), ...
             'y_tick_decimal_places', 1, ... 
             'x_tick_decimal_places', 0, ...
             'x_axis_label', '', ...
             'y_axis_label', 'Average\newlineSL (\mum)', ...
             'y_label_offset', y_label_offset, ...
             'tick_font_size', 10, ...
             'font_name', 'Arial', ...
             'panel_label', 'B', ...
             'x_label_offset', x_label_offset, ...
             'panel_label_font_size', panel_label_font_size, ...
             'panel_label_x_offset', panel_label_x_offset, ...
             'panel_label_y_offset', panel_label_y_offset, ...
             'y_axis_only', true)

% Panel C
axh(3) = axes('Position', [ax_x_off ax_y_off ax_x_dim ax_y_dim_c]);

hold on
plot([1 1],    'LineWidth', linewidth)




improve_axes('axis_handle', axh(3), ...
             'y_tick_decimal_places', 1, ... 
             'x_tick_decimal_places', 1, ...
             'x_axis_label', 'Time (s)', ...
             'y_axis_label', 'Normalized\newline SL & hSL', ...
             'y_label_offset', y_label_offset, ...
             'x_ticks', [14 30], ...
             'x_tick_label_positions', [14 30], ...
             'x_tick_labels', {'0.0', '16.0'}, ...
             'x_tick_label_vertical_offset', x_tick_label_vertical_offset, ...
             'tick_font_size', 10, ...
             'font_name', 'Arial', ...
             'panel_label', 'C', ...
             'x_label_offset', x_label_offset, ...
             'panel_label_font_size', panel_label_font_size, ...
             'panel_label_x_offset', panel_label_x_offset, ...
             'panel_label_y_offset', panel_label_y_offset)         

         
% Export Figure
parts = split(mfilename, '_');
fname = parts{2};
export_fig(['PubFigures/' fname] , '-eps')