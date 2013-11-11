% this defines the Morse potential for the OH bonds in the molecule.  

function V=Vmorse(r)
% Morse potential, params for OH bond
D=360e3/6.022e11; %[=]Bond Dissociation Energy, picoJoule/molecule
alpha=1.5; %[=] 1/Angstrom
L=1.05; %[=] equilibrium bond length, Angstrom
V=D.*(1-exp(-alpha.*(r-L))).^2;