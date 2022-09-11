function plotCircle_PL(pl)

% DESCRIPTION :
% plot circular orbit of the planet

AU = 149597870.7;

[~, ~, rpl] = planetConstants(pl);

th = linspace(0, 2*pi);

xx = rpl.*cos(th);
yy = rpl.*sin(th);

hold on; grid on; axis equal;
plot(xx./AU, yy./AU, 'k');

end