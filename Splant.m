function [sys,x0,str,ts] = Splant(t,x,u,flag)
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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [-1,0.5];
str = [];
ts  = [0 0];


function sys=mdlDerivatives(t,x,u)
x1=x(1);
x2=x(2);
ut=u(4);
% system
g1=1+0.1*sin(t)+0.1*cos(x1);
g2=2+0.1*cos(t)+0.2*sin(x1*x2);
f1=1*sin(t)-x1;
f2=3*sin(t)+3*cos(2*t)-(x1^2-1)*x2;

dx1=g1*x2+f1;
dx2=g2*ut+f2;
sys(1)=dx1;
sys(2)=dx2;


function sys=mdlOutputs(t,x,u)
x1=x(1);
x2=x(2);
xd=u(1);
dxd=u(2);
ddxd=u(3);
% system
g1=1+0.1*sin(t)+0.1*cos(x1);
g2=2+0.1*cos(t)+0.2*sin(x1*x2);
f1=1*sin(t)-x1;
f2=3*sin(t)+3*cos(2*t)-(x1^2-1)*x2;
dx1=g1*x2+f1;
dg1=0.1*cos(t)-0.1*sin(x1)*dx1;
df1=1*cos(t)-dx1;

% ddz1=ddx1-ddxd=Gu+F
G=g1*g2;
F=dg1*x2+g1*f2+df1-ddxd;

z1=x1-xd;
z2=dx1-dxd;
sys(1)=z1;
sys(2)=z2;
sys(3)=-F/G;
