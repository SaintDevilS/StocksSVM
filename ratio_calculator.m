function ratio = ratio_calculator(percentage_values_until_forward_day)
    ratio = 1;
    
    for i=1:length(percentage_values_until_forward_day)
        ratio = ratio + ratio * percentage_values_until_forward_day(i) / 100;
    end
end