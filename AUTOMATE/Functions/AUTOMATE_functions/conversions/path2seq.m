function [seq] = path2seq(path)

    seq=[];

    for i=1:length(path)
        tmp_str=sprintf('%.10e',path(i));
        seq=[seq; [sscanf(tmp_str(1),'%g')  sscanf(tmp_str(2:end), '%g')]];

        % Slow version
        %tmp_str=num2str(path(i));
        %seq=[seq; [str2num(tmp_str(1)) str2num(tmp_str(2:end))]];
    end
end

