function [ svmstruct ] = train_on_similarity( num_of_stocks_to_classify )
%TRAIN_ON_SIMILARITY Summary of this function goes here
%   Detailed explanation goes here

    num_of_samples_in_stock = 15582;
    whole_training = zeros(num_of_stoxcks_to_classify * num_of_samples_in_stock, 60);
    whole_classification = cell(num_of_stocks_to_classify * num_of_samples_in_stock, 1);
    
    training = zeros(num_of_samples_in_stock, 60);
    classification = cell(num_of_samples_in_stock, 1);
    for i = 1:num_of_stocks_to_classify
        load(strcat('training_data/training_file', num2str(i)), 'training');
        whole_training( (i - 1) * num_of_samples_in_stock + 1 : i * num_of_samples_in_stock, :) = training; 
        
        load(strcat('training_data/classification_file', num2str(i)), 'classification');
        whole_classification( (i - 1) * num_of_samples_in_stock + 1 : i * num_of_samples_in_stock, :) = classification; 
    end
    
    options = statset('MaxIter', 2000000);
    svmstruct = svmtrain(whole_training, whole_classification, 'options', options, 'kernel_function', 'mlp');
end

