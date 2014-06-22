function path = train_on_stocks_data(training, classification, portion_of_data, kernel_function, poly_order, svmstruct_path)
    if strcmp(poly_order, '')
        svmstruct_name = sprintf('svm_struct_portion_%d_%s.mat', portion_of_data, kernel_function);
    else
        svmstruct_name = sprintf('svm_struct_portion_%d_order_%s.mat', portion_of_data, poly_order);
    end
    
    if ~strcmp(svmstruct_path, '')
        path = strcat(strcat(svmstruct_path, '/'), svmstruct_name);
    else
        path = svmstruct_name;
    end
    
    if exist(path, 'file')
        return;
    end
   
    options = statset('MaxIter', 4000000);
    
    if strcmp(kernel_function, 'polynomial')
        svmstruct = svmtrain(training(1:portion_of_data:length(training),:),classification(1:portion_of_data:length(classification)),...
                             'options',options, 'kernel_function', kernel_function, 'polyorder', poly_order);
    else
        svmstruct = svmtrain(training(1:portion_of_data:length(training),:),classification(1:portion_of_data:length(classification)),...
                             'options',options, 'kernel_function', kernel_function);                         
    end
    
    save(path, 'svmstruct');
end