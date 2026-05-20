%函数名：skewedAlgorithm_dot
%函数功能：反馈函数
%参数：
%      x：反馈函数输入
%      FFtype：反馈函数类型
%      SAtype：偏曲类型
%      epsilon_x：预定性能
%      epsilon_s：流形滑动裕度
%      kpp：非奇异（非奇异偏曲参数）
function dsa=skewedAlgorithm_dot(x,FFtype,dx,SAtype,epsilon_z,epsilon_s,varargin)
kpp = 1;%kpp默认值
if nargin>5
    kpp = varargin{1};
end
Ttype = 0;%过渡函数类型
y = feedbackFunction(x,FFtype);
dy = feedbackFunction_pd(x,FFtype)*dx;
switch SAtype
    case 0%直接过渡偏曲
        dT = -2*trns_dot(x,-epsilon_z,epsilon_z,dx,0,0,Ttype);
        dsa=dy+dT*epsilon_s;
    case 1%非奇异偏曲（消除x=0时y'的奇异）
        T1 = 1-2*trns(x,-epsilon_z,epsilon_z,Ttype);%从1到-1
        dT1 = -2*trns_dot(x,-epsilon_z,epsilon_z,dx,0,0,Ttype);
        if x<0
            T2=trns(-x,0,epsilon_z,Ttype);%从1到0
            dT2=-trns_dot(-x,0,epsilon_z,dx,0,0,Ttype);
        else
            T2=trns(x,0,epsilon_z,Ttype);%从0到1
            dT2=trns_dot(x,0,epsilon_z,dx,0,0,Ttype);
        end
        k = (feedbackFunction(-epsilon_z,FFtype)+epsilon_s)/epsilon_z*kpp;
        dsa=dT2*(y+T1*epsilon_s)+T2*(dy+dT1*epsilon_s)+dT2*k*x+(1-T2)*(-k*dx);%用光滑过渡
    otherwise
        dT = -2*trns_dot(x,-epsilon_z,epsilon_z,dx,0,0,Ttype);
        dsa=dy+dT*epsilon_s;
end
