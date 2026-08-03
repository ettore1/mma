function varargout = Open2DWin(varargin)
global DS;
global nbrwin;
global TRJ_bufer Time_bufer bufer_i;

        s = size(DS(1).windows,2)+1;        
        nbrwin = nbrwin + 1;
        

	DS(1).windows(s) = openfig('plot2D.fig','new');
% Number of window
        ss=[]; ss.number =nbrwin; 
% Output parameters        
        ss.trj_out=1;
        ss.equil_out = 1;
        ss.poinc_out = 0;
        uu=findobj(gcf,'Tag','mPoincarePlot2D');
        set(uu,'Enable','off');
        
        set( DS(1).windows(s),'UserData',ss );
        set( DS(1).windows(s),'Name',strcat('Plot 2-D || ',int2str(nbrwin) ) )


       if length(DS(1).vars)==1
          plot(Time_bufer(1),TRJ_bufer(1,1));        
       else
          plot(TRJ_bufer(1,1),TRJ_bufer(1,2));        
       end;

       uu=findobj(DS(1).windows(s),'Type','line'); 
       set(uu,'EraseMode','none') ;
       set(uu,'XData',[],'YData',[]) ;

        ss.traj=findobj(DS(1).windows(s),'Type','line');

%   Type of window 2D ss.type = 1;
        ss.type = 1;

%   Expressions for variables on axes

        if length(DS(1).vars)==1
           ss.Xexpression='t'; 
           ss.Yexpression=DS(1).vars{1};
           ss.Xvalue='t';
           ss.Yvalue='X(1)';
        else
           ss.Xexpression=DS(1).vars{1}; 
           ss.Yexpression=DS(1).vars{2};          
           ss.Xvalue='X(1)';
           ss.Yvalue='X(2)';
        end;

%   Scaling regime on the axes
           ss.Xscaling = 1;
           ss.Yscaling = 1;

        set(DS(1).windows(s),'UserData',ss);

        axis([-50 50 -50 50]);
        hold on;

     axx=findobj(DS(1).windows(s),'type','axes');
     deflt=get(axx,'Units');
     set(axx,'Units','Characters');
     Pos_ax=get(axx,'Position');
     set(axx,'Units',deflt);

      xlabel(ss.Xexpression,'Units','Characters','Position',[Pos_ax(3)/2 -1.2],...
             'FontSize',10.0,'HorizontalAlignment','center');
      ylabel(ss.Yexpression,'Units','Characters','Position',[-5 Pos_ax(4)/2],...
             'FontSize',10.0,'HorizontalAlignment','center','Rotation',90);


        
	% Use system color scheme for figure:
	set(DS(1).windows(s),'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 

	handles = guihandles(DS(1).windows(s));
	guidata(DS(1).windows(s), handles);

%        set(handles.mNewtrajectory,'Enable','off');
%        set(handles.mVectorfield,'Enable','off');
        set(handles.mCurve,'Enable','off');

        var_set2d;

% Update main window and menu

        update_ds;