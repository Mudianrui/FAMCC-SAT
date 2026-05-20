%放大器
%预定时间预定性能函数：初状态无穷
%z：自变量，误差
%rho：预设性能
%delta：带宽或带宽比例
%alpha：放大器增益调整系数
%p：阶次，用于保证连续性光滑性
%flag：放大器函数类型
function [gamma] = DirectPPC_amplifier(z,rho,delta,alpha,n,flag)
%参数检查
if abs(z)>=abs(rho)
    flag = -1;
elseif rho<0
    flag = -2;
elseif delta<0
     flag = -3;
elseif delta>0
    if flag==4
        if delta>1%比例放大器下delta代表精度比例
            flag = -3;
        end
    else%其他情况下delta代表精度
        if delta>rho
            flag = -3;
        end
    end
elseif alpha<0
    flag = -4;
elseif n~=fix(n) || n<1
    flag = -5;
end

switch flag
    case 0%有界放大区带宽：caoye
        p=ceil(n+1);
        eta = (rho^2-z^2)/delta^2;
        if z^2<=rho^2-delta^2
            gamma = 1;
        else
            gamma = 1/(1-(eta-1)^p);
        end
%     case 1%有界放大区带宽：
%         eta = (z^2-(rho^2-delta^2))/delta^2;
%         if eta<=0 %z^2<=rho^2-delta^2
%             gamma = 1;
%         else
%             gamma = 1/(1-eta^(n+1));
%         end
%     case 2%固定放大区带宽：
%         eta = (z^2-(rho-delta)^2)/(rho^2-(rho-delta)^2);
%         if eta<=0 %z^2<=(rho-delta)^2
%             gamma = 1;
%         else
%             gamma = 1/(1-eta^(n+1));
%         end
%     case 3%固定保持区带宽：
%         eta = (z^2-delta^2)/(rho^2-delta^2);
%         if eta<=0 %z^2<=delta^2
%             gamma = 1;
%         else
%             gamma = 1/(1-eta^(n+1));
%         end
%     case 4%固定比例带宽：注意此时epsilon代表比例
%         eta = ((z/rho)^2-delta^2)/(1-delta^2);
%         if eta<=0 %(z/rho)^2<=delta^2
%             gamma = 1;
%         else
%             gamma = 1/(1-eta^(n+1));
%         end
    case 1%有界放大区带宽：
        eta = (z^2-(rho^2-delta^2))/delta^2;
    case 2%固定放大区带宽：
        eta = (z^2-(rho-delta)^2)/(rho^2-(rho-delta)^2);
    case 3%固定保持区带宽：
        eta = (z^2-delta^2)/(rho^2-delta^2);
    case 4%固定比例带宽：注意此时epsilon代表比例
        eta = ((z/rho)^2-delta^2)/(1-delta^2);
    otherwise
        %gamma = 0.5;
        error(['Unhandled flag from DirectPPC_amplifier = ',num2str(flag),' ',num2str(z),' ',num2str(rho)]);
end

if flag>=1 && flag<=4
    if eta<=0
        gamma = 1;
    else
        gamma = 1/(1-eta^(n+1));%可以替换成其他类似功能函数
    end
end
gamma = alpha*(gamma-1)+1;
