function [nodes] = generate_ChildNodes(current, Grid, max_depth, obj_planet)
% Generates the child nodes of the current node

    depth=current(1);
    planet=current(2);
    Vinf=current(3);
    
    % Find the intersections with inner planets
    int_prec = Grid(:,4)== planet & Grid(:,6)== Vinf;
    grid_inter_prec = Grid(int_prec,:);
    
    nodes_temp1=zeros(size(grid_inter_prec,1),3);
    nodes_temp1_idx=1;
    
    for i=1:size(grid_inter_prec,1)
        if size(grid_inter_prec,2)>0
            % Only takes nodes that are Jupiter for the last planet
            if depth+1==max_depth && grid_inter_prec(i,1)==obj_planet
                %ID = generate_ID(grid_inter_prec(i,1), grid_inter_prec(i,3));
                nodes_temp1(nodes_temp1_idx,:)=[depth+1 grid_inter_prec(i,1) grid_inter_prec(i,3)];
                nodes_temp1_idx=nodes_temp1_idx+1;
            else
                %ID = generate_ID(grid_inter_prec(i,1), grid_inter_prec(i,3));
                nodes_temp1(nodes_temp1_idx,:)=[depth+1 grid_inter_prec(i,1) grid_inter_prec(i,3)];
                nodes_temp1_idx=nodes_temp1_idx+1;
            end
        end
    end
    
    % Find intersections with outer planets
    int_after = Grid(:,1)== planet & Grid(:,3)== Vinf;
    grid_inter_after = Grid(int_after,:);
    
    nodes_temp2=zeros(size(grid_inter_after,1),3);
    nodes_temp2_idx=1;
    
    for i=1:size(grid_inter_after,1)
        if size(grid_inter_after,2)>0
            if depth+1==max_depth && grid_inter_after(i,1)==obj_planet
                %ID = generate_ID(grid_inter_after(i,4), grid_inter_after(i,6));
                nodes_temp2(nodes_temp2_idx,:)=[depth+1 grid_inter_after(i,4) grid_inter_after(i,end)];
                nodes_temp2_idx=nodes_temp2_idx+1;
            else
                %ID = generate_ID(grid_inter_after(i,4), grid_inter_after(i,6));
                nodes_temp2(nodes_temp2_idx,:)=[depth+1 grid_inter_after(i,4) grid_inter_after(i,end)];
                nodes_temp2_idx=nodes_temp2_idx+1;
            end
        end
    end

    nodes=[nodes_temp1; nodes_temp2];
    %nodes=nodes_temp;
end

