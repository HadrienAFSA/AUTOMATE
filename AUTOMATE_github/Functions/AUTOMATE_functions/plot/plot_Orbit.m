function plot_Orbit(sma_o,e_o,planetlist)
%plot_Orbit.m - Plot orbits
%
%DESCRIPTION:
%Plots a given orbit as well as orbits of input planets

%INPUTS
%-sma_o (km):
%   Semi-major axis of the orbit 
%-e_o:
%   Eccentricity of the orbit
%-planetlist:
%   List of planets plotted (e.g.: [2 3 4] for Venus, Earth and Mars).
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------


% Constants
muSun = getAstroConstants('Sun', 'mu');
au=getAstroConstants('AU');

%% Parameters
% Planets to consider
%planetlist=[2 3];

% Orbit to plot
% ra=167326734.598961;
% rp=107424983.218441;
% sma_o=(ra+rp)/2;
% e_o=ra/sma_o - 1;
kep_o=[sma_o e_o 0 0 0 0];

%% Planets orbits
% sma, radius, speed list
params=[];
for i=1:length(planetlist)
    [~,~,sma]=planetConstants(planetlist(i));
    car=kep2car([sma 0 0 0 0 0 0],muSun);

    params=[params; car];

    if i==length(planetlist)
        tau_max=2*pi*sqrt((sma^3)/muSun);
    end
end

%% Plot 
% Computation parameters
nPoints=1000;
dT_ln=linspace(0,tau_max, nPoints);

% cartesian elements of user orbit
car_o=kep2car(kep_o,muSun);

% Initialisation
pl_motions=zeros(nPoints,3*length(planetlist));
o_motion=zeros(nPoints,3);

for i=1:nPoints
    for j=1:length(planetlist)
        pl_motions(i,1+(j-1)*3:3*j)=FGKepler_dt(params(j,1:3), params(j,4:6), dT_ln(i),muSun);
    end
    o_motion(i,:)=FGKepler_dt(car_o(1:3), car_o(4:6), dT_ln(i),muSun);
end

% Plot parameters
hold on
axis equal

% Draw sun with its radius (Rs)
Rs=7e5;
[X,Y,Z] = sphere(20);
X=X*Rs; Y=Y*Rs; Z=Z*Rs;
surf(X,Y,Z)

% Plot all trajectories computed above
for i=1:length(planetlist)
    plot3(pl_motions(:,(i-1)*3+1), pl_motions(:,(i-1)*3+2), pl_motions(:,3*i));
end
plot3(o_motion(:,1), o_motion(:,2), o_motion(:,3));


end

