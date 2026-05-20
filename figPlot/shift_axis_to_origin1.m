% https://blog.csdn.net/Caesar6666/article/details/107669959

% 使用实例：shift_axis_to_origin(gca);其中gca代表刚画出来的图的句柄
function fig_handle = shift_axis_to_origin(axes_handle, lgd)
% function: 本函数目的是把 matlab 做的图坐标轴移到图形的原点
% input:
%   axes_handle: 原坐标轴句柄
% output:
%   fig_handle: 把坐标轴移动到原点的图像句柄

figure('Name','shift_axis_to_origin','NumberTitle','off')  % 创建一个新的窗口
fig_handle = copyobj( axes_handle , gcf );  % 拷贝图形到一个新的图像句柄

xL=xlim ;  % 获取x轴取值范围的最小、做大值：xL = [xlim_min,xlim_max]
yL=ylim ;  % 获取y轴取值范围的最小、做大值: yL = [ylim_min,ylim_max]

xt=get(gca,'xtick') ;  % 获取x轴的刻度
yt=get(gca,'ytick') ;  % 获取y轴的刻度

set(gca,'XTick',[],'XColor','w') ;  % 把底部的x轴坐标的刻度去掉并把底边设置为白色
set(gca,'YTick',[],'YColor','w') ;  % 把左边的y轴坐标的刻度去掉并把底边设置为白色

% 把 x 和 y 坐标轴的两个方向各延长 10% （为了视觉上好看）
extend_x = ( xL(2)-xL(1) ) * 0.1 ;
extend_y = ( yL(2)-yL(1) ) * 0.1 ;
xxL = xL + [ -extend_x extend_x] ;
yyL = yL + [ -extend_y extend_y] ;
%重新设定坐标轴的取值范围
set(gca,'xlim', xxL) ;
set(gca,'ylim', yyL) ;

pos = get(gca,'Position') ;  % 获取当前坐标轴的原点坐标和长宽：pos = [bottom,left,width,height]
box off;  % 上边和右边的边框去掉

% 计算原坐标轴到原点在x,y方向上的偏移量
x_shift = abs( yyL(1)/(yyL(2)-yyL(1)) ) ;
y_shift = abs( xxL(1)/(xxL(2)-xxL(1)) ) ;

temp_1 = axes( 'Position', pos + [ 0 , pos(4) * x_shift , 0 , - pos(4)* x_shift*0.99999 ] ) ;  % 把原底部的x轴移动到x=0的位置上
xlim(xxL) ;  % 复制x轴的取值范围
box off ;
set(temp_1,'XTick',xt,'Color','None','YTick',[]) ; %把背景设为透明，并显示x轴刻度
set(temp_1,'YColor','w') ;  %把y轴去掉

temp_2 = axes( 'Position', pos + [ pos(3) * y_shift , 0 , -pos(3)* y_shift*0.99999 , 0 ] ) ;  % 把原左边的y轴移动到y=0的位置上
ylim(yyL) ;  % 复制y轴的取值范围
box off ;
set(temp_2,'YTick',yt,'Color','None','XTick',[]) ; % 把背景设为透明，并显示y轴刻度
set(temp_2,'XColor','w') ;  % 把x轴去掉

Base_pos = get(fig_handle,'Position') ;  %获取当前图像的左下角坐标和长宽：Base_pos = [bottom,left,width,height]
arrow_pos_in_x_dircetion = Base_pos(2) - Base_pos(4) * yyL(1)/(yyL(2)-yyL(1)) ;
arrow_pos_in_y_dircetion = Base_pos(1) - Base_pos(3) * xxL(1)/(xxL(2)-xxL(1)) ;

annotation('arrow',[Base_pos(1) , Base_pos(1)+Base_pos(3)] , [arrow_pos_in_x_dircetion , arrow_pos_in_x_dircetion ] , 'Color','k');
annotation('arrow',[arrow_pos_in_y_dircetion , arrow_pos_in_y_dircetion ] , [Base_pos(2) , Base_pos(2)+Base_pos(4)] , 'Color','k');

set(axes_handle,'FontName','Helvetica','FontSize',24);
set(lgd,'Interpreter','latex');
end
