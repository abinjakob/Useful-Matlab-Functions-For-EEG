function plotHeatmap(data, title, plims)
    % row and column labels
    rowLabels = {'S-01', 'S-02', 'S-03', 'S-04', 'S-05', 'S-06', 'S-07', 'S-08', 'S-09', 'S-10'};
    colLabels = {'Block 1', 'Block 2', 'Block 3', 'Block 4'};
    figure;

    % Create the heatmap
    h = heatmap(colLabels, rowLabels, round(data, 3));
    
    % Add title and adjust colormap
    h.Title = title;
    h.XLabel = 'Block';
    h.YLabel = 'Session';
    h.ColorbarVisible = 'on';
    h.Colormap = flipud(winter);
%     h.Colormap = jet;

    
    h.ColorLimits = plims; 
    h.GridVisible = 'off';
end 