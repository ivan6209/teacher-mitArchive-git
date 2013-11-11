function [output_massFlow,A] = pset2problem3(input_massFlow)
% Solves for the mass flow rates of different species in
% various flow streams of the esterification process in proble3 of homeword
% 2. 09/12/2006 by Sandeep Sharma.
% input:
% input_massFlow: an array of massflowrates
%               : [Ac1	Al1	F3 F5 F6 r1 r2]
%               here   Ac1 = mass flow rate of Acid in stream 1.
%                      Al1 = mass flow rate of alcohol in stream 1.
%                      F3  = molar flow rate of stream 3.
%                      F5  = molar flow rate of stream 5.
%                      F6  = molar flow rate of stream 6.
%                      r3  = ratio of mass flow rate of Acid to Alcohol in stream 3.
%                      r4  = ratio of mass flow rate of Acid to Alcohol in stream 4.
%               subscript is the stream number ( see problem for description).
%               
% output:
% output_massFlow: an array of massflowrates retured by the program
%                : [W1	Al5	W5	E6	W6	Ac6	E4	W4	Ac4	Al4	E3	W3	Ac3	Al3]

% unpack the inputs
Ac1 = input_massFlow(1);
Al1 = input_massFlow(2);
F3 = input_massFlow(3);
F5 = input_massFlow(4);
F6 = input_massFlow(5);
r3 = input_massFlow(6);
r4 = input_massFlow(7);



%Define the matrix A in the equation Ax=b
A = [0	0	0	0	0	0	0	0	0	0	1/190	1/18	1/176	1/32	0	0	0	0
0	1/32	1/18	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	-1/190	0	-1/176	0	1/190	0	1/176	0	0	0	0	0
1/18	0	-1/18	0	0	0	-1/190	1/18	0	0	1/190	-1/18	0	0	0	0	0	0
0	1/32	0	0	0	0	-1/190	0	0	-1/32	1/190	0	0	1/32	0	0	0	0
0	0	0	-1	-1	-1	-1	-1	-1	-1	1	1	1	1	0	0	0	0
0	0	0	0	0	-1	0	0	-1	0	0	0	1	0	0	0	0	0
0	0	0	-1	0	0	-1	0	0	0	1	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	-1	0	0	0	1	0	0	0	0
0	0	0	0	0	0	-0.1	-0.1	0.9	-0.1	0	0	0	0	0	0	0	0
0	0	0	1/190	1/18	1/176	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	1	-r3	0	0	0	0
0	0	0	0	0	0	0	0	1	-r4	0	0	0	0	0	0	0	0
0	0	0	1	0	0	0	0	0	0	-0.9	0	0	0	0	0	0	0
-1	0	0	0	0	0	-1	-1	-1	-1	0	0	0	0	1	1	1	1
0	0	0	0	0	0	0	0	0	-1	0	0	0	0	0	1	0	0
0	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	1	0
-1	0	0	0	0	0	0	-1	0	0	0	0	0	0	1	0	0	0
];


%Define matrix b 
b = [F3
F5
Ac1/176 
0
Al1/32
0
0
0
0
0
F6
0
0
0
Ac1 + Al1
Al1
Ac1
0
];

%Solve the system of equations for x

x = A\b;
output_massFlow = x;

output = strcat('Flow rate of water in recycle stream (W4) = ', num2str(x(8)), ' Kg/mol\n');
fprintf(output)
output = strcat('Flow rate of Ester in recycle stream (E4) = ', num2str(x(7)), ' Kg/mol\n');
fprintf(output)
output = strcat('Flow rate of Acid in recycle stream (W4) = ', num2str(x(9)), ' Kg/mol\n');
fprintf(output)
output = strcat('Flow rate of Alcohol in recycle stream (Al4) = ', num2str(x(10)), ' Kg/mol\n');
fprintf(output)

return;