function [W,S,V] = pset5problem1
%does the SVD for the matrix that it reads from the file signalsvd.txt 
%input :none
%output:
%   W is the matrix of dimensionless concentrations
%   Sigmas are the sigma values which tell us which species are important
%   V values of the signal strength.


S = readS_matrix();

[W,Sigma,V] = svd(S);

%returns the size of matrix S
sizeS = size(S);

%make a matrix of times with length the same as length of concentration
%vectors
time = linspace(0,100,sizeS(1));

%make a matrix of wavelengths with lenght the same as the length of the
%absoption of each species.
lambda = linspace(432,481,sizeS(2));

%plot the concentrations and absorptions of the first 3 species.
figure;
plot(lambda,V(:,1));
title('The absoption spectrum of species 1');
xlabel('The wavelength (m^{-1})');
ylabel('The normalized absorption');

figure;
plot(time,W(:,1));
title('The concentration of species 1');
xlabel('Time (s)');
ylabel('The normalized concentration');

figure;
plot(lambda,-V(:,2));
title('The absoption spectrum of species 2');
xlabel('The wavelength (m^{-1})');
ylabel('The normalized absorption');

figure;
plot(time,-W(:,2));
title('The concentration of species 2');
xlabel('Time (s)');
ylabel('The normalized concentration');

figure;
plot(lambda,V(:,3));
title('The absoption spectrum of species 3');
xlabel('The wavelength (m^{-1})');
ylabel('The normalized absorption');

figure;
plot(time,W(:,3));
title('The concentration of species 3');
xlabel('Time (s)');
ylabel('The normalized concentration');
return;



function S = readS_matrix()

%reads the file signalsvd.txt and makes the matrix of signal S
%output: 
%       S the matrix of sinal strength

fid = fopen('signalsvd.txt');

%read each line as a string
C = textscan(fid, '%s','whitespace','\n');


mainCell = C{1};
for i = 1:length(mainCell)
    ithString = mainCell{i};
    
    %take each string and read numbers from it
    matrix_row_i = textscan(ithString,'%n');
    S(i,:) = matrix_row_i{1};
end

fclose(fid);
return;