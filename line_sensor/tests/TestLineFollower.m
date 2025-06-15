classdef TestLineFollower < matlab.unittest.TestCase
    % TestLineFollower
    % Test suite for functions:
    % - generate_histogram_data
    % - calculate_center_of_mass_for_histogram
    % - calculate_center_of_line_with_memory_and_latching
    
    properties(Constant)
        % Simulation parameters for tests
        NumHistograms = 10;
        HistBins = 8;
        RectWidth = 3;
        RectSmoothness = 0.25;
        MinVal = 500;
        MaxVal = 2500;
        EdgeThreshold = 100;
        SensorLocations = 0:10:70;
        MemorySize = 5;
        LineWidthMemSize = 20;
        DefaultLineWidth = 40;
        % Simple theoretical position vector
        TheoreticalPos = [1, 2, 3, 4, 5];
    end
    
    methods (TestClassSetup)
        function addSrcToPath(testCase)
            % Find project root (parent folder of tests directory)
            testsDir = fileparts(mfilename('fullpath'));
            projectRoot = fileparts(testsDir);
            srcDir = fullfile(projectRoot, 'src');
            addpath(srcDir);
        end
    end
    
    methods(Test)
        function testGenerateHistogramDataSizes(testCase)
            % Test: correct dimensions of matrix H and vector interp
            [H, interpPos] = generate_histogram_data( ...
                testCase.NumHistograms, ...
                testCase.TheoreticalPos, ...
                testCase.HistBins, ...
                testCase.RectWidth, ...
                testCase.RectSmoothness, ...
                testCase.MinVal, ...
                testCase.MaxVal);
            
            % H should have dimensions NumHistograms x HistBins
            testCase.verifySize(H, [testCase.NumHistograms, testCase.HistBins]);
            % interpPos should be a vector of length NumHistograms
            testCase.verifySize(interpPos, [1, testCase.NumHistograms]);
            % values in H within specified range
            testCase.verifyGreaterThanOrEqual(H, testCase.MinVal);
            testCase.verifyLessThanOrEqual(H, testCase.MaxVal);
        end
        
        function testCalculateReferenceCenterSimple(testCase)
            % Simple histogram: all values at position 3
            H = zeros(1, length(testCase.SensorLocations));
            H(3) = 10;
            
            % Calculate reference center of mass
            center = calculate_center_of_mass_for_histogram(H, testCase.SensorLocations);
            expected = testCase.SensorLocations(3);
            testCase.verifyEqual(center, expected, 'AbsTol', 1e-10);
        end
    end
end