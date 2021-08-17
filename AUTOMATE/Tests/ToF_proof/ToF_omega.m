%% Initialisation
clear all;
close all;
clc;

%% 
au=getAstroConstants('AU');
muSun=getAstroConstants('Sun', 'mu');

% Settings
planets = [2 3 4 5];

v_inf_levels = [10 11.5];
length(v_inf_levels);

% Generate the grid
Grid = generate_grid(planets,v_inf_levels);


%%
close all;
% hold on
% for pl=[3 4]
%     plotCircle_PL(pl)
% end

nPoints_omega = 10;
omega = linspace(0, pi, nPoints_omega);
list_tof = [];
list_bar = [];

for o = 1:nPoints_omega
    o
    omeg = omega(o);
    ls=tof_plot_omega_ME(omeg, false);
    min_tmp=min(ls);
    max_tmp=max(ls);
    
    
    
    list_tof=[list_tof, ls];
    
    list_bar=[list_bar [min_tmp; max_tmp]];
end
list_bar
%plot(omega,list_tof)
figure('numbertitle', 'off', 'name', 'Range bar graph with vertical bars');
rangebar(list_bar, .8);

min(list_tof);
max(list_tof);
mean(list_tof);
%%
%tof_plot_omega_ME(pi, true);