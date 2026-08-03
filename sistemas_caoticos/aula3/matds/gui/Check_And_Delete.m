
function pass = Check_And_Write(namefiles)
%------------------------------------------------------------
%        Check and delete MATDS ODE-systems files
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

if  strcmp(DS(1).currfile,[pwd filesep shortname])==0
    u=dir(pwd);
    nfls=length(u);
    for i=1:nfls
        npos=findstr(lower(u(i).name),'.');
        if ( strcmp(u(i).name(1:(npos-1)),shortname)==1) & (u(i).isdir==0)
           delete(u(i).name);
        end;
    end;
else 
   errordlg('These files are current!','Error file deleting!');
end;

cd(curpath);
pass = 0;
update_ds;