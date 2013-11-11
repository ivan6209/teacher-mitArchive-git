function rms_error = p2()

S = readS_matrix();

[W,Sigma,V] = svd(S);

%returns the size of matrix S
sizeS = size(S);

noise_matrix = zeros(length(W),length(V));
for i=3:length(V)
    noise_matrix = noise_matrix + Sigma(i,i)*W(:,i)*V(:,i)';
end

error = 0;
%estimate the error
for i=1:sizeS(1) %wavelength
    for j=1:sizeS(2) %time
        error = error + noise_matrix(i,j)^2;
    end
end
rms_error = (error/sizeS(1)/sizeS(2))^0.5;

return;