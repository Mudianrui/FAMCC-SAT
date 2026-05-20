%函数名：manifoldGeneration
%函数功能：流形生成
%参数：
%      e：误差
%      de：误差微分
%      FMtype：流形类型
%      kc：流形系数
%      epsilon_z：预定性能/预定性能终值（含偏曲反馈可选，低复杂度流形可选）
%      epsilon_s：流形滑动裕度（含偏曲反馈可选）
%      kpp：非奇异（非奇异偏曲参数）
function s=manifoldGeneration(e,de,FMtype,kc,varargin)
if nargin>4
    epsilon_z = varargin{1};
end
if nargin>5
    epsilon_s = varargin{2};
end
if nargin>6
    kpp = varargin{3};
end
switch FMtype
    case 0%渐近流形
        s=de-kc*feedbackFunction(e,0);
    case 1%有限时间流形
        s=de-kc*feedbackFunction(e,1);
    case 11%非奇异有限时间流形
        s=sgn(de/kc,2)+e;
    case 16%有限时间偏曲流形：直接过渡偏曲
        s=de-kc*skewedAlgorithm(e,1,0,epsilon_z,epsilon_s,kpp);
    case 17%有限时间偏曲流形：非奇异偏曲
        s=de-kc*skewedAlgorithm(e,1,1,epsilon_z,epsilon_s,kpp);
    case 2%固定时间流形
        s=de-kc*feedbackFunction(e,2);
    case 21%分段固定时间流形
        if e>1
            s=de+kc*sgn(e,2);
        else
            s=sgn(de/kc,2)+e;
        end
    case 22%非奇异固定时间流形
        s=sgn((kc*sgn(e,2)+de)/kc,2)+e;
    case 26%固定时间偏曲流形：直接过渡偏曲
        s=de-kc*skewedAlgorithm(e,2,0,epsilon_z,epsilon_s,kpp);
    case 27%固定时间偏曲流形：非奇异偏曲
        s=de-kc*skewedAlgorithm(e,2,1,epsilon_z,epsilon_s,kpp);
    case 3%时变幂次（2022TAC）
        s=de-kc*feedbackFunction(e,3);
    case 36%固定时间偏曲流形：直接过渡偏曲
        s=de-kc*skewedAlgorithm(e,3,0,epsilon_z,epsilon_s,kpp);
    case 37%固定时间偏曲流形：非奇异偏曲
        s=de-kc*skewedAlgorithm(e,3,1,epsilon_z,epsilon_s,kpp);
    case 31%时变幂次（改进2022TAC，连续）
        s=de-kc*feedbackFunction(e,31);
    case 38%固定时间偏曲流形：直接过渡偏曲
        s=de-kc*skewedAlgorithm(e,31,0,epsilon_z,epsilon_s,kpp);
    case 39%固定时间偏曲流形：非奇异偏曲
        s=de-kc*skewedAlgorithm(e,31,1,epsilon_z,epsilon_s,kpp);
    otherwise
        s=de+kc*e;
end
