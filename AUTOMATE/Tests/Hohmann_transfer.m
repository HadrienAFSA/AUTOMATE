function [dv1, dv2] = Hohmann_transfer(r_a_ini, r_p_ini, r_a_final, r_p_final, mu)

    a_ini = (r_a_ini+r_p_ini)/2;
    a_final = (r_a_final+r_p_final)/2;
    
    %First manoeuvre
    v_peri_ini = sqrt(mu * (2/r_p_ini - 1/a_ini));
    
    a_transfer = (r_p_ini+r_a_final)/2;
    v_peri_transfer = sqrt(mu *(2/r_p_ini - 1/a_transfer));
    
    dv1=abs(v_peri_transfer-v_peri_ini);
    
    %Second manoeuvre
    v_apo_transfer = sqrt(mu *(2/r_a_final - 1/a_transfer));
    v_final = sqrt(mu*(2/r_a_final - 1/a_final));
    
    dv2=abs(v_final-v_apo_transfer);
end

