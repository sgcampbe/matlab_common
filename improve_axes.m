function improve_axes(varargin)

% Check for non-current axes handle in args
% tp.axis_handle = -99;
% for i = 0:length(varargin)/2 - 1
%     tp.(varargin{2*i+1}) = varargin{2*i+2};
% end
% if tp.axis_handle ~= -99
%     axes(tp.axis_handle)    % Sets new handle to current for purposes of defaults inits (calling things like ylim, etc.)
%     params.axis_handle=tp.axis_handle;
% else
%     params.axis_handle=gca;
% end

% Set defaults
params.axis_handle=gca;
params.x_ticks=[];
params.y_ticks=[];
params.axis_line_width=1;
params.x_axis_label='X axis';
params.y_axis_label='Y axis';
params.label_font_size=12;
params.font_name='Arial';
params.x_limits=[];
params.x_tick_labels=[];
params.x_tick_label_positions=[];
params.x_tick_label_rotation=0;
params.y_tick_label_rotation=0;
params.y_tick_label_positions=[];
params.y_tick_labels=[];
params.x_tick_decimal_places=3;
params.y_tick_decimal_places=3;
params.tick_font_size=12;
params.x_log_mode=0;
params.y_log_mode=0;
params.x_axis_colour=[0 0 0];
params.x_axis_only=0;
params.y_axis_only=0;
params.x_tick_rotation=0;
params.redraw_axes=1;
params.x_axis_offset=-0.1;
params.x_label_offset=-0.25;
params.y_axis_offset=-0.05;
params.y_label_offset=-0.25;
params.axis_color='k';
params.y_tick_label_horizontal_offset=-0.04;
params.y_tick_length=0.025;
params.x_tick_label_vertical_offset=-0.05;
params.x_tick_length=[];
params.x_tick_dir=-1;
params.x_ticks_off=0;
params.y_label_rotation=0;
params.title='';
params.title_y_offset=1.05;
params.title_font_size=12;
params.title_font_weight='normal';
params.title_font_angle='normal';
params.title_text_interpreter='none';
params.no_x_clipping=0;
params.panel_label='';
params.panel_label_x_offset=0;
params.panel_label_y_offset=0;
params.panel_label_font_size=12;
params.font_name='Helvetica';

% Update
params=parse_pv_pairs(params,varargin);

% Set current axes to specified axes handle
axes(params.axis_handle)
% Set the limits if they are not specified
if (isempty(params.x_ticks))
    params.x_ticks=xlim;
end
if (isempty(params.y_ticks))
    params.y_ticks=ylim;
end

% Trim the present data to fall in the specified xlim - could also be
% implemented with ylims
lh = findall(params.axis_handle, 'Type', 'line');
for i = 1:length(lh)
    xdata = get(lh(i), 'XData');
    ydata = get(lh(i), 'YData');
    lims  = xlim;
    inrange = (xdata >= lims(1)) & (xdata <= lims(2));
    set(lh(i), 'XData', xdata(inrange));
    set(lh(i), 'YData', ydata(inrange));
end


% Set the tick_lengths which are required for setting the y_axis limit
y_tick_length=-params.y_tick_length*(params.x_ticks(end)-params.x_ticks(1));

if (isempty(params.x_tick_length))
    x_tick_length=-1*params.x_tick_dir* ...
        (y_tick_length/(params.x_ticks(end)-params.x_ticks(1))) *  ...
        (params.y_ticks(end)-params.y_ticks(1));
else
    x_tick_length=-1*params.x_tick_dir*params.x_tick_length* ...
        (params.y_ticks(end)-params.y_ticks(1));
end

% Check axis polarity
if (strcmp(get(params.axis_handle,'YDir'),'reverse'))
    y_axis_polarity=-1;
else
    y_axis_polarity=1;
end

% Calculate the axis locations
if (~params.x_log_mode)
    y_axis_x_location=params.x_ticks(1)+ ...
        params.y_axis_offset*(params.x_ticks(end)-params.x_ticks(1));
else
    % Log mode
    y_axis_x_location = params.x_ticks(1);
end

if (y_axis_polarity==1)
    x_axis_y_location=params.y_ticks(1)+ ...
        params.x_axis_offset*(params.y_ticks(end)-params.y_ticks(1));
else
    x_axis_y_location=params.y_ticks(end) + ...
        params.x_axis_offset*(params.y_ticks(end)-params.y_ticks(1));
end

% Now clip the axis
if (params.x_ticks(1)<params.x_ticks(end))
    xlim([min([params.x_ticks(1) y_axis_x_location])+min([0 y_tick_length]) ...
        params.x_ticks(end)]);
else
    xlim([params.x_ticks(end) ...
        max([params.x_ticks(1) y_axis_x_location])+max([0 y_tick_length])]);
end


if (y_axis_polarity==1)
    ylim([min([params.y_ticks(1) x_axis_y_location])+min([0 x_tick_length]) ...
        params.y_ticks(end)]);
else
    ylim([params.y_ticks(1) max([params.y_ticks(end) x_axis_y_location])]);
end

% Adjust the axis limits to prevent clipping issues
y_limits=ylim;
padding=0.01*diff(y_limits);
y_limits(1)=y_limits(1)-padding;
y_limits(2)=y_limits(2)+padding;
ylim(y_limits);
x_limits=xlim;
padding=0.05*diff(x_limits);
x_limits(1)=x_limits(1)-padding;
x_limits(2)=x_limits(2)+padding;
xlim(x_limits);

% Wipe out the original axes
set(params.axis_handle,'Visible','off');

if (~params.x_axis_only)

    % Draw y axis
    line(y_axis_x_location*ones(1,2), ...
        [params.y_ticks(1) params.y_ticks(end)], ...
        'Color',params.axis_color, ...
        'LineWidth',params.axis_line_width);


    % Draw y ticks and labels
    if (length(params.y_tick_labels)==0)
        % Automatic ticks
        for tick_counter=1:length(params.y_ticks)
            if (params.x_ticks(1)<params.x_ticks(end))
                tick_label_horizontal_offset=params.y_tick_label_horizontal_offset* ...
                    diff(xlim);
            else
                tick_label_horizontal_offset=params.y_tick_label_horizontal_offset* ...
                    -diff(xlim);
            end
            if (~params.y_log_mode)
                % Linear scaling

                % Tick labels
                tick_string=print_number_to_specified_decimal_places( ...
                   params.y_ticks(tick_counter),params.y_tick_decimal_places);

                text(y_axis_x_location+tick_label_horizontal_offset, ...
                    params.y_ticks(tick_counter),tick_string, ...
                    'HorizontalAlignment','right', ...
                    'FontName',params.font_name, ...
                    'FontSize',params.tick_font_size, ...
                    'Color',params.axis_color);

                % Ticks
                line(y_axis_x_location+[0 y_tick_length], ...
                    params.y_ticks(tick_counter)*ones(1,2), ...
                    'Color',params.axis_color, ...
                    'LineWidth',params.axis_line_width);
            end
        end
    else

        % User specified ticks
        if (params.x_ticks(1)<params.x_ticks(end))
            tick_label_horizontal_offset=params.y_tick_label_horizontal_offset* ...
                diff(xlim);
        else
            tick_label_horizontal_offset=params.y_tick_label_horizontal_offset* ...
                -diff(xlim);
        end

         % Set alignment
        if (params.y_tick_label_rotation==0)
            hor_align='right';
            ver_align='middle';
        else
            hor_align='right';
            ver_align='top';
        end

        for tick_counter=1:length(params.y_tick_labels)
            text(y_axis_x_location+tick_label_horizontal_offset, ...
                params.y_tick_label_positions(tick_counter), ...
                params.y_tick_labels(tick_counter), ...
                'FontName',params.font_name, ...
                'FontSize',params.tick_font_size, ...
                'Color',params.axis_color, ...
                'Rotation',params.x_tick_label_rotation, ...
                'HorizontalAlignment',hor_align, ...
                'VerticalAlignment',ver_align);

            line(y_axis_x_location+[0 y_tick_length], ...
                params.y_tick_label_positions(tick_counter)*ones(1,2), ...
                y_axis_x_location+[0 y_tick_length], ...
                'Color',params.axis_color, ...
                'LineWidth',params.axis_line_width, ...
                'Clipping','off');
        end
    end

    % Draw y label
    if (params.x_ticks(1)<params.x_ticks(end))
        offset=params.y_label_offset*diff(xlim);
    else
        offset=-params.y_label_offset*diff(xlim);
    end
    text(y_axis_x_location+offset, ...
        mean([params.y_ticks(1) params.y_ticks(end)]), ...
        params.y_axis_label, ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontName',params.font_name, ...
        'FontSize',params.label_font_size, ...
        'Color',params.axis_color, ...
        'Rotation',params.y_label_rotation);
end

% Now the x-axis

if params.x_log_mode
    set(params.axis_handle, 'XScale', 'log')
end


if (~params.y_axis_only)
    % Draw x axis
    line([params.x_ticks(1) params.x_ticks(end)], ...
        x_axis_y_location*ones(1,2), ...
        'Color',params.axis_color, ...
        'LineWidth',params.axis_line_width);

    % X-tick labels and ticks
    tick_label_vertical_offset=params.x_tick_label_vertical_offset* ...
        (params.y_ticks(end)-params.y_ticks(1));

    if (~params.x_ticks_off)
        if (length(params.x_tick_labels)==0)
            % Draw automatic x ticks and labels
            for tick_counter=1:length(params.x_ticks)

                if true %(~params.x_log_mode)
                    % Linear scaling

                    % Tick labels
                    tick_string=print_number_to_specified_decimal_places( ...
                       params.x_ticks(tick_counter),params.x_tick_decimal_places);

                    text(params.x_ticks(tick_counter), ...
                        x_axis_y_location+tick_label_vertical_offset, ...
                        tick_string, ...
                        'HorizontalAlignment','center', ...
                        'VerticalAlignment','top', ...
                        'FontName',params.font_name, ...
                        'FontSize',params.tick_font_size, ...
                        'Color',params.axis_color, ...
                        'Rotation',params.x_tick_label_rotation);

                    % Ticks
                    line(params.x_ticks(tick_counter)*ones(1,2), ...
                        x_axis_y_location+[0 x_tick_length], ...
                        'Color',params.axis_color, ...
                        'LineWidth',params.axis_line_width, ...
                        'Clipping','off');
                    
                end
            end
        else
            % User-specified tick labels and positions

            % Set alignment
            if (params.x_tick_label_rotation==0)
                hor_align='center';
                ver_align='middle';
            else
                hor_align='right';
                ver_align='top';
            end

            for tick_counter=1:length(params.x_tick_labels)
                text(params.x_tick_label_positions(tick_counter), ...
                    x_axis_y_location+tick_label_vertical_offset, ...
                    params.x_tick_labels(tick_counter), ...
                    'FontName',params.font_name, ...
                    'FontSize',params.tick_font_size, ...
                    'Color',params.axis_color, ...
                    'Rotation',params.x_tick_label_rotation, ...
                    'HorizontalAlignment',hor_align, ...
                    'VerticalAlignment',ver_align);

                line(params.x_tick_label_positions(tick_counter)*ones(1,2), ...
                    x_axis_y_location+[0 x_tick_length], ...
                    'Color',params.axis_color, ...
                    'LineWidth',params.axis_line_width, ...
                    'Clipping','off');
            end
        end
    end
    
    % Draw x label
    text(mean([params.x_ticks(1) params.x_ticks(end)]), ...
        x_axis_y_location+params.x_label_offset*diff(ylim), ...
        params.x_axis_label, ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontName',params.font_name, ...
        'FontSize',params.label_font_size, ...
        'Color',params.axis_color);
end

% Draw title
text(mean([params.x_ticks(1) params.x_ticks(end)]), ...
    x_axis_y_location + (params.title_y_offset *diff(ylim)), ...
    params.title, ...
    'VerticalAlignment','middle', ...
    'HorizontalAlignment','center', ...
    'FontName',params.font_name, ...
    'FontSize',params.title_font_size, ...
    'Interpreter',params.title_text_interpreter, ...
    'FontWeight',params.title_font_weight, ...
    'FontAngle',params.title_font_angle, ...
    'Color',params.axis_color);

% Draw label

% Find the position of the subplot
h=subplot(params.axis_handle);
original_units=get(params.axis_handle,'Units');

set(h,'Units','inches');
pos_vector=get(h,'Position');
set(h,'Units',original_units);

lhs=pos_vector(1);
top=pos_vector(4);

x_pos=params.panel_label_x_offset;
y_pos=top+params.panel_label_y_offset;

% Now draw it
text(x_pos,y_pos,params.panel_label, ...
    'Units','inches', ...
    'FontSize',params.panel_label_font_size, ...
    'FontWeight','bold', ...
    'Units','inches', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','middle', ...
    'FontName',params.font_name ...
    );
text('Units','data');
  
