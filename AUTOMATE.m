%% Initialisation
clear;close all;clc;

total_time=tic;

%% Constants
% Computation settings
planets = [2 3 4 5 6 7 8]; % Venus to Jupiter
v_inf_levels = 3:9; %km/s

% Generate the grid
Grid = generate_grid(planets,v_inf_levels);

% Plot the Tisserand graph. Intersections, tickmarks and resonances can be
% plotted too if boolean is true.
plotContoursInters(planets, v_inf_levels, Grid, false, false, false);

%% Trajectory settings

% Trajectory
departure_planet     = 3; % Earth
departure_vinf       = 3:0.5:6; % km/s
arrival_planet       = 5; % Jupiter
arrival_vinf         = 6:.5:12; %km/s
max_depth            = 4; %= max number of flyby + 1

% First possible date of launch (defines the year launch window)
ref_date = [2023 01 01 12 0 0];

% Resonance settings
max_reso_leg=1; % Maximum number of resonance used per leg
max_reso_total=2; % Maximum number of resonance used for the trajectory

% DSMs settings
max_dv=3; % Total dv available (km/s)
max_dv_per_reso=.5; % Maximum dv for each DSM (km/s)


%% Generate paths
now=fix(clock);
fprintf("######################\nStep 1 launched at %d h %d m %d s.\n\n", now(4), now(5), now(6)); 
time_step1=tic;

Paths=generate_Paths(departure_planet, departure_vinf,arrival_planet,arrival_vinf, max_depth, Grid, planets, v_inf_levels);

toc(time_step1)

%% Fix paths
now=fix(clock);
fprintf("\n######################\nStep 2 launched at %dh%dm%ds.\n\n", now(4), now(5), now(6)); 
time_step2=tic;

fixed_Paths = fix_Paths_dsm(Paths, Grid,max_reso_leg,max_reso_total,max_dv,max_dv_per_reso);

toc(time_step2)

%% Computes ToF of fixed paths
now=fix(clock);
fprintf("\n######################\nStep 3 launched at %d h %d m %d s.\n\n", now(4), now(5), now(6)); 
time_step3=tic;

% Generates the phase angle database
phase_database = generate_phaseDatabase(ref_date, planets(end));

ToF_Paths=generate_PathsToF(fixed_Paths, Grid, phase_database);

toc(time_step3)

%% Generating output
fprintf("\n######################\nGenerating output...\n\n"); 

% Settings
range_vinfs_output=[0 Inf];

time_step5=tic;
OUTPUT=generate_Output(ToF_Paths,range_vinfs_output);
toc(time_step5)

%% Total time
fprintf("Total time: %g seconds.\n", round(toc(total_time)));
