function rand_indices = getRandomSamples(N_population, n_sample)

% getRandomSamples.m
% This function will return a list of n_sample vector indices which are
% randomly chosen on the interval [0 N_population].  If n_sample >
% N_population, the function still returns n_sample indices, so use with
% caution.

if n_sample > N_population
    rand_indices = randi(N_population,1,n_sample);
else
    [~, I] = sort(rand(1,N_population));
    rand_indices = I(1:n_sample);
end

return

