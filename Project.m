classdef Project < matlab.apps.AppBase

%% GUI Parts
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        TypeLab                    matlab.ui.control.Label
        RP                  matlab.ui.control.EditField
        RPLab               matlab.ui.control.Label
        RPType                  matlab.ui.control.EditField
        RPTypeLab               matlab.ui.control.Label
        IN1Lab              matlab.ui.control.Label
        IN2Lab      matlab.ui.control.Label
        IN1                        matlab.ui.control.NumericEditField
        IN2                        matlab.ui.control.NumericEditField
        TimeRange1Lab       matlab.ui.control.Label
        TimeRange2Lab        matlab.ui.control.Label
        TimeRange1                        matlab.ui.control.NumericEditField
        TimeRange2                        matlab.ui.control.NumericEditField
        LoadFunction            matlab.ui.control.Button
        FilenameLab             matlab.ui.control.Label
        Filename       matlab.ui.control.EditField
        LoadButton                      matlab.ui.control.Button
        PlotfunctionButton                      matlab.ui.control.Button
        ANALYSISOFSTOCHASTICPROCESSESLabel  matlab.ui.control.Label
        NumberofSamplefunctionsLab  matlab.ui.control.Label
        NumberofSamplefunctions  matlab.ui.control.NumericEditField
        PlotMeanButton               matlab.ui.control.Button
        SampleI                       matlab.ui.control.NumericEditField
        SampleJ               matlab.ui.control.NumericEditField
        ACFLab              matlab.ui.control.Label
        ACFButton           matlab.ui.control.Button
        enternthmean             matlab.ui.control.NumericEditField
        CalculateTimeMean            matlab.ui.control.Button
        TimeMeanLab                 matlab.ui.control.Label
        TimeACFLab                  matlab.ui.control.Label
        EnternthACF                 matlab.ui.control.NumericEditField
        TimeACFButton                     matlab.ui.control.Button
        PSDButton                           matlab.ui.control.Button
        TAPButton                    matlab.ui.control.Button
        ThreeDACFButton                 matlab.ui.control.Button
        UIAxes1                          matlab.ui.control.UIAxes
        UIAxes2                          matlab.ui.control.UIAxes
        UIAxes3                          matlab.ui.control.UIAxes
        UIAxes4                          matlab.ui.control.UIAxes
    end

%% Class variables
        properties (Access = public)
        t=zeros(1,101); % Description
        X;
        %pTimeACF=zeros(1,101);
        InputType
        RPFunc;
        name;
        N;
        n_user=0;
        Time;
        i;
        j;
        TimeACF;
        A=1;
        Theta=0;
        NoFunction;
        Input1;
        Input2;
        Time1;
        Time2;

        end


%% Functions


      methods (Access = private)
          %% To get the type
          function getType (Project,event)
              Project.InputType=Project.Type.Value;
          end
          %% To spicify the type
          function FuncOrFile(Project,event)
              if Project.InputType==1
                  Project.X=0;
                  Project.t=0;
              end
          end
          %% Get time1
          function getTime1(Project,event)
              Project.TimeRange1.Value;
          end
          %% Get time2 and range
          function getTime2(Project,event)
              Project.TimeRange2.Value;
             diff=abs(Project.TimeRange1.Value-Project.TimeRange2.Value)/100;
            Project.t=[Project.TimeRange1.Value:diff:Project.TimeRange2.Value];

          end


          %% To spicify the first input
          function getIn1(Project,event)
              Project.IN1.Value;
          end

          %% To spicify the second input
          function getIn2(Project,event)
              Project.IN2.Value;
          end

          %% To get RP
          function getRP(Project,event)
              Project.RP.Value;
          end
          %% To get RPType
          function getRPType(Project,event)
              Project.RPType.Value;
          end

            %% To get the function
          function getInfunc(Project,event)
              if Project.RP.Value=="Theta"
                  Project.A=repmat(1,1,101);
                  if Project.RPType.Value=="N"
                       Project.RPFunc=normrnd(Project.IN1.Value,Project.IN2.Value,1,101);
                  elseif Project.RPType.Value=="U"
                      Project.RPFunc=unifrnd(Project.IN1.Value,Project.IN2.Value,1,101);

                  end
                  Project.Theta=Project.RPFunc;

              elseif Project.RP.Value=="A"
                  Project.Theta=repmat(0,1,101);
                  if Project.RPType.Value=="N"
                       Project.RPFunc=normrnd(Project.IN1.Value,Project.IN2.Value,1,101);
                  elseif Project.RPType.Value=="U" 
                      Project.RPFunc=unifrnd(Project.IN1.Value,Project.IN2.Value,1,101);

                  end
                  Project.A=Project.RPFunc;
              end
                for i = 1:100
                    for j = 1:length(Project.t)
                        Project.X(i, j) = Project.A(i) * cos(4 * pi * Project.t(j) + Project.Theta(i));
                    end
                end
          end



          %% to load the ensamble file
            function loadfile(Project,event)
                ensamble=load(Project.name,'X','t');
                Project.X=ensamble.X;
                Project.t=ensamble.t;
            end
          
          %% To get the file name

        function getfilename(Project, event)
            Project.name = Project.Filename.Value;
            
        end

          %% to get the number of functions
          function getNOSampleFunctions(Project,event)
              if Project.NumberofSamplefunctions.Value==0 ||Project.NumberofSamplefunctions.Value<0
                  msgbox("Enter a valid number");
              else 
                Project.n_user=Project.NumberofSamplefunctions.Value;
              end
            end

          %% To plot the functions
            function PlotSampleFunctions(Project,event)
                [Project.N Project.Time]=size(Project.X);
                if Project.n_user>Project.N
                    msgbox("The number of input function is larger those in the file");
                    for i=1:Project.N
                        figure;
                        plot(Project.t,Project.X(i,:));
                        title(['Function',num2str(i)]);
                        xlabel('t');
                        ylabel('X');
                    end 
                elseif Project.n_user==0
                    msgbox("no plots to draw, enter a valid number");
     
                elseif  Project.n_user<Project.N
                    for i=1:Project.n_user
                            figure;
                            plot(Project.t,Project.X(i,:));
                            title(['Function ',num2str(i)]);
                            xlabel('t');
                            ylabel('X');
                   end 
                end                
            end 
            %% To Calculate the mean
                function getmean(Project,event)
                    funcmean=mean(Project.X);
                    plot(Project.UIAxes1,Project.t,funcmean);
                end
            %% To get the No.function to with we will get the nth mean
            function getNofunction(Project,event)
                Project.NoFunction=Project.enternthmean.Value;
            end


            %% To Calculate the time mean of nth sample function
            function getTimeMean(Project,event)
                    [Project.N, Project.Time]=size(Project.X);
                    if Project.NoFunction>0 && Project.NoFunction<=Project.N
                        TimeMean=mean(Project.X(Project.NoFunction,:));
                        msgbox("The Time mean of sample function "+Project.NoFunction+" is "+TimeMean);
                    else 
                        msgbox("Enter a valid number");
                    end

                end


                
            %% To get i 
            function getI(Project,event)
                [Project.N, Project.Time]=size(Project.X);
                Project.i=Project.SampleI.Value;
                 if Project.i>0 && Project.i<=Project.N                  
                else
                    msgbox("Enter a valid number for i");
                end
            end

            %% To get J
            function getJ(Project,event)  
            [Project.N, Project.Time]=size(Project.X);
            Project.j=Project.SampleJ.Value;
                if Project.j>0 && Project.j<=Project.N 
             
                else
                    msgbox("Enter a valid number for j");
                end
            end

            %% To calculate the auto correlation Button
            function calculateAutoCorrelation(Project,event)
                [ACF, lags]=xcorr(Project.X(:,Project.i),Project.X(:,Project.j));
                bar(Project.UIAxes2,lags,ACF);
            end

            %% Plotting ACF 3d
            function ACF3d(Project,event)
                for k1=1:100
                    for k2=1:100
                        ACF(k1,k2)=mean(Project.X(:,k1).*Project.X(:,k2));
                    end
                end
                surf(ACF);
            end
            %% To calculate the Time ACF
            function TimeACFFunc(Project,event)
            Project.NoFunction=Project.EnternthACF.Value;
            [Project.N, Project.Time]=size(Project.X);
            if Project.NoFunction>0 && Project.NoFunction<=Project.N
                [Project.TimeACF,lags] =xcorr(Project.X(Project.NoFunction,:));
                bar(Project.UIAxes3,lags,Project.TimeACF);
            else
                msgbox("Enter a valid number");
            end
            
            end

            %% To calculate power Spectural density

            function CalculatePSD(Project, event)

                [Project.N, Project.Time]=size(Project.X);
               PSD=abs(fft(Project.TimeACF,Project.N)).^2/Project.Time;
                plot(Project.UIAxes4,PSD);
                
            end

            %% To calcilate Total Avg Power
            function CalculateTAP(Project, event)
                [Project.N, Project.Time]=size(Project.X);
                for C=1:Project.N
                    M(C)=sum(Project.X(C,:).*Project.X(C,:));
                end
                AP=mean(M);
                msgbox("Total Average Power is "+AP+" Watt");
            end





        % Create UIFigure and components
        function GUIcomponents(Project)




            % Create UIFigure and hide until all components are created
            Project.UIFigure = uifigure('Visible', 'off');
            Project.UIFigure.Position = [400 200 840 480];
            Project.UIFigure.Name = 'Project';
            Project.UIFigure.Color='#D5D6EA';

%% Get type            
            %Create FilenameEditFieldLabel
            Project.TypeLab = uilabel(Project.UIFigure);
            Project.TypeLab.HorizontalAlignment = 'Center';
            Project.TypeLab.Position = [150 450 550 22];
            Project.TypeLab.Text = 'Enter a function or an ensamble file?';
            Project.TypeLab.FontColor = '#000000'; 
            Project.TypeLab.FontName='Lucida Handwriting';
     

%% Get Function            

            Project.RPLab = uilabel(Project.UIFigure);
            Project.RPLab.HorizontalAlignment = 'left';
            Project.RPLab.Position = [120 420 150 22];
            Project.RPLab.Text = 'RP';
            Project.RPLab.FontColor = '#000000'; 
            Project.RPLab.FontName='Lucida Handwriting';


            Project.RPTypeLab = uilabel(Project.UIFigure);
            Project.RPTypeLab.HorizontalAlignment = 'left';
            Project.RPTypeLab.Position = [170 420 150 22];
            Project.RPTypeLab.Text = 'RP Type';
            Project.RPTypeLab.FontColor = '#000000'; 
            Project.RPTypeLab.FontName='Lucida Handwriting';

            Project.IN1Lab = uilabel(Project.UIFigure);
            Project.IN1Lab.HorizontalAlignment = 'left';
            Project.IN1Lab.Position = [230 420 150 22];
            Project.IN1Lab.Text = 'Input1';
            Project.IN1Lab.FontColor = '#000000'; 
            Project.IN1Lab.FontName='Lucida Handwriting';

            Project.IN2Lab = uilabel(Project.UIFigure);
            Project.IN2Lab.HorizontalAlignment = 'left';
            Project.IN2Lab.Position = [290 420 150 22];
            Project.IN2Lab.Text = 'Input2';
            Project.IN2Lab.FontColor = '#000000'; 
            Project.IN2Lab.FontName='Lucida Handwriting';

            Project.TimeRange1Lab = uilabel(Project.UIFigure);
            Project.TimeRange1Lab.HorizontalAlignment = 'left';
            Project.TimeRange1Lab.Position = [210 380 150 22];
            Project.TimeRange1Lab.Text = 'T1';
            Project.TimeRange1Lab.FontColor = '#000000'; 
            Project.TimeRange1Lab.FontName='Lucida Handwriting';

            Project.TimeRange2Lab = uilabel(Project.UIFigure);
            Project.TimeRange2Lab.HorizontalAlignment = 'left';
            Project.TimeRange2Lab.Position = [270 380 150 22];
            Project.TimeRange2Lab.Text = 'T2';
            Project.TimeRange2Lab.FontColor = '#000000'; 
            Project.TimeRange2Lab.FontName='Lucida Handwriting';
      
            Project.RPType = uieditfield(Project.UIFigure, 'text');
            Project.RPType.ValueChangedFcn = createCallbackFcn(Project, @getRPType, true);
            Project.RPType.Position = [170 400 51 23];

            Project.IN1 = uieditfield(Project.UIFigure, 'numeric');
            Project.IN1.ValueChangedFcn = createCallbackFcn(Project, @getIn1, true);
            Project.IN1.Position = [230 400 51 23];

            Project.IN2 = uieditfield(Project.UIFigure, 'numeric');
            Project.IN2.ValueChangedFcn = createCallbackFcn(Project, @getIn2, true);
            Project.IN2.Position = [290 400 51 23];

            Project.TimeRange1 = uieditfield(Project.UIFigure, 'numeric');
            Project.TimeRange1.ValueChangedFcn = createCallbackFcn(Project, @getTime1, true);
            Project.TimeRange1.Position = [190 360 51 23];

            Project.TimeRange2 = uieditfield(Project.UIFigure, 'numeric');
            Project.TimeRange2.ValueChangedFcn = createCallbackFcn(Project, @getTime2, true);
            Project.TimeRange2.Position = [250 360 51 23];

            Project.RP = uieditfield(Project.UIFigure, 'text');
            Project.RP.ValueChangedFcn = createCallbackFcn(Project, @getRP, true);
            Project.RP.Position = [110 400 51 23];

            Project.LoadFunction = uibutton(Project.UIFigure, 'push');
            Project.LoadFunction.ButtonPushedFcn = createCallbackFcn(Project, @getInfunc, true);
            Project.LoadFunction.Position = [360 390 78 25];
            Project.LoadFunction.Text = 'Load';
            Project.LoadFunction.FontName='Lucida Handwriting';
%% Upload file

            %Create FilenameEditFieldLabel
            Project.FilenameLab = uilabel(Project.UIFigure);
            Project.FilenameLab.HorizontalAlignment = 'Center';
            Project.FilenameLab.Position = [600 420 80 22];
            Project.FilenameLab.Text = 'File name';
            Project.FilenameLab.FontColor = '#000000'; 
            Project.FilenameLab.FontName='Lucida Handwriting';
      
%             % Create FilenameEditField
            Project.Filename = uieditfield(Project.UIFigure, 'text');
            Project.Filename.ValueChangedFcn = createCallbackFcn(Project, @getfilename, true);
            Project.Filename.Position = [520 390 130 23];

           % Create LoadButton
            Project.LoadButton = uibutton(Project.UIFigure, 'push');
            Project.LoadButton.ButtonPushedFcn = createCallbackFcn(Project, @loadfile, true);
            Project.LoadButton.Position = [670 390 78 25];
            Project.LoadButton.Text = 'Load';
            Project.LoadButton.FontName='Lucida Handwriting';

%% Plotting function
            % Create SamplefunctionstodisplayEditFieldLabel
            Project.NumberofSamplefunctionsLab = uilabel(Project.UIFigure);
            Project.NumberofSamplefunctionsLab.HorizontalAlignment = 'center';
            Project.NumberofSamplefunctionsLab.Position = [520 340 250 50];
            Project.NumberofSamplefunctionsLab.Text = 'Enter the number of functions';
            Project.NumberofSamplefunctionsLab.FontColor ='#000000';
             Project.NumberofSamplefunctionsLab.FontName='Lucida Handwriting';

            % Create SamplefunctionstodisplayEditField
            Project.NumberofSamplefunctions = uieditfield(Project.UIFigure, 'numeric');
            Project.NumberofSamplefunctions.ValueChangedFcn = createCallbackFcn(Project, @getNOSampleFunctions, true);
            Project.NumberofSamplefunctions.Position = [570 330 51 21];
 
            % Create PlotfunctionButton
            Project.PlotfunctionButton = uibutton(Project.UIFigure, 'push');
            Project.PlotfunctionButton.ButtonPushedFcn = createCallbackFcn(Project, @PlotSampleFunctions, true);
            Project.PlotfunctionButton.Position = [670 330 50 22];
            Project.PlotfunctionButton.Text = 'Plot';
            Project.PlotfunctionButton.FontName='Lucida Handwriting';

            % Create CalculateandplottheensemblemeanButton
            Project.PlotMeanButton = uibutton(Project.UIFigure, 'push');
            Project.PlotMeanButton.ButtonPushedFcn = createCallbackFcn(Project, @getmean, true);
            Project.PlotMeanButton.Position = [535 285 225 25];
            Project.PlotMeanButton.Text = ' Calculate The ensamble mean';
            Project.PlotMeanButton.FontName='Lucida Handwriting';

%% ACF
            Project.ACFLab = uilabel(Project.UIFigure);
            Project.ACFLab.HorizontalAlignment = 'center';
            Project.ACFLab.Position = [490 230 320 50];
            Project.ACFLab.Text = 'Enter i and j to calculate the ACF';
            Project.ACFLab.FontColor ='#000000';
            Project.ACFLab.FontName='Lucida Handwriting';


            Project.SampleI = uieditfield(Project.UIFigure, 'numeric');
            Project.SampleI.ValueChangedFcn = createCallbackFcn(Project, @getI, true);
            Project.SampleI.Position = [480 220 51 21];

            Project.SampleJ = uieditfield(Project.UIFigure, 'numeric');
            Project.SampleJ.ValueChangedFcn = createCallbackFcn(Project, @getJ, true);
            Project.SampleJ.Position = [545 220 51 21];

            
            % Create CalculateandplottheensemblemeanButton
            Project.ACFButton=uibutton(Project.UIFigure, 'push');
            Project.ACFButton.ButtonPushedFcn = createCallbackFcn(Project, @calculateAutoCorrelation, true);
            Project.ACFButton.Position = [620 220 180 22];
            Project.ACFButton.Text = ' Calculate The ACF';
            Project.ACFButton.FontName='Lucida Handwriting';

%% 3D ACF
            Project.ThreeDACFButton=uibutton(Project.UIFigure, 'push');
            Project.ThreeDACFButton.ButtonPushedFcn = createCallbackFcn(Project, @ACF3d, true);
            Project.ThreeDACFButton.Position = [535 190 225 22];
            Project.ThreeDACFButton.Text = 'Plot 3D ACF';
            Project.ThreeDACFButton.FontName='Lucida Handwriting';

%% Time mean
            Project.TimeMeanLab = uilabel(Project.UIFigure);
            Project.TimeMeanLab.HorizontalAlignment = 'center';
            Project.TimeMeanLab.Position = [480 140 320 50];
            Project.TimeMeanLab.Text = 'Enter No.Function';
            Project.TimeMeanLab.FontColor ='#000000';
            Project.TimeMeanLab.FontName='Lucida Handwriting';


            Project.enternthmean = uieditfield(Project.UIFigure, 'numeric');
            Project.enternthmean.ValueChangedFcn = createCallbackFcn(Project, @getNofunction, true);
            Project.enternthmean.Position = [545 130 51 21];

           % Create CalculateandplottheensemblemeanButton
            Project.CalculateTimeMean = uibutton(Project.UIFigure, 'push');
            Project.CalculateTimeMean.ButtonPushedFcn = createCallbackFcn(Project, @getTimeMean, true);
            Project.CalculateTimeMean.Position = [620 130 180 22];
            Project.CalculateTimeMean.Text = ' Calculate Time mean';
            Project.CalculateTimeMean.FontName='Lucida Handwriting';
                        
%% Time ACF

            Project.TimeACFLab = uilabel(Project.UIFigure);
            Project.TimeACFLab.HorizontalAlignment = 'center';
            Project.TimeACFLab.Position = [480 90 320 50];
            Project.TimeACFLab.Text = 'Enter No.Function';
            Project.TimeACFLab.FontColor ='#000000';
            Project.TimeACFLab.FontName='Lucida Handwriting';


            Project.EnternthACF = uieditfield(Project.UIFigure, 'numeric');
            Project.EnternthACF.ValueChangedFcn = createCallbackFcn(Project, @getNofunction, true);
            Project.EnternthACF.Position = [545 80 51 21];

           % Create CalculateandplottheensemblemeanButton
            Project.TimeACFButton = uibutton(Project.UIFigure, 'push');
            Project.TimeACFButton.ButtonPushedFcn = createCallbackFcn(Project, @TimeACFFunc, true);
            Project.TimeACFButton.Position = [620 80 180 22];
            Project.TimeACFButton.Text = ' Calculate Time ACF';
            Project.TimeACFButton.FontName='Lucida Handwriting';

%% PSD
           % Create CalculateandplottheensemblemeanButton
            Project.PSDButton = uibutton(Project.UIFigure, 'push');
            Project.PSDButton.ButtonPushedFcn = createCallbackFcn(Project, @CalculatePSD, true);
            Project.PSDButton.Position = [680 40 80 22];
            Project.PSDButton.Text = 'Plot PSD';
            Project.PSDButton.FontName='Lucida Handwriting';

%% TAP

           % Create CalculateandplottheensemblemeanButton
            Project.PSDButton = uibutton(Project.UIFigure, 'push');
            Project.PSDButton.ButtonPushedFcn = createCallbackFcn(Project, @CalculateTAP, true);
            Project.PSDButton.Position = [550 40 120 22];
            Project.PSDButton.Text = 'Total Avg Power';
            Project.PSDButton.FontName='Lucida Handwriting';

%% GUI Graphs

            Project.UIAxes1 = uiaxes(Project.UIFigure);
            ylabel(Project.UIAxes1, 'Ensamble Mean',FontAngle='italic')
            xlabel(Project.UIAxes1,'Time (Sec)');
            Project.UIAxes1.Position = [25 230 225 100];

            Project.UIAxes2 = uiaxes(Project.UIFigure);
            ylabel(Project.UIAxes2, 'ACF',FontAngle='italic')
            xlabel(Project.UIAxes2,'Frequency',FontAngle='italic');
            zlabel(Project.UIAxes2,'ACF',FontAngle='italic')
            Project.UIAxes2.Position = [25 70 225 100];


            Project.UIAxes3 = uiaxes(Project.UIFigure);
            ylabel(Project.UIAxes3, 'Time ACF',FontAngle='italic')
            xlabel(Project.UIAxes3,'Time (Sec)',FontAngle='italic');
            Project.UIAxes3.Position = [250 230 225 100];   

            Project.UIAxes4 = uiaxes(Project.UIFigure);
            ylabel(Project.UIAxes4, 'PSD',FontAngle='italic')
            xlabel(Project.UIAxes4,'Frequency',FontAngle='italic');
            Project.UIAxes4.Position = [250 70 225 100];     


            % Show the figure after all components are created
            Project.UIFigure.Visible = 'on';

        end
    end



    % Project creation and deletion
    methods (Access = public)

        % Construct Project
        function  app= Project

            % Create UIFigure and components
            GUIcomponents(app)

            % Register the Project with Project Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before Project deletion
        function delete(app)

            % Delete UIFigure when Project is deleted
            delete(app.UIFigure)
        end
    end
end
