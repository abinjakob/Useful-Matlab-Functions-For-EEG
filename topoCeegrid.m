%   This function creates a topographical plot of cEEGrid data on a 2D 
%   layout of electrode positions. 
%
% Inputs:
%   - data: A vector containing the values to be plotted
%
%   - channel_names: A cell array of strings containing the names of the 
%                    channels (e.g., 'L1', 'R2', etc.).
%
%   - title_text: A string specifying the title of the plot. This will be 
%                 displayed at the top of the figure.
%
%   - clim: (Optional) A two-element vector specifying custom color limits 
%           for the plot. 
%
% Usage: topoCeegrid(data, channel_names, title_text, clim);

function topoCeegrid(data, channel_names, title_text, clim)

    % default channels of cEEGrid
    cEEGrid_chans = {'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8', 'L9', 'L10', 'R8', 'R7', 'R6', 'R5', 'R1', 'R4', 'R3', 'R2', 'L1'};

    % cEEGrid locs (assumed 2D locs for plotting)
    electrode_locs = [
        -0.8, 0.8;  % L2
        -0.5, 0.8;  % L3
        -0.3, 0.5;  % L4
        -0.25, 0.15;   % L5
        -0.25, -0.15;   % L6
        -0.3, -0.5;   % L7
        -0.5, -0.8;  % L8
        -0.8, -0.8;   % L9
        -1, -0.4;   % L10
        1, -0.4;   % R8
        0.8, -0.8;   % R7
        0.5, -0.8;   % R6
        0.3, -0.5;   % R5
        1, 0.4;   % R1
        0.3, 0.5;   % R4
        0.5, 0.8;   % R3
        0.8, 0.8;   % R2
        -1, 0.4;   % L1
    ];

    % check if any channels are missing 
    if length(cEEGrid_chans) ~= length(channel_names)
        misschanid = find(~ismember(cEEGrid_chans, channel_names));
        electrode_locs(misschanid, :) = []; 
    end 

    % convert ceegrid_data to a column vector
    data = data(:);

    % define the colormap from blue (low values) to red (high values)
    cmap = jet(256); 

    if nargin < 4 || isempty(clim)
        clim = [min(data), max(data)];
    end

    % create the figure
    figure;
    hold on;
  
    % loop through each electrode and plot a circle
    for i = 1:size(electrode_locs, 1)

        % get normalized value for color mapping
        color_idx = round((data(i) - clim(1)) / (clim(2) - clim(1)) * 255) + 1; 
        % ensuring indices stay within the colormap range
        color_idx = max(1, min(256, color_idx)); 
        
        % define the color for the circle (blue for low, red for high)
        electrode_color = cmap(color_idx, :);
        
        % draw a circle at the electrode location
        pos = [electrode_locs(i,1)-0.05, electrode_locs(i,2)-0.05, 0.1, 0.1]; % Position and size of the circle
        rectangle('Position', pos, 'Curvature', [1, 1], 'FaceColor', electrode_color, 'EdgeColor', 'k'); 
        
        % add electrode label
        text(electrode_locs(i,1), electrode_locs(i,2), channel_names{i}, 'VerticalAlignment', 'bottom', ...
            'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 12);
    end
    
    colorbar;
    colormap(jet); 
    caxis(clim);
    title(title_text);

end
