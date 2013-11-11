function k1 = bestfitk1()
%uses absoption spectrum at 470 nm to calculate the best fit value of k_1.

k10 = 0.01;

S = readS_matrix();
[W,Sigma,V] = svd(S);
sizeS = size(S);
time = linspace(0,100,sizeS(1));
Abs = S(:,40)/S(1,40);

k1 = fminunc(@myfuncfork1, k10,[], Abs,time);

Absfit = zeros*Abs;
for i=1:length(Abs)
    Absfit(i) = exp(-k1*time(i));
end

figure;
plot(time,Absfit,'.-',time,Abs,'o'); legend('Best Fit [B]','[B] obtained due to signal at 470 nm');
title('The normalized concentration of B');
xlabel('time (sec)');
ylabel('Concentration');

return;

function res = myfuncfork1(k1,Abs,time)

res = 0;

for i=1:length(time)
    res = res + (Abs(i) - exp(-k1*time(i)))^2;
end
return;
