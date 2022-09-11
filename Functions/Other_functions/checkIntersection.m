function [INTER] = checkIntersection(vinfpl1, pl1, vinflevels, pl2)

% DESCRIPTION :
% this function checks and computes intersections between two different
% infinity velocity contours on the Tisserand map.
%
% INPUT : 
% vinfpl1    : infinity velocity at the first planet (km/s)
% vinflevels : infinity velocity levels at next planet to scan for
%              intersections (km/s)
% pl1        : departing planet ID
% pl2        : arrival planet ID
% 
% OUTPUT : 
% INTER : matrix containing the intersections:
%         INTER(:,1) : departing planet
%         INTER(:,2) : departing alpha angle (rad)
%         INTER(:,3) : departing infinity velocity (km/s)
%         INTER(:,4) : arrival planet
%         INTER(:,5) : arrival alpha angle (rad)
%         INTER(:,6) : arrival infinity velocity (km/s)
%
% -------------------------------------------------------------------------

% --> generate the contour for the first planet
[rascCONT_pl1, rpscCONT_pl1] = generateContours(pl1, vinfpl1);

% --> compute intersections between two planets
INTER    = zeros(length(vinflevels),6);
indinter = 1;
for indvinf = 1:length(vinflevels)
    
    vinfpl2 = vinflevels(indvinf);
    
    [rascCONT_pl2, rpscCONT_pl2] = generateContours(pl2, vinfpl2);              % --> generate contours for the arrival planet
    P = InterX([rascCONT_pl1'; rpscCONT_pl1'], [rascCONT_pl2'; rpscCONT_pl2']); % --> provide guess for the intersection
    if ~isempty(P)                                                              % --> then there is an intersection
        E0 = raRp2En(P(1), P(2));                                               % --> provide guess for the intersection 
        E  = fzero(@(E) find_Intersection(E, pl1, pl2, vinfpl1, vinfpl2), E0);  % --> find intersection (rp)
        [rp, ra]   = En2raRp(E, pl2, vinfpl2);                                  % --> find intersection (ra)
        [alphapl1] = raRp2AlphaVinf(ra, rp, pl1);
        [alphapl2] = raRp2AlphaVinf(ra, rp, pl2);
        INTER(indinter,:) = [[pl1 alphapl1 vinfpl1] [pl2 alphapl2 vinfpl2]];    % --> save the results
        indinter = indinter + 1;
    end
end

% --> eliminate rows all equal to zero
INTER = INTER(~all(INTER == 0, 2),:);

end