classdef SimilarityTrainer
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ItsCsvMatrix
        Num_of_days_in_training
        Num_of_days_in_classification
        Jump_interval = 30;
        training_data_start = 719;
        training_data_end
    end
    
    methods
        function obj = SimilarityTrainer(csvMatrix, num_of_days_in_training, num_of_days_in_classification)
            obj.ItsCsvMatrix = csvMatrix;
            obj.Num_of_days_in_training = num_of_days_in_training;
            obj.Num_of_days_in_classification = num_of_days_in_classification;
            obj.training_data_end = num_of_days_in_training + num_of_days_in_classification + 1;
        end
        
        function [training, classification] = get_training_and_classification(obj, num_of_stocks_for_training)
            num_of_samples = floor( num_of_stocks_for_training * (num_of_stocks_for_training - 1) / 2 * (obj.training_data_start - obj.training_data_end) / obj.Jump_interval);

            training = zeros(num_of_samples, obj.Num_of_days_in_training * 2);
            classification = cell(num_of_samples ,1);

            index = 1;
            for first_stock = 1:num_of_stocks_for_training
                for second_stock = first_stock + 1:num_of_stocks_for_training
                    for j = obj.training_data_start:-obj.Jump_interval:obj.training_data_end
                        [training(index,:), classification{index, 1}] = obj.get_training_and_classification_of_stocks(obj.ItsCsvMatrix(first_stock,:), obj.ItsCsvMatrix(second_stock,:), j);
                        index = index + 1;
                    end
                end
            end
        end

        function [current_training, classification] = get_training_and_classification_of_stocks(obj, first_stock, second_stock, index_of_first_value_in_training)

            index_of_first_value_in_classification = index_of_first_value_in_training - obj.Num_of_days_in_training;

            first_stock_training = first_stock(index_of_first_value_in_training:-1:index_of_first_value_in_classification + 1);
            second_stock_training = second_stock(index_of_first_value_in_training:-1:index_of_first_value_in_classification + 1);

            current_training = horzcat(first_stock_training, second_stock_training );

            ratio_first = ratio_calculator(first_stock(index_of_first_value_in_classification:-1:index_of_first_value_in_classification - obj.Num_of_days_in_classification + 1));
            ratio_second = ratio_calculator(second_stock(index_of_first_value_in_classification:-1:index_of_first_value_in_classification - obj.Num_of_days_in_classification + 1));

            if (ratio_first < 1 && ratio_second < 1) || (ratio_first > 1 && ratio_second > 1)  
                classification = 'green';
            else
                classification = 'red';
            end
        end 
        
    end
end

