function [dv, Tt, POS, DV, ALIGN] = DVcost_Tiss(kep, kept)

% DESCRIPTION :
% given two orbits, find the dv between them. The orbits are assumed to be
% coplanar (no dv is used to change the inclination).
%
% INPUT :
% - kep  : keplerian elements for the departing orbit
% - kept : keplerian elements for the arrival orbit
%
% OUTPUT :
% - dv : cost of a Hohmann-like transfer between two orbits (km/s)

mu = 132724487690;

a1 = kep(1);  e1 = kep(2);
a2 = kept(1); e2 = kept(2);

rp1 = a1*(1 - e1);
E1  = -mu/(2*a1);

rp2 = a2*(1 - e2);
E2  = -mu/(2*a2);

% find the initial orbit
a1  = -mu/(2*E1);
e1  = 1 - rp1/a1;
ra1 = a1*(1 + e1);

% periapsis/apoapsis velocity of initial orbit
vp1 = sqrt((2*mu)/(ra1 + rp1)*(ra1/rp1));
va1 = sqrt((2*mu)/(ra1 + rp1)*(rp1/ra1));

% find the arrival orbit
a2 = -mu/(2*E2);
e2  = 1 - rp2/a2;
ra2 = a2*(1 + e2);

% periapsis/apoapsis velocity of arrival orbit
vp2 = sqrt((2*mu)/(ra2 + rp2)*(ra2/rp2));
va2 = sqrt((2*mu)/(ra2 + rp2)*(rp2/ra2));

tol = 1e-2;

% no hyperbolic transfers considered
if (e1 >= 1) && (e2 ~= 1)
    dv    = 1e99;
    Tt    = 1e99;
    pos1  = 1e99;
    pos2  = 1e99;
    DV    = 1e99;
    ALIGN = 1e99;
elseif (e2 >= 1) && (e1 ~= 1)
    dv    = 1e99;
    Tt    = 1e99;
    pos1  = 1e99;
    pos2  = 1e99;
    DV    = 1e99;
    ALIGN = 1e99;
elseif (e1 >= 1) && (e2 >= 1)
    dv    = 1e99;
    Tt    = 1e99;
    pos1  = 1e99;
    pos2  = 1e99;
    DV    = 1e99;
    ALIGN = 1e99;
else

if (rp1<rp2) && (ra1<ra2)
    
    if abs(rp1/rp2 - 1) <= tol && abs(ra1/ra2 - 1) >= tol
        vpt = sqrt((2*mu)/(rp1 + ra2)*(ra2/rp1));
        dv  = vpt - vp1;
        DV  = dv;
        
        Tt  = 0;
        
        pos1 = 0;
        pos2 = [];
        
        ALIGN = +1;
        
    elseif abs(rp1/rp2 - 1) <= tol && abs(ra1/ra2 - 1) <= tol
        
        dv = 0;
        DV = dv;

        Tt = 0;
        
        pos1  = [];
        pos2  = [];
        ALIGN = [];
        
    elseif abs(rp1/rp2 - 1) >= tol && abs(ra1/ra2 - 1) <= tol
        
        vat = sqrt((2*mu)/(rp1 + ra2)*(rp1/ra2));
        dv  = va2 - vat;
        DV  = dv;
        
        Tt = 0;
        
        pos1 = pi;
        pos2 = [];
        
        ALIGN = +1;
        
    else
    
        vpt = sqrt((2*mu)/(rp1 + ra2)*(ra2/rp1));
        vat = sqrt((2*mu)/(rp1 + ra2)*(rp1/ra2));

        dv1 = vpt - vp1;
        dv2 = va2 - vat;

        dv = dv1 + dv2;
        DV = [dv1 dv2];

        at = 0.5*(rp1 + ra2);
        Tt = pi*sqrt(at^3/mu);

        pos1 = 0;
        pos2 = pos1 + pi;
        pos1 = wrapToPi(pos1);
        pos2 = wrapToPi(pos2);
        
        ALIGN = [+1 +1];
    
    end
    
elseif (rp1<rp2) && (ra1>ra2)
    
    if abs(rp1/rp2 - 1) <= tol && abs(ra2/ra1 - 1) >= tol
        
        vpt = sqrt((2*mu)/(rp2 + ra1)*(ra1/rp2));
        dv  = vpt - vp2;
        DV  = dv;
        
        Tt = 0;
        
        pos1 = 0;
        pos2 = [];
        
        ALIGN = -1;
        
    elseif abs(rp1/rp2 - 1) <= tol && abs(ra2/ra1 - 1) <= tol
        
        dv = 0;
        DV = dv;

        Tt = 0;
        
        pos1 = [];
        pos2 = [];
        
        ALIGN = [];
        
    elseif abs(rp1/rp2 - 1) >= tol && abs(ra2/ra1 - 1) <= tol
        
        vat = sqrt((2*mu)/(rp2 + ra1)*(rp2/ra1));
        dv  = vat - va1;
        DV  = dv;
        
        Tt = 0;
        
        pos1 = pi;
        pos2 = [];
        
        ALIGN = +1;
    else
    
        vpt = sqrt((2*mu)/(rp2 + ra1)*(ra1/rp2));
        vat = sqrt((2*mu)/(rp2 + ra1)*(rp2/ra1));

        dv1 = vat - va1;
        dv2 = vpt - vp2;

        dv = dv1 + dv2;
        DV = [dv1 dv2];

        at = 0.5*(rp2 + ra1);
        Tt = pi*sqrt(at^3/mu);
        
        pos1 = pi;
        pos2 = pos1 + pi;
        pos1 = wrapToPi(pos1);
        pos2 = wrapToPi(pos2);
        
        ALIGN = [+1 -1];
    
    end
    
elseif (rp1==rp2) && (ra1<ra2)
    
    dv = vp2 - vp1;
    DV = dv;
    
    Tt = 0;
    
    pos1 = 0;
    pos2 = [];
    
    ALIGN = +1;
    
elseif (rp1<rp2) && (ra1==ra2)
    
    dv = va2 - va1;
    DV = dv;
    
    Tt = 0;
    
    pos1 = pi;
    pos2 = [];
    
    ALIGN = +1;
    
elseif (rp1==rp2) && (ra1>ra2)
    
    dv = vp1 - vp2;
    DV = dv;
    
    Tt = 0;
    
    pos1 = 0;
    pos2 = [];
    
    ALIGN = -1;
    
elseif (rp1>rp2) && (ra1==ra2)
    
    dv = va1 - va2;
    DV = dv;
    
    Tt = 0;
    
    pos1 = pi;
    pos2 = [];
    
    ALIGN = +1;
    
elseif (rp1>rp2) && (ra1>ra2)
    
    if abs(rp2/rp1 - 1) <= tol && abs(ra2/ra1 - 1) >= tol 
        vpt = sqrt((2*mu)/(rp1 + ra2)*(ra2/rp1));
        dv  = vp1 - vpt;
        DV  = dv;
        
        Tt = 0;
        
        pos1 = 0;
        pos2 = [];
        
        ALIGN = -1;
        
    elseif abs(rp2/rp1 - 1) <= tol && abs(ra2/ra1 - 1) <= tol 
        
        dv = 0;
        DV = dv;

        Tt = 0;
        
        pos1 = [];
        pos2 = [];
        
        ALIGN = [];
        
    elseif abs(rp2/rp1 - 1) >= tol && abs(ra2/ra1 - 1) <= tol 
        vat = sqrt((2*mu)/(rp1 + ra2)*(rp1/ra2));
        dv  = vat - va2;
        DV  = dv;
        
        Tt = 0;
        
        pos1 = pi;
        pos2 = [];
        
        ALIGN = -1;
        
    else
    
        vpt = sqrt((2*mu)/(rp1 + ra2)*(ra2/rp1));
        vat = sqrt((2*mu)/(rp1 + ra2)*(rp1/ra2));

        dv1 = vp1 - vpt;
        dv2 = vat - va2;

        dv = dv1 + dv2;
        DV = [dv1 dv2];

        at = 0.5*(rp1 + ra2);
        Tt = pi*sqrt(at^3/mu);

        pos1 = pi;
        pos2 = pos1 + pi;
        pos1 = wrapToPi(pos1);
        pos2 = wrapToPi(pos2);
    
        ALIGN = [-1 -1];
        
    end
    
elseif (rp1>rp2) && (ra1<ra2)
    
    if abs(rp2/rp1 - 1) <= tol && abs(ra1/ra2 - 1) >= tol
        vpt = sqrt((2*mu)/(rp1 + ra2)*(ra2/rp1));
        dv  = vpt - vp1;
        DV = dv;
        
        Tt = 0;
        
        pos1 = 0;
        pos2 = [];
        
        ALIGN = +1;
        
    elseif abs(rp2/rp1 - 1) <= tol && abs(ra1/ra2 - 1) <= tol
        dv = 0;
        DV = dv;

        Tt = 0;
        
        pos1 = [];
        pos2 = [];
        
        ALIGN = [];

    elseif abs(rp2/rp1 - 1) >= tol && abs(ra1/ra2 - 1) <= tol
        vat = sqrt((2*mu)/(rp1 + ra2)*(rp1/ra2));
        dv = vat - va2;
        DV  = dv;
        
        Tt = 0;
        
        pos1 = pi;
        pos2 = [];
        
        ALIGN = -1;
        
    else
        
        vpt = sqrt((2*mu)/(rp1 + ra2)*(ra2/rp1));
        vat = sqrt((2*mu)/(rp1 + ra2)*(rp1/ra2));

        dv1 = vpt - vp1;
        dv2 = vat - va2;

        dv = dv1 + dv2;
        DV = [dv1 dv2];

        at = 0.5*(rp1 + ra2);
        Tt = pi*sqrt(at^3/mu);

        pos1 = 0;
        pos2 = pos1 + pi;
        pos1 = wrapToPi(pos1);
        pos2 = wrapToPi(pos2);
        
        ALIGN = [+1 -1];
    
    end
    
elseif (rp1==rp2) && (ra1==ra2)
    
    dv = 0;
    DV = dv;
    
    Tt = 0;
    
    pos1 = [];
    pos2 = [];
    
    ALIGN = [];
    
end

end

POS = [pos1 pos2];

end