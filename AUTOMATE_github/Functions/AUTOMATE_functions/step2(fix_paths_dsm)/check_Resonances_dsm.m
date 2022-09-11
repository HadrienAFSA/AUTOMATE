function [num_reso, alpha_list, reso_used, dv_final] = check_Resonances_dsm(current_alpha, alpha_goal, id_pl, v_inf, max_reso_leg,max_dv_per_DSM)
%check_Resonances_dsm.m - Check resonances and DSMs
%
%DESCRIPTION:
%When a single flyby is not enough, checks if resonances are available to 
%go from current_alpha to alpha_goal on the contour. Returns the number of
%resonances used, the alpha list of the resonances and the resonances used 
%if applicable
%
%INPUTS
%-current_alpha (rad):
%   Current pump angle on the contour.
%-alpha_goal (rad):
%   Objective alpha on the contour.
%-id_pl:
%   Planet ID of the contour.
%-v_inf (km/s):
%   Infinity velocity of the contour.
%-max_reso_leg:
%   Maximum number of resonance allowed for each leg of the trajectory.
%-max_dv_per_DSM (km/s):
%   Maximum delta V allowed by DSM.
%
%OUTPUTS
%-num_reso:
%   Number of resonances used.
%-alpha_list (rad):
%   List of all the resonances' pump angle (alpha).
%-reso_used:
%   Ratio of the resonances used. E.g.: 2:3.
%-dv_final (km/s):
%   Total delta V required.
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    max_alpha=compute_maxDelta(id_pl,v_inf);
    
    list_nm = find_resonance(id_pl);
    
    % Creates list of all resonances' alpha
    list_alpha_res = zeros(size(list_nm,1),3);
    list_res_idx=1;
    
    for nm=1:size(list_nm,1)
        n=list_nm(nm,1);
        m=list_nm(nm,2);
        
        [~,~,alpha_res]=resonanceVinf2raRp(n,m,v_inf, id_pl);
        if not(isnan(alpha_res))
            list_alpha_res(list_res_idx,:)=[n m alpha_res];
            list_res_idx=list_res_idx+1;
        end
    end

    % Keeps unique alphas and sorts the alpha list
    list_alpha_res=sortrows(list_alpha_res,3);
    list_alpha_res( all(~list_alpha_res,2), : ) = [];
    
    % Computes how much flyby are required
    alpha_list=NaN(1,max_reso_leg);
    alpha_idx=1;

    reso_used=NaN(1,2);
    reso_idx=1;
    nb_reso=1;
    while nb_reso <= max_reso_leg 
        
%         current_alpha
%         alpha_goal
%         max_alpha

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
                dv_final=NaN;
                return
            end

            % Computes the alpha of the resonance used based on the
            % direction (here, left of the contour)
            if nearest_alpha > max_reach_alpha && idx-1 > 0
                alpha_list(alpha_idx)=list_alpha_res(idx-1,3);
                alpha_idx=alpha_idx+1;
                
                n=list_alpha_res(idx-1, 1);
                m=list_alpha_res(idx-1, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
            else
                alpha_list(alpha_idx)=nearest_alpha;
                alpha_idx=alpha_idx+1;
                
                n=list_alpha_res(idx, 1);
                m=list_alpha_res(idx, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
            end
            
            % Checks if the goal can be achieved after the resonance
            if alpha_list(nb_reso)+max_alpha >= alpha_goal
                % The goal is reached, end of the loop and return
                num_reso=nb_reso;

                dv_final=0;

                % Removes NaN in reso_used
                reso_used=reso_used(all(~isnan(reso_used),2),:);
                return
            else     
                % The goal is not reached, DSM or another resonance is required

                % Checks for DSM

                if max_dv_per_DSM>0
                    dv=dalpha2dv(id_pl, v_inf, alpha_list(nb_reso)+max_alpha, alpha_goal);
    
                    if dv<=max_dv_per_DSM
                        % The goal is reached with DSM, end of the loop and return
                        num_reso=nb_reso;
    
                        % Saves dv
                        dv_final = dv;
    
                        % Removes NaN in reso_used
                        reso_used=reso_used(all(~isnan(reso_used),2),:);
                        return
                    else
                        % If no DSM possible, adds resonance
                        current_alpha=alpha_list(nb_reso);
                        nb_reso=nb_reso+1;
                    end

                else
                    % If no DSM possible, adds resonance
                    current_alpha=alpha_list(nb_reso);
                    nb_reso=nb_reso+1;
                end
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
                dv_final=NaN;
                return
            end
           
            if nearest_alpha < max_reach_alpha && idx+1 <= size(list_alpha_res,1)
                alpha_list(alpha_idx)=list_alpha_res(idx+1,3);
                alpha_idx=alpha_idx+1;
                
                n=list_alpha_res(idx+1, 1);
                m=list_alpha_res(idx+1, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
            else
                alpha_list(alpha_idx)=nearest_alpha;
                alpha_idx=alpha_idx+1;
                
                n=list_alpha_res(idx, 1);
                m=list_alpha_res(idx, 2);
                reso_used(reso_idx,:)=[n m];
                reso_idx=reso_idx+1;
            end
            
            % Checks if the goal can be achieved after the resonance
            if alpha_list(nb_reso)-max_alpha <= alpha_goal
                % The goal is reached, end of the loop and return
                num_reso=nb_reso;

                dv_final=0;

                % Removes NaN in reso_used
                reso_used=reso_used(all(~isnan(reso_used),2),:);
                return
            else
                % The goal is not reached, DSM or another resonance is required

                if max_dv_per_DSM>0
                    % Checks for DSM
                    dv=dalpha2dv(id_pl, v_inf, alpha_list(nb_reso)-max_alpha, alpha_goal);
                   
                    if dv<=max_dv_per_DSM
                        % The goal is reached with DSM, end of the loop and return
                        num_reso=nb_reso;
    
                        % Saves dv
                        dv_final = dv;
    
                        % Removes NaN in reso_used
                        reso_used=reso_used(all(~isnan(reso_used),2),:);
                        return
                    
                    else

                        % The goal is not reached, another resonance is required
                        current_alpha=alpha_list(nb_reso);
                        nb_reso=nb_reso+1;   
                    end
                else

                    % The goal is not reached, another resonance is required
                    current_alpha=alpha_list(nb_reso);
                    nb_reso=nb_reso+1;    
                end
            end
        end           
        
        % No possible achievement
        num_reso=0;
        dv_final=NaN;
           
    end    
end

