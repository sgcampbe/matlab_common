function vec = graycolor(how_light_0_to_1)
% This function makes a color vector for gray shades.  The input arg, a
% number from zero to one, determines how light a shade of gray it is, 0
% being black, 1 being white.

if how_light_0_to_1 < 0
    how_light_0_to_1 = 0;
elseif how_light_0_to_1 > 1
    how_light_0_to_1 = 1;
end

vec = how_light_0_to_1 * ones(1,3);


        