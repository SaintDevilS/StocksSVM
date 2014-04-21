function svmstruct = train_on_stocks_data(csvMatrix)
    global PORTION_OF_DATA POLY_ORDER
    
    [training, classification] = get_training_and_classification(csvMatrix);
    
    options = statset('MaxIter', 150000);
    svmstruct = svmtrain(training(1:PORTION_OF_DATA:length(training),:),classification(1:PORTION_OF_DATA:length(classification)), 'kernel_function', 'polynomial', 'polyorder', POLY_ORDER, 'options', options);
    
    save(sprintf('svm_struct_portion_%d_order_%d.mat', PORTION_OF_DATA, POLY_ORDER), 'svmstruct');
%    svmstruct = svmtrain(training(1:5:length(training),:),classification(1:5:length(classification)), 'options', options);
end

function [training, classification] = get_training_and_classification(csvMatrix)
    global TRAINING_DATA_START TRAINING_DATA_END NUM_OF_STOCKS_FOR_TRAINING NUM_OF_DAYS_IN_SAMPLE
    
    jump_interval = 7;
    num_of_samples = floor(NUM_OF_STOCKS_FOR_TRAINING * (TRAINING_DATA_START - TRAINING_DATA_END) / jump_interval);

    training = zeros(num_of_samples ,NUM_OF_DAYS_IN_SAMPLE);
    classification = cell(num_of_samples ,1);

    index = 1;
    for i = 1:NUM_OF_STOCKS_FOR_TRAINING
        for j = TRAINING_DATA_START:-jump_interval:TRAINING_DATA_END
            [training(index,:), classification{index, 1}] = get_training_and_classification_of_stock(csvMatrix(i,:), j);
            
            index=index + 1;
        end
    end

end

function [current_interval_training, classification] = get_training_and_classification_of_stock(single_stock, j)
    global NUM_OF_DAYS_TO_FORWARD_DAY NUM_OF_DAYS_IN_SAMPLE
    first_classified_index = j - NUM_OF_DAYS_IN_SAMPLE;
    current_interval_training = single_stock(j:-1:first_classified_index + 1);
        
    ratio = ratio_calculator(single_stock(first_classified_index:-1:first_classified_index - NUM_OF_DAYS_TO_FORWARD_DAY + 1));
    
    if ratio < 1
        classification = 'red';
    else
        classification = 'green';
    end
end