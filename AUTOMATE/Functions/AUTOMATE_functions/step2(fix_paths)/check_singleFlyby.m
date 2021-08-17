function [bool] = check_singleFlyby(current_alpha, alpha_goal, id_pl, v_inf)
% Checks if a single flyby is enough to reach alpha_goal from current_alpha
% on the contour.

    [mu,radius]=planetConstants(id_pl);
    [hmin,~]=maxmin_flybyAltitude(id_pl);
    %current_alpha
    %alpha_goal
    max_e = 1 + ((radius+hmin)*v_inf^2)/mu;
    max_alpha = 2*asin(1/max_e);
    %abs(alpha_goal-current_alpha)

    if abs(alpha_goal-current_alpha) < max_alpha
        %Single flyby possible
        bool=true;
    else
        %Single flyby impossible
        bool=false;
    end
    %disp("########################");
end

