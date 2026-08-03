function EquilibriaPlot2D;
% Define regime of trajectory output

global TRJ_bufer Time_bufer bufer_i;
uu=findobj(gcf,'Tag','mEquilibriaPlot2D');
vv=get(gcf,'UserData');
ss=get(uu,'Checked');
if isequal(ss,'on')
   set(uu,'Checked','off');
   vv.equil_out = 0;
   set(gcf,'UserData',vv);   
else
   set(uu,'Checked','on');
   vv.equil_out = 1;
   set(gcf,'UserData',vv);   
end;

