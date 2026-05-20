close all;
% clf reset


% 方式一：绘图后放缩图像
x=0:0.05:1;
y1=x.^2;
y2=1-x.^2;
C6=0.2+x-x;
figure
% plot(x,y1,x,y2,x,C6);
plot(x,y1,'b*',x,y2,'r-',x,C6);
axes('position',[0.2 0.4 0.3 0.3]);
plot(x,y1,'b*',x,y2,'r-',x,C6);
xlim([0.7,1]);


% 方式二：直接绘局部图
figure
t=0:0.1:10;
plot(t,exp(0).*sin(20*pi*t))
h2=axes('Position',[0.5 0.5 0.3 0.3]);
%比如插入x\in [1 2]之间的函数变化
tt=1:0.1:2;%这里在绘图前直接定义了tt的范围
plot(tt,exp(-10*tt).*sin(20*pi*tt))
