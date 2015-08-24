function [color alpha] = RGBA2MatColor(rgba_str)
% This function converts an 'rgba' color specification string, such as
% those used in inkscape, into a MATLAB-compatible color vector and
% optionally returns an alpha value as well.  

r     = hex2dec(rgba_str(1:2)) / 255;
g     = hex2dec(rgba_str(3:4)) / 255;
b     = hex2dec(rgba_str(5:6)) / 255;
alpha = hex2dec(rgba_str(7:8)) / 255;

color = [r g b];
