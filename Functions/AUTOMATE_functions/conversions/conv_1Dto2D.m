function [seq] = conv_1Dto2D(path)
%conv_1Dto2D.m - Convert 1D path format to 2D
%
%DESCRIPTION:
%Converts path in the format [pl_ID1+vinf1 pl_ID1+vinf2 ...] to the format:
%[pl_ID1 vinf1; pl_ID2 vinf2; ...]. E.g.: [35 47] for Earth 5km/s to Mars 
%7km/s to [3 5; 4 7].
%
%INPUTS
%-path:
%   Path in concatenate 1D format.
%
%OUTPUTS
%-seq:
%   Path in 2D format.
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    seq=[];

    for i=1:length(path)
        tmp_str=sprintf('%.10e',path(i));
        seq=[seq; [sscanf(tmp_str(1),'%g')  sscanf(tmp_str(2:end), '%g')]];

        % Slow version
        %tmp_str=num2str(path(i));
        %seq=[seq; [str2num(tmp_str(1)) str2num(tmp_str(2:end))]];
    end
end

