function [H,V,flag]=arnoldi(A,v,m);
% 
% Arnoldi process: 
%
% Vorth = norm(V'*V - eye(j+1),1)
% Res = norm(A*V(:,1:m) - V*H,1)
%
% -----------------------------------------------------------------------

n = size(A,1);
H = zeros(m+1,m);
V = zeros(n,m+1);

flag = 0;

V(:,1) = v/norm(v);

for j = 1:m,

    w = A*V(:,j);

    for i = 1:j,
        H(i,j) = V(:,i)'*w;
        w = w - H(i,j)*V(:,i);
    end

    H(j+1,j) = norm(w);

    if H(j+1,j) <= eps,
       flag = 1;
       break;
    end

    V(:,j+1) = w/H(j+1,j);

end
