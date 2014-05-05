function save_training_and_classification_of_every_stock(csvMatrix, num_of_days_in_sample, num_of_stocks_for_training)
    jump_interval = 7;
    
    for first_stock = 1:num_of_stocks_for_training
        get_training_data_for_stock(csvMatrix, first_stock, num_of_days_in_sample, num_of_stocks_for_training, jump_interval)

        save(strcat('training_data/training_file', int2str(first_stock_index)), 'training');
        save(strcat('training_data/classification_file', int2str(first_stock_index)), 'classification');
    end
end

