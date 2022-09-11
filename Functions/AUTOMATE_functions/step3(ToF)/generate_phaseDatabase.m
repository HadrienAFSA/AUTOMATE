function [phase_database] = generate_phaseDatabase(date,max_planet)
%GENERATE_PHASEDATABASE - Generates phase angle between planets database
% 
%DESCRIPTION:
%This script generates a database of phase angle between planets, for an
%entire synodic period and from a specified date, with a step of one day. 
%the length of the arrays generated is therefore the ceil of the synodic 
%period in days.
%
%The generated database is a N-by-N cell where N is the ID of the last
%planet considered. E.g.: if N=5, the database will be generated for
%planets from Mercury (1) to Jupiter (5). 
%
%The upper part of the cell (without the diagonal) contains the data
%generated. E.g.: the cell (3,4) contains the phase angle of Earth (3) and
%Mars (4).
%
%The (1,1) cell contains the date from which the data is computed. 
%E.g.: if the date is January 1st 2021, it means that the phase angle will
%be computed from this date to this same date + the synodic period.
% 
%INPUTS
%-date: 
%   date from which the database is generated. Format is 
%   [year month day hours minutes seconds]
%-max_planet: 
%   last planet considered. E.g.: if N=5, the database will 
%   be generated for planets from Mercury (1) to Jupiter (5). 
%
% OUTPUTS
%-phase_database:
%   Cell containing the phase angle for each couple of planet and for the 
%   whole synodic period, starting from 'date'.
%
%   The upper part of the cell (without the diagonal) contains the data
%   generated. E.g.: the cell (3,4) contains the phase angle of Earth (3) and
%   Mars (4).
%     
%   The (1,1) cell contains the date from which the data is computed. 
%   E.g.: if the date is January 1st 2021, it means that the phase angle will
%   be computed from this date to this same date + the synodic period.
%
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    muSun=getAstroConstants('Sun', 'mu');

    % Initial date. The database will be generated from this date, and for a
    % full synodic period between two planets
    date_ini= date2mjd2000(date);
    
    %% Generating the database
    % Allocate space for the database
    phase_database = cell(max_planet);
    
    for i=1:max_planet % All planets from Mercury to max_planet
        
        % Gets the cartesian and keplerian of planet 1
        [r_pl1,v_pl1]=EphSS_car(i,date_ini);
        kep_pl1=car2kep([r_pl1,v_pl1],muSun);
        
        % Computes the rate
        n_pl1 = sqrt(muSun/(kep_pl1(1)^3));
        
        for j=i+1:max_planet
             % Gets the cartesian and keplerian of planet 1
            [r_pl2,v_pl2]=EphSS_car(j,date_ini);
            kep_pl2=car2kep([r_pl2,v_pl2],muSun);
    
            % Computes the rate
            n_pl2 = sqrt(muSun/(kep_pl2(1)^3));
            
            % Computes the synodic period
            syn_per=2*pi/(abs(n_pl1-n_pl2)*3600*24); % days
    
            % Date span
            date_span = 0:ceil(syn_per)-1;
            
            % Stores the data
            tmp_data = zeros(length(date_span),2);
            
            for d=date_span
                % Gets the cartesian and keplerian of both planets
                [r_pl1,v_pl1]=EphSS_car(i,date_ini+d);
                [r_pl2,v_pl2]=EphSS_car(j,date_ini+d);
                kep_pl1=car2kep([r_pl1,v_pl1],muSun);
                kep_pl2=car2kep([r_pl2,v_pl2],muSun);
                
                % Gets the anomaly at the date
                theta1=fast_wrapToPi(sum(kep_pl1(4:6)));
                theta2=fast_wrapToPi(sum(kep_pl2(4:6))); 
                            
                % Computes the phase angle at this time
                if isAheadOf(theta1,theta2)
                    delta_theta=min(abs(theta2-theta1),abs(2*pi-max(theta1,theta2)+min(theta1,theta2)));
                else
                    delta_theta=-min(abs(theta2-theta1),abs(2*pi-max(theta1,theta2)+min(theta1,theta2)));
                end
                
                % Saves
                tmp_data(d+1,1) = date_ini+d;
                tmp_data(d+1,2) = delta_theta;
    
            end
            
            % Saves in the database
            phase_database{i,j}=tmp_data;
        end
    end
    
    % Writes the date it is generated for
    phase_database{1,1}=mjd20002date(date_ini);
    
    % Saves the database in a file
    % save('Functions/AUTOMATE_functions/step3(ToF)/phase_database', 'phase_database');


end

