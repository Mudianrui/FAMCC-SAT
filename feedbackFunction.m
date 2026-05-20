%函数名：feedbackFunction
%函数功能：反馈函数
%参数：
%      x：误差
%      FFtype：反馈函数类型
function ff=feedbackFunction(x,FFtype)
switch FFtype
    case 0%渐近流形
        ff=-x;
    case 1%有限时间流形
%         ff=-3*sgn(x,0.5);%这组参数画图更好看
        ff=-1*sgn(x,0.5);
    case 2%固定时间流形
        ff=-2*sgn(x,0.5)-1*sgn(x,2);
    case 3%时变幂次（2022TAC）
        p = 2*x^2/(1+0.1*x^2);
        ff=-sgn(x,p);
    case 31%时变幂次（改进2022TAC，连续）
%         rb = 0.5;%这组参数画图更好看
%         r1 = 1;
%         rt = 2;
        rb = 0.5;
        r1 = 2;
        rt = 3;
        b = (r1-rb)/(rt-r1);
        a = (rt-rb)*b;
        p = a*x^2/(1+b*x^2)+rb;
        ff=-sgn(x,p);
    otherwise
        ff=-x;
end
