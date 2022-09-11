function [bool,dv] = check_singleFlyby_dsm(current_alpha, alpha_goal, id_pl, v_inf, max_dv_per_DSM)
%check_singleFlyby_dsm.m - Check single flyby
%
%DESCRIPTION:
%Check if a single flyby is enough to go from current_alpha to alpha_goal
%on the contour. Computes the delta V required if a small gap is met.
%
%INPUTS
%-current_alpha (rad):
%   Current pump angle on the contour.
%-alpha_goal (rad):
%   Objective alpha on the contour.
%-id_pl:
%   Planet ID of the contour.
%-v_inf (km/s):
%   Infinity velocity of the contour.
%-max_dv_per_DSM (km/s):
%   Maximum delta V allowed by DSM.
%
%OUTPUTS
%-bool:
%   Boolean. 0 if the transfer is impossible, 1 if it is.
%-dv (km/s):
%   Delta V used to fix the gap (if needed).
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------


    max_alpha = compute_maxDelta(id_pl,v_inf);

    if abs(alpha_goal-current_alpha) < max_alpha
        %Single flyby possible
        bool=true;
        dv=NaN;
    else
        %Single flyby impossible
        bool=false;

        % Checks if a DSM can allow to reach next flyby
        if max_dv_per_DSM>0
            if current_alpha<alpha_goal % goes to the left on the contour
                dv=dalpha2dv(id_pl, v_inf, current_alpha+max_alpha, alpha_goal);
            else % goes to the right on the contour
                dv=dalpha2dv(id_pl, v_inf, current_alpha-max_alpha, alpha_goal);
            end
        else
            dv=NaN;
        end
    end
    %disp("########################");
end

