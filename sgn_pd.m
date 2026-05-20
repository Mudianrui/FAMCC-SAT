%幂次反馈率的偏导数
function ds=sgn_pd(x,p)
ds = p*abs(x)^(p-1);
