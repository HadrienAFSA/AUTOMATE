%% Initialisation
clear all;
close all;
clc;

%% Constants
au=getAstroConstants('AU');
muSun=getAstroConstants('Sun', 'mu');

% Settings
planets = [2 3 4 5];

v_inf_levels = [6 8 10 12];%3:6;%[3.2984 5.8219 5.84 8.8019 10.0887 11.5837];%3:.5:15;%[6 10 12];
length(v_inf_levels);

% Generate the grid
Grid = generate_grid(planets,v_inf_levels);

%% Plot the TM and its intersections
plotContoursInters_alpha(planets, v_inf_levels, Grid);
%plotTrip(planets, v_inf_levels, [33 25 36 44],Grid);
%plot(0.723,0.723,'.','MarkerSize',15, 'color', [0.64 0.08 0.18]);
%plot(1,1,'.','MarkerSize',15, 'color', [0 0.5 0]);
%plot(1.524,1.524,'.','MarkerSize',15, 'color', [0.3 0.75 0.93]);

[mu,radius]=planetConstants(4);
[hmin,~]=maxmin_flybyAltitude(4);
max_e = 1 + ((radius+hmin)*6^2)/mu;
max_alpha = 2*asin(1/max_e);

[ra1, rp1]=modified_generateContours(4, 6, 2.46, 2.2)
[ra2, rp2]=modified_generateContours(4, 6, 2.22, 2);

% wid=10;
% max_couples=5;
% for pl=planets
%     if pl == 1
%         COLOR = [0 0.45 0.74];
%     elseif pl == 2
%         COLOR = [0.64 0.08 0.18];
%     elseif pl == 3
%         COLOR = [0 0.5 0];
%     elseif pl == 4
%         COLOR = [0.3 0.75 0.93];
%     elseif pl == 5
%         COLOR = [0 0 0];
%     elseif pl == 6
%         COLOR = [0 0.5 0.2];
%     end
%     
%     for vinf=v_inf_levels
%         for n=1:max_couples
%             for m=1:max_couples
%                 
%                 if (n~=m | n==1)
%                     [ra,rp, alphares]=resonanceVinf2raRp(n,m,vinf, pl);
%                     if n==3 && m==4
%                         wid=20;
%                         if vinf==6 && pl==4
%                             alphares
%                         end
%                     end
%                     plot(ra/au, rp/au, '.' ,'MarkerSize', wid, 'color', COLOR);
%                     wid=10;
%                     
%                 end
%             end
%         end
%     end
% end


%plot(ra2/au, rp2/au, 'b', 'LineWidth', 2);
%plot(ra1/au, rp1/au, 'r', 'LineWidth', 2);

%% Step1: Generate paths
% Conditions
departure_planet    =3;
departure_vinf      =v_inf_levels(1);
arrival_planet      =5;
arrival_vinf        =v_inf_levels;
max_depth = 5; % max number of flyby + 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
departure_condition=create_depCond(departure_planet, departure_vinf);
arrival_condition=create_arriCond(arrival_planet, arrival_vinf);

time_step1=tic;
Paths=generate_Paths(departure_condition, arrival_condition, max_depth, Grid, planets, v_inf_levels);
toc(time_step1)

length(Paths)

%% finds max length
%{
%nb=0;
max=0;
for i=1:length(Paths)
    if length(Paths{i})>max
        %nb=nb+1;
        max=length(Paths{i});
    end
end
max
%nb;
%}

%% Step2: Fix paths
% Maximum number of considered resonances. if max_couples=5, resonances can 
% only go up to 4:5 or 5:4.
max_couples=5;
% Maximum number of consecutive flyby of the same planet
max_resonance=1;

time_step2=tic;
fixed_Paths = fix_Paths(Paths, Grid, max_couples, max_resonance);
toc(time_step2)

length(fixed_Paths)

%%
%{
new_paths=cell(length(fixed_Paths),1);
tt=0;
for i=1:length(fixed_Paths)
    if length(fixed_Paths{i,1})<=max_depth+1
        tt=tt+1;
        new_paths{i}=fixed_Paths{i,1};
    end
end
new_paths=new_paths(~cellfun('isempty',new_paths));
tt
%}

%% Step3: Computes ToF of fixed paths

time_step3=tic;
ToF_Paths=generate_PathsToF(fixed_Paths, Grid);
toc(time_step3)

%%

fixed_Paths=cell(1,2);
fixed_Paths{1,1}=[33.5 26 39 410 311.5 56];
fixed_Paths{1,2}=[];
max_depth=5



%% Step4: Phasing

%fixed_Paths=Juice_Paths;

theta_threshold = deg2rad(200);
max_revolution = 0;

% Generates list of all I/O combinations for the fixed_Paths (for all the different lengths)
time_step4=tic;
[All_IOCombinations, idx_shift]=generate_IOCombinations(fixed_Paths, max_depth);

[phased_Paths,phased_Paths_unique]=fix_Phasing(ToF_Paths, theta_threshold, max_revolution, Grid, All_IOCombinations, idx_shift);
toc(time_step4)


%% Generating output

output_Paths=generate_Output(phased_Paths_unique, 0.2);

    
