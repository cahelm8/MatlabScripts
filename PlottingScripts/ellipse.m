function h = ellipse(a,b,cx,cy,angle,color1,color2)
%a: width in pixels
%b: height in pixels
%cx: horizontal center
%cy: vertical center
%angle: orientation ellipse in degrees
% color 1: ellipse face color code
% color 2: ellipse outline color code (e.g., 'r' or [0.4 0.5 0.1])

angle=angle/180*pi;

r=0:0.1:2*pi+0.1;
p=[(a*cos(r))' (b*sin(r))'];

a=[cos(angle) -sin(angle)
       sin(angle) cos(angle)];
   
 p1=p*a;
 
h = patch(cx+p1(:,1),cy+p1(:,2),color1,'EdgeColor',color2);

alpha(h,0.5)
   
   