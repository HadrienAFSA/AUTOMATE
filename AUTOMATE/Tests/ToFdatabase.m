function [ToF_database] = ToFdatabase(Date_Range, ToF_range, planets, v_inf_levels, max_vinf)

    muSun = getAstroConstants('Sun', 'mu');
    au = getAstroConstants('AU');
    
    l_Date_Range=   length(Date_Range);
    l_ToF_range =   length(ToF_range);

    tot_length=length(planets)*(length(planets)-1);
    
    ToF_database = cell(8);
    
    progress=1;
    for pl1=planets
        for pl2=planets
            
            if pl1~=pl2
                tof_matrix = NaN((length(v_inf_levels)^2)*l_Date_Range*l_ToF_range,4);
                tof_matrix_idx=1;


                v1_inf_tic = tic;
                for date=1:l_Date_Range
                    curr_date = Date_Range(date);

                    [r_1, v_1] = EphSS_car(pl1, curr_date);

                    for tof=1:l_ToF_range



                        curr_tof = ToF_range(tof);

                        [r_2, v_2] = EphSS_car(pl2, curr_date+curr_tof);

                        % Lambert Arc
                        [v_1_sc, v_2_sc]  = lambertMR(r_1,r_2,curr_tof*24*3600,muSun,0,0);

                        % Delta theta
                        kep_sc1=car2kep([r_1, v_1_sc], muSun);
                        kep_sc2=car2kep([r_2, v_2_sc], muSun);

                        theta1=kep_sc1(end);
                        theta2=kep_sc2(end);

                        delta_Theta = angleSpanned(theta1,theta2);
                        %delta_Theta2= acos(dot(r_1,r_2)/(norm(r_1)*norm(r_2)));

                        v_inf_1 = norm(v_1_sc-v_1);
                        v_inf_2 = norm(v_2_sc-v_2);


                        % Saves if realistic values
                        if v_inf_1<=max_vinf && v_inf_2<=max_vinf

                            tof_matrix(tof_matrix_idx,1)=delta_Theta;
                            tof_matrix(tof_matrix_idx,2)=v_inf_1;
                            tof_matrix(tof_matrix_idx,3)=v_inf_2;
                            tof_matrix(tof_matrix_idx,4)=curr_tof;

                            tof_matrix_idx=tof_matrix_idx+1;
                        end
                    end
                end                
            
            
                % Removes empty rows
                tof_matrix = tof_matrix(all(~isnan(tof_matrix),2),:);
                % Saves matrix
                ToF_database{pl1,pl2}=tof_matrix;

                % Show ETA
                elapsed_time=toc(v1_inf_tic);
                remaining_time = round((tot_length-progress+1)*elapsed_time);
                hours_left=floor(remaining_time/3600);
                minutes_left=floor((remaining_time-hours_left*3600)/60);
                seconds_left=mod(remaining_time,60);

                percent = progress/tot_length*100;

                fprintf("Generate ToF database: %d/%d (%f%%). Pl1: %d, pl2: %d. ETA: %d h %d m %d s.\n", progress, tot_length, percent,pl1, pl2,hours_left, minutes_left, seconds_left);
                progress=progress+1;
           
            end
        end
    end
end

