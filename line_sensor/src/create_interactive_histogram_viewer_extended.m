function create_interactive_histogram_viewer_extended(H, center_of_mass, rising_edges, falling_edges)
    % INTERACTIVE HISTOGRAM VIEWER
    % Creates an interactive plot with slider and center of mass
    
    % Check if optional parameters are provided
    if nargin < 3
        rising_edges = [];
    end
    if nargin < 4
        falling_edges = [];
    end
    
    figure('Name', 'Interactive Histogram Viewer');
    
    % Bar plot for the first histogram
    axes('Position', [0.1 0.3 0.85 0.65]);
    single_bar = bar(H(1,:), 'FaceColor', [0.2 0.4 0.6]);
    ylim([min(H(:)) max(H(:))]);
    xlabel('Sensor Bin');
    ylabel('Reading Value');
    
    % Add center of mass line
    hold on;
    com_line = xline((center_of_mass(1) / 10) + 1, 'r--', 'LineWidth', 2, ...
        'Label', sprintf('CoM: %.1f', center_of_mass(1)));
    
    % Initialize edge line variables
    rising_line = [];
    falling_line = [];
    
    % Add rising edge line if provided
    if ~isempty(rising_edges)
        rising_line = xline((rising_edges(1) / 10) + 1, 'g--', 'LineWidth', 2, ...
            'Label', sprintf('Rising: %.1f', rising_edges(1)));
    end
    
    % Add falling edge line if provided
    if ~isempty(falling_edges)
        falling_line = xline((falling_edges(1) / 10) + 1, 'b--', 'LineWidth', 2, ...
            'Label', sprintf('Falling: %.1f', falling_edges(1)));
    end
    
    hold off;
    title(sprintf('Histogram (index: 1), Center of Mass: %.1f', center_of_mass(1)));
    
    % Slider
    slider = uicontrol('Style', 'slider', ...
        'Min', 1, 'Max', size(H,1), 'Value', 1, ...
        'SliderStep', [1/(size(H,1)-1), 0.1], ...
        'Units', 'normalized', ...
        'Position', [0.2 0.05 0.6 0.05]);
    
    % Slider label
    uicontrol('Style', 'text', 'String', 'Histogram Index:', ...
        'Units', 'normalized', 'Position', [0.2 0.12 0.2 0.05]);
    
    % Callback for updates
    addlistener(slider, 'Value', 'PostSet', @(src, event) ...
        update_histogram_with_com(round(slider.Value), H, center_of_mass, ...
        rising_edges, falling_edges, single_bar, com_line, rising_line, falling_line));
end

function update_histogram_with_com(index, H, center_of_mass, rising_edges, falling_edges, ...
    bar_handle, com_line, rising_line, falling_line)
    % UPDATE HISTOGRAM
    
    % Update bars
    set(bar_handle, 'YData', H(index, :));
    
    % Update center of mass line
    com_pos = (center_of_mass(index) / 10) + 1;
    set(com_line, 'Value', com_pos);
    set(com_line, 'Label', sprintf('CoM: %.1f', center_of_mass(index)));
    
    % Update edges only if they exist
    if ~isempty(rising_edges) && ~isempty(rising_line)
        rising_pos = (rising_edges(index) / 10) + 1;
        set(rising_line, 'Value', rising_pos, 'Label', sprintf('Rising: %.1f', rising_edges(index)));
    end
    
    if ~isempty(falling_edges) && ~isempty(falling_line)
        falling_pos = (falling_edges(index) / 10) + 1;
        set(falling_line, 'Value', falling_pos, 'Label', sprintf('Falling: %.1f', falling_edges(index)));
    end
    
    % Update title
    title(sprintf('Histogram (index: %d), Center of Mass: %.1f', index, center_of_mass(index)));
end