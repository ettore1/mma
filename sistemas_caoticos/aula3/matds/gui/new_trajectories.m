function res=new_trajectories(window_head);
global DS;
global TRJ_bufer Time_bufer bufer_i;

ss=get(window_head,'UserData');
colorval=get(ss.traj,'Color');
figure(window_head);
if ss.type==1
   X = TRJ_bufer(bufer_i,:);
   t = Time_bufer(bufer_i);
   Xp = eval(ss.Xvalue);
   Yp = eval(ss.Yvalue);
  if ss.trj_out==1
      ss.traj = line(Xp,Yp,'EraseMode','none');
      set(ss.traj,'Color',colorval);
      set(window_head,'UserData',ss);
  end;
elseif ss.type==2
    X = TRJ_bufer(bufer_i,:);
    t = Time_bufer(bufer_i);
    Xp = eval(ss.Xvalue);
    Yp = eval(ss.Yvalue);
    Zp = eval(ss.Zvalue);
    if ss.trj_out==1
        ss.traj = line(Xp,Yp,Zp,'EraseMode','none');
        set(ss.traj,'Color',colorval);
        set(window_head,'UserData',ss);
    end;
end;