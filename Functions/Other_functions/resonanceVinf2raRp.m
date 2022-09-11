function [ra, rp, alpha, vinf, asc, Tsc] = resonanceVinf2raRp(N, M, vinf, idPL)

% on a Tisserand plot, this function computes (ra,rp) and (alpha,vinf)
% coordinates from a give N:M resonance for a given moon
% only valid for elliptical orbits

% central body is SATURN
mu = 132724487690;

% moon properties
[~, ~, rPL] = planetConstants(idPL);
vPL = sqrt(mu/rPL);
tPL = 2*pi*sqrt(rPL^3/mu);

Tsc = N/M*tPL; % find the N:M resonance
asc = (mu*(Tsc/(2*pi))^2)^(1/3)/rPL; % SC semi-major axis (non-dimensional)

% compute the corresponding alpha
alpha = acos(vPL/(2*vinf)*(1 - (vinf/vPL)^2 - 1/asc));
if isreal(alpha)
    alpha    = fast_wrapToPi(alpha);
    [ra, rp] = alphaVinf2raRp(alpha, vinf, idPL);
else
    % no resonance available for the given vinf
    alpha = NaN;
    ra    = NaN; 
    rp    = NaN;
end

end