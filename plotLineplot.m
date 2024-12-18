function plotLineplot(data1, data2, titlestr, plims, ylabl, legnds)
    % Create the figure
    figure;
    x = 1:10;
    % plot data 1
    errorbar(x, mean(data1, 2), std(data1, 0, 2), 'o-', 'LineWidth', 1, 'MarkerSize', 6);
    hold on;
    % plot data 2
    errorbar(x, mean(data2, 2), std(data2, 0, 2), 'o-', 'LineWidth', 1, 'MarkerSize', 6);
    ylim(plims);
    xticks(x); 
    xticklabels({'s-01', 's-02', 's-03', 's-04', 's-05', 's-06', 's-07', 's-08', 's-09', 's-10'}); % Custom labels
    xlabel('Sessions');
    ylabel(ylabl);
    title(titlestr);
    
    % Add a legend
    legend(legnds{1}, legnds{2}, 'Location', 'Best');
    % Increase font size for readability
    set(gca, 'FontSize', 12);
end 