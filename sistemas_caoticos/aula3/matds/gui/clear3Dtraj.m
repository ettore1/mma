function clear3Dtraj;
 ff = get(gcf,'UserData');
 set(ff.traj,'EraseMode','normal') ;
 set(ff.traj,'XData',[],'YData',[],'Zdata',[]);
 set(ff.traj,'EraseMode','none') ;
