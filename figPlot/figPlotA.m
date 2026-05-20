close all;

tAll = SD_A.time(end);
FontSize = 24;

%% z
% figPlotSignals(SD_A,1,2,{1,'g-';2,'b-';3,'r--'});
% % axis([0 tAll -1.2 1.2]);
% xlabel('$t(s)$','Interpreter','latex','FontSize',FontSize);
% % ylabel('$$','Interpreter','latex','FontSize',FontSize);
% h=legend('$y_d$','$z_1$','$z_2$');
% set(gca,'FontName','Helvetica','FontSize',FontSize);
% set(h,'Interpreter','latex');
% 
% axes('position',[0.4 0.27 0.45 0.25]);
% hold on
% plot(SD_A.time,SD_A.signals(1).values(:,3),'r--','LineWidth',2);
% plot(SD_A.time,SD_A.signals(1).values(:,1),'g-','LineWidth',2);
% plot(SD_A.time,SD_A.signals(1).values(:,2),'b-','LineWidth',2);
% % ylim([0,0.01]);
% % ylim([-0.01,0.01]);
% axis([0 tAll -0.1 0.1]);

%% zo
figPlotSignals(SD_A,4,2,{1,'b-';2,'g-';3,'r--';4,'m--'});
axis([0 tAll -2 2]);
xlabel('$t(s)$','Interpreter','latex','FontSize',FontSize);
% ylabel('$$','Interpreter','latex','FontSize',FontSize);
h=legend('$z_1$','$z_2$','$\hat{z}_1$','$\hat{z}_2$');
set(gca,'FontName','Helvetica','FontSize',FontSize);
set(h,'Interpreter','latex');

axes('position',[0.4 0.27 0.45 0.25]);
hold on
plot(SD_A.time,SD_A.signals(4).values(:,1),'b-','LineWidth',2);
plot(SD_A.time,SD_A.signals(4).values(:,2),'g-','LineWidth',2);
plot(SD_A.time,SD_A.signals(4).values(:,3),'r--','LineWidth',2);
plot(SD_A.time,SD_A.signals(4).values(:,4),'m--','LineWidth',2);
% ylim([0,0.01]);
% ylim([-0.01,0.01]);
axis([0 tAll -0.1 0.1]);

%% s
figPlotSignals(SD_A,3,2,{1,'b-';2,'m-.';3,'r--'});
% axis([0 tAll -1.2 1.2]);
xlabel('$t(s)$','Interpreter','latex','FontSize',FontSize);
% ylabel('$$','Interpreter','latex','FontSize',FontSize);
% h=legend('$s_{fn}$','$x_U$','$x_L$');
h=legend('$s$','$\widetilde{x}_U$','$\widetilde{x}_L$');
% h=legend('$s$','$y_U$','$y_L$');
% h=legend('$s$','$\widetilde{y}_U$','$\widetilde{y}_L$');
set(gca,'FontName','Helvetica','FontSize',FontSize);
set(h,'Interpreter','latex');

axes('position',[0.4 0.27 0.45 0.2]);
hold on
plot(SD_A.time,SD_A.signals(3).values(:,1),'b-','LineWidth',2);
plot(SD_A.time,SD_A.signals(3).values(:,2),'m-.','LineWidth',2);
plot(SD_A.time,SD_A.signals(3).values(:,3),'r--','LineWidth',2);
% ylim([0,0.01]);
% ylim([-0.01,0.01]);
% axis([0.3 0.7 1.4 5]);
axis([4.4 5.8 -0.23 -0.09]);

%% z1-z2
figure('color','white');
hold on
plot(SD_A.signals(4).values(:,1),SD_A.signals(4).values(:,2),'g','LineWidth',2);
% plot(SD_A.signals(1).values(:,2),y.signals.values(:,2),'b--','LineWidth',1);
% axis([-1.2 1.2 -1.2 1.2]);
xlabel('$z_1$','Interpreter','latex','FontSize',FontSize);
ylabel('$z_2$','Interpreter','latex','FontSize',FontSize);
h=legend('$(z_1,z_2)$');
set(gca,'FontName','Helvetica','FontSize',FontSize);
set(h,'Interpreter','latex');

%% u
figPlotSignals(SD_A,2,2,{1,'b-';2,'r--'});
% axis([0 tAll -500 2000]);
xlabel('$t(s)$','Interpreter','latex','FontSize',FontSize);
% ylabel($u_l$','Interpreter','latex','FontSize',FontSize);
h=legend('$-\frac{F}{G}$','$u$');
set(gca,'FontName','Helvetica','FontSize',FontSize);
set(h,'Interpreter','latex');
