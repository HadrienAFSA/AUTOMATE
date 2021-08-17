function [ra, rp] = alphaVinf2raRp(alpha, vinf, idPL)

% on a Tisserand plot, this function computes (ra,rp) from (alpha,vinf) 
% only valid for elliptical orbits

% central body is SUN
mu = 132724487690;

% moon properties
[~, ~, rPL] = planetConstants(idPL);
vPL = sqrt(mu/rPL);

% find (ra,rp)
[ra, rp] = SCorbit(alpha, vinf, vPL, rPL);

end