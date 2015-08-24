function sse = sumsqerr(X)
% This function computes the sum of the squares of sample deviation from
% their sample means.  X may be a vector of sample values or a matrix of
% values.  If X is a matrix, the SSE is computed for each column and a row
% of sse values is returned.

[r c] = size(X);

if r == 1   % If this is just a vector, but not in row form yet, transpose!
    X = X';
end

mu    = mean(X);

muex  = repmat(mu, r, 1);

sqe   = (X - muex) .^ 2;

sse   = sum(sqe, 1);