function visualize_with_center_of_mass_and_edges(H, reference_center_of_mass, center_of_mass, rising_edges, falling_edges, theoretical_line_center_interp)
% VISUALIZATION: Side-by-side comparison of original vs modified algorithm
% Creates thermal maps comparing theoretical line center (reference) with 
% center of mass and edges analysis (modified algorithm)

figure('Name', 'Algorithm Comparison: Reference vs Modified', 'Position', [100, 100, 1200, 500]);

% Data preparation - convert values to bin positions (1-8 scale)
y_axis = 1:length(center_of_mass);

center_bins = (center_of_mass / 10) + 1;     % Scale from 0-70 to 1-8
reference_center_bins = (reference_center_of_mass / 10) + 1;     % Scale from 0-70 to 1-8
rising_bins = (rising_edges / 10) + 1;       % Scale from 0-70 to 1-8
falling_bins = (falling_edges / 10) + 1;     % Scale from 0-70 to 1-8

% Left subplot: Reference algorithm (original algorithm)
subplot(1, 2, 1);
imagesc(H);
colormap(flipud(hot));
colorbar;
hold on;

% Plot only center of mass
plot(reference_center_bins, y_axis, 'c-', 'LineWidth', 2, 'DisplayName', 'Center of mass');
plot(reference_center_bins, y_axis, 'co', 'MarkerSize', 2, 'MarkerFaceColor', 'white');

% Plot theoretical line center
plot(theoretical_line_center_interp, y_axis, 'g-', 'LineWidth', 2, 'DisplayName', 'Theoretical line center');
plot(theoretical_line_center_interp, y_axis, 'go', 'MarkerSize', 3, 'MarkerFaceColor', 'green');

% Formatting for left plot
xlabel('Sensor Bin (1-8)');
ylabel('Reading Number');
title('Reference Algorithm');
legend('Reference algorithm output', '', 'Theoretical line center', '', 'Location', 'best');
xlim([0.5, 8.5]);
ylim([1, size(H, 1)]);
hold off;

% Right subplot: Modified algorithm (all metrics)
subplot(1, 2, 2);
imagesc(H);
colormap(flipud(hot));
colorbar;
hold on;

% Plot center of mass
plot(center_bins, y_axis, 'c-', 'LineWidth', 2, 'DisplayName', 'Center of mass');
plot(center_bins, y_axis, 'co', 'MarkerSize', 2, 'MarkerFaceColor', 'white');

% Plot rising edges
plot(rising_bins, y_axis, 'r-', 'LineWidth', 2, 'DisplayName', 'Rising edges');
plot(rising_bins, y_axis, 'ro', 'MarkerSize', 2, 'MarkerFaceColor', 'cyan');

% Plot falling edges
plot(falling_bins, y_axis, 'b-', 'LineWidth', 2, 'DisplayName', 'Falling edges');
plot(falling_bins, y_axis, 'bo', 'MarkerSize', 2, 'MarkerFaceColor', 'blue');

% Plot theoretical line center for comparison
plot(theoretical_line_center_interp, y_axis, 'g-', 'LineWidth', 2, 'DisplayName', 'Theoretical line center');
plot(theoretical_line_center_interp, y_axis, 'go', 'MarkerSize', 2, 'MarkerFaceColor', 'green');

% Formatting for right plot
xlabel('Sensor Bin (1-8)');
ylabel('Reading Number');
title('Modified Algorithm');
legend('Modified algorithm output', '', 'Rising edges', '', 'Falling edges', '', 'Theoretical line center', '', 'Location', 'best');
xlim([0.5, 8.5]);
ylim([1, size(H, 1)]);
hold off;

% Summary output
fprintf('Generated %d histograms with center of mass analysis\n', length(center_of_mass));
fprintf('Comparison: Reference algorithm vs Modified algorithm with multiple metrics\n');
end