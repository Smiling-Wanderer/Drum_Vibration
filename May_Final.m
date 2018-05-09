%% Final Project Asher May 5/10/18
%This project will model various modes of vibration of a circular drum. We
%choose to input a certain material type and radius of the drum, and the
%program (via a gui) will output the various modes of vibration of that
%particular drum... and compare where the various drum mode vibrations occur.

%A note for future commits: This models only in terms of r and theta. 
%Shifting back into cartesian coordinates is non-trivial because the heigh
%of the drum is calculated wrt r and theta, instead of x and y. One may
%convert these, but I ran into problems since, for example, if we have 1x10
%arrays of x,y, then we calculate r and theta and we have 1x100 which makes
%our Height array 100x100. This is a problem since now we have 10x the
%points we started off with. Trying to graph this calculated height array
%using surf has proven far more difficult than expected. Even when we
%reduce the dimensions of the input theta and r arrays. 

%Even so, this model is physically correct, it is just a little hard to
%visualize due to the r and theta graphs instead of cartesian graphs. 
%Please visit
%https://en.wikipedia.org/wiki/Vibrations_of_a_circular_membrane if you'd
%like to see first nine modes in cartesian coordinates before unless most
%recent commit to the public repository Uberherrkonig/Drum_Vibration on Github indicates otherwise.

%Here our Drum_Vibration class will be called.
DV = Drum_Vibration();
%Setting some defaults
DV.Rho = 1;
DV.H = 1;
DV.a = 1;
%Calling the GUI
DV.gui();

