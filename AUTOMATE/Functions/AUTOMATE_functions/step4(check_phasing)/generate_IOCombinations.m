function [IOcombinations, idx_shift] = generate_IOCombinations(fixed_Paths,max_depth)

%generate_IOCombinations.m - Generate I/O combinations
%
%DESCRIPTION:
%Generates all Inbound/Outbound combination for a given length of a
%sequence, to be used with Step 4 of the AUTOMATE algorithm, fix_Phasing.m
%
%INPUTS
%-fixed_Paths:
%   Cell containing lists of fixed paths, obtained from fix_Paths.m
%-max_depth:
%   Maximum depth of the tree search, also given as input of Step 1
%   (generate_Paths.m)
%
%OUTPUTS
%-IOcombinations:
%   Cell containing lists of possible IO combination, for all the sequences
%   length of fixed_Paths
%-idx_shift:
%   Index shift to correctly use the IOcombination cell. Used by Step 4
%   (fix_Phasing.m)
%
%AUTHOR
%Hadrien AFSA
%
%--------------------------------------------------------------------------
    
    min_length=2*max_depth;
    max_length=0;
    for i=1:length(fixed_Paths)
        if length(fixed_Paths{i})<min_length
            min_length=length(fixed_Paths{i});
        end
        if length(fixed_Paths{i})>max_length
            max_length=length(fixed_Paths{i});
        end
    end
    
    range=min_length:max_length;

    IOcombinations=cell(length(range),1);
    for i=1:length(range)
        IOcombinations{i}=dec2bin(0:2^range(i)-1)-'0';
    end
    
    % Shift of the index to get the combinations for the lowest length from
    % IOcombinations{1}
    idx_shift=min_length-1;
end

