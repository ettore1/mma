function redraw2d;

ff = get(gcf,'UserData');
fig_axes = findobj(gcf,'type','axes');
fig_lines = findobj(gcf,'type','line');
nln = length(fig_lines);

if ff.Xscaling==1
   tmp = get(fig_axes,'Xlim');
   mx_x = tmp(1);
   mn_x = tmp(2);
   for i=1:nln 
     xd = get(fig_lines(i),'XData');
     if length(xd)>=2
        mx_x = max(max(xd),mx_x);
        mn_x = min(min(xd),mn_x);
     end;
   end;
   if mx_x>mn_x, set(fig_axes,'Xlim',[mn_x mx_x]); end;
end;

if ff.Yscaling==1
   tmp = get(fig_axes,'Ylim');
   mx_x = tmp(1);
   mn_x = tmp(2);
   for i=1:nln 
     xd = get(fig_lines(i),'YData');
     if length(xd)>=2
        mx_x = max(max(xd),mx_x);
        mn_x = min(min(xd),mn_x);
     end;
   end;
   if mx_x>mn_x, set(fig_axes,'Ylim',[mn_x mx_x]); end;
end;
