%X_chazhi和Y_chazhi是为方便插值后的（x,y）数据的命名（1000*1000）
X=X_chazhi;
Y=Y_chazhi;
z=Zn';%元素浓度直接以对应符号（对应符号As,Cr,Cd,Cu,Pb,Ni,Zn,Hg都已导入对应的插值数据）
count=1;
for i=2:999
	for j=2:999
        if (z(i,j)>z(i-1,j))&&(z(i,j)>z(i+1,j))&&(z(i,j)>z(i,j+1))&&(z(i,j)>z(i,j-1))&&(z(i,j)>z(i-1,j-1))&&(z(i,j)>z(i-1,j+1))&&(z(i,j)>z(i+1,j-1))&&(z(i,j)>z(i+1,j+1));
            z(i,j)=1000;
        end;
    end;
    end;
    
	[ii,jj]=find(z==1000);
    As_position=[ii,jj];

	disp(ii');disp(jj');
	scatter(ii,jj,'*r'),title('Zn')%这里修改元素符号就好