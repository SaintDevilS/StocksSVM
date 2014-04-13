function classify_with_svm()
    csvMatrix = csvread('C:\Weiyun\workspace\StocksSVM\vectors.csv');
    declare_global()
    
    svmstruct = train_svm(csvMatrix);
    
    test_classify(csvMatrix, svmstruct)
end

function declare_global()
    global TRAINING_DATA_START TRAINING_DATA_END NUM_OF_FEATURES NUM_OF_STOCKS_FOR_TRAINING

    TRAINING_DATA_START = 719;
    TRAINING_DATA_END = 11;
    NUM_OF_FEATURES = TRAINING_DATA_START - TRAINING_DATA_END + 1;
    NUM_OF_STOCKS_FOR_TRAINING = 160;
end

function svmstruct = train_svm(csvMatrix)
    global TRAINING_DATA_START TRAINING_DATA_END NUM_OF_FEATURES NUM_OF_STOCKS_FOR_TRAINING
    
    training = zeros(NUM_OF_STOCKS_FOR_TRAINING ,NUM_OF_FEATURES);
    for i = 1:NUM_OF_STOCKS_FOR_TRAINING
        training(i,:) = csvMatrix(i,TRAINING_DATA_START:-1:TRAINING_DATA_END);
    end

    classification = cell(NUM_OF_STOCKS_FOR_TRAINING ,1);
    for i= 1:length(csvMatrix(1:NUM_OF_STOCKS_FOR_TRAINING ))
        if csvMatrix(i,TRAINING_DATA_END - 1) <= 0
            classification{i, 1} = 'red';
        else
            classification{i, 1} = 'green';
        end
    end
  
    svmstruct = svmtrain(training,classification, 'kernel_function', 'polynomial', 'polyorder', 4);
    %svmstruct = svmtrain(training,classification);
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
