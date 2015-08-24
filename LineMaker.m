classdef LineMaker < matlab.mixin.Copyable
    % LINEMAKER An object with all necessary information to plot a line
    % There is no obvious way to create a line object without actually
    % plotting it as well.  In some cases, it may be desirable to specify
    % the characteristics of a line programmatically, then pass it to
    % another entity to plot when the time is right (or when the
    % destination axes have actually been determined). 
    % The contstructor is designed to behave somewhat similarly to the
    % built-in line command:
    % lh = LineMaker(xdata, ydata, 'Color', 'r', 'LineStyle', ':')
    % Anything after xdata and ydata is placed in the property 'params'.
    % These properties will be transferred straight over to the line
    % instance when it is plotted, so all property names and values have to
    % be valid LineSpec param/val pairs.
    % xdata and ydata can be omitted from the constructor call, and
    % included with pv pairs with other options ('XData', xdata, etc), or even omitted all
    % together (you can add them at a later point).
    % To actually plot the specified line, invoke the 'draw' class method.
    % If no axes handle is specified, it uses gca.
    % Use the method 'updateProps' to pass in more LineSpec properties.
    % These will replace or add to those already there.
    
    properties
        params = struct(...     % Struct where fields are LineSpec property names and field contents are LineSpec property values
                        'Color',           [0 0 0], ...
                        'LineStyle',       '-', ...
                        'LineWidth',       1, ...
                        'Marker',          'none', ...
                        'MarkerSize',      6, ...
                        'MarkerEdgeColor', 'auto', ...
                        'MarkerFaceColor', 'none', ...
                        'XData',           [], ...
                        'YData',           [], ...
                        'ZData',           [])
    end
    
    
    methods
        
        %*******************%
        % Class Constructor %
        %*******************%
        
        function LM = LineMaker(varargin)
            if nargin < 2   % Not enough args
                return % Assume an empty one is desired (to preallocate a list or something)
            elseif nargin >= 2  
                if isfloat(varargin{1}) && isfloat(varargin{2}) % First two args had better be vectors, or they're all params
                    LM.params.XData = varargin{1};
                    LM.params.YData = varargin{2};
                    LM.updateProps(varargin{3:end});            % parse pv pairs and replace over other entries
                elseif ~ischar(varargin{1})                     % Had better be a prop name string (not a number)
                    error('First two args must be numerical!')
                else                                            % All args are prop/val pairs
                    LM.updateProps(varargin{:})
                end
            end
            
        end
        
        %-----------------------------------------------------------------%
        function updateProps( LM, varargin )
            % This method extracts pv pairs passed in and adds/updates pv
            % pairs existing in LM.params
            LM.params = parse_pv_pairs(LM.params, varargin); % parse pv pairs and replace over other entries
        end
        
        %-----------------------------------------------------------------%
        function lh = draw( LM, varargin)
            % This method will actually create the line specified by the
            % class instance.  An axis handle can be provided which will be 
            % used as the line parent.  If none are provided, gca is used 
            % to furnish parent axes.
            % NOTE: Can also accept an array of LM instances so that
            % multiple plots can be drawn simultaneously
            
            numlines = length(LM);
            
            if nargin > 1
                axh = varargin{1};
            else
                axh = gca;
            end
            
            for i = 1:numlines
                % Create line(s)
                lh = line('Parent', axh);

                % Update line properties
                propnames = fieldnames(LM(i).params);
                numprops = length(propnames);
                for p = 1:numprops
                    set(lh, propnames{p}, LM(i).params.(propnames{p}))
                end
            end
        end
        
        
        %-----------------------------------------------------------------%
        %-----------------------------------------------------------------%
        %-----------------------------------------------------------------%
        %-----------------------------------------------------------------%
        %-----------------------------------------------------------------%
        
        % END METHODS %
    end
    
    
    % END CLASS % 
end