function PoincarePlot3D;
% Define regime of trajectory output

uu=findobj(gcf,'Tag','mPoincarePlot3D');
vv=get(gcf,'UserData');
ss=get(uu,'Checked');
if isequal(ss,'on')
   set(uu,'Checked','off');
   vv.poinc_out = 0;
   set(gcf,'UserData',vv);   
else
   set(uu,'Checked','on');
   vv.poinc_out = 1;
   set(gcf,'UserData',vv);   
end;

