function [com_mean, rising_current, falling_current] = calculate_center_of_line_with_memory_and_latching(values, weights, dynamic_threshold, default_line_width, memory_size, line_width_memory_size)
    DEFAULT_RISING = -5;
    DEFAULT_FALLING = 75;
    CENTER = (weights(4) + weights(5)) /2;
    
    if length(values) ~= length(weights)
        error('Values and weights vectors must have the same length!');
    end
    
    persistent com_history line_width line_side;
    
    if isempty(com_history) || isempty(line_width) || isempty(line_side)
        com_history = ones(1, memory_size) * CENTER;
        line_width = ones(1, line_width_memory_size) * default_line_width;
        line_side = 0; % 0 = center, -1 = left, 1 = right
    end
    
    values_normalized = values - min(values);
    com_current = calculate_center_of_mass_for_histogram(values_normalized,weights);
    
    diff_values = diff(values_normalized);

    rising_current = DEFAULT_RISING;
    [diff_max, max_idx] = max(diff_values);
    if diff_max > dynamic_threshold
        rising_current = (weights(max_idx + 1) + weights(max_idx)) / 2;
    end

    falling_current = DEFAULT_FALLING;
    [diff_min, min_idx] = min(diff_values);
    if diff_min < -dynamic_threshold
        falling_current = (weights(min_idx + 1) + weights(min_idx)) / 2;
    end
    
    mean_line_width = mean(line_width);

    if line_side == -1 && rising_current == DEFAULT_RISING
        if falling_current == DEFAULT_FALLING
            falling_current = DEFAULT_RISING;
        end
        com_current = falling_current - mean_line_width / 2;
    end

    if line_side == 1 && falling_current == DEFAULT_FALLING
        if rising_current == DEFAULT_RISING  
            rising_current = DEFAULT_FALLING;
        end
        com_current = rising_current + mean_line_width / 2;
    end

    com_history = [com_history, com_current];
    com_history = com_history(end-memory_size+1:end);
    com_mean = round(mean(com_history));

    current_line_width = line_width(end);
    if falling_current < CENTER
        line_side = -1;
    elseif rising_current >  CENTER
        line_side = 1;
    else
        line_side = 0;
        current_line_width = abs(rising_current - falling_current);
    end
    
    line_width = [line_width, current_line_width];
    line_width = line_width(end-line_width_memory_size+1:end);
    
end