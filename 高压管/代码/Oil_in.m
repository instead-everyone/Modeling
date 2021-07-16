%% 进油计算

function inQual = Oil_in(time,density,quatyG,Tt1)
global dt;
C=0.85;%流量系数
A=pi*0.7^2;%A口面积
time = mod(time,Tt1);%由于周期的存在,时间取周期的模
densityThis=quatyG/(pi*2.5^2*(8.2576-funP1(time,Tt1)));
P1 = funP2(densityThis);
dP = P1-funP2(density);
if dP>0
    inQual = dt*C*A*sqrt(2*dP/densityThis)*densityThis;%高压油泵的进油质量
else
    inQual =0;
end
    function y = funP1(time,Tt1)
        x =time/Tt1*2*pi;
        if x>pi
            x=2*pi-x;
        end
        p=[0.350883971620368,-1.64948618755122,0.204612192193817,7.21756739475012];
        y =p(1)*x.^3+p(2)*x.^2+p(3)*x.^1+p(4);
    end
end