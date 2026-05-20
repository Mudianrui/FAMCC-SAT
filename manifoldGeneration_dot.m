%函数名：manifoldGeneration_dot
%函数功能：流形的微分生成
%参数：
%      e：误差
%      de：误差微分
%      FMtype：流形类型
%      kc：流形系数
%      epsilon_z：预定性能/预定性能终值（含偏曲反馈可选，低复杂度流形可选）
%      epsilon_s：流形滑动裕度（含偏曲反馈可选）
%      kpp：非奇异（非奇异偏曲参数）
function ds=manifoldGeneration_dot(e,de,dde,FMtype,kc,varargin)
if nargin>5
    epsilon_z = varargin{1};
end
if nargin>6
    epsilon_s = varargin{2};
end
if nargin>7
    kpp = varargin{3};
end
switch FMtype
    case 0%渐近流形
        ds=dde-kc*feedbackFunction_pd(e,0)*de;
    case 1%有限时间流形
        ds=dde-kc*feedbackFunction_pd(e,1)*de;
    case 11%非奇异有限时间流形
        ds=sgn_pd(de/kc,2)*dde/kc+de;
    case 16%有限时间偏曲流形：直接过渡偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,1,de,0,epsilon_z,epsilon_s,kpp);
    case 17%有限时间偏曲流形：非奇异偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,1,de,1,epsilon_z,epsilon_s,kpp);
    case 2%固定时间流形
        ds=dde-kc*feedbackFunction_pd(e,2)*de;
    case 21%分段固定时间流形
        if e>1
            ds=dde+kc*sgn_pd(e,2)*de;
        else
            ds=sgn_pd(de/kc,2)*dde/kc+de;
        end
    case 22%非奇异固定时间流形
        ds=sgn_pd((kc*sgn(e,2)+de)/kc,2)*(sgn_pd(e,2)*de+dde/kc)+de;
    case 26%固定时间偏曲流形：直接过渡偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,2,de,0,epsilon_z,epsilon_s,kpp);
    case 27%固定时间偏曲流形：非奇异偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,2,de,1,epsilon_z,epsilon_s,kpp);
    case 3%时变幂次（2022TAC）
        ds=dde-kc*feedbackFunction_pd(e,3)*de;
    case 36%固定时间偏曲流形：直接过渡偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,3,de,0,epsilon_z,epsilon_s,kpp);
    case 37%固定时间偏曲流形：非奇异偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,3,de,1,epsilon_z,epsilon_s,kpp);
    case 31%时变幂次（改进2022TAC，连续）
        ds=dde-kc*feedbackFunction_pd(e,31)*de;
    case 38%固定时间偏曲流形：直接过渡偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,31,de,0,epsilon_z,epsilon_s,kpp);
    case 39%固定时间偏曲流形：非奇异偏曲
        ds=dde-kc*skewedAlgorithm_dot(e,31,de,1,epsilon_z,epsilon_s,kpp);
    otherwise
        ds=dde+kc*de;
end
