function ColorPlotTraj;
ss=get(gcf,'UserData');
set(ss.traj,'EraseMode','normal');
ff=uisetcolor(ss.traj,'Define color of trajectory');
drawnow;
set(ss.traj,'EraseMode','none');
%set(ff,'WindowStyle','modal');
