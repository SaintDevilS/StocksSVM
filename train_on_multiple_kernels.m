function svmstruct = train_on_multiple_kernels(csvMatrix)
    [training, classification] = get_training_and_classification(csvMatrix);

    options = statset('MaxIter', 4000000);
    
    for portion_of_data = 20:-1:1
        for poly_order = [1,4]
            train_on_stocks_data(training, classification, portion_of_data, poly_order);
        end
    end

end