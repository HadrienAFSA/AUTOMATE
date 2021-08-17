function [list_tof] = tof_plot_omega_ME2(omega_pl, bool_plot)

    list_tof = [];
    
    au=getAstroConstants('AU');
    muSun=getAstroConstants('Sun', 'mu');
    
    nPoints= 20;
    nPoints2=20;

    v_inf_range = linspace(-.5, .5, nPoints);
    alpha_range = linspace(-.1, .1, nPoints);

    [~,~,sma_Mars, rp_min, ~]=planetConstants(4);
    e_Mars = 1 - rp_min/sma_Mars;
    
    [~,~,sma_Earth] = planetConstants(3);

    for v=1:length(v_inf_range)
        for a=1:nPoints
            [ra,rp]=alphaVinf2raRp(1.40938378328745+alpha_range(a), 11.5+v_inf_range(v), 3);
            a_SC = (ra+rp)/2;
            e_SC = 1 - rp/a_SC;
            n_SC = sqrt(muSun/(a_SC^3));
            tau_SC=2*pi/n_SC;

            theta_1 = wrapTo2Pi(acos((1/e_SC) * ((a_SC*(1-e_SC^2)/sma_Earth) - 1)));

            theta_linspace_sc = linspace(0,pi, nPoints2);
            theta_linspace_pl = linspace(0-omega_pl,pi-omega_pl, nPoints2);
            
            min_dist = 1E8;
            th_sc_min = NaN;
            th_pl_min = NaN;

            for i=1:nPoints2
                for j=1:nPoints2
                    th1=theta_linspace_sc(i);
                    th2=theta_linspace_pl(j);

                    kep_sc = [a_SC e_SC 0 0 0 th1];

                    kep_pl   = [sma_Mars e_Mars 0 0 omega_pl th2];

                    car1 = kep2car(kep_sc,muSun);
                    car2 = kep2car(kep_pl,muSun);

                    r1 = car1(1:3);
                    r2 = car2(1:3);

                    %quiver(0, 0, r1(1)/au,r1(2)/au, 0,'g')
                    %quiver(0, 0, r2(1)/au,r2(2)/au, 0,'y')

                    dist = norm(r1 - r2);

                    if dist < min_dist
                        min_dist=dist;
                        th_sc_min=th1;
                        th_pl_min=th2;
                    end
                end
            end           

            kep_SC_inter = [a_SC e_SC 0 0 0 th_sc_min];
            kep_Mars_inter=[sma_Mars e_Mars 0 0 omega_pl th_pl_min];
            
            car_SC_inter=kep2car(kep_SC_inter,muSun);
            car_Mars_inter=kep2car(kep_Mars_inter,muSun);
 
            Vinf_Mars = norm(car_SC_inter(4:end)-car_Mars_inter(4:end));

            if 9.05 < Vinf_Mars && Vinf_Mars < 10.5
                E_1=2*atan(sqrt((1-e_SC)/(1+e_SC))*tan(theta_1/2));
                E_2=2*atan(sqrt((1-e_SC)/(1+e_SC))*tan(th_sc_min/2));

                t1 = (1/n_SC) * (E_1 - e_SC*sin(E_1));
                t2 = (1/n_SC) * (E_2 - e_SC*sin(E_2));
                
                tof = (tau_SC - t2 + t1)/(24*3600);
                
                list_tof=[list_tof tof];
            
 


            if bool_plot
                

                vect_sc = kep2car(kep_SC_inter,muSun);
                vect_pl = kep2car(kep_Mars_inter,muSun);
                vect_ini= kep2car([a_SC e_SC 0 0 0 theta_1], muSun);

                color='g';
                plotEllipse_SC(kep_SC_inter,0,2*pi, color)
                color='r';
                plotEllipse_SC(kep_Mars_inter,0,2*pi, color)

                quiver(0, 0, vect_ini(1)/au,vect_ini(2)/au, 0,'g')
                quiver(0, 0, vect_sc(1)/au,vect_sc(2)/au, 0,'b')
                quiver(0, 0, vect_pl(1)/au,vect_pl(2)/au, 0,'r')

            end
            end
        end
    end  
    
    if bool_plot
        hold on
        for pl=[3 4]
            plotCircle_PL(pl)
        end
    end


    %tof = (tau_SC + t2 - t1)/(24*3600);
    %tof = (t2 + t1)/(24*3600);
end

