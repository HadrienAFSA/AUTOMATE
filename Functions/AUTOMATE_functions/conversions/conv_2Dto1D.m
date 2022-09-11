function [path] = conv_2Dto1D(seq)
%conv_2Dto1D.m - Convert 2D path format to 1D
%
%DESCRIPTION:
%Converts path in the format [pl_ID1 vinf1; pl_ID2 vinf2; ...] to the format
%[pl_ID1+vinf1 pl_ID1+vinf2 ...]. E.g.: [3 5; 4 7] for Earth 5km/s to Mars 
%7km/s to [35 47].
%
%INPUTS
%-seq:
%   Path in 2D format.
%
%OUTPUTS
%-path:
%   Path in concatenate 1D format.
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    path=[];
    
    for i=1:size(seq,1)
        tmp_str=[sprintf('%g',seq(i,1)) sprintf('%g\n',seq(i,2))];
        path=[path, sscanf(tmp_str,'%f');];
        
        % Slow version
        %path=[path, str2num(strcat(num2str(seq(i,1)),num2str(seq(i,2))))];
    end
end

