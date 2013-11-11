%  This script is used to generate simulation data using the HH
%propagated action potential software.  The extracellular potassium 
%concentration is varied and the approximate refractory period is determined
% by varying stimulus interpulse times. All other parameters remain unchanged.

%  With each setting of the concentration, the simulation is run and the
%resulting data is checked to see if a second action potential occurred. 
%This is determined by checking whether the propagation of the potential down
%the length of the axon is decrement-free, as would be expected in an action
%potential. When the refractory period is determined, the resulting data is 
%saved to data files which can then be used to display the results in the 
%Comparisons figure.

%  Before using the script, make sure that the Hodgkin-Huxley
%biophysics software has been started.
%If it hasn't been started, start the software using SOFTCELL.M
%      softcell('pap');

%APscr('set') will list the parameters that can be changed

%  Since a lot of files will be created, it is best to store them in a
%separate folder.  Examples of foldername are
%foldername = 'C:\data\temp'; %Windows
%foldername = '/user/tsb/data/temp'; %UNIX
%foldername = 'MacHD:matlab:data:temp'; %Mac
foldername = pwd;

% First reset all parameters to their defaults:
APstim('default');
APparams('default');
APnum('default');

% Make sure the duration of the simulation is long enough to get in two action
% potentials:
APscr('set','dur',10);

%  Set up a loop that samples through a concentration range.
%In this case, we use the range c_K_o = [0.11 10.11 20.11 30.11] mmol/L
for c_K_o = 0.11:10:30.11

  %set the model's temperature parameter
  newconc = APscr('set','c_K_o',c_K_o);

  %give yourself a note: indicate in the console what the settings are
  disp(['Concentration is set to ' num2str(newconc)]);

  % Set up a loop to figure out the refractory period by sampling through a
  %range of interpulse periods (the parameter that we are changing here
  %is the start time of pulse2) from 0 until we find the refractory period
				
  no_second_AP = 1;
  t = -0.1;

  while (no_second_AP == 1),
    t = t + 0.1;
    APscr('set','stimulus','pulse2','amplitude',0.05);
    APscr('set','stimulus','pulse2','duration',0.5);
    newInterval = APscr('set','stimulus','pulse2','start',t);
    disp(['Interpulse interval is set to ' num2str(newInterval)]);

    %perform simulation
    APscr('start');

    Vm1 = APscr('get','V_{ m}',1.5,':');
    % only look at values of Vm _after_ the first AP (from ~2ms on)
    peak1 = max(Vm1(200:end));
    Vm2 = APscr('get','V_{ m}',2.5,':');
    peak2 = max(Vm2(200:end));

    % Compare the peaks of Vm at z=1.5cm and z=2.5cm to see if the propagation
    % is decrement-free, and therefore an AP
    if ((peak1 - peak2) < 10) & (min([peak1;peak2]) > 10),
      disp(['Action potential detected.']);
      no_second_AP = 0;
    else
      disp(['No action potential detected.']);
    end
    
  end 
  
  %create a unique filename that contains the simulation data
  filename = ['/c_K_o' num2str(c_K_o) 't' num2str(t) '.mat']; 

  %save the simulation data to the file
  APscr('save','simulation',foldername,filename);
end

%That's it -- all the data has been saved.

%Now, put up all the data simultaneously by following these steps:
%1. call up the "Graphics" figure,
%2. using "Setup", select whichever variable(s) to plot,
%3. still inside "Setup HH plot", select the source of "Get values from"
%   to be the "Files with parameters".
% 3a. using "Select files", add the files to the list "Use these files".
% 3b. select "Overlay" to view the selected variable(s) in all the datafiles.
