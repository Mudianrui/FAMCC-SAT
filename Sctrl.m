function [sys,x0,str,ts] = Sctrl(t,x,u,flag)
switch flag
case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1
    sys=mdlDerivatives(t,x,u);
case 3
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end


function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = 0;
str = [];
ts  = [];

% controller parameter
global Ts epsilon_z umin umax
Ts = 1;
epsilon_z = 0.1;
umin = -2.5;
umax = 3;
% -----------------finite-time control-----------------
global FMtype kc ku epsilon_x epsilon_s epsilon_z1 epsilon_s1
FMtype = 11;
kc = 1;
ku = 5;
epsilon_x = epsilon_z;
epsilon_s = epsilon_x;
epsilon_z1 = 0;
epsilon_s1 = 0;
% -----------------fixed-time control-----------------
% global FMtype kc ku epsilon_y epsilon_s epsilon_z1 epsilon_s1
% FMtype = 26;
% kc = 1;
% ku = 5;
% epsilon_y = 0.5;
% epsilon_s = epsilon_y;
% epsilon_z1 = epsilon_z;
% epsilon_s1 = epsilon_y;
% -----------------variable exponential coefficient fixed-time control-----------------
% global FMtype kc ku epsilon_y epsilon_s epsilon_z1 epsilon_s1
% FMtype = 38;
% kc = 1.5;
% ku = 2;
% epsilon_y = 0.15;
% epsilon_s = epsilon_y;
% epsilon_z1 = epsilon_z;
% epsilon_s1 = epsilon_y;

% controller (has been simplified as parper)
global kpp
kpp = 1;

global beginFlag
beginFlag = 0;


function sys=mdlDerivatives(t,x,u)
z1h = u(1);
z2h = u(2);

% controller parameter
global Ts umin umax
% -----------------finite-time control-----------------
global FMtype kc ku epsilon_s epsilon_z1 epsilon_s1
% -----------------fixed-time control-----------------
% global FMtype kc ku epsilon_s epsilon_z1 epsilon_s1
% -----------------variable exponential coefficient fixed-time control-----------------
% global FMtype kc ku epsilon_s epsilon_z1 epsilon_s1

global kpp

% controller (has been simplified as parper)
s=manifoldGeneration(z1h,z2h,FMtype,kc,epsilon_z1,epsilon_s1,kpp);

k0 = 2;
global s0 beginFlag
if beginFlag==0
    s0=abs(s);
    beginFlag = 1;
end
rho0 = max(k0*s0,epsilon_s);
rhoE = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s+x(1);
v = -ku*log((rhoE+s)/(rhoE-s));
u = satU(v,umin,umax);
sys(1) = -10*x(1)+5*abs(v-u);


function sys=mdlOutputs(t,x,u)
z1h = u(1);
z2h = u(2);
uL = u(3);

% controller parameter
global Ts umin umax
% -----------------finite-time control-----------------
global FMtype kc ku epsilon_s epsilon_z1 epsilon_s1
% -----------------fixed-time control-----------------
% global FMtype kc ku epsilon_s epsilon_z1 epsilon_s1
% -----------------variable exponential coefficient fixed-time control-----------------
% global FMtype kc ku epsilon_s epsilon_z1 epsilon_s1

global kpp

% controller (has been simplified as parper)
s=manifoldGeneration(z1h,z2h,FMtype,kc,epsilon_z1,epsilon_s1,kpp);
%如果预设的精度太小，非线性流形控制容易振荡，而高增益则不会。但是高增益需要适当选取系数，而非线性不太依赖参数，自身就有动态增益。
% if t<5
%     s=manifoldGeneration(z1h,z2h,FMtype,kc,epsilon_z1,epsilon_s1,kpp);
% else
%     s=100*(10*z1h+z2h);%线性控制也很难在准确性、快速性、超调之间做权衡，而非线性控制在这方面很容易调试（对于二阶系统）
% end

k0 = 2;
global s0 beginFlag
if beginFlag==0
    s0=abs(s);
    beginFlag = 1;
end
rho0 = max(k0*s0,epsilon_s);

PPCflag = 3;
switch PPCflag
case 0% 无扩展
    rhoE = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s;
    u = -ku*log((rhoE+s)/(rhoE-s));
case 1% 柔性扩展方法1：饱和误差驱动的自适应扩展
    rhoE = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s+x(1);
    v = -ku*log((rhoE+s)/(rhoE-s));
    u = satU(v,umin,umax);
case 2% 柔性扩展方法2：饱和误差驱动的延迟直接扩展（失败，ke扩大只会增加振荡，仍然失败）
    ke = 0.3;
    rhoE = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s+ke*smoothTfun1(abs(uL-sat(uL,umax)));
    v = -ku*log((rhoE+s)/(rhoE-s));
    u = satU(v,umin,umax);
% case 3% 柔性扩展方法3：基于误差扩展
otherwise
    rhoE = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s;
    rhoee = 0.01;
    Trns = trns(abs(s),rhoE-rhoee,rhoE,0);
    rhoE2 = abs(s)+rhoee;
    rhoE = Trns*rhoE2+(1-Trns)*rhoE;
    v = -ku*log((rhoE+s)/(rhoE-s));
    u = satU(v,umin,umax);%sat(v,umax);
end

sys(1)=u;
sys(2)=s;
sys(3)=rhoE;
sys(4)=-rhoE;
sys(5)=u;
