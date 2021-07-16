clear,clc
global dt Tc;%定义全局变量dt和Tc，分别为时间离散长度和最大公倍数周期
Tc= 1;dt = 0.1;
N=1000*Tc/dt;
density = 0.850;% 密度初值
T1s = 50;%231
[T1,error] = InTime(T1s);% t0:初始喷油延时,fP:目标压强
T1 = 50;
%%重新计算最优值,记录中间结果

count =1;
for n= 1:N%离散计算
    time=n*dt; %计算实际时间
    %每一周期过后油量增加到初始值8.5Mpa
    count0 =ceil(time/T1);
    if count0==count
        quatyG = (8.2576-2.413)*pi*2.5^2*0.804541084;%高压油泵进油质量
        count0 = count;
        count =count +1;
        T1Rand =T1*(1-rand*0);
    end
    Tra(n)=T1Rand;
    %进油quatyG:高压油管内的燃油质量
    inQual = Oil_in(time, density, quatyG,T1Rand);% Oil_in为进油方程
    inQ(n)=inQual;
    quatyG =quatyG - inQual;
    %出油
    outQual = Oil_out(time, density);% Oil_out为出油方程
    outQ(n)=outQual;
    %更新密度
    allM = density*pi*5^2*500;
    density =(allM - outQual + inQual)/(pi*5^2*500);% 油管内燃油密度
    Denp(n)= P_den (density);% P_den为密度-压强转换两数
    redu= 0;
    if Denp(n)>100
        dP = Denp(n)-0.1;C= 0.85;%流量系数
        A=pi*0.7^2;%A口的面积
        redu = dt*C*A*sqrt(2*dP/density)*density;
        %更新密度
        allM = density*pi*5^2*500;
        density = (allM - redu)/(pi*5^2*500);
        Denp(n)= P_den(density);
    end
    reduQ(n)=redu;
    Err1(n)=Denp(n)-100;
end

Err2=sum(Err1)/N;%该时间内输入油量的误差
Err3=sum(abs(Err1))/N;%波动误差

%% 数据整理
%绘制压强曲线图
figure
plot((1:N)*dt,Denp,'-','Linewidth',1)
legend('压强曲线')
xlabel('时间t(ms)')
ylabel('压强P(Mpa)')
set(gcf,'units','centimeters')%标准单位:厘米
set(gcf,'InnerPosition',[0 5 16 8])%在屏幕的位置，图窗的长宽

%绘制压强差
figure
plot((1:N)*dt,Err1,'-','Linewidth',1)
legend('压强差')
xlabel('时间t(ms)')
ylabel('压强差P(Mpa)')
set(gcf,'units','centimeters')%标准单位:厘米
set(gcf, 'InnerPosition',[16 5 16 8])%在屏幕的位置，图窗的长宽

%绘制时间与流速和时间与阀流速关系图
figure
yyaxis left
plot((1:N)*dt,reduQ/dt,'r-','Linewidth',0.6)
%axis([1, Tc*1000,0,4])
xlabel('时间t(ms)')
ylabel('阀流速v(mg/ms)')
yyaxis right
plot((1:N)*dt,Err1,'b-','Linewidth',1)

%Legend('压力误差')
xlabel('时间t(ms)')
ylabel('压强差P(Mpa)')
legend('压强差','阀流速')
set(gcf,'units','centimeters')%标准单位:厘米
set(gcf,'InnerPosition',[0 8 16 8])%在屏幕的位置，图窗的长宽
fprintf('波动误差为:%.3fMpain\n' ,Err3)
fprintf('喷油角速度为%.3frad/ms\n',2*pi/T1)
fprintf('喷油周期为%.3fmsIn\n',T1)


        
        
