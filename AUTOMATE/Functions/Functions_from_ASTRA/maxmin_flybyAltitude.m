function [hmin, hmax] = maxmin_flybyAltitude(pl)

% maximum and minimum flyby altitudes for the Solar System planets

        % Y   % V   % E   % M    % J       % S      % U       % N
HMIN = [ 200   200   200   200  69911*5   58232*2   25362    24624];
HMAX = [35000 35000 35000 35000 69911*200 58232*100 25362*10 24624*10];

hmin = HMIN(pl);
hmax = HMAX(pl);

end