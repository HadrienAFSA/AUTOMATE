function [] = plotTrip(planets, v_inf_levels, path, Grid)
% Plot the path on the Tisserand graph
    
    au=149597870.7;
        
    % Converts the path to a readable format and deletes duplicates due to
    % resonances
    sequence=path2seq(unique(path, 'stable'));

    x=[];
    y=[];
    
    for i=1:size(sequence,1)
        %Draws the starting and arriving contour
        if i==1 | i==size(sequence,1)
            [ra, rp]=modified_generateContours(sequence(i,1), sequence(i,2), 0, pi);
            plot(ra/au, rp/au, 'k', 'LineWidth', 2);      
            
        %Draws the intermediate contours
        else
            %Finds the first intersection
            if sequence(i-1,1)<sequence(i,1)    %From inner to outer planet
                int_prec =  Grid(:,1)== sequence(i-1,1)& ...
                            Grid(:,4)==sequence(i,1) & ...
                            Grid(:,3)==sequence(i-1,2) & ...
                            Grid(:,6)==sequence(i,2);
                idx_prec = 5;
            else                                %From outer to inner planet
                int_prec =  Grid(:,1)== sequence(i,1)& ...
                            Grid(:,4)==sequence(i-1,1) & ...
                            Grid(:,3)==sequence(i,2) & ...
                            Grid(:,6)==sequence(i-1,2);
                idx_prec = 2;
            end
            Grid_prec=Grid(int_prec,:);
            
            %Finds the second intersection
            if sequence(i,1)<sequence(i+1,1)    %From inner to outer planet
                int_after =  Grid(:,1)== sequence(i,1)& ...
                            Grid(:,4)==sequence(i+1,1) & ...
                            Grid(:,3)==sequence(i,2) & ...
                            Grid(:,6)==sequence(i+1,2);
                idx_after = 2;
            else                                %From outer to inner planet
                int_after =  Grid(:,1)== sequence(i+1,1)& ...
                            Grid(:,4)==sequence(i,1) & ...
                            Grid(:,3)==sequence(i+1,2) & ...
                            Grid(:,6)==sequence(i,2);
                idx_after = 5;
            end
            Grid_after=Grid(int_after,:);

            %Draws the contour between the two intersections
            [ra, rp]=modified_generateContours(sequence(i,1), sequence(i,2), Grid_prec(idx_prec), Grid_after(idx_after));
            plot(ra/au, rp/au, 'r', 'LineWidth', 2);
        end
    end
end

