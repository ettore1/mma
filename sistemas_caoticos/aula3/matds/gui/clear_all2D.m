function clear_all2D
uu=findobj(gcf,'type','line');
nobj = length(uu);
for i=1:nobj
    set(uu(i),'EraseMode','normal');
    set(uu(i),'Xdata',[],'Ydata',[]);
    set(uu(i),'EraseMode','none');
end;
drawnow;
