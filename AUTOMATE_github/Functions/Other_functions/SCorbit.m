function [rasc, rpsc] = SCorbit(alpha, vInf, vPL, rPL)

asc  = 1./(1 - (vInf./vPL).^2 - 2.*(vInf./vPL).*cos(alpha));
esc  = (1 - 1./asc.*(0.5.*(3 - 1./asc - (vInf./vPL).^2)).^2).^(1/2);

asc  = rPL.*asc;

rpsc = asc.*(1 - esc);
rasc = asc.*(1 + esc);

end