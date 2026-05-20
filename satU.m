function u = satU(v,min,max)
    if v <= min
        u = min;
    elseif v >= max
        u = max;
    else
        u = v;
    end
end