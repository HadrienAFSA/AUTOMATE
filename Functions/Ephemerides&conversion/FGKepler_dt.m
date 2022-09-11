function [r_f_v, rdot_f_v] = FGKepler_dt(r_v,rdot_v, deltaT, mu)
%FGKepler_dt.m - FGKepler_dt
%
%DESCRIPTION
%Propagate the initial position of r0_v with initial speed
%r0dot_v with the transfer time deltaT
%
%INPUTS
%-r_v [3] (in km):
%   Departure position
%-rdot_v [3] (in km/s):
%   Departure speed
%-deltaT [1] (in sec):
%   Transfer time
%-mu [1] (in km3/s2):
%   The Standard Gravitational Parameter of the orbiting body
%
%OUTPUTS
%-r_f_v [3] (in km):
%   Final position after propagation
%-rdot_f_v [3] (in km/s):
%   Final speed after propagation
%
%USED FUNCTIONS
%fzero.
%
%AUTHOR
%Hadrien AFSA

    r=norm(r_v);
    rdot=norm(rdot_v);

    a=mu/(2*mu/r - rdot^2);
    n=sqrt(mu/a^3);
    sigma0=dot(r_v, rdot_v)/sqrt(mu);

    % Solves Kepler's equation to find eccentric anomaly
    deltaM=n*deltaT;
    fdE=@(x) x-(1-r/a)*sin(x) - sigma0*(cos(x)-1)/sqrt(a)-deltaM;
    deltaE=fzero(fdE, deltaM);
    
    F=1-a*(1-cos(deltaE))/r;
    G=deltaT+sqrt(a^3/mu)*(sin(deltaE)-deltaE);
    
    r_f_v=F*r_v+G*rdot_v;
    
    Gdot=1-a*(1-cos(deltaE))/norm(r_f_v);
   
    rdot_f_v=(Gdot*r_f_v-r_v)/G;
end

