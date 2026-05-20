%过渡函数
%x：过渡值
%x1：起点x
%y1：起点y=0
%x2：终点x
%y2：终点y=1
%flag：过渡函数类型
function [s] = trns(x,x1,x2,flag)
%参数检查
if x1==x2
    flag = -1;
    error(['Unhandled flag from trns = ',num2str(flag)]);
end

xx = (x-x1)/(x2-x1);
if xx<=0
    s=0;
elseif xx>=1
    s=1;
else
    switch flag
        case 0%无限光滑
            s = 1/(exp((1-2*xx)/(xx*(1-xx)))+1);
        case 1%多项式形式1阶次导连续
            s = xx^2*(-2*xx+3);
        case 2%多项式形式2阶次导连续
            s = xx^3*(6*xx^2-15*xx+10);
        case 3%三角函数形式
            s = 1/2*(1+sin((xx-1/2)*pi));
        otherwise
            error(['Unhandled flag from trns = ',num2str(flag)]);
    end
end
