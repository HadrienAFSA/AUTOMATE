function plotEllipse_SC(kep, th1, th2,color)

% DESCRIPTION :
% plot elliptical orbit of the spacecraft (only planar cases considered)

AU = 149597870.7;

a  = kep(1);
e  = kep(2);
om = kep(5);
p  = a*(1 - e^2);

if nargin < 2
    th = linspace(0, 2*pi, 200);
else
    th = linspace(th1, th2, 200);
end

xt = zeros(1,length(th));
yt = zeros(1,length(th));
for indth = 1:length(th)
    r = p/(1 + e*cos(th(indth)));
    xt(indth) = r*cos(th(indth));
    yt(indth) = r*sin(th(indth));
end

R3 = [cos(om) -sin(om); sin(om) cos(om)];
for ind = 1:length(xt)
    X = [xt(ind) yt(ind)]';
    X = R3*X;
    xt(ind) = X(1);
    yt(ind) = X(2);
end

hold on; grid on; axis equal;
plot(xt./AU, yt./AU, 'linewidth', 2, 'color', color);

end