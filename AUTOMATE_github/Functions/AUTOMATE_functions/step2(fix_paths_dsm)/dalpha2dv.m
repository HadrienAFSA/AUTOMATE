function [deltaV] = dalpha2dv(id_pl, v_inf, alpha1, alpha2)
%dalpha2dv.m - Delta alpha to dv
%
%DESCRIPTION:
%Computes the dv required to go from alpha1 to alpha2 on a contour.
%
%INPUTS
%-id_pl:
%   Planet ID of the contour.
%-v_inf (km/s):
%   Infinity velocity of the contour.
%-alpha1 (rad):
%   Starting alpha.
%-alpha2 (rad):
%   Arrival alpha.
%
%OUTPUTS
%-deltaV (km/s):
%   Delta V used to go from alpha1 to alpha2.
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------
    [ra1, rp1]=alphaVinf2raRp(alpha1,v_inf,id_pl);
    [ra2, rp2]=alphaVinf2raRp(alpha2,v_inf,id_pl);

    a1 = (rp1 + ra1)/2;
    e1 = 1 - (rp1)/a1;

    a2 = (rp2 + ra2)/2;
    e2 = 1 - (rp2)/a2;

    deltaV=DVcost_Tiss([a1 e1 0 0 0 0], [a2 e2 0 0 0 0]);
end

