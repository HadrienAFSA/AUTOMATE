function [ID] = generate_ID(pl, vinf)
%generate_ID.m - Generate ID
%
%DESCRIPTION:
%Generates the ID of a node (pl, vinf) by concatenating the planet ID and the vinf
%
%INPUTS
%-pl:
%   Planet ID.
%-vinf (km/s):
%   Infinity velocity.
%%
%OUTPUTS
%-ID:
%   ID of the node. E.g., for node (3, 5.5), the ID is 35.5.
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------
    
    % Converts in string and concat (doesn't use num2str or strcat as they
    % are slow)
    pl_str=sprintf('%d',pl);
    vinf_str=sprintf('%g',vinf);
    
    % Only for integers Vinf, doesn't work for floats
    %pl_str=dec2base(next_pl,10);
    %vinf_str=dec2base(next_Vinf,10);
    
    ID = [pl_str vinf_str];

    ID = sscanf(ID,'%f');
    
    
    % Slow version
    %ID = strcat(num2str(next_pl),num2str(next_Vinf));
    %ID = str2double(ID);
end

