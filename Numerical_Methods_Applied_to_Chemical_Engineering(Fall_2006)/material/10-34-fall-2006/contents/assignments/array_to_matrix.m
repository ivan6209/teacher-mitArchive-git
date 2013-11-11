function c_matrix = array_to_matrix(c,ny,nz);
%takes a vector of scalar values and converts it into a matrix of dimension
%ny and nz

for i = 1:nz
    for j = 1:ny
        c_matrix(i,j) = c((i-1)*ny+j);
    end
end
return;