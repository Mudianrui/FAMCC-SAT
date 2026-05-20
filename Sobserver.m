function [sys,x0,str,ts] = Sobserver(t,x,u,flag)
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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [-1,0];%the first value can be set as z1(=x0[0] in Splant - xd(0) in Sinput) since the output z1(0) is known
str = [];
ts  = [0 0];


function sys=mdlDerivatives(~,x,u)
x1=u(1);
x1hat=x(1);
x2hat=x(2);
mu=0.01;
% (s+2)^2 = s^2+4s+4 = a0s^2+a1s+a2 = 0 i.e., s=-2
a1=4;
a2=4;
sys(1)=x2hat+a1/mu*(x1-x1hat);
sys(2)=a2/(mu^2)*(x1-x1hat);


function sys=mdlOutputs(~,x,~)
sys(1)=x(1);
sys(2)=x(2);
