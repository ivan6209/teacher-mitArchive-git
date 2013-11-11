load clown.mat;
[U,S,V]=svd(X);
colormap(gray);
subplot(221);
image(X);
pause;

for k=1:3
   X=U(:,1:k*10)*S(1:k*10,1:k*10)*V(:,1:k*10)';
   subplot(2,2,k+1);
   colormap(gray);
   image(X);
   pause;
end
