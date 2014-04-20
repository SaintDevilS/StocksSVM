function classify_with_svm()
    csvMatrix = csvread('C:\Weiyun\workspace\StocksSVM\vectors.csv');
    declare_global()
    
    %train_svm(csvMatrix);
    
    load('svm_struct.mat', 'svmstruct');
    test_classify(csvMatrix, svmstruct)
end

function declare_global()
    global TRAINING_DATA_START TRAINING_DATA_END NUM_OF_FEATURES NUM_OF_STOCKS_FOR_TRAINING NUM_OF_DAYS_TO_FORWARD_DAY NUM_OF_DAYS_IN_SAMPLE

    TRAINING_DATA_START = 719;
    NUM_OF_DAYS_TO_FORWARD_DAY = 8;
    NUM_OF_DAYS_IN_SAMPLE = 30;

    TRAINING_DATA_END = NUM_OF_DAYS_TO_FORWARD_DAY + NUM_OF_DAYS_IN_SAMPLE;
    NUM_OF_FEATURES = TRAINING_DATA_START - TRAINING_DATA_END + 1;
    NUM_OF_STOCKS_FOR_TRAINING = 160;
end


function [current_interval_training, classification] = get_training_and_classification(single_stock, j)
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
            [training(index,:), classification{index, 1}] = get_training_and_classification(csvMatrix(i,:), j);
            
            index=index + 1;
        end
    end
    
    options = statset('MaxIter', 150000);
    svmstruct = svmtrain(training(1:2:length(training),:),classification(1:2:length(classification)), 'kernel_function', 'polynomial', 'polyorder', 4, 'options', options);
    
    save('svm_struct.mat', 'svmstruct');
%    svmstruct = svmtrain(training(1:5:length(training),:),classification(1:5:length(classification)), 'options', options);
end

function test_classify(csvMatrix, svmstruct)
    global TRAINING_DATA_END NUM_OF_STOCKS_FOR_TRAINING NUM_OF_DAYS_TO_FORWARD_DAY
    num_of_mistakes = 0;
    acceptect_mistake = 0.1;
    
    for i = NUM_OF_STOCKS_FOR_TRAINING:189
        stock_class = svmclassify(svmstruct, csvMatrix(i,TRAINING_DATA_END:-1:NUM_OF_DAYS_TO_FORWARD_DAY + 1));

        ratio = ratio_calculator(csvMatrix(i,NUM_OF_DAYS_TO_FORWARD_DAY:-1:1));
        if (strcmp(stock_class, 'green') && ratio < 1 || strcmp(stock_class, 'red') && ratio >= 1)
    %        if (abs(ratio - 1) > acceptect_mistake)
                disp('WRONG: ')
                i
                ratio
                num_of_mistakes = num_of_mistakes + 1;
     %       end
        end
    end
    
    num_of_mistakes
end
