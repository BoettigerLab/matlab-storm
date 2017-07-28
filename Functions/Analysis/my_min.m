function ret_min = my_min(array)
min = array(1);
for k = 1:length(array)
    if array(k) < min
        min = array(k);
    end
end
ret_min = min;