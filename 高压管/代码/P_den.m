%% 计算一定密度下的压强
function y=P_den(density)
a0 = 0.0006492;
a2 =1.181e-09;a1 =-2.005e-06;C1 =-0.217807596;x1= 0;
x2=200;
for i=1:15
    x3=(x1+x2)/2;
    diff =C1 + a0*x3 + a1*x3^2/2+a2*x3^3/3 - log(density);%由附件数据拟合得来
    if diff>0
        x2=x3;
    else
        x1=x3;
    end
end
y=x1;
end