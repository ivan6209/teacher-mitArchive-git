function problem2d()
%plots the values of C for temperatures ranging from 300K to 2000K using a
%series of M

%make a matrix of Ms
M = [20 50 100 300 500]';

%make a matrix of values of temperatures
T = linspace(100, 2000);

%for each value of M calculate an array of Cs for each value of T
for n=1:length(M)
    c(:,n) = problem2c(T,M(n));
end


%plot the final results
plot(T,c(:,1),':',T,c(:,2),'-',T,c(:,3),'-.',T,c(:,4),'--',T,c(:,5),'*');


title('Plots of heat capacities vs temperature for various Ms');
xlabel('Temperature (K)'); axis([100 2000 0 1]); axis 'auto y';
ylabel('Heat Capcities (J/mol/K)');
legend('M=20','M=50','M=100','M=300','M=500');
return;