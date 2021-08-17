function [rp, ra] = En2raRp(E, pl, vinf)

% on the Tisserand map, from the energy of the orbit, find the (ra,rp)
% w.r.t. the given planet and infinity velocity.

mu = 132724487690;

% planet properties
[~, ~, rPL] = planetConstants(pl);
vPL = sqrt(mu/rPL);

a    = -mu/(2*E);
v    = sqrt(mu*(2/rPL - 1/a));
cosk = (v^2 + vPL^2 - vinf^2)/(2*v*vPL);
h    = rPL*v*cosk;

e    = sqrt(1 - h^2/(mu*a));
rp   = a*(1 - e);
ra   = a*(1 + e);

end