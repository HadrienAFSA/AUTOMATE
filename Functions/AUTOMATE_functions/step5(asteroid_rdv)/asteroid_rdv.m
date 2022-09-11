function [list_pl_vinf_alpha_dv] = asteroid_rdv(kep_ast, planets, v_inf_levels,max_dv)
%asteroid_rdv.m - Asteroid rendezvous
%
%DESCRIPTION:
%Given the orbit of any object (e.g. asteroid), finds the closest contour
%on the Tisserand graph in terms of deltaV to join the orbit.
%
%INPUTS
%-kep_ast:
%   Keplerian parameters of the orbit
%-planets:
%   Planets considered on the Tisserand graph
%-v_inf_levels:
%   Infinity velocity levels considered on the Tisserand graph
%-max_dv (km/s):
%   Maximum delta V allowed (filters the list)
%
%OUTPUTS
%-list_pl_vinf_alpha_dv:
%   List of the closest contours ranked in terms of delta V. Gives the
%   planet ID and infinity velocity of the contour, the alpha on the 
%   contourfor which the orbit is the closest, and the delta V
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------
        
    list_pl_vinf_alpha_dv=NaN(length(planets)*length(v_inf_levels),4);
    indx_lpvd=1;
    
    % Find closest contours
    for pl = planets
        for vinf = v_inf_levels
            [tmp_cont_ra, tmp_cont_rp]=generateContours(pl,vinf);
    
            temp_dv_min=Inf;

            tmp_rp_min=NaN;
            tmp_ra_min=NaN;

            % Goes through all orbits
            for orb = 1:length(tmp_cont_ra)
                tmp_ra=tmp_cont_ra(orb);
                tmp_rp=tmp_cont_rp(orb);
    
                % Computes orbit kepler elements
                sma_tmp = (tmp_ra + tmp_rp)/2;
                e_tmp = 1 - tmp_rp/sma_tmp;
                kep_tmp = [sma_tmp e_tmp 0 0 0 0];
                
                % Computes dv
                dv_tmp = DVcost_Tiss(kep_ast, kep_tmp);
                %fprintf('#######################\n')

                if dv_tmp<max_dv && dv_tmp<temp_dv_min
                    temp_dv_min=dv_tmp;

                    %Saves the corresponding orbit
                    tmp_rp_min=tmp_rp;
                    tmp_ra_min=tmp_ra;
                end
            end
            if temp_dv_min<Inf
                % Computes the closest alpha
                closest_alpha = abs(raRp2AlphaVinf(tmp_ra_min,tmp_rp_min,pl));

                % Saves the minimum dv for this contour
                list_pl_vinf_alpha_dv(indx_lpvd,1) = pl;
                list_pl_vinf_alpha_dv(indx_lpvd,2) = vinf;
                list_pl_vinf_alpha_dv(indx_lpvd,3) = closest_alpha;
                list_pl_vinf_alpha_dv(indx_lpvd,4) = temp_dv_min;
                indx_lpvd=indx_lpvd+1;
            end
        end
    end

    % Sorts the list
    list_pl_vinf_alpha_dv=sortrows(list_pl_vinf_alpha_dv,4);
    list_pl_vinf_alpha_dv=rmmissing(list_pl_vinf_alpha_dv);
    % Keep the best ones

end

