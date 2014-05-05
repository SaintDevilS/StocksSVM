function [training, classification] = get_training_data_for_stock(csvMatrix, first_stock_index, num_of_days_in_sample, num_of_stocks_for_training, jump_interval)
    global TRAINING_DATA_START TRAINING_DATA_END 
    
    num_of_samples = floor( (num_of_stocks_for_training - 1) * (TRAINING_DATA_START - TRAINING_DATA_END) / jump_interval);
    
    training = zeros(num_of_samples, num_of_days_in_sample * 2);
    classification = cell(num_of_samples ,1);

    index = 1;
    for second_stock = 1:num_of_stocks_for_training
        if first_stock_index == second_stock
            continue
        end
        for j = TRAINING_DATA_START:-jump_interval:TRAINING_DATA_END
            [training(index,:), classification{index, 1}] = get_training_and_classification_of_stocks(csvMatrix(first_stock_index,:), csvMatrix(second_stock,:), j, 7, num_of_days_in_sample);
            index = index + 1;
        end
    end
end

function [current_training, classification] = get_training_and_classification_of_stocks(first_stock, second_stock, index_of_first_value_in_training,...
                                                                                                                                                    num_of_days_in_classification, num_of_days_in_training)

    index_of_first_value_in_classification = index_of_first_value_in_training - num_of_days_in_training;
    
    first_stock_training = first_stock(index_of_first_value_in_training:-1:index_of_first_value_in_classification + 1);
    second_stock_training = second_stock(index_of_first_value_in_training:-1:index_of_first_value_in_classification + 1);
    
    current_training = horzcat(first_stock_training, second_stock_training );
    
    ratio_first = ratio_calculator(first_stock(index_of_first_value_in_classification:-1:index_of_first_value_in_classification - num_of_days_in_classification + 1));
    ratio_second = ratio_calculator(second_stock(index_of_first_value_in_classification:-1:index_of_first_value_in_classification - num_of_days_in_classification + 1));
    
    if (ratio_first < 1 && ratio_second < 1) || (ratio_first > 1 && ratio_second > 1)  
        classification = 'green';
    else
        classification = 'red';
    end
end