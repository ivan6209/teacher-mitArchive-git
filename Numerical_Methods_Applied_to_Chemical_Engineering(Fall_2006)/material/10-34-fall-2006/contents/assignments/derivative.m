function df = derivative(c,i,j,xi,zory);
%calculates the derivative of a two dimensional matrix c at grid point i,j
%input:
%   c: matrix whose derivative is to be evaluates
%   i: the z coordinate
%   j: the y coordinate
%   xi: the grid points on either z or y direction
%   zory: 1, if need z derivative; 2, if need y derivative

if (zory == 1)
    df = (c(i,j) - c(i-1,j))/(xi(i)-xi(i-1));
end

if (zory == 2)
    df = (c(i,j) - c(i,j-1))/(xi(j)-xi(j-1));
end

return;