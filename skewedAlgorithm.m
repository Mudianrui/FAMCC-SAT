%函数名：skewedAlgorithm
%函数功能：反馈函数
%参数：
%      x：反馈函数输入
%      FFtype：反馈函数类型
%      SAtype：偏曲类型
%      epsilon_x：预定性能
%      epsilon_s：流形滑动裕度
%      kpp：非奇异（非奇异偏曲参数）
function sa=skewedAlgorithm(x,FFtype,SAtype,epsilon_z,epsilon_s,varargin)
kpp = 1;%kpp默认值
if nargin>5
    kpp = varargin{1};
end
Ttype = 0;%过渡函数类型
y = feedbackFunction(x,FFtype);
switch SAtype
    case 0%直接过渡偏曲
        T = 1-2*trns(x,-epsilon_z,epsilon_z,Ttype);%从1到-1
        sa=y+T*epsilon_s;
    case 1%非奇异偏曲（消除x=0时y'的奇异）
        T1 = 1-2*trns(x,-epsilon_z,epsilon_z,Ttype);%从1到-1
        if x<0
            T2=trns(-x,0,epsilon_z,Ttype);%从1到0
        else
            T2=trns(x,0,epsilon_z,Ttype);%从0到1
        end
        k = (feedbackFunction(-epsilon_z,FFtype)+epsilon_s)/epsilon_z*kpp;
        sa=T2*(y+T1*epsilon_s)+(1-T2)*(-k*x);%用光滑过渡
    otherwise
        T = 1-2*trns(x,-epsilon_z,epsilon_z,Ttype);%从1到-1
        sa=y+T*epsilon_s;
end
