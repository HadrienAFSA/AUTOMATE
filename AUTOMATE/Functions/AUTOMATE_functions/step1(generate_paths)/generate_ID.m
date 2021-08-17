function [ID] = generate_ID(next_pl, next_Vinf)
% Generates the ID of a node by concatenating the planet ID and the vinf
% (km/s)
    
    % Converts in string and concat (doesn't use num2str or strcat as they
    % are slow)
    pl_str=sprintf('%d',next_pl);
    vinf_str=sprintf('%g',next_Vinf);
    
    % Only for integers Vinf, doesn't work for floats
    %pl_str=dec2base(next_pl,10);
    %vinf_str=dec2base(next_Vinf,10);
    
    ID = [pl_str vinf_str];

    ID = sscanf(ID,'%f');
    
    
    % Slow version
    %ID = strcat(num2str(next_pl),num2str(next_Vinf));
    %ID = str2double(ID);
end

