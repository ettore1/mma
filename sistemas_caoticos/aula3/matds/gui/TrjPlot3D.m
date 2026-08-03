function TrjPlot3D;
% Define trajectory output regime
global TRJ_bufer Time_bufer bufer_i;

uu=findobj(gcf,'Tag','mTrajectoryPlot3D');
vv=get(gcf,'UserData');
ss=get(uu,'Checked');
if isequal(ss,'on')
   vv.trj_out = 0;
   set(uu,'Checked','off');
   set(gcf,'UserData',vv);
else
   vv.trj_out = 1;
   set(uu,'Checked','on');
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
            Zp = eval(ss.Zvalue);
            ss.traj = line(Xp,Yp,Zp,'EraseMode','none');
            set(ss.traj,'Color',colorval);
            set(gcf,'UserData',ss);

