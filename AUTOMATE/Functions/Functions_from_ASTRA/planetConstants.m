function [muPL, radius, sma, rpMin, raMin, hmin] = planetConstants(idPL)

% constants of planets in the solar system

CONSTANTS = [22032.8921800000,2440,57909126.3109510;
             324855.044150000,6051.80000000000,108208867.170024;
             398600.446192176,6378.16000000000,149597905.107510;
             42828.0184128135,3389.92000000000,227940540.100692;
             126685793.740000,69911,778292047.786863;
             37931005.1140000,58232,1429369806.27721;
             5793943.34880000,25362,2874992822.81450;
             6834733.93700000,24624,4504327559.69260];
         
         % Y   % V   % E   % M    % J       % S      % U       % N
HMIN = [ 200   200   200   200  69911*5   58232*2   25362    24624];

muPL   = CONSTANTS(idPL, 1);
radius = CONSTANTS(idPL, 2);
sma    = CONSTANTS(idPL, 3); % assumed constant in uplanet ephemerides
hmin   = HMIN(idPL);       

% min RP/RA for planet in the 2000-2100 timeframe -> assume these define
% the circular path for the given planet
rpMIN = [45999824.3603811;
         107475964.076118;
         147098256.656908;
         206628847.246249;
         740419402.555503;
         1349973898.45798;
         2741829201.37164;
         4463744955.71266];
     
raMIN = [69817248.6526180;
         108936633.913632;
         152091243.817671;
         249231300.491516;
         816038014.079576;
         1508268752.48885;
         3008080691.07147;
         4544881678.30505];

rpMin = rpMIN(idPL,:);
raMin = raMIN(idPL,:);

end