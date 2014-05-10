function train_on_stocks_data(training, classification, portion_of_data, poly_order, svmstruct_path)

    svmstruct_name = sprintf('svm_struct_portion_%d_order_%d.mat', portion_of_data, poly_order);
    
    if exist(strcat(strcat(svmstruct_path, '/'), svmstruct_name), 'file')
        return;
    end
    
    options = statset('MaxIter', 4000000);
    svmstruct = svmtrain(training(1:portion_of_data:length(training),:),classification(1:portion_of_data:length(classification)),...
                         'options', options);
    
    save(strcat(strcat(svmstruct_path, '/'), svmstruct_name), 'svmstruct');
end