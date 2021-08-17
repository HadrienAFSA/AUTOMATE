function plotContoursInters(IDS, vinflevels, Grid, plot_inter)
% Plots the contours of the specified planets (IDs) and infinity
% velocities (vinflevels), as well as the intersections.

    hold on;

    au=getAstroConstants('AU');

    for indplanet = 1:length(IDS)
        idpl = IDS(indplanet);

        if idpl == 1
            COLOR = [0 0.45 0.74];
        elseif idpl == 2
            COLOR = [0.64 0.08 0.18];
        elseif idpl == 3
            COLOR = [0 0.5 0];
        elseif idpl == 4
            COLOR = [0.3 0.75 0.93];
        elseif idpl == 5
            COLOR = [0 0 0];
        elseif idpl == 6
            COLOR = [0 0.5 0.2];
        end

        for indi = 1:length(vinflevels)
            [rascCONT, rpscCONT] = generateContours(idpl, vinflevels(indi));

            %
    %         C(1,1)=vinflevels(indi); % data value to plot on the line
    %         C(2,1)=100; % number of data points
    %         C(1,2:101)=rascCONT; % x data points for the red line
    %         C(2,2:101)=rpscCONT;
    %         
    %         clabel(C,h)
            %

            hold on;
            if indi == 1
                plot(rascCONT./au, rpscCONT./au,'Color', COLOR);
            else
                plot(rascCONT./au, rpscCONT./au, 'Color', COLOR, 'handlevisibility', 'off');
            end
        end
    end

    idMIN = min(IDS);
    idMAX = max(IDS);
    XLIM(:,1) = [0.15 0.7 0.9 2 4 9.7]';
    XLIM(:,2) = [0.5  2   2.8 6 6 15]';  
    xlim([XLIM(idMIN,1) XLIM(idMAX,2)]);
    if idMAX >= 5
        ylim([0 2]);
    end

    xlabel('r_a - AU'); ylabel('r_p - AU');

    % Plots the intersections
    if plot_inter
        for i=1:size(Grid,1)
            grid_temp=Grid(i,:);
            [ra,rp]=alphaVinf2raRp(grid_temp(2),grid_temp(3),grid_temp(1));
            plot(ra/au,rp/au,'k.','MarkerSize',10);
        end
    else

end