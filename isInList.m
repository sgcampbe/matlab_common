%***********************************************************************%
%   Markov model of thin filament activation                            %
%   File:   isInList                                                    %
%   Author: Stuart Campbell                                             %
%   Date Started: 8/29/2008                                             %
%   Description: This function checks to see if the input string matches
%   any entries in the input cell array (list).  Returns TRUE if it is,
%   FALSE if it isn't.
%***********************************************************************%

function found = isInList(string, list)

found = sum(strcmp(string, list));

return