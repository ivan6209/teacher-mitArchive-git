function f=obj(c,x)
global sigma beta yl yh p R ppv s1 p1

u = c.^(1-sigma)/(1-sigma);
x_prime = R*(x-c)*ones(1,length(s1)) + ones(length(c),1)*s1;

fi= beta*[ppval(ppv,x_prime)*p1];

ff = u + fi;
f = -ff;
