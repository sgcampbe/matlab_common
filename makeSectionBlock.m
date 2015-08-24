function makeSectionBlock(title)
% This function takes the title string and creates a section block of the
% kind I (Stuart) like.  The section block is copied to the clipboard and
% echoed to the command line

mainstr = sprintf('%% %s %%', title);

border = '%';

for i = 1:length(mainstr) - 2
    border = [border '-'];
end
border = [border '%'];

blockstr = sprintf('%s\n%s\n%s\n', border, mainstr, border);

fprintf('%s', blockstr)

clipboard('copy', blockstr) % Copy to clipboard for pasting into code