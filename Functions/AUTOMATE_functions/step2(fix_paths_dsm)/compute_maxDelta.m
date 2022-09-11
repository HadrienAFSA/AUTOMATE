function [max_delta] = compute_maxDelta(id_pl,v_inf)
%compute_maxDelta.m - Compute max Delta
%
%DESCRIPTION:
%Computes the maximum deflection angle possible for a contour. See report
%or paper for more info.
%
%INPUTS
%-id_pl:
%   Planet ID of the contour.
%-v_inf (km/s):
%   Infinity velocity of the contour.
%
%OUTPUTS
%-max_delta (rad):
%   Maximum deflection angle possible given the minimum viable altitude
%   for a planet and the infinity velocity of the flyby.
%
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    [mu,radius]=planetConstants(id_pl);
    [hmin,~]=maxmin_flybyAltitude(id_pl);

    max_e = 1 + ((radius+hmin)*v_inf^2)/mu;
    max_delta = 2*asin(1/max_e);
end

