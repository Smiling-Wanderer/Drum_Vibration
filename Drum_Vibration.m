classdef Drum_Vibration < handle
    %This class will allow us to model the various modes of vibration of a
    %drum.
    
    properties
    H;          %Thickness
    Rho;        %Density
    Area;       %Area
    r;          %radius
    a;          %maximum radius
    M;          %material
    FigGUI;     %figure
    t;          %The time over which we will see our vibration
    theta;      %the possible angles on our circle (0,2*pi)
    m;          %J_m for mth bessel function
    n;          %n for the nth root of the J_m bessel function
    Go;         %Logical for graphs
    
    end
    
    methods
        function [lbd_ass,roots] = Accept_Input(obj)
           %This function loads the Bessel functions zeros that we will use
           load 'Bessel_zero.dat'
           roots = Bessel_zero;
           %creating associated lambdas with for our height of drum eqn.
           lbd_ass = roots/obj.a;
           
        end
        function Create_Output(obj)
            %(This could also go inside the GUI class)
            %This saves the desired figures as .fig files
        end
        function U_mn = Cruncher(obj)
            %This function calculates the height of the drum: U_mn
            
            %Loading data
            [lbd_ass,roots] = obj.Accept_Input();
            
            %Initializing time and theta (don't want these to be variable)
            obj.t = linspace(0,10,10);
            obj.theta = linspace(0,2*pi,10);
            
            %Assume that the waves propagate at the same speed in all directions
            N_rr = 1;
            c = sqrt(N_rr/(obj.Rho*obj.H));
            
            %Normalization
            A = .5;
            B = .5;
            C = .5;
            D = .5;
           
            
            %we set m and n to their corresponding values (see properties)
            obj.m = 0:length(roots)-1;
            obj.n = 1:length(roots);

            %Here we initialize U_mn the drum height function
            %This function is dependent on the values m,n for the bessel function,
            %r,theta, and t. See
            %https://en.wikipedia.org/wiki/Vibrations_of_a_circular_membrane for more
            %details.
            U_mn = zeros(length(roots),length(roots),length(obj.r),length(obj.theta),length(obj.t));
            
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
            F = figure('Position',[100 100 1000 700]);
            F.Tag='AddGUI';
            
            %Save figure to object property
            obj.FigGUI=F;
            
            
            % Setup UI CONTROLS----------------------------------------------
            %The X-X1 pairs are editable boxes and their corresponding titles.
            TextBoxA = uicontrol('Style','text','String','The First 9 Modes of Drum Vibration',...
                'Position',[350 670 400 20],'FontWeight','bold','FontSize',12);
            TextBoxB = uicontrol('Style','edit','String','Test',...
                'Position',[10 650 50 20],'background','green');
            TextBoxB1 = uicontrol('Style','text','String','Thickness',...
                'Position',[10 670 50 20]);
            
            popupC = uicontrol('Style', 'popup',...
                   'String', {'Default','Leather','Mylar','Copper','Kevlar'},...
                   'Position', [10 400 50 20],'background','green');
            TextBoxC1 = uicontrol('Style','text','String','Material',...
                'Position',[10 420 50 20]);
            
            TextBoxD = uicontrol('Style','edit','String','Test',...
                'Position',[10 200 50 20],'background','green');
            TextBoxD1 = uicontrol('Style','text','String','Radius',...
                'Position',[10 220 50 20]);
            
            Button = uicontrol('Style', 'pushbutton', 'String', 'start simulation',...
                'Position', [10 60 100 50],...
                'Callback', @Simulation);
            
            StopButton = uicontrol('Style', 'pushbutton', 'String', 'stop simulation',...
                'Position', [10 10 100 50],...
                'Callback', @stop_simulation);
            
            % -----------------------------------------------------------------
            
            %Intialize UI controls with current object
            property2gui()
            
            
            function Simulation(~,~)
                %Callback of 'start simulation' Button
                gui2property()
                property2gui()
                obj.Go = 1;
                while obj.Go
                    U_mn = obj.Cruncher();
                    plot_stuff(U_mn);
                end
            end
            function stop_simulation(~,~)
                %Callback of 'stop simulation button'
                obj.Go = 0;
            end
            function plot_stuff(U_mn)
                %plotting our drum membrane
                for tt=1:length(obj.t)
                    
                    for mm = 1:length(obj.m) 
                        for nn = 1:length(obj.n)
                            %Making indexes for our subplots
                            if mm == 1
                               if nn == 1
                                   k = 1;
                               elseif nn == 2
                                   k = 2; 
                               else 
                                   k = 3;
                               end
                            elseif mm == 2
                                if nn == 1
                                   k = 4;
                               elseif nn == 2
                                   k = 5; 
                               else 
                                   k = 6;
                                end
                            else
                                if nn == 1
                                   k = 7;
                               elseif nn == 2
                                   k = 8; 
                               else 
                                   k = 9;
                                end
                            end
                            %Storing our height in a matrix so we can use
                            %surf
                            HTEMP(:,:) = U_mn(mm,nn,:,:,tt);
                            subplot(length(obj.m),length(obj.n),k)
                            surf(obj.theta,obj.r,HTEMP)
                            axis ([0 7 0 obj.a -.5 .5])
                            xlabel('theta')
                            ylabel('r')
                            zlabel('Height')
                            title(['m = ' num2str(mm-1) ', n = ' num2str(nn)])
                            pause(0.1)
                        end
                    end
                    
                end
            end
            %Write object properties into GUI unicontrols
            function property2gui()
                obj.r = linspace(0,obj.a,10);
                TextBoxB.String=num2str(obj.H);
                TextBoxD.String=num2str(obj.a);
            end
            
            %Get values from UI controls and set object properties
            function gui2property()
                obj.H=str2double(TextBoxB.String);
                MAT = get(popupC,'Value');
                switch MAT
                    case 1
                        obj.Rho = 1;
                        obj.M = 'Default';
                    case 2
                        obj.Rho = .86e3;
                        obj.M = 'Leather';
                    case 3
                        obj.Rho = 1380;
                        obj.M = 'Mylar';
                    case 4
                        obj.Rho = 8.79e3;
                        obj.M = 'Copper';
                    otherwise
                        obj.Rho = 1440;
                        obj.M = 'Kevlar';
                end
                      
                obj.a=str2double(TextBoxD.String);
                obj.r(end) = obj.a;
            end
            
        end

    end
    
end

