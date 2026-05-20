function [sys,x0,str,ts] = Sinput3(t,x,u,flag)
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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];


function sys=mdlOutputs(t,~,~)
sys(1)=sin(t);
sys(2)=cos(t);
sys(3)=-sin(t);
sys(4)=-cos(t);
% sys(1)=0;
% sys(2)=0;
% sys(3)=0;
% sys(4)=0;
