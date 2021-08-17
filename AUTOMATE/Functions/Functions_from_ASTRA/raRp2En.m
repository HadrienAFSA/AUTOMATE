function [E] = raRp2En(ra, rp)

% on a Tisserand map, from (ra,rp) find the energy of the orbit

mu = 132724487690;
a  = 0.5*(ra + rp);
E  = -mu/(2*a);

end