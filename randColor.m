% Creates a random color vector [R, G, B]
% Tries to keep the intensity high enough to be seen by various tricks.
% (And avoids YELLOW!)

function color = randColor()

color = zeros(1,3);

brighttone = rand;

if brighttone > 0.5
    color(round(2*rand)+1) = 1;
else
    howmany = round(2*rand) + 1;    % How many to set to 0.5
    if howmany == 1
        color(round(2*rand)+1) = 0.5;
    elseif howmany ==2
        whichcombo = round(2*rand)+1;
        switch(whichcombo)
            case 1
                dex = [1 2];
            case 2
                dex = [1 3];
            case 3
                dex = [2 3];
        end
        color(dex) = 0.5;   % Set the chosen two to 0.5
    else    % Means all 3 will be set to 0.5
        color = [0.5 0.5 0.5];
    end
end

return