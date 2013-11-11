% 10.34 - Fall 2006 HW#1
% Problem #3
% Text reading and writing
% Rob Ashcraft - Sept. 7th, 2006

% This script reads in two specific files (a text file and an excel file),
% p2_text.txt and p2_excel.xls, extracts rate constant data, plots the rate 
% cosntant as a function of T, and then writes a text and excel file
% showing the rate constant values from 300K -> 1500K in increments of 100K

% clear the variables/workspace and the command window
clear; clc;

%%%%%% Read in the text file as a cell-array of strings
% Open the text file so Matlab can use it
fid = fopen('p2_text.txt');

% Read in the data, turning each line into a string.  The "\n" means new
% line, so it read until it finds a new line (i.e. reads the whole line)
text_data = textscan(fid,'%s','whitespace','\n');

% Convert the cell array returned by textscan into an array of
% characters
text_char = char(text_data{1});

%determine how many lines of text are present
n_lines = length(text_char(:,1));

% Extract the parameter values from the data line:
% we make use of the n_lines, since we know the data to be present in the
% final line of the file.  There are other methods one can use if you don;t
% know where the data would be, as long as there is some reference point
% you can use (keyword, number, etc.).  The "%f" means to read a floating
% point number (there are other formats for numbers and strings as well)
[Af,n,EaR] = strread(text_char(n_lines,:),'%f %f %f');

%%% Generate k(T) and plot the result
% make a vector of Temp values from 300 to 1500 with interval of 100
T = [300:100:1500];

% iterate over the T vector to calculate the k(T) at each value and store
% in a vector called k
for i=1:length(T)
    k(i) = Af*T(i)^n*exp(-EaR/T(i));
end

% make a semilog y plot of the rate constant and label the axes
semilogy(T,k); xlabel('Temperature   [K]'); ylabel('k(T)   [cm^3/mole-K]');

% closes the file p2_text.txt so it can be used outside of Matlab again
fclose all;

%%% write the text file
% open the specified file with write priviledges
fid2 = fopen('text_output.txt','w');

% find the line on which "NH2OH" appears, so we can print this line in the
% output file
rxn_loc = strmatch('NH2OH',text_char);

% Print the text/data to a text file specified by "fid2"
% \n means go to a new line, \t means tab over
fprintf(fid2,'Rate constant data for: \n');
fprintf(fid2,text_char(rxn_loc,:));
fprintf(fid2,'\n\n');
fprintf(fid2,'Temp (K) \t k(T) (cm3/mole-s) \n');
% this writes two fields on the same line, separated by 2 tabs.  The format
% is specified by %g (simplest notation) and %e (scientific notation)
for i=1:length(T)
    fprintf(fid2,'%g \t\t %e \n',T(i),k(i));
end

fclose all;


%%%%%% Start dealing with the Excel file
% read in the Excel data; this put the numeric data directly in xls_data,
% and puts all other text data in xls_text
[xls_data, xls_text]= xlsread('p2_excel.xls');

% Extract the parameter values from the data line
Af = xls_data(1);
n = xls_data(2);
EaR = xls_data(3);

% Generate k(T) to be written to the file
T = [300:100:1500];

for i=1:length(T)
    k_xls(i) = Af*T(i)^n*exp(-EaR/T(i));
end

%%% write the Excel file
% find the location of the reaction again
rxn_loc_xls = strmatch('NH2OH',xls_text);

% To write to an excel file, the easiest thing to do is create a matrix or
% cell array with everything in it, and just write it in one pass.  The
% first few lines create a cell array with the require data and the final
% line writes it.  The num2str on the k_xls data was simply used so that
% the format could be forced to be scientific notation (optional).
xls_mat{1,1}=('Rate constant data for:');
xls_mat{2,1}=xls_text{rxn_loc_xls};
xls_mat{3,1}=(' ');
xls_mat{4,1}=('Temp (K)');  xls_mat{4,2}=('k(T) (cm3/mole-s)');
for i=1:length(T)
    xls_mat{4+i,1}=T(i);
    xls_mat{4+i,2}=num2str(k_xls(i),'%e');
end

xlswrite('xls_output.xls',xls_mat);

