function [H, theoretical_line_center_interp] = generate_histogram_data(num_histograms, theoretical_line_center_orig, ...
 hist_bins, rect_width, smoothness, min_val, max_val)
% HISTOGRAM DATA GENERATION
% Creates a matrix of histograms based on interpolation
 original_points = length(theoretical_line_center_orig);
 x_original = 1:original_points;
 x_interp = linspace(1, original_points, num_histograms);
% Spline interpolation
 theoretical_line_center_interp = interp1(x_original, theoretical_line_center_orig, x_interp, 'spline');
% Extended position range
 margin = 10;
 extended_range = -margin:hist_bins + margin;
% Histogram matrix
 H = zeros(num_histograms, hist_bins);
% Generating histograms
for i = 1:num_histograms
 center = theoretical_line_center_interp(i);
% Rounded rectangle function
 rect_vals = 0.5 * (tanh((extended_range - (center - rect_width/2)) / smoothness) - ...
 tanh((extended_range - (center + rect_width/2)) / smoothness));
% Selection of fragment corresponding to histogram bins
 valid_bins = (extended_range >= 1) & (extended_range <= hist_bins);
 h = rect_vals(valid_bins);
% Scaling and quantization
 h = min_val + h * (max_val - min_val);
% ADDING AMPLITUDE NOISE in range -50 to 50
 noise = -50 + 100 * rand(1, length(h)); % Uniform noise in range [-50, 50]
 h = h + noise;
%clamping output values
 h = max(h, min_val);
 h = min(h, max_val);
 
 H(i, :) = round(h);
end
end