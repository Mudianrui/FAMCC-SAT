function [sys,x0,str,ts] = Splant3(t,x,u,flag)
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
sizes.NumOutputs     = 4;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1,0.5,4];
str = [];
ts  = [0 0];


function sys=mdlDerivatives(t,x,u)
x1=x(1);
x2=x(2);
x3=x(3);
ut=u(5);
%system
g1=1+0.1*cos(t)+0.1*sin(x1);
f1=1*cos(t)-x1;
g2=1+0.1*sin(t)+0.1*cos(x1*x2);
f2=1*sin(t)-(x1^2-1)*x2;
g3=2+0.1*cos(t)+0.2*sin(x1*x2*x3);
f3=10*sin(t)+10*cos(2*t)-(x1^2+x2)*x3;

dx1=g1*x2+f1;
dx2=g2*x3+f2;
dx3=g3*ut+f3;
sys(1)=dx1;
sys(2)=dx2;
sys(3)=dx3;


function sys=mdlOutputs(t,x,u)
x1=x(1);
x2=x(2);
x3=x(3);
xd=u(1);
dxd=u(2);
ddxd=u(3);
dddxd=u(4);
%system
g1=1+0.1*cos(t)+0.1*sin(x1);
f1=1*cos(t)-x1;
g2=1+0.1*sin(t)+0.1*cos(x1*x2);
f2=1*sin(t)-(x1^2-1)*x2;
g3=2+0.1*cos(t)+0.2*sin(x1*x2*x3);
f3=10*sin(t)+10*cos(2*t)-(x1^2+x2)*x3;

dx1=g1*x2+f1;
dx2=g2*x3+f2;
% dx3=g3*ut+f3;

dg1=-0.1*sin(t)+0.1*cos(x1)*dx1;
df1=-1*sin(t)-dx1;
ddx1=dg1*x2+g1*dx2+df1;

ddg1=-0.1*cos(t)-0.1*sin(x1)*dx1^2+0.1*cos(x1)*ddx1;
ddf1=-1*cos(t)-ddx1;
dg2=0.1*cos(t)-0.1*sin(x1*x2)*(dx1*x2+x1*dx2);
df2=1*cos(t)-2*x1*dx1*x2-(x1^2-1)*dx2;

% dddx1=ddg1*x2+2*dg1*dx2+g1*ddx2+ddf1;
% dddx1=ddg1*x2+2*dg1*dx2+g1*(dg2*x3+g2*dx3+df2)+ddf1;
% dddx1=ddg1*x2+2*dg1*(g2*x3+f2)+g1*dg2*x3+g1*g2*g3*ut+g1*g2*f3+g1*df2+ddf1;
% dddx1=g1*g2*g3*ut + ddg1*x2+2*dg1*g2*x3+g1*dg2*x3+g1*g2*f3+2*dg1*f2+g1*df2+ddf1;

% dddz1=dddx1-dddxd=Gu+F
G=g1*g2*g3;
F=ddg1*x2+2*dg1*g2*x3+g1*dg2*x3+g1*g2*f3+2*dg1*f2+g1*df2+ddf1-dddxd;

z1=x1-xd;
z2=dx1-dxd;
z3=ddx1-ddxd;
sys(1)=z1;
sys(2)=z2;
sys(3)=z3;
sys(4)=-F/G;
