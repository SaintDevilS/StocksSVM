function classify_with_svm()
    csvMatrix = csvread('C:\Weiyun\workspace\StocksSVM\vectors.csv');
    declare_global()
    
    svmstruct = train_svm(csvMatrix)
    
    %test_classify(csvMatrix, svmstruct)
end

function declare_global()
    global TRAINING_DATA_START TRAINING_DATA_END NUM_OF_FEATURES NUM_OF_STOCKS_FOR_TRAINING

    TRAINING_DATA_START = 719;
    TRAINING_DATA_END = 30;
    NUM_OF_FEATURES = TRAINING_DATA_START - TRAINING_DATA_END + 1;
    NUM_OF_STOCKS_FOR_TRAINING = 160;
end

function [current_interval_training, classification] = get_training_and_classification(csvMatrix, i, j, num_of_days_in_sample)
    current_interval_training = csvMatrix(i,j:-1:j - num_of_days_in_sample + 1);
        
    if csvMatrix(i,j - num_of_days_in_sample) <= 0
        classification = 'red';         
    else
        classification = 'green';
    end

end

function svmstruct = train_svm(csvMatrix)
    global TRAINING_DATA_START TRAINING_DATA_END NUM_OF_STOCKS_FOR_TRAINING
    
    num_of_days_in_sample = 30;
    jump_interval = 7;
    num_of_samples = floor(NUM_OF_STOCKS_FOR_TRAINING * (TRAINING_DATA_START - TRAINING_DATA_END) / jump_interval);
    
    training = zeros(num_of_samples ,num_of_days_in_sample);
    classification = cell(num_of_samples ,1);
    
    index = 1;
    for i = 1:NUM_OF_STOCKS_FOR_TRAINING
        for j = TRAINING_DATA_START:-jump_interval:TRAINING_DATA_END
            [training(index,:), classification{index, 1}] = get_training_and_classification(csvMatrix, i, j, num_of_days_in_sample);
            
            index=index + 1;
        end
    end
    
    options = statset('MaxIter', 50000);
    svmstruct = svmtrain(training,classification, 'kernel_function', 'polynomial', 'polyorder', 30, 'options', options);
%    svmstruct = svmtrain(training,classification, 'options', options);
end

function test_classify(csvMatrix, svmstruct)
    global TRAINING_DATA_START TRAINING_DATA_END NUM_OF_STOCKS_FOR_TRAINING
    num_of_mistakes = 0;
    acceptect_mistake = 0.1;
    
    for i = NUM_OF_STOCKS_FOR_TRAINING:189
        stock_class = svmclassify(svmstruct, csvMatrix(i,TRAINING_DATA_START:-1:TRAINING_DATA_END));

        if (strcmp(stock_class, 'green') && csvMatrix(i,TRAINING_DATA_END - 1) <= 0 || strcmp(stock_class, 'red') && csvMatrix(i,TRAINING_DATA_END - 1) > 0)
            if (abs(csvMatrix(i,TRAINING_DATA_END - 1)) > acceptect_mistake)
                disp('WRONG: ')
                i
                csvMatrix(i,TRAINING_DATA_END - 1)
                num_of_mistakes = num_of_mistakes + 1;
            end
        end
    end
    
    num_of_mistakes
end
