% Data vector - 12 elements, 8 within range, 4 outside
row = [200, 300, 2982, 3054, 3020, 1200, 100, 108, 101,123, 105, 130, 140];
x = 1:length(row);
% Bin range from which we calculate center of mass (1–8)
inRange = 1:8;
outRange = 9:length(row);
% Calculate center of mass only for data within range
centerOfMass = sum(x(inRange) .* row(inRange)) / sum(row(inRange));
% Draw histogram
figure;
hold on;
% Bars within range (blue)
hIn = bar(x(inRange), row(inRange), 'FaceColor', [0 0 1]);
% Bars outside range (black)
hOut = bar(x(outRange), row(outRange), 'FaceColor', [0 0 0]);
% Red line for center of mass
ylims = ylim;
hLine = plot([centerOfMass centerOfMass], ylims, 'r--', 'LineWidth', 2);
% Red point for center of mass
plot(centerOfMass, max(row(inRange)), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
% Plot descriptions
title('Histogram with marked center of mass (for bins 1–8)');
xlabel('Bin position');
ylabel('Count');
% Legend with current colors
legend([hIn, hOut, hLine], {'Data within range', 'Data outside range', 'Center of mass'});
hold off;