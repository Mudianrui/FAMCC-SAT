% 本函数目的是把 matlab 做的图坐标轴移到图形的中间部分去(与数学的做图习惯一致)
% 在https://blog.sina.com.cn/s/blog_4ac35a650100va35.html基础上
% 1、增加isCopynew：0在原图上修改，1新建副本修改。
% 2、增加scale：0不改变原图大小，≠1延长坐标轴百分比。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_fig_handle = shift_axis_to_origin(fig_handle, varargin)
if nargin>1
    isCopynew = varargin{1};
end
if nargin>2
    scale = varargin{2};
else
    scale = 0.1;
end
if isCopynew==1
    figure('Name','shift_axis_to_origin','NumberTitle','off')
    new_fig_handle = copyobj( fig_handle, gcf );% 拷贝图形到一个新的窗口
else
    new_fig_handle = fig_handle;
end
xL=xlim ;
yL=ylim ;

xt=get(gca,'xtick') ;
yt=get(gca,'ytick') ;
set(gca,'XTick',[],'XColor','w') ;
set(gca,'YTick',[],'YColor','w') ;

% 把 x 和 y 坐标轴的两个方向各延长 scale*100% （为了顶格的曲线在视觉上好看）
extend_x = ( xL(2)-xL(1) ) * scale ;
extend_y = ( yL(2)-yL(1) ) * scale ;
xxL = xL + [ -extend_x extend_x] ;
yyL = yL + [ -extend_y extend_y] ;
set(gca,'xlim', xxL) ;
set(gca,'ylim', yyL) ;

% figure的position中的[left bottom width height] 是指figure的可画图的部分的左下角的坐标以及宽度和高度。
pos = get(gca,'Position') ;
box off;

% 设置新的坐标轴
x_shift = abs( yyL(1)/(yyL(2)-yyL(1)) ) ;
y_shift = abs( xxL(1)/(xxL(2)-xxL(1)) ) ;

temp_1 = axes( 'Position', pos + [ 0 , pos(4) * x_shift , 0 , - pos(4)* x_shift*0.99999 ] ) ;
xlim(xxL) ;
box off ;
set(temp_1,'XTick',xt,'Color','None','YTick',[]) ;
set(temp_1,'YColor','w') ;

temp_2 = axes( 'Position', pos + [ pos(3) * y_shift , 0 , -pos(3)* y_shift*0.99999 , 0 ] ) ;
ylim(yyL) ;
box off ;
set(temp_2,'YTick',yt,'Color','None','XTick',xt) ;
set(temp_2,'XColor','w') ;

% 设置带箭头的坐标轴
Base_pos = get(new_fig_handle,'Position') ;
arrow_pos_in_x_dircetion = Base_pos(2) - Base_pos(4) * yyL(1)/(yyL(2)-yyL(1)) ;
arrow_pos_in_y_dircetion = Base_pos(1) - Base_pos(3) * xxL(1)/(xxL(2)-xxL(1)) ;

annotation('arrow',[Base_pos(1) , Base_pos(1)+Base_pos(3)] , [arrow_pos_in_x_dircetion , arrow_pos_in_x_dircetion ] , 'Color','k');
annotation('arrow',[arrow_pos_in_y_dircetion , arrow_pos_in_y_dircetion ] , [Base_pos(2) , Base_pos(2)+Base_pos(4)] , 'Color','k');
end