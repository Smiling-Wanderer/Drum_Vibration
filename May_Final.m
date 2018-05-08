%% Final Project Asher May 5/10/18
%This project will model various modes of vibration of a circular drum. We
%choose to input a certain material type and radius of the drum, and the
%program (via a gui) will output the various modes of vibration of that
%particular drum... and compare where the various drum mode vibrations occur.

%Here our Drum_Vibration class will be called.
DV = Drum_Vibration();
DV.Rho = 1;
DV.H = 1;
DV.a = 1;
DV.gui();

% t = linspace(0,10,100);
% theta = linspace(0,2*pi,100);
% r = linspace(0,1,100);
% Rho = 1;
% H = 1;
% %Normalization 
% A = .5;
% B = .5;
% C = .5;
% D = .5;
% 
% %Assume that the waves propagate at the same speed in all directions
% N_rr = 1;
% c = sqrt(N_rr/(Rho*H));
% 
% %Creating the inside of the Bessel function
% load 'Bessel_zero.dat'
% lbd_ass = Bessel_zero/r(end);
% %lbd_ass
% %Here we initialize U_mn the drum height function
% %This function is dependent on the values m,n for the bessel function,
% %r,theta, and t. See
% %https://en.wikipedia.org/wiki/Vibrations_of_a_circular_membrane for more
% %details.
% U_mn = zeros(3,3,100,100,100);
% for ii = 1:length(Bessel_zero)
%     for jj = 1:length(Bessel_zero)
%         for kk = 1:length(r)
%             Bessel_input = lbd_ass(ii,jj)*r(kk);
%             for ff = 1:length(theta)
%                 U_mn(ii,jj,kk,ff,:) = (A*cos(c*lbd_ass(ii,jj).*t)+B*sin(c*lbd_ass(ii,jj).*t)).*besselj(ii-1,Bessel_input)*(C*cos((ii-1)*theta(ff))+D*sin((ii-1)*theta(ff)));
%             end
%         end
%     end
% end
% %Storing just a single snapshot of the drum for a particular instant (t =
% %1)
% for zz = 1:100
%    for yy = 1:100 
%         Height(yy,zz) = U_mn(1,1,yy,zz,1);
%    end
% end
% %Plotting what should be just relation ship of height with respect to r and
% %theta, and then converting back to regular coordinates.
% figure 
% surf(theta,r,Height)
% xlabel('theta')
% ylabel('r')
% zlabel('Height')
% title('Drum vibration')
% figure 
% surf(r.*sin(theta),r.*cos(theta),Height)
% xlabel('y')
% ylabel('x')
% zlabel('Height')
% title('Drum vibration')
