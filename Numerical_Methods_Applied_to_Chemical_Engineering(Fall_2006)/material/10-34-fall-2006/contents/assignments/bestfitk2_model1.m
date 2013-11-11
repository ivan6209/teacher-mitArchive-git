function k2 = bestfitk2_model1()
%uses absoption spectrum at 470 nm to calculate the best fit value of k_1.

k20 = 0.01;
k1 = 0.0497;
S = readS_matrix();
[W,Sigma,V] = svd(S);
sizeS = size(S);
time = linspace(0,100,sizeS(1));
Abs = S(:,9)/S(101,9);

k2 = fminunc(@myfuncfork2, k20,[], Abs,time,k1);

Absfit = zeros*Abs;
for i=1:length(Abs)
    Absfit(i) = (1 + (k2*exp(-k1*time(i)))/(k1-k2) + (k1*exp(-k2*time(i)))/(k2-k1)) ;
end

figure;
plot(time,Absfit,'.-',time,Abs,'o'); legend('Best Fit [C]','[C] obtained due to signal at 440 nm');
title('The normalized concentration of C');
xlabel('time (sec)');
ylabel('Concentration');

return;

function res = myfuncfork2(k2,Abs,time,k1)

res = 0;

for i=1:length(time)
    res = res + (Abs(i) - (1 + (k2*exp(-k1*time(i)))/(k1-k2) + (k1*exp(-k2*time(i)))/(k2-k1))  )^2;
end

return;
