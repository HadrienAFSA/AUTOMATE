function [bool] = isAheadOf(theta1,theta2)
% Checks if theta2 is ahead of theta1

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

