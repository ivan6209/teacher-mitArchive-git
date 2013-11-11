
% This code is a partal solution to problem 2c
% The code call the "tip" function over and over with different values of
% the errors as selected from the given probability distributions.

for i=1:1000
    out=tip(-29.813*pi/180,78.097*pi/180,560,random('Normal',0,0.0001,1,1),random('Normal',0,0.0001,1,1),random('Normal',0,0.01,1,1),random('Normal',0,0.00005,1,1),random('Normal',0,0.00005,1,1),random('Normal',0,0.0001,1,1));
    save(i,1)=out(1);
    save(i,2)=out(2);
end
plot(save(:,1),save(:,2),'+')
hold on
plot([700.25  700.25  699.75 699.75 700.25],[50.25 49.75 49.75 50.25 50.25])


