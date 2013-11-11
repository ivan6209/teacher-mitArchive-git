d=[1:10];
w=0.01*ones(1,10);
x=[-2:0.01:15];

f=1;
for i=1:10
  f=f+w(i)./(d(i)-x);
end
plot(x,f);
grid
axis([-2 15 -0.5 2]);