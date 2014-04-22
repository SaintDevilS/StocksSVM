function test_classify(csvMatrix, svmstruct)
    global TRAINING_DATA_END NUM_OF_STOCKS_FOR_TRAINING NUM_OF_DAYS_TO_FORWARD_DAY
    num_of_mistakes = 0;
    accepted_mistake = 0.02;
    
    for i = NUM_OF_STOCKS_FOR_TRAINING:189
        stock_class = svmclassify(svmstruct, csvMatrix(i,TRAINING_DATA_END:-1:NUM_OF_DAYS_TO_FORWARD_DAY + 1));

        ratio = ratio_calculator(csvMatrix(i,NUM_OF_DAYS_TO_FORWARD_DAY:-1:1));
        if (strcmp(stock_class, 'green') && ratio < 1 || strcmp(stock_class, 'red') && ratio >= 1)
            if (abs(ratio - 1) > accepted_mistake)
                disp('WRONG: ')
                i
                ratio
                num_of_mistakes = num_of_mistakes + 1;
            end
        end
    end
    
    num_of_mistakes
end
