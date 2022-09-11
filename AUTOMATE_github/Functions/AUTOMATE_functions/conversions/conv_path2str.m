function [str] = conv_path2str(path)
%conv_path2str.m - Convert path to string
%
%DESCRIPTION:
%Converts path to sequence string. E.g.: [3 5; 4 6] to 'EM';
%
%INPUTS
%-path:
%   Path in concatenate 1D or 2D format.
%
%OUTPUTS
%-str:
%   String of planets.
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------

    symbol=['Y' 'V' 'E' 'M' 'J' 'S' 'U' 'N'];
    
    str='';
    
    for i=1:length(path)
        tmp=sprintf('%g',path(i));
        str(i)=symbol(sscanf(tmp(1),'%g'));
    end
end

