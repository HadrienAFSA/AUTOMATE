function [list_nm] = find_resonance(pl)
% List of resonances used. See AUTOMATE report for references
    
    if pl==1
        list_nm = [1 1; 6 5; 5 4; 4 3; 3 2];
    elseif pl==2
        list_nm = [2 1; 1 1; 3 4; 2 3; 1 2];
    elseif pl==3
        list_nm = [1 1; 2 1; 3 1; 2 3];
    elseif pl==4
        list_nm = [1 1; 2 1; 3 1];
    end
end

