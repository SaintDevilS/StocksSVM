function classify_with_svm()
    csvMatrix = csvread('C:\Weiyun\workspace\StocksSVM\vectors.csv');
    declare_global()
    
    %train_svm(csvMatrix);
    
    load('svm_struct.mat', 'svmstruct');
    test_classify(csvMatrix, svmstruct)
end