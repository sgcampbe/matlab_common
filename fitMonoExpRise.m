%***********************************************************************%
%   General Purpose Code                                                %
%   File:   fitMonoExpRise.m                                            %
%   Date Started: 12/14/2009                                            %
%   Author: Stuart Campbell                                             %
%                                                                       %
%   Description: This function takes a vector of time points and 
%   corresponding function values and fits them using a simple exponential 
%   decay function.  It returns 1/tau, which happens to be ktr.
%***********************************************************************%

function [k_tr Fss] = fitMonoExpRise(t, F, Fss)

[r, c] = size(F);
if c > r % Absurd backwards compatibility issue...
    F = F';
end


ktr_0 = [0.001, Fss];         % [1/ms]

ktr = lsqnonlin(@(ktr) ktr_func(ktr, t, F), ktr_0);

k_tr = ktr(1);
Fss = ktr(2);

return


function diff = ktr_func(ktr, t, F)
tau = 1/ktr(1);
Fss = ktr(2);
diff = F' - Fss * makeMonoExpRise(t,tau);
