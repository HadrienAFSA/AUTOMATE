function [num_reso, alpha_list, reso_used] = check_Resonances(current_alpha, alpha_goal, id_pl, v_inf, max_reso)
% Check if resonances are available to go from current_alpha to alpha_goal
% on the contour. Returns the number of resonances used, the alpha list of
% the resonances and the resonances used if applicable


    % max_reso: maximum number of consecutive resonances (nb of flyby+1) on the same planet

    [mu,radius]=planetConstants(id_pl);
    [hmin,~]=maxmin_flybyAltitude(id_pl);

    max_e = 1 + ((radius+hmin)*v_inf^2)/mu;
    max_alpha = 2*asin(1/max_e);
    
    list_nm = find_resonance(id_pl);
    
    % Creates list of all resonances' alpha
    list_alpha_res = zeros(size(list_nm,1),3);
    list_res_idx=1;
    
    for nm=1:size(list_nm,1)
        n=list_nm(nm,1);
        m=list_nm(nm,2);
        
        [~,~,alpha_res]=resonanceVinf2raRp(n,m,v_inf, id_pl);
        if not(isnan(alpha_res))
            %fprintf("n = %d, m=%d, alpha = %f\n", n,m, alpha_res);
            list_alpha_res(list_res_idx,:)=[n m alpha_res];
            list_res_idx=list_res_idx+1;
        end
    end

    % Keeps unique alpha (and deletes duplicate resonances (1:2=2:4) and
    % sorts the alpha list
    %[~,un_idx]=unique(list_alpha_res(:,3), 'stable');
    %list_alpha_res=list_alpha_res(un_idx,:);
    list_alpha_res=sortrows(list_alpha_res,3);
    list_alpha_res( all(~list_alpha_res,2), : ) = [];
    
    % Computes how much flyby are required
    alpha_list=NaN(1,max_reso);
    alpha_idx=1;

    reso_used=NaN(2*max_reso,2);
    reso_idx=1;
    nb_reso=1;
    while nb_reso <= max_reso 
        
        % Go to the left of the contour (higher alpha)
        if current_alpha<alpha_goal
            max_reach_alpha = min(current_alpha + max_alpha, pi);

            % Finds nearest value of max_reach_alpha in the list of resonances
            [~,idx]=min(abs(list_alpha_res(:,3)-max_reach_alpha));
            nearest_alpha=list_alpha_res(idx, 3);
            
            % Checks if the nearest resonance can not be reached
            if idx==1 && (max_reach_alpha<nearest_alpha)
                num_reso=0;
                alpha_list=NaN;
                reso_used=[];
                return
            end

            % Computes the alpha of the resonance used based on the
            % direction (here, left of the contour)
            if nearest_alpha > max_reach_alpha && idx-1 > 0
                alpha_list(alpha_idx)=list_alpha_res(idx-1,3);
                alpha_idx=alpha_idx+1;
                %alpha=[alpha list_alpha_res(idx-1,3)];
                
                n=list_alpha_res(idx-1, 1);
                m=list_alpha_res(idx-1, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
                %reso_used=[reso_used; [n m]];
            else
                alpha_list(alpha_idx)=nearest_alpha;
                alpha_idx=alpha_idx+1;
                %alpha=[alpha nearest_alpha];
                
                n=list_alpha_res(idx, 1);
                m=list_alpha_res(idx, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
                %reso_used=[reso_used; [n m]];
            end
            
            % Checks if the goal can be achieved after the resonance
            if alpha_list(nb_reso)+max_alpha >= alpha_goal
                % The goal is reached, end of the loop and return
                num_reso=nb_reso;
                
                % Removes NaN in reso_used
                reso_used=reso_used(all(~isnan(reso_used),2),:);
                return
            else
                % The goal is not reached, another resonance is required
                current_alpha=alpha_list(nb_reso);
                nb_reso=nb_reso+1;
            end
                               

        % Go to the right of the contour (lower alpha)
        elseif current_alpha>alpha_goal
            max_reach_alpha = max(current_alpha - max_alpha, 0);

            % Finds nearest value of max_reach_alpha in the list of resonances
            [~,idx]=min(abs(list_alpha_res(:,3)-max_reach_alpha));
            nearest_alpha=list_alpha_res(idx, 3);
            
            % Checks if the nearest resonance can not be reached
            if idx==length(list_alpha_res) && (max_reach_alpha>nearest_alpha)
                num_reso=0;
                alpha_list=NaN;
                reso_used=[];
                return
            end

            if nearest_alpha < max_reach_alpha && idx+1 <= size(list_alpha_res,1)
                alpha_list(alpha_idx)=list_alpha_res(idx+1,3);
                alpha_idx=alpha_idx+1;
                %alpha=[alpha list_alpha_res(idx+1,3)];
                
                n=list_alpha_res(idx+1, 1);
                m=list_alpha_res(idx+1, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
                %reso_used=[reso_used; [n m]];
            else
                alpha_list(alpha_idx)=nearest_alpha;
                alpha_idx=alpha_idx+1;
                %alpha=[alpha nearest_alpha];
                
                n=list_alpha_res(idx, 1);
                m=list_alpha_res(idx, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
                %reso_used=[reso_used; [n m]];
            end
            
            % Checks if the goal can be achieved after the resonance
            if alpha_list(nb_reso)-max_alpha <= alpha_goal
                % The goal is reached, end of the loop and return
                num_reso=nb_reso;
                
                % Removes NaN in reso_used
                reso_used=reso_used(all(~isnan(reso_used),2),:);
                return
            else
                % The goal is not reached, another resonance is required
                current_alpha=alpha_list(nb_reso);
                nb_reso=nb_reso+1;     
            end
        end           
        
        % No possible achievement
        num_reso=0;
           
        % Removes NaN in reso_used
        reso_used=reso_used(all(~isnan(reso_used),2),:);
    end    
end

