%%
%引入文件
question02data=xlsread('附件1-凸轮边缘曲线.xlsx',1,'A2:B629');
question02data_zhen1=xlsread('附件2-针阀运动曲线',1,'B2:B46');
question02data_zhen2=xlsread('附件2-针阀运动曲线',1,'E2:E46');
%%
%拟合公式：
density=@(x)(-6.441e-07*x^2-0.0005171*x+0.8048)
Pression=@(x)(x-0.80853816)/(0.001859637768-0.00170*x);

%%
%已知量定义
c=0.85; %单向阀孔面积
A=(1.4/2)^2*pi;
A_oil=(5/2)^2*pi;
H=5.8846;%容器整体高度
Vmax=H*A_oil;%最大的体积
M=Vmax*rho(0.5);%初始油质量
V=(5^2)*500*pi;%油管体积
m0=rho(100)*V;%高压油管初始质量
delta_t=0.01;%步长
p_wai=0.1;%油孔外气压
theta=question02data(:,1);
r=question02data(:,2);
L0=0.7/tan(9/180*pi)*2.5/1.4;%针阀初始高度（圆锥顶点）
A_zhen=(2.5/2)^2*pi;%针阀的底面积
A_kong=0.7^2*pi;%喷孔的底面积

a1=question02data_zhen1;
b1=2*ones(156,1);
c1=question02data_zhen2;
h_zhen=[a1;b1;c1;zeros(9755,1)]';%针阀上升距离
k=[];x=[];y=[];

%%
%代码运算
%计算每个极角对应的x,y
for i=1:628
    x(i)=sin(theta(i))*r(i);
    y(i)=cos(theta(i))*r(i);
end

s=[];u=1;

%每0.01rad油泵上升的距离
for i=0:0.01:6.27
    xk=[];yk=[];
    for j=1:628
        xk(j)=x(j)*cos(i)-y(j)*sin(i);
        yk(j)=x(j)*sin(i)-y(j)*cos(i);
    end
    s(u)=max(yk)-2.4130;%2.4130是最低距底部距离
    u=u+1;
end

%不同角速度对应稳定压强：由此确定w的范围
y_test=[];
x_test=[];
s=interp1([0:0.01:6.27],s,[0:0.000001:6.27],'spline');%三次样条插值

%for w=0.027:0.0001:0.028

w=0.02725;
j=1;
u=1;
p0=100;
rho0=0.85;
m_oil=M;
fy=1;
for i=0.1:0.01:1
    
    w=0.0273;%算出来的角速度
    j=1;
    u=1;
    p0=100;%管内初始压强
    rho0=0.85;%管内初始密度
    m_you=M;%油箱初始质量
    fy=1;%这是个啥？？
    
    for i=0:delta_t:20000%这里再修改一下吧:2s
        fy=fy+int32(w*delta_t/0.000001)%角度
        while fy>6270001
            fy=fy-6270001;%到下一个周期
            m_you=M;%补油
        end
        h_now=H-s(fy);%剩余高度
        V_now=A_oil*h_now;%剩余体积
        rho_now=m_you/V_now;%当前邮箱密度
        P_now=Pression(rho_now);%当前压强
        vin=0;
        if P_now>p0
            vin=c*A*(2*(P_now-p0)/rho_now)^(.5);%进入流量
        end
        m_in=rho_now*vin*delta_t;%进入质量
        m_you=m_you-m_in;%剩余油质量
        r1=(h_zhen(u)+L0)*tan(9/180*pi);h_z=h_zhen(u);%大圆半径
        A_out=pi*r1^2-A_zhen;
        if pi*r1^2-A_zhen-A_kong>0
            A_out=A_kong;
        end
        if h_zhen(u)==0
            A_out=0;%不喷油情况
        end
        u=u+1;
        if u>10001
            u=u-10001;
        end
        
        vout=c*A_out*(2*(p0-p_wai)/rho0)^(.5);%喷油流量
        mout=vout*rho0*delta_t;%喷出质量
        delta_m=m_in-mout;%管内质量差
        rho0=(m0+delta_m)/V;%管内新密度
        k(j)=p0;
        p0=Pression(rho0);%管内新亚强
        j=j+1;
        
        m0=m0+delta_m;
    end
    ave=mean(k(:));
    x_test(flag)=w;
    y_test(flag)=ave;
flag=flag+1;
end
%用来有限二乘得到的数据图形：
ave=mean(k(:));
x_test(flag)=w;
y_test(flag)=ave;
flag=flag+1;
%
%检测角速度对应的平均压力：
% plot(x_test,y_test);
% title('不同角速度对应稳定压力')
% xlabel('角速度(w/rad)')
% ylabel('压力(P/MPa)')

%查看压力变化结果
plot(k)
xlabel('时间')
ylabel('压力')


