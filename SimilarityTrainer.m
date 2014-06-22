classdef SimilarityTrainer
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ItsCsvMatrix
        Num_of_days_in_training
        Num_of_days_in_classification
        Jump_interval = 30;
        training_data_start = 780;
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
            
%            fprintf('ratio of first=%f and second=%f and their classification=%s\n', ratio_first, ratio_second, classification);
        end
        
        function test_similarity_classify(obj, svmstruct, index_of_first_stock_under_test)
            num_of_mistakes = 0;
            
            for first_stock = index_of_first_stock_under_test:111
                for second_stock = first_stock+1:111
                    [data, classification] = obj.get_training_and_classification_of_stocks(obj.ItsCsvMatrix(first_stock,:), obj.ItsCsvMatrix(second_stock,:), obj.training_data_end - 1);
                    
                    classifier_answer = svmclassify(svmstruct, data);

                    if (~strcmp(classification, classifier_answer))
%                        fprintf('WRONG for: %d %d\n', first_stock, second_stock);
                        num_of_mistakes = num_of_mistakes + 1;

                    end
                end
            end
            num_of_times_classified=(111 - index_of_first_stock_under_test) * (111 - index_of_first_stock_under_test - 1);
            fprintf('num of mistakes=%d out of %d which is %f percent wrong\n',num_of_mistakes, num_of_times_classified, num_of_mistakes / num_of_times_classified * 100);

        end

        
    end
end

