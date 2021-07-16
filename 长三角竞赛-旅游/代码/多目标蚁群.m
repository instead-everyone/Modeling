多目标蚁群算法：main.m
%% 蚁群算法求解TSP问题


%% 清空环境变量
clear 
clc
%% 导入数据
%%此时坐标之间的距离就量化为路程时间+目的景点滞留时间
citys=[     0    0
    24.7407    4.8535
   90.2420   57.6453
   59.4352   61.6624
   79.4263   37.0313
   77.0310   44.6290
    6.1991   81.1495
   15.4004   67.8402
   72.2492   43.9154
   62.0861   57.6873
   32.9242   89.2398
   73.1427   26.6720
   26.4250   47.4074
   32.4315   90.0216
   80.4632   34.4149
   36.8873   78.0451
   87.3951   27.4268
   69.8592   17.0459
   38.6822   25.4801
    5.1970   11.1690];
%每个景点分数
Grade=[92.49,91.57,91.57,89.73,99.58,83.83,82.91,80.32,66.33,66.33,68.51,67.59,67.95,67.95,59.92,59,59.13,58.21,49.39,49.39];
total_Grade=0;
%共计游玩时间
Time=168;

%% 计算景区间相互距离
n = size(citys,1);
D = zeros(n,n);
for i = 1:n
    for j = 1:n
        if i ~= j
            D(i,j) = sqrt(sum((citys(i,:) - citys(j,:)).^2));
        else
            D(i,j) = 1e-4;      
        end
    end    
end

%% 初始化参数
m = 70;                              % 蚂蚁数量
alpha = 1;                           % 信息素重要程度因子
beta = 5;                            % 启发函数重要程度因子
rho = 0.1;                           % 信息素挥发因子
Q = 1;                               % 常系数
Eta = 1./D;                          % 启发函数（越小越好）
Eta1=Grade/100                     % 启发函数二：景点评分（经转换也是越小越好）
Tau = ones(n,n);                     % 信息素矩阵
Table = zeros(m,n);                  % 路径记录表
iter = 1;                            % 迭代次数初值
iter_max = 200;                      % 最大迭代次数 
Route_best = zeros(iter_max,n);      % 各代最佳路径       
Length_best = zeros(iter_max,1);     % 各代最佳路径的长度  
Length_ave = zeros(iter_max,1);      % 各代路径的平均长度  

%% 迭代寻找最佳路径
while iter <= iter_max
    % 随机产生各个蚂蚁的起点城市
      start = zeros(m,1);
      for i = 1:m
          temp = randperm(n);
          start(i) = temp(1);
      end
      Table(:,1) = start; 
      % 构建解空间
      citys_index = 1:n;
      % 逐个蚂蚁路径选择
      for i = 1:m
          % 逐个城市路径选择
         for j = 2:n
             tabu = Table(i,1:(j - 1));           % 已访问的城市集合(禁忌表)
             allow_index = ~ismember(citys_index,tabu);
             allow = citys_index(allow_index);  % 待访问的城市集合
             P = allow;
             % 计算城市间转移概率,应该要加入景点分数
             for k = 1:length(allow)
                 P(k) =Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
             end
             P = P/sum(P);
             % 轮盘赌法选择下一个访问城市
             Pc = cumsum(P);     
            target_index = find(Pc >= rand); 
            target = allow(target_index(1));
            Table(i,j) = target;
         end
      end
      %重点%首先记录上一次迭代之后的最佳路线放在第一个位置
      if iter>=2
          table(1,:)=Route_best(iter-1,:);
      end
      
      % 计算各个蚂蚁的路径距离
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));
      end
      % 计算最短路径距离及平均距离
      if iter == 1
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min_Length;  
          Length_ave(iter) = mean(Length);
          Route_best(iter,:) = Table(min_index,:);
      else%试着在这里修改，添加因素
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min(Length_best(iter - 1),min_Length);
          Length_ave(iter) = mean(Length);
          if Length_best(iter) == min_Length
              Route_best(iter,:) = Table(min_index,:);
          else
              Route_best(iter,:) = Route_best((iter-1),:);
          end
      end
      % 更新信息素
      Delta_Tau = zeros(n,n);
      % 逐个蚂蚁计算
      for i = 1:m
          % 逐个城市计算
          for j = 1:(n - 1)
              %每个城市分数越高，释放的信息素越多，具体的信息素，量化为0-1模型
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i)+Eta1(j);
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i)+Eta1(j);
      end
      Tau = (1-rho) * Tau + Delta_Tau;
    % 迭代次数加1，清空路径记录表
    iter = iter + 1;
    Table = zeros(m,n);
end

%% 结果显示
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['最少需要的时间:' num2str(Shortest_Length*0.42)]);%这里的时间还需要乘以一个系数，这个系数是将每个景点之间距离转换为1-100坐标轴的相关系数的倒数
disp(['最短路径:' num2str([Shortest_Route Shortest_Route(1)])]);
for i=1:Shortest_Route
    total_Grade=total_Grade+Grade(Shortest_Route(i));
end
disp(['同时最高收益:' num2str(total_Grade)]);

%% 绘图
figure(1)
plot([citys(Shortest_Route,1);citys(Shortest_Route(1),1)],...
     [citys(Shortest_Route,2);citys(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);
end
text(citys(Shortest_Route(1),1),citys(Shortest_Route(1),2),'');
text(citys(Shortest_Route(end),1),citys(Shortest_Route(end),2),'');
xlabel('城市位置横坐标')
ylabel('城市位置纵坐标')
title('蚁群算法优化路径');
figure(2)
plot(1:iter_max,Length_best,'b',1:iter_max,Length_ave,'r:')
legend('最短距离','平均距离')
xlabel('迭代次数')
ylabel('距离')

title('各代最短距离与平均距离对比')
