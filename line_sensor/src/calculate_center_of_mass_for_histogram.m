function [xcm] = calculate_center_of_mass_for_histogram(h, x)
% Calculate weighted average (center of mass) for histogram data
% h - data values vector
% x - position weights vector (x-axis positions)
% xcm - center of mass (rounded)

if length(h) ~= length(x)
    error('Values and weights vectors must have the same length!');
end

% Normalize values to remove offset
h_normalized = h - min(h);

% Calculate center of mass using weighted average
xcm = round(sum(x .* h_normalized) / sum(h_normalized));

end