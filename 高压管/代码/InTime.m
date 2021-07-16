%% 计算进油工作周期：
function [T1,error] = InTime(T1s)

global dt Tc;%定义全局变量dt和Tc,分别为时间离散长度和最大公倍数周期N=1000*Tc/dt;
s =0;
N=1000*Tc/dt;
for Tt1 = T1s%搜索法,进油工作周期
    density = 0.850;%密度初值
    count =1;
    for n=1:N%离散计算
        time =n*dt;%计算实际时间
        %每一周期过后油量增加到初始值0.5Mpa对应的油量
        count0 = ceil(time/Tt1);
        if count0 ==count
            quatyG =(8.2576-2.413)*pi*2.5^2*0.804541084;%高压油泵进油
            count0 = count;count = count +1;
        end
        %进油quatyG:高压油管内的燃油质量
        inQual = Oil_in(time, density, quatyG, Tt1);
        quatyG = quatyG - inQual;
        %出油
        outQual =Oil_out(time, density);%更新密度
        allM=density*pi*5^2*500;
        density = (allM - outQual*2 + inQual)/(pi*5^2*500);
        thisDen = P_den (density);
        if thisDen>100
            dP= thisDen-0.1;
            C = 0.85;%流量系数
            A= pi*0.7^2;
            redu = dt*C*A*sqrt(2*dP/density )*density;
            allM = density*pi*5^2*500;
            density = (allM - redu)/(pi*5^2*500);
            thisDen = P_den(density);
        end
        Err1(n)= thisDen - 100;
    end
    s = s+1;Tt(s) =Tt1;
    Err2(s) = sum(Err1)/N;%该时间内输入油量的误差
    Err3(s)= sum(abs(Err1))/N;%波动误差
end
[~,post] = min(abs(Err2));%最小误差值
T1 = Tt(post);
error = Err3(post);%波动误差
end