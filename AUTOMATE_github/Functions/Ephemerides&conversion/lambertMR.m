function [VI, VF] = lambertMR(RI, RF, TOF, MU, Nrev, Ncase)

% lambertMR.m - Lambert's problem solver for all possible transfers
%   (multi-revolution transfer included).
%
% PROTOTYPE:
%   [A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(RI,RF,TOF,MU,orbitType,Nrev,Ncase,optionsLMR)
%
% DESCRIPTION:
%   Lambert's problem solver for all possible transfers:
%       1- zero-revolution (for all possible types of orbits: circles, ellipses,
%       	parabolas and hyperbolas)
%       2- multirevolution case
%       3- inversion of the motion
%
%   1- ZERO-REVOLUTION LAMBERT'S PROBLEM
%
%   For the solution of Lambert's problem with number of revolution = 0 the
%   subroutine by Chris D'Souza is included here.
%   This subroutine is a Lambert algorithm which given two radius vectors
%   and the time to get from one to the other, it finds the orbit
%   connecting the two. It solves the problem using a new algorithm
%   developed by R. Battin. It solves the Lambert problem for all possible
%   types of orbits (circles, ellipses, parabolas and hyperbolas).
%   The only singularity is for the case of a transfer angle of 360 degrees,
%   which is a rather obscure case.
%   It computes the velocity vectors corresponding to the given radius
%   vectors except for the case when the transfer angle is 180 degrees
%   in which case the orbit plane is ambiguous (an infinite number of
%   transfer orbits exist).
% 
%   2- MULTIREVOLUTION LAMBERT'S PROBLEM
%
%   For the solution of Lambert's problem with Nrev>0 number of revolution,
%   Battin's formulation has been extended to accomodate N-revolution
%   transfer orbits, by following the paper: "Using Battin Mathod to obtain 
%   Multiple-revolution Lambert's Solutions" by Shen and Tsiotras.
%
%   When Nrev>0 the possible orbits are just ellipses.
%   If 0<=Nrev<=Nmax, there are two Nrev-revolution transfer orbits.
%   These two transfer orbits have different semi-major axis and they may 
%   be all combinations of large-e and small-e transfer orbits.
%   The Original Successive Substitution Method by Battin converges to one
%   of the two possible solution with a viable initial guest, however it
%   diverges from the other one. Then a Reversed Successive Substitution is
%   used to converge to the second solution.
%   A procedure is implemented in order to guarantee to provide initial
%   guesses in the convergence region. If Nrew exceeds the maximum number
%   of revolution an ERROR is given:
%   warning('off','lambertMR:SuccessiveSubstitutionDiverged') to take out
%   the warnings or use optionsLMR(1) = 0.
% 
%   3- INVERSION OF THE MOTION
% 
%   Direct or retrograde option can be selected for the transfer.
%   
%   The algorithm computes the semi-major axis, the parameter (semi-latus 
%   rectum), the eccentricity and the velocity vectors.
% 
%   NOTE: If ERROR occurs or the 360 or 180 degree transfer case is 
%   encountered. 
%
% INPUT:
%	RI[3]           Vector containing the initial position in Cartesian
%                   coordinates [L].
%	RF[3]           Vector containing the final position vector in
%                   Cartesian coordinates [L].
%	TOF[1]          Transfer time, time of flight [T].
%  	MU[1]           Planetary constant of the planet (mu = mass * G) [L^3/T^2]
%	orbitType[1]    Logical variable defining whether transfer is
%                       0: direct transfer from R1 to R2 (counterclockwise)
%                       1: retrograde transfer from R1 to R2 (clockwise)
%	Nrev[1]         Number of revolutions.
%                   if Nrev = 0 ZERO-REVOLUTION transfer is calculated
%                   if Nrev > 0 two transfers are possible. Ncase should be
%                          defined to select one of the two.
%	Ncase[1]        Logical variable defining the small-a or large-a option
%                   in case of Nrev>0:
%                       0: small-a option
%                       1: large-a option
%	optionsLMR[1]	lambertMR options:
%                    optionsLMR(1) = display options:
%                                    0: no display
%                                    1: warnings are displayed only when
%                                       the algorithm does not converge
%                                    2: full warnings displayed
%
% OUTPUT:
%	A[1]        Semi-major axis of the transfer orbit [L].
% 	P[1]        Semi-latus rectum of the transfer orbit [L].
%  	E[1]        Eccentricity of the transfer orbit.
%	ERROR[1]	Error flag
%                   0:	No error
%                   1:	Error, routine failed to converge
%                   -1:	180 degrees transfer
%                   2:  360 degrees transfer
%                   3:  the algorithm doesn't converge because the number 
%                       of revolutions is bigger than Nrevmax for that TOF
%                   4:  Routine failed to converge, maximum number of
%                       iterations exceeded.
%	VI[3]       Vector containing the initial velocity vector in Cartesian
%               coordinates [L/T].
%	VT[1]		Vector containing the final velocity vector in Cartesian
%               coordinates [L/T].
%	TPAR[1] 	Parabolic flight time between RI and RF [T].
%	THETA[1]	Transfer angle [radians].
%
% NOTE: The semi-major axis, positions, times, and gravitational parameter
%       must be in compatible units.
%
% CALLED FUNCTIONS:
%   qck, h_E (added at the bottom of this file)
%
% FUTURE DEVELOPMENT:
%   - 180 degrees transfer indetermination
%   - 360 degrees transfer singularity
%   - Nmax number of max revolution for a given TOF:
%     work in progress - Camilla Colombo
%
% -------------------------------------------------------------------------

if Nrev == 0 % ZERO REVOLUTIONS
    
    nitermax = 2000; % Maximum number of iterations for loops
    TOL      = 1e-14;

    TWOPI = 2*pi;
    PI    = TWOPI/2;

    % Reset
    VI = [0, 0, 0];
    VF = [0, 0, 0];

    % ----------------------------------
    % Compute the vector magnitudes and various cross and dot products

    RIM2   = dot(RI,RI);
    RIM    = sqrt(RIM2);
    RFM2   = dot(RF,RF);
    RFM    = sqrt(RFM2);
    CTH    = dot(RI,RF)/(RIM*RFM);
    CR     = cross(RI,RF);
    STH    = norm(CR)/(RIM*RFM);
    if CR(3) < 0 % always direct transfer
        STH = -STH;
    end

    THETA  = (atan2(STH,CTH));
    THETA = THETA - (TWOPI * (fix(THETA/TWOPI) + min([0,sign(THETA)])));

    if THETA == TWOPI || THETA == 0
        VI=[0,0,0]; VF=[0,0,0]; 
        return
    end

    B1     = sign(STH); if STH == 0; B1 = 1; end

    % ----------------------------------
    % Compute the chord and the semi-perimeter

    C = sqrt(RIM2 + RFM2 - 2*RIM*RFM*CTH);
    S = (RIM + RFM + C)/2;
    LAMBDA = B1*sqrt((S-C)/S);

    if 4*TOF*LAMBDA == 0 || abs((S-C)/S) < TOL
        VI=[0,0,0]; VF=[0,0,0]; 
        return
    end

    % ----------------------------------
    % Compute L carefully for transfer angles less than 5 degrees

    if THETA*180/PI <= 5
       W   = atan((RFM/RIM)^.25) - PI/4;
       R1  = (sin(THETA/4))^2;
       S1  = (tan(2*W))^2;
       L   = (R1+S1)/(R1+S1+cos(THETA/2));
    else
       L   = ((1-LAMBDA)/(1+LAMBDA))^2;
    end

    M      = 8*MU*TOF^2/(S^3*(1+LAMBDA)^6);
    TPAR   = (sqrt(2/MU)/3)*(S^1.5-B1*(S-C)^1.5);
    L1     = (1 - L)/2;

    CHECKFEAS = 0;

    % ----------------------------------
    % Initialize values of y, n, and x

    Y  = 1;
    N  = 0;
    N1 = 0;

    if (TOF-TPAR) <= 1e-3
        X0  = 0;
    else
        X0  = L;
    end

    X= -1.e8;

    % ----------------------------------
    % Begin iteration

    while (abs(X0-X) >= abs(X)*TOL+TOL) && (N <= nitermax)
        N   = N+1;
        X   = X0;
        ETA = X/(sqrt(1+X) + 1)^2;
        CHECKFEAS=1;

        % ----------------------------------
        % Compute x by means of an algorithm devised by
        % Gauticci for evaluating continued fractions by the
        % 'Top Down' method

        DELTA = 1;
        U     = 1;
        SIGMA = 1;
        M1    = 0;

        while abs(U) > TOL && M1 <= nitermax
            M1    = M1+1;
            GAMMA = (M1 + 3)^2/(4*(M1+3)^2 - 1);
            DELTA = 1/(1 + GAMMA*ETA*DELTA);
            U     = U*(DELTA - 1);
            SIGMA = SIGMA + U;
        end

        C1 = 8*(sqrt(1+X)+1)/(3+1/(5 + ETA + (9*ETA/7)*SIGMA));

        % ----------------------------------
        % Compute H1 and H2

        if N == 1
            H1 = (L+X)^2*(C1 + 1 + 3*X)/((1 + 2*X + L)*(3*C1 + X*C1 +4*X));
            H2 = M*(C1+X-L)/((1 + 2*X + L)*(3*C1 + X*C1 +4*X));
        else
            QR = sqrt(L1^2 + M/Y^2);
            H1 = (((QR - L1)^2)*(C1 + 1 + 3*X))/((2*QR)*(3*C1 + X*C1+4*X));
            H2 = M*(C1+X-L)/((2*QR)*(3*C1 + X*C1+4*X));
        end

        B = 27*H2/(4*(1+H1)^3);
        U = -B/(2*(sqrt(B+1)+1));

        % ----------------------------------
        % Compute the continued fraction expansion K(u)
        % by means of the 'Top Down' method

        DELTA = 1;
        U0    = 1;
        SIGMA = 1;
        N1    = 0;

        while N1 < nitermax && abs(U0) >= TOL
            if N1 == 0
                GAMMA = 4/27;
                DELTA = 1/(1-GAMMA*U*DELTA);
                U0 = U0*(DELTA - 1);
                SIGMA = SIGMA + U0;
            else
                for I8 = 1:2
                    if I8 == 1
                        GAMMA = 2*(3*N1+1)*(6*N1-1)/(9*(4*N1 - 1)*(4*N1+1));
                    else
                        GAMMA = 2*(3*N1+2)*(6*N1+1)/(9*(4*N1 + 1)*(4*N1+3));
                    end
                    DELTA = 1/(1-GAMMA*U*DELTA);
                    U0 = U0*(DELTA-1);
                    SIGMA = SIGMA + U0;
                end
            end

            N1 = N1 + 1;
        end

        KU = (SIGMA/3)^2;
        Y = ((1+H1)/3)*(2+sqrt(B+1)/(1-2*U*KU));    % Y = Ycami

        X0 = sqrt(((1-L)/2)^2+M/Y^2)-(1+L)/2;
    end

    % ----------------------------------
    % Compute the velocity vectors

    if CHECKFEAS == 0
        VI=[0,0,0]; VF=[0,0,0]; 
        return
    end

    if N1 >= nitermax || N >= nitermax
        VI=[0,0,0]; VF=[0,0,0];
        return
    end

    R11 = (1 + LAMBDA)^2/(4*TOF*LAMBDA);
    S11 = Y*(1 + X0);
    T11 = (M*S*(1+LAMBDA)^2)/S11;

    VI(1) = -R11*(S11*(RI(1)-RF(1))-T11*RI(1)/RIM);
    VI(2) = -R11*(S11*(RI(2)-RF(2))-T11*RI(2)/RIM);
    VI(3) = -R11*(S11*(RI(3)-RF(3))-T11*RI(3)/RIM);

    VF(1) = -R11*(S11*(RI(1)-RF(1))+T11*RF(1)/RFM);
    VF(2) = -R11*(S11*(RI(2)-RF(2))+T11*RF(2)/RFM);
    VF(3) = -R11*(S11*(RI(3)-RF(3))+T11*RF(3)/RFM);

    
else % MULTIREVOLUTIONS
    
    if Ncase == 0
        m = -Nrev;
    else
        m = Nrev;
    end
    
    [VI,VF] = lambert(RI, RF, TOF, m, MU);
    
end

return
