function u = sat(x,max)
    max = abs(max);
    if abs(x) <= max
        u = x;
    else
        u = sign(x)*max;
    end
end