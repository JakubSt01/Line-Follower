% Line sensor simulation with center of mass calculation and edge detection
% This simulation generates histogram data representing line sensor readings
% and analyzes the center of mass along with rising/falling edge detection

clearvars; close all; clc; clear;

addpath( genpath( fullfile(pwd, 'src') ) );

fprintf('=== GENERATING SIMULATION DATA ===\n');

% Simulation parameters
num_histograms_per_second = 2000; % measurements frequency
data_logging_period = 2; % time of receiving data

% Variants of line center positions with descriptions
variants = {
    struct('data', [0,0,0,0,4,4,4,4,10,10,6,3,3,-10,3,5,5], 'description', 'Original trajectory'), ...
    struct('data', [5,5,2,1,1,8,8,12,12,15,10,7,4,0,-5,-8,-3], 'description', 'High dynamic range'), ...
    struct('data', [-5,-2,0,3,6,9,7,4,1,-2,-6,-10,-8,-4,0,2,4], 'description', 'Negative start values'), ...
    struct('data', [3,3,4,3,3,3,4,5,5,4,3,3], 'description', 'values in the middle')
};

hist_bins = 8;
rect_width = 3;
rect_smothness = 0.25;
min_sensor_reading_val = 500;
max_sensor_reading_val = 3000;
edge_threshold = 100; % Threshold for edge detection - minimus sensor reading dynamics
sensor_locations = 0:10:70; % Position of sensors for center of mass calculation
memory_size = 50;
line_width_memory_size = 1000;
default_line_width = 40;

%==========================================================================
num_histograms = num_histograms_per_second * data_logging_period;

% Run simulation for all variants
for variant = 1:length(variants)
    fprintf('=== RUNNING VARIANT %d: %s ===\n', variant, variants{variant}.description);
    
    % Select current variant
    theoretical_line_center_orig = variants{variant}.data;
    
    % Generate histogram data based on theoretical line position
    [H, theoretical_line_center_interp] = generate_histogram_data(num_histograms, ...
     theoretical_line_center_orig, hist_bins, rect_width, rect_smothness, min_sensor_reading_val, max_sensor_reading_val);
    
    % Analyze edges and calculate center of mass for each histogram
    fprintf('=== PERFORMING EDGE ANALYSIS FOR VARIANT %d ===\n', variant);
    rising_edges = zeros(1, num_histograms);
    falling_edges = zeros(1, num_histograms);
    center_of_mass = zeros(num_histograms, 1);
    reference_center_of_mass = zeros(num_histograms, 1);
    
    for i = 1:num_histograms
    % Calculate center of mass with memory and latching mechanism
     [center_of_mass(i), rising_edges(i), falling_edges(i)] = ...
     calculate_center_of_line_with_memory_and_latching(H(i,:), sensor_locations, edge_threshold, default_line_width, memory_size, line_width_memory_size);
    % Calculate reference center of mass for comparison
     reference_center_of_mass(i) = calculate_center_of_mass_for_histogram(H(i,:), sensor_locations);
    end
    
    % Create visualization showing center of mass and detected edges
    visualize_with_center_of_mass_and_edges(H, reference_center_of_mass, center_of_mass, ...
     rising_edges, falling_edges, theoretical_line_center_interp);
    
    % Optional: Create interactive histogram viewer with slider control
    % create_interactive_histogram_viewer_extended(H, center_of_mass);
end