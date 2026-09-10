%clear
%close all
figure
for i=1:12
    for j=5:5:100
        X=0.5+[i-1 i i i-1]; 
        Y=[j-5 j-5 j j];
        patch(X,Y,HInt2RGB(i,j),'EdgeColor','none');
    end
end
xlim ([0.5 12.5]);
set (gca,'xtick',[1:12]);
title ('Available colors');
xlabel ('Hue');
ylabel ('Grayscale intensity - red is 100%');
%%
figure;

Nmax=14;%10;
istart=1;%9;
intmin=10;
for i=1:Nmax
    ic=mod(istart+(i-2)*1,10); if (ic==0) ic=10; end
    int=floor(100-(100-intmin)*(i-1)/(Nmax-1));
    patch(0.5+[i-1 i i i-1],[0 0 1 1],HInt2RGB(ic,int),'EdgeColor','none'); hold on
    rgb(i,:) = HInt2RGB(ic,int); 
end

title ('Example 15 colors int 100->30');

% 

% calcOptimalColormap