function [rascCONT, rpscCONT] = generateContours(pl, vInf)

% only works for elliptical orbits
% Sun is the main body 

mu    = 132724487690; 
alpha = deg2rad(linspace(0,180)); alpha = alpha';

% planet properties
[~, ~, rPL] = planetConstants(pl);
vPL = sqrt(mu/rPL);

% for indi = 1:length(alpha)
%     [rascCONT(indi,:), rpscCONT(indi,:)] = SCorbit(alpha(indi), vInf, vPL, rPL);
% end

[rascCONT, rpscCONT] = SCorbit(alpha, vInf, vPL, rPL);

% eliminate elliptical orbits
idxs           = find(rascCONT < 0);
rascCONT(idxs) = [];
rpscCONT(idxs) = [];

end