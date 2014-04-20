function ratio = ratio_calculator(vector_between_last_stock_and_forward_day)
    ratio = 1;
    
    for i=2:length(vector_between_last_stock_and_forward_day)
        ratio = ratio + ratio * vector_between_last_stock_and_forward_day(i) / 100
    end
end