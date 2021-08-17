function [varargout]=getAstroConstants(varargin)
% getAstroConstants.m - function wrapper for several common planetary
% constants and parameters
%
% PROTOTYPE: 
%  [value]=getAstroConstants(namePlanet, nameConstant)
%  [value]=getAstroConstants(nameConstant)
%
% DESCRIPTION: 
%  This functions wraps astroConstants.m and ephSS and outputs
%  some of the most common planetary constants or astronomical
%  parameters by inputing strings
%
% INPUT:
% namePlanet        -   string with the name of the planet
% nameConstant:     -   string with the name of the constant 
%           'G'     -   Universal gravity constant (G) [km^3/(kg*s^2)]
%          'AU'     -   Astronomical Unit (AU) [km]
%           'c'     -   Speed of light in the vacuum [km/s]
%          'g0'     -   Standard free fall [m/s^2]
%          'Mu'     -   Gravitational constant of the body in km^3/s^2.
%      'Radius'     -   Equatorial radius of the body in km.
%         'Sma'     -   Semimajor axis in km.
%      'Period'     -   Mean orbital period in seconds.  
%
% OUTPUT:
% valueConstant     -   value of the constant called
%
% EXAMPLE:
% [mu_Earth, sma_Earth] = getAstroConstants('Mars', 'Mu','Sma')
% [speedLight] = getAstroConstants('c')
%
%   
% CALLED FUNCTIONS: astroConstants
%
% AUTHOR:   
%   Joan Pau Sanchez, 15/09/2009, MATLAB, getAstroConstants.m
%   
% CHANGELOG:
%   Joan Pau Sanchez, 17/01/20019, Corrected bug in line 114 (i.e. period)
% REVISION: 
%
%--------------------------------------------------------------------------
% 1. Uploading Set of Planets and Constants
  nameBody = {'Sun' 'Mercury' 'Venus' 'Earth' 'Mars' 'Jupiter' 'Saturn'... 
                'Uranus' 'Neptune' 'Moon'};
  IdBody= [0 1 2 3 4 5 6 7 8 10];         
  nameCon = {'G' 'AU' 'c' 'g0'};
  valueCon= [1 2 5 6];
  namePlanCon = {'mu' 'mass' 'radius' 'sma' 'period'};
%--------------------------------------------------------------------------
% 2. Check Input Arguments
if any(strcmpi(varargin{1},nameBody)) 
    if (nargin-1 ~= nargout)
        msg = ['wrong number of inputs'];
        eid = sprintf('TOOLBOX:%s:propertyError', mfilename);
        error(eid,'%s',msg)
    end
elseif (nargin ~= nargout);
        msg = ['wrong number of inputs'];
        eid = sprintf('TOOLBOX:%s:propertyError', mfilename);
        error(eid,'%s',msg)
end
 conNames = varargin(:);
 ncons    = length(conNames);
%--------------------------------------------------------------------------
% 3. Loading Constants
if strcmpi(varargin{1},nameBody)==0
    for i=1:ncons
        index=find(strcmp(conNames{i},cellstr(nameCon))==1);
        if any(index)
            outValue(i)=astroConstants(valueCon(index));
        else
            msg = ['Input argument does not correspond with the' ... 
                   ' astroConstants data. Doble-check it is not a case problem.'];
            eid = sprintf('TOOLBOX:%s:propertyError', mfilename);
            error(eid,'%s',msg)
        end
    end
end
%--------------------------------------------------------------------------
% 4. Load Planetary Constants
if any(strcmpi(varargin{1},nameBody))
        index=find(strcmpi(conNames{1},nameBody)==1);
        Id_planet=IdBody(index);
        for i=2:ncons
            switch conNames{i}
                case {'Mu','mu'}
                    if Id_planet==0
                        outValue(i-1)= astroConstants(4);
                    else
                        outValue(i-1)= astroConstants(Id_planet+10);
                    end
                 case {'Mass','mass'}
                    if Id_planet==0
                        outValue(i-1)= astroConstants(4)/astroConstants(1);
                    else
                        outValue(i-1)= astroConstants(Id_planet+10)/astroConstants(1);
                    end
                case {'Radius','radius'}
                    if Id_planet==0
                        outValue(i-1)= astroConstants(3);
                    else
                        outValue(i-1)= astroConstants(Id_planet+20);
                    end                    
                case {'sma','Sma'}
                    if (Id_planet==0);  Id_planet = 10; end
                    if (Id_planet==10); Id_planet = 11; end
                    kep_planet=uplanet (0, Id_planet);
                    outValue(i-1)= kep_planet(1);
                case {'period','Period'}
                    if (Id_planet==0);  Id_planet = 10; end
                    if (Id_planet==10); Id_planet = 11; end
                    kep_planet=uplanet (0, Id_planet);
                    outValue(i-1)= 2*pi*sqrt(kep_planet(1)^3/astroConstants(4));
                otherwise
                    msg = ['Input argument does not correspond with the' ...
                           ' available planetary data'];
                    eid = sprintf('TOOLBOX:%s:propertyError', mfilename);
                    error(eid,'%s',msg)                    
            end             
        end
        
end
%--------------------------------------------------------------------------
for k=1:length(outValue)
    varargout(k) = {outValue(k)};
end

%%
% Things to do:
% Make sure it complies with the NEW spaceToolBox (e.g., ephSS_kep)