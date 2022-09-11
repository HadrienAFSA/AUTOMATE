function [a] = fast_wrapToPi(angle)
    
    angle = mod(angle + pi,2*pi);
   
    if (angle < 0.0)
        angle = angle + 2*pi;
    end
    a = angle - pi;

end