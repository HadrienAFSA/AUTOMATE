function [diff] = MeanAnDiff(MA1,MA2)
% Computes the difference in angle between 0 and 2pi  
    tmp_diff=abs(MA1-MA2);
    if tmp_diff<pi
        diff=tmp_diff;
    else
        diff=2*pi-tmp_diff;
    end
end

