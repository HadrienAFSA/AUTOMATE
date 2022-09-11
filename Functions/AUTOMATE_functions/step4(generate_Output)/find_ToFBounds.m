function [min_bound,max_bound] = find_ToFBounds(pl1,pl2)
%find_ToFBounds.m - Find ToF bounds
%
%DESCRIPTION:
% Finds the maximum authorized time of flight between planets (see AUTOMATE report)
%
%INPUTS
%-pl1, pl2::
%   ID of the planets.
%
%OUTPUTS
%-min_bound (days):
%   Minimum allowed time of flight for the trajectory from pl1 to pl2.
%   Lower ToF would be impossible.
%-max_bound (days):
%   Maximum allowed time of flight for the trajectory from pl1 to pl2.
%   Higher ToF would be unecessary (multi-revolutions are not allowed).
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    
if pl1==5 || pl1==6 || pl2==5 || pl2==6
        min_bound = 500;
        max_bound = 2500;
    else
        min_bound=50;
        if (pl1==2 && pl2==3)||(pl1==3 && pl2==2)
            max_bound=750;
        else
            max_bound=850;
        end
    end
end

