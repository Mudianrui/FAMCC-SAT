function [sys,x0,str,ts] = Sobserver3(t,x,u,flag)
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
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1,0,0];%输出初值已知
str = [];
ts  = [0 0];


function sys=mdlDerivatives(~,x,u)
x1=u(1);
x1hat=x(1);
x2hat=x(2);
x3hat=x(3);
mu=0.01;
% (s+2)^2=s^2+4s+4=a0s^2+a1s+a2
% 多项式求根
% d = [1 2 3 4];
% r = roots(d);
% 根据根生成多项式
r = -1*ones(3+1,1);
% r = -2*ones(3,1);
A = poly(r);
% a0 = A(1);
a1 = A(2);
a2 = A(3);
a3 = A(4);
sys(1)=x2hat+a1/mu*(x1-x1hat);
sys(2)=x3hat+a2/(mu^2)*(x1-x1hat);
sys(3)=a3/(mu^3)*(x1-x1hat);


function sys=mdlOutputs(~,x,~)
sys(1)=x(1);
sys(2)=x(2);
% xmax = 10;
% if x(3)>xmax
%     x(3)=xmax;
% elseif x(3)<-xmax
%     x(3)=-xmax;
% end
sys(3)=x(3);
