classdef Drum_Vibration < handle
    %This class will allow us to model the various modes of vibration of a
    %drum.
    
    properties
    H;          %Thickness
    Rho;        %Density
    Area;       %Area
    r;     %radius
    a;      %maximum radius
    Material;
    FigGUI;
    t;
    theta;
    
    end
    
    methods
        function [lbd_ass,roots] = Accept_Input(obj)
           %Read input file here
           load 'Bessel_zero.dat'
           roots = Bessel_zero;
           lbd_ass = roots/obj.a;
           
        end
        function Create_Output(obj)
            %(This could also go inside the GUI class)
            %This saves the desired figures as .fig files
        end
        function U_mn = Cruncher(obj)
            [lbd_ass,roots] = obj.Accept_Input();
            obj.t = linspace(0,10,100);
            obj.theta = linspace(0,2*pi,100);
            
            %Assume that the waves propagate at the same speed in all directions
            N_rr = 1;
            c = sqrt(N_rr/(obj.Rho*obj.H));
            
            %Normalization
            A = .5;
            B = .5;
            C = .5;
            D = .5;
            
            %Just for now, set Rho, H = 1;
            obj.Rho = 1;
            obj.H = 1;
            %Here we initialize U_mn the drum height function
            %This function is dependent on the values m,n for the bessel function,
            %r,theta, and t. See
            %https://en.wikipedia.org/wiki/Vibrations_of_a_circular_membrane for more
            %details.
            U_mn = zeros(3,3,100,100,100);
            for ii = 1:length(roots)
                for jj = 1:length(roots)
                    for kk = 1:length(obj.r)
                        Bessel_input = lbd_ass(ii,jj)*obj.r(kk);
                        for ff = 1:length(obj.theta)
                            U_mn(ii,jj,kk,ff,:) = (A*cos(c*lbd_ass(ii,jj).*obj.t)+B*sin(c*lbd_ass(ii,jj).*obj.t)).*besselj(ii-1,Bessel_input)*(C*cos((ii-1)*obj.theta(ff))+D*sin((ii-1)*obj.theta(ff)));
                        end
                    end
                end
            end
            
        end
        function gui(obj)
            %Gui
            
            %See if we already have a figure for this class
            Z=findall(0,'Tag','AddGUI');
            if ~isempty(Z);return;end
            
            %Create figure
            F = figure('Position',[100 100 700 500]);
            F.Tag='AddGUI';
            
            %Save figure to object property
            obj.FigGUI=F;
            
            
            % Setup UI CONTROLS----------------------------------------------
            %The B-B1 pairs are editable boxes and their corresponding titles.
            TextBoxB = uicontrol('Style','edit','String','Test',...
                'Position',[10 400 100 50]);
            TextBoxB1 = uicontrol('Style','text','String','Thickness (H)',...
                'Position',[10 450 100 20]);
            
            TextBoxC = uicontrol('Style','edit','String','Test',...
                'Position',[10 300 100 50]);
            TextBoxC1 = uicontrol('Style','text','String','Density (Rho)',...
                'Position',[10 350 100 20]);
            
            TextBoxD = uicontrol('Style','edit','String','Test',...
                'Position',[10 200 100 50]);
            TextBoxD1 = uicontrol('Style','text','String','Radius',...
                'Position',[10 250 100 20]);
            
            Button = uicontrol('Style', 'pushbutton', 'String', 'start simulation',...
                'Position', [10 100 100 50],...
                'Callback', @Simulation);
            
            StopButton = uicontrol('Style', 'pushbutton', 'String', 'stop simulation',...
                'Position', [10 50 100 50],...
                'Callback', @stop_simulation);
            
            % -----------------------------------------------------------------
            
            %Intialize UI controls with current object
            property2gui()
            
            
            function Simulation(~,~)
                %Callback of 'run fit' Button
                gui2property()
                property2gui()
                Go = 1;
                
%                 while Go
                    U_mn = obj.Cruncher();
                    %Storing just a single snapshot of the drum for a particular instant (t = 1)
                    for tt = 1: length(obj.t)
                        for zz = 1:100
                            for yy = 1:100
                                Height(tt,yy,zz) = U_mn(1,1,yy,zz,tt);
                            end
                        end
                    end
                    %ShowIter=1000;
%                     if (nn/ShowIter==round(nn/ShowIter))
%                         pause(.01);if ~Go;break;end % Time to process closed figure
%                         try
                    plot_stuff(Height);
%                         catch
%                         end
%                         pause(.01)
%                     end
%                 end
            end
            function stop_simulation(~,~)
                %Callback of 'stop simulation button'
                Go = 0;
            end
            function plot_stuff(Height)
                for tt=1:length(obj.t)
                    HTEMP(:,:) = Height(tt,:,:);
                    surf(obj.theta,obj.r,HTEMP)
                    axis ([0 7 0 obj.a -1 1])
                    xlabel('theta')
                    ylabel('r')
                    zlabel('Height')
                    title('Drum vibration')
                    pause(0.1)
                end
            end
            %Write object properties into GUI unicontrols
            function property2gui()
                obj.r = linspace(0,obj.a,100);
                TextBoxB.String=num2str(obj.H);
                TextBoxC.String=num2str(obj.Rho);
                TextBoxD.String=num2str(obj.a);
            end
            
            %Get values from UI controls and set object properties
            function gui2property()
                obj.H=str2double(TextBoxB.String);
                obj.Rho=str2double(TextBoxC.String);
                obj.a=str2double(TextBoxD.String);
                obj.r(end) = obj.a;
            end
            
        end

    end
    
end

