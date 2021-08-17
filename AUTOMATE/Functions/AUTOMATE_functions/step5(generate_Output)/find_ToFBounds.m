function [min_bound,max_bound] = find_ToFBounds(pl1,pl2)
% Finds the limits of ToF (see AUTOMATE report)
    
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

