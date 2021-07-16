%%
%引入数据
question01data=xlsread('附件3-弹性模量与压力.xlsx',1,'A2:B402');
Pression=question01data(:,1);%压力
elastic_Mo=question01data(:,2);%弹性模量
%density=@(x)0.80853816*(1+ (0.6*10^-3*x)/(1+0.0017*x));%(Pression-137.9)/8.9;%燃油密度----------------------------有问题
flag=1;
flag=flag+1;

%进出油
T1=0;%每次进油的时间（待求值）
T2=10;%进油间隔10ms
T3=2.4;%每次出油的时间为2.4ms
T4=0;%出油间隔时间（相当于不用）
Time_out=100;%单次出油时间为100ms
Time_in=0;%进油时间
delta=0.01;%ms
V=(5^2)*500*pi;%体积
A=(1.4/2)^2*pi;%A口的面积


P0=100;%开始压强
m0=0;%对应密度的质量
C=0.85;%流量系数
A=0.7*pi*pi;%A处小孔面积mm2
p0=100;
Pression_change=60;%这是按照160MPa和100MPa来计算的
Q=0%进出高压管流量
%喷油分段函数
Out_V=@(x)100*x.*(x<=0.2)+20.*(x>0.2&x<=2.2)-(100*x-240).*(x>2.2&x<=2.4)+0.*(x>2.4);
Pression_x=@(x)(x-0.80853816)/(0.001859637768-0.00170*x);
density=@(x)(-6.441e-07*x^2-0.0005171*x+0.8048)

x=[];%绘图x：时间
y=[];%绘图y：压力
flag1=0;
%%
%代码部分

%Q=C.*A*sqrt(2.*Pression_change/density);
%V=Q.*T;一个进油周期的进油量
%min->sum(p(t)-p(1))

%输出：

for t=0.1:0.5:10%范围
    
    flag=0;
    Time_in=0;
    Time_out=0;
    m0=100;
    flag1=flag1+1;
    x=[],y=[];
    for i=0:delta:100000
        flag=flag+1;
        x(flag)=i;
        y(flag)=p0;
        vin=0;%流量
        if Time_in>t+10
            Time_in=Time_in-(t+10);
        end
        if Time_in<t
            vin=(C*A*(2*(160-p0)/0.8710)^(.5));
        end
        
        Time_in=Time_in+delta;
        m_in=0.8696*vin*delta;%进来的总质量
        if Time_out>100
            Time_out=Time_out-100;
        end
        vout=Out_V(Time_out)*delta;%v
        Time_out=Time_out+delta;
        m_out=vout*density(p0) ;%m
        delta_m=m_in-m_out;
        
        rho_now=(m0+delta_m)/V;
        p0=Pression_x(rho_now);
        m0=m0+delta_m;
        flag=flag+1;
        x(flag)=i;
        y(flag)=p0;
    end
    
    y_sum=0;k=0;
    for j=9950000:10000000
        k=k+1;
        y_sum=y_sum+y(j);
    end
    y_sum=y_sum/k;
    y_t(flag1)=y_sum,x_t(flag1)=t;
    
end

plot(x_t,y_t);
%plot(x,y);
