classdef RatioCalculatorTest < matlab.unittest.TestCase
    methods (Test)
        function test_ratio_calc(testCase)
            vector_between_last_stock_and_forward_day = [0.01 10 -2];

            ratio = ratio_calculator(vector_between_last_stock_and_forward_day);

            testCase.verifyEqual(ratio, 1.078);
        end
    end
end
