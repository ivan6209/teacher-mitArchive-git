%% Hexagon art
clear
clc
close all

N=20; % must be even

x0=0:2:2*N-2; x1=x0+1; x=[x0 x1]; x=x'; 
x=kron(ones(N/2,1),x);
s=sqrt(3); y=0:1:N-1; y=y*s; y=y'; y=kron(y,ones(N,1));
verts=[x y];

% plot vertices of hexagonal lattice
% figure
% plot(x,y,'.')
% axis equal

faces=[];
for k=2:2:N-1
    j=N*(k-1)+1;
    for i=j:3:j+N-4
        hfaces = [% hexagon
                  i     i+1     i-N+2    i-N+1
                  i+1   i-N+2   i+2      i+N+2
                  i     i+1     i+N+2    i+N+1
                  % diagonally up and adjacent hexagon
                  i+2   i+3     i+N+3    i+N+2
                  i+3   i+N+3   i+2*N+3  i+N+4
                  i+N+2 i+N+3   i+2*N+3  i+2*N+2];
        faces = [faces
                 hfaces];
    end
end
Cdata=[1 0 0      % red
       0 1 0      % green
       0 0 1];    % blue
nfaces=size(faces,1); nf3=nfaces/3;   
Cdata=kron(ones(nf3,1),Cdata);  

figure
p = patch('Faces', faces, 'Vertices', verts, 'FaceColor', 'flat', 'FaceVertexCdata', Cdata);
axis equal
ylim([s (N-2)*s])
xlim([2 2*N-4])
