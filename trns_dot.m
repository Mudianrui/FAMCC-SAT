%过渡函数的导数
%x：过渡值
%x1：起点x
%y1：起点y=0
%x2：终点x
%y2：终点y=1
%flag：过渡函数类型
function [ds] = trns_dot(x,x1,x2,dx,dx1,dx2,flag)
%参数检查
if x1==x2
    flag = -1;
    error(['Unhandled flag from trns = ',num2str(flag)]);
end

xx = (x-x1)/(x2-x1);
dxx = ((dx-dx1)*(x2-x1)-(x-x1)*(dx2-dx1))/(x2-x1)^2;
if xx<=0 || xx>=1
    ds=0;
else
    switch flag
        case 0%无限光滑
            ds = -1/(exp((1-2*xx)/(xx*(1-xx)))+1)^2 * exp((1-2*xx)/(xx*(1-xx))) * (-2*xx*(1-xx)-(1-2*xx)*(1-2*xx))/(xx^2*(1-xx)^2)*dxx;
            if isnan(ds)%在接近0的时候会计算极小值/极小值=Nan，但准确值其实是十分接近0
                ds=0;
            end
        case 1%多项式形式
            ds = (-6*xx^2+6*xx)*dxx;
        case 2%多项式形式
            ds = (30*xx^4-60*xx^3+30*xx^2)*dxx;
        case 3%三角函数形式
            ds = 1/2*pi*cos((xx-1/2)*pi)*dxx;
        otherwise
            error(['Unhandled flag from trns = ',num2str(flag)]);
    end
end
