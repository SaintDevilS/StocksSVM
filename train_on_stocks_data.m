function path = train_on_stocks_data(training, classification, portion_of_data, poly_order, svmstruct_path)

    svmstruct_name = sprintf('svm_struct_portion_%d_order_%s.mat', portion_of_data, poly_order);
    path = strcat(strcat(svmstruct_path, '/'), svmstruct_name);
    
    if exist(path, 'file')
        return;
    end
   
    options = statset('MaxIter', 4000000);
    
    svmstruct = svmtrain(training(1:portion_of_data:length(training),:),classification(1:portion_of_data:length(classification)),...
                         'kernelcachelimit', 15000,'options',options, 'kernel_function', 'polynomial', 'polyorder', 4);
    
    save(path, 'svmstruct');
end