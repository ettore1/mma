function clear_all3D
uu=findobj(gcf,'type','line');
nobj = length(uu);
for i=1:nobj
    set(uu(i),'EraseMode','normal');
    set(uu(i),'Xdata',[],'Ydata',[],'Zdata',[]);
    set(uu(i),'EraseMode','none');
end;
uu=findobj(gcf,'type','surface');
nobj = length(uu);
for i=1:nobj
    set(uu(i),'EraseMode','normal');
    set(uu(i),'Xdata',[],'Ydata',[],'Zdata',[],'Cdata',[]);
    set(uu(i),'EraseMode','none');
end;
drawnow;
