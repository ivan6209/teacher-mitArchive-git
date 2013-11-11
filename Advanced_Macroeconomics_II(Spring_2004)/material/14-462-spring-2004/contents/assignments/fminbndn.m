function [y,fval]=fminbndn(f,a,b,n,OPTIONS,varargin)

% FMAXBNDN(f,a,b,n,OPTIONS,varargin)
% This is a crude way at trying to have a better chance of finding global maxima.
% Suppose you have a function F(x_1,x_2,x_3,...x_n) that you want to maximize
% as a function of its ith argument x_i over the intervall [a,b].
% You want to find a global maximum. What FMAXBNDN does is subdivide the interval
% [a,b] into n intervalls, find a local maximum in each and then take the 
% global maximum of all.
% Consider the example where you have four arguments, you want to maximize over
% the third argument while the other arguments are x_1=1, x_2=2 and x_4=4. 
% Futhermore suppose that [a,b]=[0,1], that you want subdivision into 10 intervalls.
% Then you would use the command
%
% fmaxbndn('F',0,1,10,1,2,[],4)
%
% Notice that an empty matrix [] was specified for the argument over which you want
% to maximizae.

n_parameters=length(varargin);
parameter_string='';
for i=1:n_parameters
   if isempty(varargin{i})
      parameter_string=[parameter_string 'x'];
   else
      parameter_string=[parameter_string num2str(varargin{i},15)];
   end
   if i<n_parameters
      parameter_string=[parameter_string ','];
   end
end
fstring=[f '(' parameter_string ')'];
x=linspace(a,b,n+1);
for i=1:n
   [minimizer(i),minimized(i)]=fminbnd(fstring,x(i),x(i+1),OPTIONS);
end

[min,index]=min(minimized);
y=minimizer(index);
fval=min;