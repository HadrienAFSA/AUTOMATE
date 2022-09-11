function [rascCONT, rpscCONT] = modified_generateContours(pl, vInf, alpha1, alpha2)
% see generateContours.m from Other_functions

% only works for elliptical orbits
% Sun is the main body 

mu    = 132724487690; 
alpha = linspace(min(alpha1,alpha2), max(alpha1,alpha2)); alpha = alpha';

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