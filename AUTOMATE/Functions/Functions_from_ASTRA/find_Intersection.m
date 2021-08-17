function [DE] = find_Intersection(E, pl1, pl2, vinfpl1, vinfpl2)

% this function is used to find intersections between contours on Tisserand
% map.

rp1 = En2raRp(E, pl1, vinfpl1);
rp2 = En2raRp(E, pl2, vinfpl2);

DE = rp1 - rp2;

end