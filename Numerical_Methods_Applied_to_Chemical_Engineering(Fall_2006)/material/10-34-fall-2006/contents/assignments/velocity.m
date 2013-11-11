function v = velocity(y,params)
%calculates the velocity vz given y

%unpack the params
nz = params.nz;k = params.k; K = params.K; Ha = params.Ha; 
pa = params.pa; mu = params.mu; rho = params.rho; Da = params.Da; 
Db = params.Db; Dc = params.Dc; b = params.b ; L = params.L; theta = params.theta;

v = -rho*9.8*cos(theta*pi/180)*(y^2 - 0.1^2)/2/mu/100;

return;