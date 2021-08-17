function [inter] = check_intersectionGrid(pl1, vinf1, pl2, vinf2,Grid)
% Find the information of the intersection of pl1 with vinf1 and pl2 with
% vinf2, from the Grid
    
    if pl1<pl2
        ind = Grid(:,1)==pl1 & Grid(:,4)==pl2 & Grid(:,3)==vinf1 & Grid(:,6)==vinf2;
    elseif pl2<pl1
        ind = Grid(:,1)==pl2 & Grid(:,4)==pl1 & Grid(:,3)==vinf2 & Grid(:,6)==vinf1;
    end
    
    inter=Grid(ind,:);
    
end

