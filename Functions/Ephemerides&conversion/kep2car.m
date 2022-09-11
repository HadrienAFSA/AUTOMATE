function out = kep2car(kep,mu,p)

% kep2car.m - Convertion from Keplerian orbital elements to Cartesian
%   position and velocity.
%
% PROTOTYPE:
%   out = kep2car(kep, mu, p)
%
% DESCRIPTION:
%   Converts from Keplerian orbital elements to Cartesian position and
%   velocity. All units to be consistent each other. Angles in radians.
%   Note: In the case of hyperbola, theta must be such that the point is on
%       the physical leg of the hyperbola (the leg around the attracting
%       mass).
%  
% INPUT:
%	kep[6]      Vector of keplerian elements: [a e i Om om theta], where
%               theta is the true anomaly. a in [L], angles in [rad].
%               In case of hyperbola (e>1), it must be: kep(1)<0.
%   mu          Planetary gravity constant [L^3/(M*T^2)].
%   p           Semi-latus rectum [L]. Only used for parabola case.
%
% OUTPUT:
% 	out[1,6]    State vector in cartesian coordinates (position [L],
%               velocity [L/T]).
%
% CALLED FUCTIONS:
%   (none)
%
% REFERENCES:
%	ASCL, "ToolboxManual", cap 2, 2010 - for setting on threshold on the
%       eccentricity for considering the orbit to be parabolic.
%
% AUTHOR:
%   Massimiliano Vasile, 2002, MATLAB, kep2car.m
%
% PREVIOUS VERSION:
%   Massimiliano Vasile, 2002, MATLAB, kep2cart.m
%       - Header and function name in accordance with guidlines.
%
% CHANGELOG:
%   12/02/2007, REVISION: Matteo Ceriotti
%   17/04/2007, Camilla Colombo, Matteo Ceriotti: checked case of the
%   	non-physical leg of the hyperbola and added note.
%   27/02/2008, Matteo Ceriotti, Daniel Novak: added the parabolic case, in
%     	which kep(1)=rp.
%   30/09/2009, Camilla Colombo: Header and function name in accordance
%       with guidlines.
%   12/11/2009, Matteo Ceriotti, Jeannette Heiligers: changed the criterion
%       to fall into the parabolic case from e==1 to e>=0.99999999999999999
%       to prevent singularities with highly eccentric orbits. Added the
%       semi-latus rectum to the input to eliminate the assumption
%       kep(1)=rp.
%   07/10/2010, Matteo Ceriotti:
%       - Added condition on parabolic case for eccentricity to be smaller
%         than (1+elimitpar). This corrects a bug that made function not
%         working on all hyperbolic orbits.
%       - Removed "if nargin < 3" that made function use input p value even
%         if not parabola.
%
% -------------------------------------------------------------------------

% Threshold on the eccentricity for considering the orbit to be parabolic
%   Reference to report ToolboxTest cap 1.

%elimitpar = 0.99999999999999999;
% ---> CL: 07/10/2010, Matteo Ceriotti: changed way of expressing elimitpar
elimitpar = 1e-17;

e   = kep(2);
i   = kep(3);
Om  = kep(4);
om  = kep(5);
tho = kep(6);

% Rotation matrix
R(1,1) = cos(om)*cos(Om)-sin(om)*cos(i)*sin(Om);
R(2,1) = cos(om)*sin(Om)+sin(om)*cos(i)*cos(Om);
R(3,1) = sin(om)*sin(i);

R(1,2) = -sin(om)*cos(Om)-cos(om)*cos(i)*sin(Om);
R(2,2) = -sin(om)*sin(Om)+cos(om)*cos(i)*cos(Om);
R(3,2) = cos(om)*sin(i);

R(1,3) = sin(i)*sin(Om);
R(2,3) = -sin(i)*cos(Om);
R(3,3) = cos(i);

% In plane Parameters
% ---> CL: 07/10/2010, Matteo Ceriotti: added condition e <= (1+elimitpar)
if e >= (1-elimitpar) && e <= (1+elimitpar) % Parabola
    if nargin < 3
        error('Parabolic case: the semi-latus rectum needs to be provided')
    end
else
    % ---> CL: 07/10/2010, Matteo Ceriotti: Removed if nargin < 3. p shall
    % be computed even if it is given, if it is not a parabola.
    p = kep(1)*(1-e^2);     % Value of p in the input is not considered and overwritten with this one
end

r = p/(1+e*cos(tho));
xp = r*cos(tho);
yp = r*sin(tho);
wom_dot = sqrt(mu*p)/r^2;
r_dot   = sqrt(mu/p)*e*sin(tho);
vxp = r_dot*cos(tho)-r*sin(tho)*wom_dot;
vyp = r_dot*sin(tho)+r*cos(tho)*wom_dot;

% 3D cartesian vector
out(1) = R(1,1)*xp+R(1,2)*yp;
out(2) = R(2,1)*xp+R(2,2)*yp;
out(3) = R(3,1)*xp+R(3,2)*yp;

out(4) = R(1,1)*vxp+R(1,2)*vyp;
out(5) = R(2,1)*vxp+R(2,2)*vyp;
out(6) = R(3,1)*vxp+R(3,2)*vyp;

return
