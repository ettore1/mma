function newtraj3D;
global TRJ_bufer Time_bufer bufer_i;
global DS;
global calculation_progress;

ss=get(gcf,'UserData');
colorval=get(ss.traj,'Color');
Xdt=get(ss.traj,'Xdata');
Ydt=get(ss.traj,'Ydata');
Zdt=get(ss.traj,'Zdata');
npnt=length(Xdt);
if npnt>0
   Xp=Xdt(npnt);
   Yp=Ydt(npnt);
   Zp=Zdt(npnt);
else
    X = TRJ_bufer(bufer_i,:);
    t = Time_bufer(bufer_i);
    Xp = eval(ss.Xvalue);
    Yp = eval(ss.Yvalue);
    Zp = eval(ss.Zvalue);
end;

ss.traj = line(Xp,Yp,Zp,'EraseMode','none');
set(ss.traj,'Color',colorval);

if calculation_progress==0
   set(ss.traj,'XData',[],'YData',[],'ZData',[]);
end;

set(gcf,'UserData',ss);

