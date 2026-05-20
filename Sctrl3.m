function [sys,x0,str,ts] = Sctrl3(t,x,u,flag)
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
sizes.NumOutputs     = 6;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = 0;
str = [];
ts  = [];

global Ts epsilon_z umin umax
Ts = 1;
epsilon_z = 0.1;
umin = -7;
umax = 9;
% -----------------Linear Fully-actuated Manifold Constraint Control-----------------
% global FMtype kc1 kc2 epsilon_s
% FMtype = 0;
% kc1=3;
% kc2=3;
% epsilon_s = 3;
% -----------------FAMCC Based Recursive Fixed-time Control (RFC)-----------------
global FMtype epsilon_y kc1 epsilon_z1 epsilon_s1 kpp1 kc2 epsilon_z2 epsilon_s2 kpp2 epsilon_s
FMtype = 27;
epsilon_y = 3;
kc1 = 0.5;
epsilon_z1 = epsilon_z;
epsilon_s1 = 0.2;
kpp1 = 0.1;
kc2 = 1;
epsilon_z2 = epsilon_s1;
epsilon_s2 = epsilon_y;
kpp2 = 1;
epsilon_s = epsilon_y;

global beginFlag ku
beginFlag = 0;
ku = 30;


function sys=mdlDerivatives(t,x,u)
e=u(1);
de=u(2);
dde=u(3);

global Ts umin umax

% -----------------Linear Fully-actuated Manifold Constraint Control-----------------
% global FMtype kc1 kc2 epsilon_s
% s1=manifoldGeneration(e,de,FMtype,kc1);
% ds1=manifoldGeneration_dot(e,de,dde,FMtype,kc1);
% s=manifoldGeneration(s1,ds1,FMtype,kc2);
% -----------------FAMCC Based Recursive Fixed-time Control (RFC)-----------------
global FMtype kc1 epsilon_z1 epsilon_s1 kpp1 kc2 epsilon_z2 epsilon_s2 kpp2 epsilon_s
s1=manifoldGeneration(e,de,FMtype,kc1,epsilon_z1,epsilon_s1,kpp1);
ds1=manifoldGeneration_dot(e,de,dde,FMtype,kc1,epsilon_z1,epsilon_s1,kpp1);
kpp2 = 1;
s=manifoldGeneration(s1,ds1,FMtype,kc2,epsilon_z2,epsilon_s2,kpp2);

% controller (has been simplified as parper)
global s0 beginFlag ku
if beginFlag==0
    s0=abs(s);
    beginFlag = 1;
end
k0 = 2;
rho0 = max(k0*s0,epsilon_s);
rho = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s+x(1);
v = -ku*log((rho+s)/(rho-s));
u = satU(v,umin,umax);
sys(1) = -10*x(1)+5*abs(v-u);


function sys=mdlOutputs(t,x,u)
e=u(1);
de=u(2);
dde=u(3);

global Ts umin umax

% -----------------Linear Fully-actuated Manifold Constraint Control-----------------
% global FMtype kc1 kc2 epsilon_s
% s1=manifoldGeneration(e,de,FMtype,kc1);
% ds1=manifoldGeneration_dot(e,de,dde,FMtype,kc1);
% s=manifoldGeneration(s1,ds1,FMtype,kc2);
% -----------------FAMCC Based Recursive Fixed-time Control (RFC)-----------------
global FMtype kc1 epsilon_z1 epsilon_s1 kpp1 kc2 epsilon_z2 epsilon_s2 kpp2 epsilon_s
s1=manifoldGeneration(e,de,FMtype,kc1,epsilon_z1,epsilon_s1,kpp1);
ds1=manifoldGeneration_dot(e,de,dde,FMtype,kc1,epsilon_z1,epsilon_s1,kpp1);
s=manifoldGeneration(s1,ds1,FMtype,kc2,epsilon_z2,epsilon_s2,kpp2);

% controller (has been simplified as parper)
global s0 beginFlag ku
if beginFlag==0
    s0=abs(s);
    beginFlag = 1;
end
k0 = 2;
rho0 = max(k0*s0,epsilon_s);

PPCflag = 3;
switch PPCflag
case 0% 无饱和，无扩展
    rho = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s;
    u = -ku*log((rho+s)/(rho-s));
case 1% 柔性扩展方法1：饱和误差驱动的自适应扩展
    rho = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s+x(1);
    v = -ku*log((rho+s)/(rho-s));
    u = satU(v,umin,umax);
% case 3% 柔性扩展方法3：基于误差扩展
otherwise
    rho = (rho0-epsilon_s)*smoothTfun1((Ts-t)/Ts)+epsilon_s;
    rhoee = 0.01;
    if abs(s)>=rho-rhoee
        Trns = trns(abs(s),rho-rhoee,rho,0);
        rhoE = abs(s)+rhoee;
        rho = Trns*rhoE+(1-Trns)*rho;
    end
    v = -ku*log((rho+s)/(rho-s));
    u = satU(v,umin,umax);%sat(v,umax);
end

    if ~isreal(u) || isnan(u)
        u=0;
    end
% isMeaningless(u,s,rho,-rho);
sys(1)=u;
sys(2)=s;
sys(3)=rho;
sys(4)=-rho;
sys(5)=s1;
sys(6)=ds1;
