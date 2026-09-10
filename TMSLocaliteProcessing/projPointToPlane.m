function C_proj = projPointToPlane(n,P,C)

% P is  a point on the plane
% n is a normal vector 
% C is the point to project

n = n / norm(n);

v = C - P;
distance = dot(v,n);
C_proj = C - distance * n;



end