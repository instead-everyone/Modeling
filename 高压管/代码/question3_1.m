%密度函数，压力函数
density=@(x)0.80853816*(1+ (0.6*10^-3*x)/(1+1.7*10^-3*x));
P=@(x)-(90071992547409920000*x-72826643121816530000)/(153122387330596864*x-167501279180178019);


c=0.85;
V=(5^2)*500*pi;
A=(1.4/2)^2*pi;
A_oil=(5/2)^2*pi;
H=5.8446;
Vmax=H*A_oil;
M=Vmax*density(0.5);
m0=density(100)*V;
delta_t=0.01;
p_wai=0.1;
theta=xlsread('附件1-凸轮边缘曲线','sheet1','A2:A629');
r=xlsread('附件1-凸轮边缘曲线','sheet1','B2:B629');
L0=0.7/tan(9/180*pi)*2.5/1.4;
A_zhen=(2.5/2)^2*pi;
A_kong=0.7^2*pi;
k=[];x=[];y=[];
al=xlsread('附件2-针阀运动曲线','sheet1','B2:B46');
cl=xlsread('附件2-针阀运动曲线','sheet1','E2:E46');
bl=2*ones(156,1);
h_zhen=[al;bl;cl;zeros(9755,1)]';

yanchi=5000;
%延迟后真正的输入油

x_test=[],y_test=[];
flag=1;
temping=0;
%  for yanchi=4400:10:5500
    for i=10001:-1:yanchi+1
        h_zhenl(i)=h_zhen(i-yanchi);
    end
    for i=1:1:yanchi
        h_zhenl(i)=0;
    end
    
    for i=1:628
        x(i)=sin(theta(i))*r(i);
        y(i)=cos(theta(i))*r(i);
    end
    s=[];u=1;
    
    for i=0:0.01:6.27
        xk=[];
        yk=[];
        for j=1:628
            xk(j)=x(j)*cos(i)-y(j)*sin(i);
            yk(j)=x(j)*sin(i)-y(j)*cos(i);
        end
        s(u)=max(yk)-2.4130;
        u=u+1;
    end
    
    s=interp1([0:0.01:6.27],s,[0:0.000001:6.27],'spline');
    w=0.0545;
    j=1;
    u=1;
    p0=100;
    rho0=0.85;
    m_oil=M;
    fy=1;
    
    for i=0:delta_t:100000
        fy=fy+int32(w*delta_t/0.000001);
        while fy>6270001
            fy=fy-6270001;
            m_oil=M;
        end
        h_now=H-s(fy);
        V_now=A_oil*h_now;
        rho_now=m_oil/V_now;
        P_now=P(rho_now);
        vin=0;
        if P_now>p0
            vin=c*A*(2*(P_now-p0)/rho_now)^(.5);
        end
        m_in=rho_now*vin*delta_t;
        m_oil=m_oil-m_in;
        rl=(h_zhen(u)+L0)*tan(9/180*pi);
        rl2=(h_zhenl(u)+L0)*tan(9/180*pi);
        
        A_out=pi*rl^2-A_zhen;
        if pi*rl^2-A_zhen-A_kong>0
            A_out=A_kong;
        end
        if h_zhen(u)==0
            A_out=0;
        end
        
        Al_out=pi*rl2^2-A_zhen;
        if pi*rl2^2-A_zhen-A_kong>0
            Al_out=A_kong;
        end
        if h_zhenl(u)==0
            Al_out=0;
        end
        u=u+1;
        if u>10001
            u=u-10001;
        end
        vout=c*(A_out+Al_out)*(2*(p0-p_wai)/rho0)^(.5);
        mout=vout*rho0*delta_t;
        delta_m=m_in-mout;
        rho0=(m0+delta_m)/V;
        k(j)=p0;
        p0=P(rho0);
        j=j+1;
        
        m0=m0+delta_m;
    end
    %测试结果
    ave=0
    if(flag>1)
        ave=mean(k(:));
        x_test(flag-1)=yanchi;
        y_test(flag-1)=abs(ave-temping);
        temping=ave;
    else
        temping=ave;
    end
    flag=flag+1;
    
% end
% 
%查看不同间隙时间对应的压力：
% plot(x_test,y_test);
% xlabel('间隔时间');
% ylabel('压强差');


 plot(k)
 xlabel('时间(t/ms)')
 ylabel('压力(P/MPa)')
