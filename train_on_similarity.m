function [ svmstruct ] = train_on_similarity( num_of_stocks_to_classify )
%TRAIN_ON_SIMILARITY Summary of this function goes here
%   Detailed explanation goes here

    num_of_samples_in_stock = 15528;
    training = zeros(num_of_stocks_to_classify * num_of_samples_in_stock, 60);
    classification = cell(num_of_stocks_to_classify * num_of_samples_in_stock, 1);

    for i = 1:num_of_stocks_to_classify
        load(strcat('training_data/training_file', num2str(i)), 'training');
        load(strcat('training_data/classification_file', num2str(i)), 'classification');
        
    svmstruct = svmtrain(training, classification);
end

