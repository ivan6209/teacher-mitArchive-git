function S = readS_matrix()

%reads the file signalsvd.txt and makes the matrix of signal S
%output: 
%       S the matrix of sinal strength

fid = fopen('signalsvd.txt');

C = textscan(fid, '%s','whitespace','\n');


mainCell = C{1};
for i = 1:length(mainCell)
    ithString = mainCell{i};
    matrix_row_i = textscan(ithString,'%n');
    S(i,:) = matrix_row_i{1};
end
fclose(fid);

return;