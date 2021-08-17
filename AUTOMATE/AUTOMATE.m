%% Initialisation
clear all;
close all;
clc;

total_time=tic;

%% Constants
au=getAstroConstants('AU');
muSun=getAstroConstants('Sun', 'mu');

% Computation settings
planets = [2 3 4 5]; % Venus to Jupiter
v_inf_levels = 3:1:15; %km/s

% Generate the grid
Grid = generate_grid(planets,v_inf_levels);

% Plot the TM and its intersections
plotContoursInters(planets, v_inf_levels, Grid, false);

%% Trajectory settings
departure_planet     = 3; % Earth
departure_vinf       = 3:6; % km/s
arrival_planet       = 5; % Jupiter
arrival_vinf         = v_inf_levels; %km/s
max_depth            = 5; %= max number of flyby + 1

%% Step1: Generate paths
now=fix(clock);
fprintf("######################\nStep 1 launched at %d h %d m %d s.\n\n",now(4), now(5), now(6)); 
time_step1=tic;
Paths=generate_Paths(departure_planet, departure_vinf,arrival_planet,arrival_vinf, max_depth, Grid, planets, v_inf_levels);
toc(time_step1)

%% Step2: Fix paths

% Settings
max_reso_leg=1;
max_reso_total=2;

now=fix(clock);
fprintf("\n######################\nStep 2 launched at %dh%dm%ds.\n\n",now(4), now(5), now(6)); 
time_step2=tic;
fixed_Paths = fix_Paths(Paths, Grid,max_reso_leg,max_reso_total);
toc(time_step2)

%% Step3: Computes ToF of fixed paths

now=fix(clock);
fprintf("\n######################\nStep 3 launched at %d h %d m %d s.\n\n",now(4), now(5), now(6)); 
time_step3=tic;
ToF_Paths=generate_PathsToF(fixed_Paths, Grid);
toc(time_step3)

%% Step4: Phasing

% % Settings 
% theta_threshold = deg2rad(30);
% max_revolution = 0;
% 
% % Generates list of all I/O combinations for the fixed_Paths (for all the different lengths)
% time_step4=tic;
% [All_IOCombinations, idx_shift]=generate_IOCombinations(ToF_Paths, max_depth);
% 
% [phased_Paths,phased_Paths_unique]=fix_Phasing(ToF_Paths, theta_threshold, Grid, All_IOCombinations, idx_shift);
% toc(time_step4)

%% Generating output

% Settings
range_vinfs_output=[3 7];

time_step5=tic;
output_Paths=generate_Output(ToF_Paths,range_vinfs_output);
toc(time_step5)

%% Total time
fprintf("Total time: %g seconds.\n", round(toc(total_time)));
