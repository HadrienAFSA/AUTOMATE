function [MA_out] = R2MA(r_x,r_y)
% Computes the Mean anomaly from the r cartesian vector

    MA=atan(abs(r_y/r_x));
    if r_x<0
        if r_y>0
            MA_out=pi-MA;
        else
            MA_out=pi+MA;
        end
    else
        if r_y>0
            MA_out=MA;
        else
            MA_out=2*pi-MA;
        end
    end
end

