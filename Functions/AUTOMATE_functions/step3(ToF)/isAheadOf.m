function [bool] = isAheadOf(theta1,theta2)
%isAheadOf.m  
%DESCRIPTION:
%Checks if theta2 is ahead of theta1 on an orbit (i.e. if the theta1-theta2
%angle is less than the theta2-theta1 angle).
%
%INPUTS
%-theta1, theta2 (rad):
%   Anomalies of the orbit.
%
%OUTPUTS
%-bool:
%   Boolean. 0 if theta1 is not ahead of theta2, 1 if it is.
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    if theta2<theta1
        if abs(theta2-theta1) < abs(2*pi-max(theta2,theta1)+min(theta2,theta1))
            bool=false;
        else
            bool=true;
        end
    else
        if abs(theta2-theta1) < abs(2*pi-max(theta2,theta1)+min(theta2,theta1))
            bool=true;
        else
            bool=false;
        end
    end
end

