xm=table2array(zonghe(:,1));
ym=table2array(zonghe(:,2));
Z=table2array(zonghe(:,10));
xlabel('x'),ylabel('y');

contourf(xm,ym,Z) %等高线图
colorbar

hold on,
%绘制不同功能区的污染程度
plot(table2array(level_1(:,1)),table2array(level_1(:,2)),'r *'),%等级1
hold on,
plot(table2array(level_2(:,1)),table2array(level_2(:,2)),'g *'),
hold on,
plot(table2array(level_3(:,1)),table2array(level_3(:,2)),'b *'),
hold on,
plot(table2array(level_4(:,1)),table2array(level_4(:,2)),'w *'),
hold on,
plot(table2array(level_5(:,1)),table2array(level_5(:,2)),'k *'),
legend("","level1","level2","level3","level4","level5");
title('xxx元素污染程度')%画出每一点的位置
xlabel('x'),ylabel('y');