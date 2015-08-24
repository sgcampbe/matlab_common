function axh = multiSubplot(rows, cols)
% This function creates and returns handles for rows by cols subplots.  The
% returned matrix axh holds axis handles, indexed intuitively by row and
% column (as opposed to the serial numbering used by subplot).

axh = zeros(rows, cols);
ctr = 1;
for r = 1:rows
    for c = 1:cols
        axh(r,c) = subplot(rows, cols, ctr);
        ctr = ctr + 1;
    end
end

