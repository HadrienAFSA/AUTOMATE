function [INTER] = checkIntersection_inv(vinfpl1, pl1, vinflevels, pl2)

% generate the contour for the first planet
[rascCONT_pl1, rpscCONT_pl1] = generateContours(pl1, vinfpl1);

% compute intersections between two planets
INTER = zeros(length(vinflevels),6);
indinter = 1;
for indvinf = 1:length(vinflevels)
    
    vinfpl2 = vinflevels(indvinf);
    
    [rascCONT_pl2, rpscCONT_pl2] = generateContours(pl2, vinfpl2);
    P = InterX([rascCONT_pl1'; rpscCONT_pl1'], [rascCONT_pl2'; rpscCONT_pl2']);
    if ~isempty(P)
        E0 = raRp2En(P(1), P(2));                                              % --> provide guess for the intersection 
        E  = fzero(@(E) find_Intersection(E, pl1, pl2, vinfpl1, vinfpl2), E0); % --> find intersection (rp) (refinement stage)
        [rp, ra]   = En2raRp(E, pl2, vinfpl2);                                 % --> find intersection (ra)
        [alphapl1] = raRp2AlphaVinf(ra, rp, pl1);
        [alphapl2] = raRp2AlphaVinf(ra, rp, pl2);
        INTER(indinter,:) = [[pl1 vinfpl1 alphapl1] [pl2 vinfpl2 alphapl2]];   % --> save the results
        indinter = indinter + 1;
    end
end

% eliminate rows all equal to zero
INTER = INTER(~all(INTER == 0, 2),:);

end