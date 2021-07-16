%X_chazhi，Y_chazhi，Z('As ','Cd','Cr ','Cu','Hg','Ni','Pb','Zn')
X=X_chazhi;
Y=Y_chazhi;
Z=Zn;
z=Z';
k=z;
%各数据初始化
CC=[],c=[],ii=[],jj=[],pp=[],rr=[],kk=[],kkk=[],n=[];
for i=2:999
    for j=2:999
        if (z(i,j)>z(i-1,j))&&(z(i,j)>z(i+1,j))&&(z(i,j)>z(i,j+1))&&(z(i,j)>z(i,j-1))&&(z(i,j)>z(i-1,j-1))&&(z(i,j)>z(i-1,j+1))&&(z(i,j)>z(i+1,j-1))&&(z(i,j)>z(i+1,j+1))
        z(i,j)=1000;
		end;
	end;
end;
[ii,jj]=find(z==1000);
c=[ii,jj];
n=size(ii,1);

for i=1:n
	kk(i)=k(ii(i),jj(i));
end

pp=kk';
kkk=find(kk>600);%这里是算取到的范围
kkk=kkk';
n=size(kkk,1);
for i=1:n
	rr(i)=pp(kkk(i));
end

for i=1:n
	CC(i,1)=c(kkk(i),1);
	CC(i,2)=c(kkk(i),2);
end
scatter(CC(:,1),CC(:,2),'*r')
axis([0,1000,0,1000.]),title('Zn');
%CC是污染源对应（X,Y）1000*1000中对应序列的坐标，rr是对应污染源极大值点浓度坐标
