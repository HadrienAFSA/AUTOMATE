function [dth] = angleSpanned2(th1, th2)

if th1<=th2
    dth=th2-th1;
else
    dth=2*pi- th1 + th2;
end
end