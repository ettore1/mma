function mTrajectoryPlot2D;
uu=findobj(gcf,'Tag','mTrajectoryPlot2D');
ss=get(uu,'Checked');
if isequal(ss,'on')
   set(uu,'Checked','off');
else
   set(uu,'Checked','on');
end;
