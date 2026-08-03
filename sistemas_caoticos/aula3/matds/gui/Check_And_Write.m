
function pass = Check_And_Write(namefiles)
%------------------------------------------------------------
%        Check and write MATDS ODE-systems files
%------------------------------------------------------------
global DS;
global matdspath;

namefs=lower(namefiles);
if isempty(namefiles)
   namefs = lower(DS(1).currfile);
end;

ns=length(namefs);
npos=findstr(namefs,filesep);
curpath = pwd;
shortname=namefs( (npos(length(npos))+1) : ns);
namepath=namefs( 1 : ( npos(length(npos))-1 ) );
cd(namepath);

u=dir(pwd);
nfls=length(u);
for i=1:nfls
    npos=findstr(lower(u(i).name),'.');
    if ( strcmp(u(i).name(1:(npos-1)),shortname)==1) & (u(i).isdir==0)
       delete(u(i).name);
    end;
end;

namef=strcat(shortname,'.mds');

     DS(1).currfile = [matdspath.systems filesep shortname];


% Save DS structure
save(namef,'DS');

% Save plot windows
nwin=length(DS(1).windows)-1;
k=1;
for i=1:nwin
    if ishandle(DS(1).windows(i+1))==1
       stemp = int2str(k);
       if k<9 stemp=['0' stemp]; end;
       namef=strcat(shortname,['.w' stemp]);
       hgsave(DS(1).windows(i+1),namef);
       k=k+1;
    end;
end;

cd(curpath);
pass = 0;
update_ds;