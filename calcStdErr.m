function stderr = calcStdErr(data)
% Calculate the standard error of a vector of numbers
% If data is a matrix, the standard error of each column is returned in a
% row vector.

[r c] = size(data);

multrows = (r > 1);
multcols = (c > 1);

if multrows && multcols     % Must be a matrix
    N = r;
else
    N = max([r c]);         % Must be a vector; take the biggest one as N
end

stderr = std(data) / sqrt(N);