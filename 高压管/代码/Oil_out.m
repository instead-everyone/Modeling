%% 出油量计算
function outQual =Oil_out(time,density)
global dt;
C=0.85;
time = mod(time,100);%由于周期的存在,时间取周期的模
outQual =dt*C*fA(time)*sqrt(2*(funP2(density)-0.1)/density)*density;
%喷油器出油横截面积和升程的关系分段拟合方程
function y =fA(t)
    if t <=0.33
        y = 66.71*t^3 -9.078*t^2+0.386*t -0.00245;
    elseif t <= 2.11
        y=1.53938040025900;
    elseif t<=2.46
        p= [-12599.3716123347,174495.841196611,-1006433.46601700, 3094198.90735766,-5347936.07171245,4926758.50356979,-1889937.68991857];
        y=p(1)*t.^6+p(2)*t.^5+p(3)*t.^4+p(4)*t.^3+p(5)*t.^2+p(6)*t.^1+p(7);
    else
        y=0;
    end
end
end