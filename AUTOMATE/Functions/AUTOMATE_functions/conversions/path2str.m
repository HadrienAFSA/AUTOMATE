function [str] = path2str(path)

    symbol=['Y' 'V' 'E' 'M' 'J' 'S' 'U' 'N'];
    
    str='';
    
    for i=1:length(path)
        tmp=sprintf('%g',path(i));
        str(i)=symbol(sscanf(tmp(1),'%g'));
    end
end

