%函数名：feedbackFunction_pd
%函数功能：反馈函数的偏导数
%参数：
%      x：误差
%      FFtype：反馈函数类型
function dff=feedbackFunction_pd(x,FFtype)
switch FFtype
    case 0%渐近流形
        dff=-1;
    case 1%有限时间流形
        dff=-sgn_pd(x,0.5);
    case 2%固定时间流形
        dff=-2*sgn_pd(x,0.5)-1*sgn_pd(x,2);
    case 3%时变幂次（2022TAC）
        p = 2*x^2/(1+0.1*x^2);
        dp = 2*(2*x*(1+0.1*x^2)-x^2*0.2*x)/(1+0.1*x^2)^2;
        dff=-sgn(x,p)*(dp*log(x)+p/x);
    case 31%时变幂次（改进2022TAC，连续）
        rb = 0.5;
        r1 = 2;
        rt = 3;
        b = (r1-rb)/(rt-r1);
        a = (rt-rb)*b;
        p = a*x^2/(1+b*x^2)+rb;
        dp = a*(2*x*(1+b*x^2)-x^2*2*b*x)/(1+b*x^2)^2;
        dff=-sgn(x,p)*(dp*log(x)+p/x);
    otherwise
        dff=-1;
end
