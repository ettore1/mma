function PointSizeSet;
prompt = {'Enter integer number:'};
dlg_title = 'Input for size of points definition';
num_lines= 1;
def     = {'1'};
k  = inputdlg(prompt,dlg_title,num_lines,def);
uu=findobj(gcf,'type','line');
nobj = length(uu);
for i=1:nobj
    vv0 = get(uu(i),'Marker');
    vv1 = get(uu(i),'LineStyle');
    vv2 = get(uu(i),'EraseMode');
    if (vv0=='.') & (vv1=='none') & (vv2=='none')
        set(uu(i),'MarkerSize',eval(k{1}),'EraseMode','normal');
        drawnow;
        set(uu(i),'EraseMode','none');
    end
end