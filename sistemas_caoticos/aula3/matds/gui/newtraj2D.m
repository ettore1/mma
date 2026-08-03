function newtraj2D;
global TRJ_bufer Time_bufer bufer_i;
global DS;
global calculation_progress;


ss=get(gcf,'UserData');
colorval=get(ss.traj,'Color');
Xdt=get(ss.traj,'Xdata');
Ydt=get(ss.traj,'Ydata');
npnt=length(Xdt);
if npnt>0
   Xp=Xdt(npnt);
   Yp=Ydt(npnt);
else
    X = TRJ_bufer(bufer_i,:);
    t = Time_bufer(bufer_i);
    Xp = eval(ss.Xvalue);
    Yp = eval(ss.Yvalue);
end;
ss.traj = line(Xp,Yp,'EraseMode','none');
set(ss.traj,'Color',colorval);
if calculation_progress==0
   set(ss.traj,'XData',[],'YData',[]);
end;
set(gcf,'UserData',ss);

