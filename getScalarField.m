% This function extracts scalars from multiple entries of a single field in
% a multi-D struct

function vec = getScalarField(data, field)

num = length(data);
vec = zeros(num,1);

for i = 1:num
    vec(i) = data(i).(field);
end

return