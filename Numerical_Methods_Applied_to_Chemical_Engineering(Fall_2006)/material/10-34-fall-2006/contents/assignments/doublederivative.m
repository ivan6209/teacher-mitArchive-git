function ddf = doublederivative(c,i,j,xi,zory);
%calculates the second derivative of a two dimensional matrix c at grid point i,j
%input:
%   c: matrix whose derivative is to be evaluates
%   i: the z coordinate
%   j: the y coordinate
%   xi: the grid points on either z or y direction
%   zory: 1, if need z derivative; 2, if need y derivative

if (zory == 1)
    ddf = 2*c(i-1,j)/(xi(i-1) - xi(i))/(xi(i-1)-xi(i+1)) + 2*c(i,j)/(xi(i)-xi(i-1))/(xi(i) - xi(i+1)) + 2*c(i+1,j)/(xi(i+1)-xi(i-1))/(xi(i+1)-xi(i));
end

if (zory == 2)
    ddf = 2*c(i,j-1)/(xi(j-1) - xi(j))/(xi(j-1)-xi(j+1)) + 2*c(i,j)/(xi(j)-xi(j-1))/(xi(j) - xi(j+1)) + 2*c(i,j+1)/(xi(j+1)-xi(j-1))/(xi(j+1)-xi(j));
end

return;

