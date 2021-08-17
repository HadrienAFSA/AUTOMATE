function [path] = seq2path(seq)

    path=[];
    
    for i=1:size(seq,1)
        tmp_str=[sprintf('%g',seq(i,1)) sprintf('%g\n',seq(i,2))];
        path=[path, sscanf(tmp_str,'%f');];
        
        % Slow version
        %path=[path, str2num(strcat(num2str(seq(i,1)),num2str(seq(i,2))))];
    end
end

