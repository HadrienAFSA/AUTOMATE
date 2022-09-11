function [inter] = check_intersectionGrid(pl1, vinf1, pl2, vinf2,Grid)
%check_intersectionGrid.m - Check intersection grid
%
%DESCRIPTION:
%Find the information of the intersection of pl1 with vinf1 and pl2 with
%vinf2, from Grid

%INPUTS
%-pl1:
%   Planet 1 ID
%-vinf1 (km/s):
%   Planet 1 infinity velocity
%-pl2:
%   Planet 2 ID
%-vinf2 (km/s):
%   Planet 2 infinity velocity
%-Grid:
%   Grid generated by the generate_grid.m function.
%
%OUTPUTS
%-inter [6]:
%   Return the line from Grid that corresponds to the input intersection. 
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------
    
    if pl1<pl2
        ind = Grid(:,1)==pl1 & Grid(:,4)==pl2 & Grid(:,3)==vinf1 & Grid(:,6)==vinf2;
    elseif pl2<pl1
        ind = Grid(:,1)==pl2 & Grid(:,4)==pl1 & Grid(:,3)==vinf2 & Grid(:,6)==vinf1;
    end
    
    inter=Grid(ind,:);
    
end
