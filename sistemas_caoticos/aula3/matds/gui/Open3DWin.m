function varargout = Open3DWin(varargin)
global DS;
global nbrwin;
global TRJ_bufer Time_bufer bufer_i;

        s = size(DS(1).windows,2)+1;
        nbrwin = nbrwin + 1;


	DS(1).windows(s) = openfig('plot3D.fig','new');
% Number of window
        ss=[]; ss.number = nbrwin; 
        
% Output parameters        
        ss.trj_out=1;
        ss.equil_out = 1;
        ss.poinc_out = 0;
        uu=findobj(gcf,'Tag','mPoincarePlot3D');
        set(uu,'Enable','off');

        set( DS(1).windows(s),'UserData',ss );
        set( DS(1).windows(s),'Name',strcat('Plot 3-D || ',int2str(nbrwin) ) )



        if length(DS(1).vars)<3
           plot3(Time_bufer(1),TRJ_bufer(1,1),TRJ_bufer(1,1));        
        else
           plot3(TRJ_bufer(1,1),TRJ_bufer(1,2),TRJ_bufer(1,3));        
        end;

       uu=findobj(DS(1).windows(s),'Type','line'); 
       set(uu,'EraseMode','none') ;
       set(uu,'XData',[],'YData',[],'ZData',[]);

        ss.traj=findobj(DS(1).windows(s),'Type','line');

%   Type of window 3D ss.type = 2;
        ss.type = 2;

%   Expressions for variables on axes

        if length(DS(1).vars)<3
           ss.Xexpression='t'; 
           ss.Yexpression=DS(1).vars{1};
           ss.Zexpression=DS(1).vars{1};
           ss.Xvalue='t';
           ss.Yvalue='X(1)';
           ss.Zvalue='X(1)';
        else
           ss.Xexpression=DS(1).vars{1}; 
           ss.Yexpression=DS(1).vars{2};          
           ss.Zexpression=DS(1).vars{3};          
           ss.Xvalue='X(1)';
           ss.Yvalue='X(2)';
           ss.Zvalue='X(3)';
        end;

%   Scaling regime on the axes
           ss.Xscaling = 1;
           ss.Yscaling = 1;
           ss.Zscaling = 1;

        set(DS(1).windows(s),'UserData',ss);

        axis([-50 50 -50 50 -50 50]);
        hold on;

	% Use system color scheme for figure:
	set(DS(1).windows(s),'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 

	handles = guihandles(DS(1).windows(s));
	guidata(DS(1).windows(s), handles);

%        set(handles.mNewtrajectory,'Enable','off');
%        set(handles.mVectorfield,'Enable','off');
        set(handles.mSurface,'Enable','off');
%        set(handles.mStreamtube,'Enable','off');

        var_set3d;

% Update main window and menu

        update_ds;