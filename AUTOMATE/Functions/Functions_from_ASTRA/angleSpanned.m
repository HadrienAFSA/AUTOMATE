function [dth] = angleSpanned(th1, th2)

if th1 >= 0 && th1 <= pi && th2 >= 0 && th2 <= pi
    if th2 > th1
        dth = th2 - th1;
    else
        dth = 2*pi - th1 + th2;
    end
elseif th1 >= 0 && th1 <= pi && th2 > pi && th2 <= 2*pi
    dth = th2 - th1;
elseif th1 > pi && th1 <= 2*pi && th2 > pi && th2 <= 2*pi
    if th2 > th1
        dth = th2 - th1;
    else
        dth = 2*pi - th1 + th2;
    end
elseif th1 > pi && th1 <= 2*pi && th2 >= 0 && th2 <= pi
    dth = (2*pi - th1) + th2;
end

end