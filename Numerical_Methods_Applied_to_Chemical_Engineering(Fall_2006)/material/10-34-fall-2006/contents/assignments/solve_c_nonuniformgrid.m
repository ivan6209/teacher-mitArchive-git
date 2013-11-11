function f = solve_c(c,params)
%returns the residual 


%unpack the params
nz = params.nz;k = params.k; K = params.K; Ha = params.Ha; 
pa = params.pa; mu = params.mu; rho = params.rho; Da = params.Da; 
Db = params.Db; Dc = params.Dc; b = params.b ; L = params.L; theta = params.theta;
cb_init = params.cb_init;ny = params.ny; y_i = params.y_i;
z_i = params.z_i;


f = zeros(3*ny*(nz),1);

ca = c(1:ny*(nz));
cb = c(ny*(nz)+1:2*ny*(nz));
cc = c(2*ny*(nz)+1:3*ny*(nz));

%convert the array of c's to a matrix
ca_matrix = array_to_matrix(ca,ny,nz);
cb_matrix = array_to_matrix(cb,ny,nz);
cc_matrix = array_to_matrix(cc,ny,nz);

%calculate the velocity at each value of y
for j=1:ny
    v(j) = velocity((j-1)*b/ny,params);
end

%precalculate the reaction rate at every grid point, this saves us the
%effort of calculating it every time for every species.
for i=1:nz
    for j=1:ny
        r(i,j) = reactionRate(ca_matrix(i,j), cb_matrix(i,j), cc_matrix(i,j), params);
    end
end
        

%Equations in the interior of the channel
for i = 2:nz-1
    for j = 2:ny-1
        f((i-1)*ny + j) =  Da*doublederivative(ca_matrix,i,j,y_i,2) + Da*doublederivative(ca_matrix,i,j,z_i,1) ...
             - v(j) * derivative(ca_matrix,i,j,z_i,1)  - r(i,j);

         f((i-1)*ny + j + ny*(nz)) =  Db*doublederivative(cb_matrix,i,j,y_i,2) + Db*doublederivative(cb_matrix,i,j,z_i,1) ...
             - v(j) * derivative(cb_matrix,i,j,z_i,1)  - r(i,j);
          
        f((i-1)*ny + j + 2*ny*(nz)) =  Dc*doublederivative(cc_matrix,i,j,y_i,2) + Dc*doublederivative(cc_matrix,i,j,z_i,1) ...
             - v(j) * derivative(cc_matrix,i,j,z_i,1)  + r(i,j);  
    end
end


%BC1 z=0
for j=1:ny
    f(j) = ca_matrix(1,j) - 0;
    f(j+ny*(nz)) = cb_matrix(1,j) - cb_init;
    f(j+2*ny*(nz)) = cc_matrix(1,j) - 0;
end

%BC2 z = L
for j=1:ny
    f((nz-1)*ny+j) = -3*ca_matrix((nz),j) + 4*ca_matrix((nz)-1,j) - ca_matrix((nz)-2,j);
    f((nz-1)*ny+j + ny*(nz)) = -3*cb_matrix((nz),j) + 4*cb_matrix((nz)-1,j) - cb_matrix((nz)-2,j);
    f((nz-1)*ny+j +2*ny*(nz)) = -3*cc_matrix((nz),j) + 4*cc_matrix((nz)-1,j) - cc_matrix((nz)-2,j);
end

%BC y = b
for i = 1:nz
    f((i-1)*ny+ny) = -3*ca_matrix(i,ny) + 4*ca_matrix(i, ny-1) -ca_matrix(i,ny-2);
    f((i-1)*ny+ny + ny*(nz)) = -3*cb_matrix(i,ny) + 4*cb_matrix(i, ny-1) - cb_matrix(i,ny-2);
    f((i-1)*ny+ny + 2*ny*(nz)) = -3*cc_matrix(i,ny) + 4*cc_matrix(i, ny-1) - cc_matrix(i,ny-2);
end

%BC y = 0
for i = 1:nz
    f((i-1)*ny+1) = ca_matrix(i,1) - pa*Ha;
    f((i-1)*ny+1+ny*(nz)) = -3*cb_matrix(i,1) + 4*cb_matrix(i,2) - cb_matrix(i,3);
    f((i-1)*ny+1+2*ny*(nz)) = -3*cc_matrix(i,1) + 4*cc_matrix(i,2) - cc_matrix(i,3);
end

return;
    
    
    