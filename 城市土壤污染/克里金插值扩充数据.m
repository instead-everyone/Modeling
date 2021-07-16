%高度
data=xlsread('data1.xls','附件1','B4:D322');
S=data(:,1:2);
Y=data(:,3);

%采用克里金插值法
    theta = [10 10]; lob = [1e-1 1e-1]; upb = [20 20];%参数
    [dmodel, perf] = dacefit(S, Y, @regpoly0, @corrspherical, theta, lob, upb)
    m=1000;
    %创建一个1000*1000的格网，标注范围为0-30000，0-20000，即格网间距为30,20
    X = gridsamp([0 0;20000 30000], m);
    [YX MSE] = predictor(X, dmodel);
    X1 = reshape(X(:,1),m,m); X2 = reshape(X(:,2),m,m);
    YX = reshape(YX, size(X1));

    figure(1)
    surf(X1, X2, YX)
    hold on, 
    hold off
    xlabel('x/m')
    ylabel('y/m')
    zlabel('水平')
    title('高度')
    figure;

 
%污染物
clc,clear
b={'As','Cd','Cr','Cu','Hg','Ni','Pb','Zn'};
nd=xlsread('data1.xls','附件2','B4:I322');
S=xlsread('data1.xls','附件1','B4:C322');
for i=1:8
%克里金插值
    Y=fix(nd(:,i));
    theta = [10 10]; lob = [1e-1 1e-1]; upb = [20 20];%参数
    [dmodel, perf] = dacefit(S, Y, @regpoly0, @corrspherical, theta, lob, upb)
    m=100;
    X = gridsamp([0 0;30000 20000], m);
    [YX MSE] = predictor(X, dmodel);
    X1 = reshape(X(:,1),m,m); X2 = reshape(X(:,2),m,m);
    YX = reshape(YX, size(X1));

    figure;
    mesh(X1, X2, YX)
    hold on, 
    hold off
    xlabel('x/m')
    ylabel('y/m')
    zlabel('浓度')
    title([b(i)])
    figure;
    contourf(X1,X2,YX)
%平面图
    [C,h] = contour(X1,X2,YX);
    xlabel('x/m')
    ylabel('y/m')
    zlabel('浓度')
    title([b(i)])
end