%对simulink-scope记录的曲线的绘制：（多input port版本，每个port仅一路信号）
%首先要设置simulink中scope-设置-记录-记录数据到工作区-设置变量名称（即本函数中的x），保存格式“Structure With Time”

%使用实例：
% figPlotMuti(x1,2,{'g--';'b-';'m-.';'r--'});
%//下面是对这副图的坐标轴范围、坐标轴名称、图例、字体的操作实例
% axis([0 tAll -0.6 0.6]);
% xlabel('time(s)');
% ylabel('x_{1}(m/s)');
% h=legend('$x_{1d}$','$x_{1}$','$F_{1}$','$-F_{1}$');
% set(gca,'FontName','Helvetica','FontSize',24);
% set(h,'Interpreter','latex');

%参数说明：
%至少包括一个参数，最多可以三个参数
%x：simulink-scope中设置的变量名称
%两个参数时：第二个参数：可以是数字，用于设置线条宽度；也可以是一个cell，用于设置每个线条的样式
%三个参数时：第二必须是数字，用于设置线条宽度，第三个必须是cell，用于设置每个线条的样式
function figPlotMuti(x,varargin)

figure('color','white');

switch nargin %总输入参数个数，varargin是可变数量参数的对象
case 1
    for i=1:size(x.signals,2)
        plot(x.time,x.signals(i).values,'LineWidth',2);hold on;
    end
case 2
    % 仅设定了线条宽度
    if isa(varargin{1},'double')
        lineWidth = varargin{1};
        for i=1:size(x.signals,2)
            plot(x.time,x.signals(i).values,'LineWidth',lineWidth);hold on;
        end
    % 仅设定了每个线条的显示方式
    elseif iscell(varargin{1})
        lineType = varargin{1};
        plotWithType(x,2,lineType);
    end
case 3
    lineWidth = varargin{1};
    lineType = varargin{2};
    plotWithType(x,lineWidth,lineType);
otherwise
    error('figPlot的输入参数过多');
end

grid on
% grid minor %%稠密网格
end

%将x内的目标信号按照给定设定plot
function plotWithType(x,lineWidth,lineType)
    if size(lineType,1)>size(x.signals,2)
        error('信号数量比预期的少');
    end
    if size(lineType,2)==1
        for i=1:size(lineType,1)
            plot(x.time,x.signals(i).values,lineType{i},'LineWidth',lineWidth);hold on;
        end
    elseif size(lineType,2)==2
        for i=1:size(lineType,1)
            plot(x.time,x.signals(lineType{i,1}).values,lineType{i,2},'LineWidth',lineWidth);hold on;
        end
    end
end
