function [grid_out] = generate_grid(planets, V_inf_lvls)
%generate_grid.m - Generate grid
%
%DESCRIPTION:
%Generates the list of all intersections of the contours. Stores the planet
%ID, Vinf (km/s) and alpha of the contour, for boths contours.

%INPUTS
%-planets:
%   List of planets ID taken into account
%-V_inf_lvls (km/s):
%   List of infinity velocities taken into account
%
%OUTPUTS
%-grid_out:
%   Matrix containing all the informations of the intersections of the
%   contours on the Tisserand graph.
%
%AUTHOR
%Hadrien AFSA, Andrea BELLOME
%
%--------------------------------------------------------------------------

    Grid =[];

    for pl=1:length(planets)-1
        %Planet considered for this loop
        pl_1 = planets(pl);

        %Other planets to check intersection with
        other_planets=planets(pl+1:end);

        for v=1:length(V_inf_lvls)
            %V_inf of the contour
            v_inf=V_inf_lvls(v);

            for o_pl=1:length(other_planets)
                pl_2 = other_planets(o_pl);

                %Check intersections of the v_inf contour of planet pl_1, 
                %with all contours of planet o_pl          
                inter=checkIntersection(v_inf,pl_1,V_inf_lvls,pl_2);

                Grid= [Grid; inter];
            end

        end
    end
    
    grid_out=Grid;
end

