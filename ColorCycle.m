classdef ColorCycle < handle
    % This class cycles through the standard MATLAB color scheme.
    properties
        colors    = [0 0 1;0 0.5 0;1 0 0;0 0.75 0.75;0.75 0 0.75;0.75 0.75 0;0.25 0.25 0.25]
        i_color   = 1;    % Keeps track of which color you're on
        numcolors = 7;
    end
    
    methods
        function CC = ColorCycle()
            
        end
        
        function color = getColor( CC )
            color = CC.colors(CC.i_color, :);
            if ~mod(CC.i_color, CC.numcolors)   % Check for > numcolors index
                CC.i_color = 1; % Reset
            else
                CC.i_color = CC.i_color + 1;    % Increment
            end
        end
    end
end
