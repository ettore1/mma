function clear2Dtraj;
 ff = get(gcf,'UserData');
 set(ff.traj,'EraseMode','normal') ;
 set(ff.traj,'XData',[],'YData',[]);
 drawnow;
 set(ff.traj,'EraseMode','none') ;
