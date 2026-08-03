function TrjPlot2D;
% Define regime of trajectory output

global TRJ_bufer Time_bufer bufer_i;
uu=findobj(gcf,'Tag','mTrajectoryPlot2D');
vv=get(gcf,'UserData');
ss=get(uu,'Checked');
if isequal(ss,'on')
   set(uu,'Checked','off');
   vv.trj_out = 0;
   set(gcf,'UserData',vv);   
else
   set(uu,'Checked','on');
   vv.trj_out = 1;
   set(gcf,'UserData',vv);   
end;

% Define new trajectory

         ss=get(gcf,'UserData');
         colorval=get(ss.traj,'Color');
         if bufer_i>1
            kkk = bufer_i-1;
         else
            kkk = 1;
         end;
            X = TRJ_bufer(kkk,:);
            t = Time_bufer(kkk);
            Xp = eval(ss.Xvalue);
            Yp = eval(ss.Yvalue);
            ss.traj = line(Xp,Yp,'EraseMode','none');
            set(ss.traj,'Color',colorval);
            set(gcf,'UserData',ss);
