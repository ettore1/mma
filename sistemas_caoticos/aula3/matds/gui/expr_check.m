function [rescode,exprcorr,ss]=expr_check(exprin,DS);
% Checking of mathematical expressions
if ischar(exprin)==0
   exprin = char(exprin);
end;
exprtemp = exprin;
rescode = 0;
exprcorr = '';

tmp_podst=[];
tmp=[];
tmpl=[];
ntmp=length(union(DS(1).vars,DS(1).param));


nvars = length(DS.vars);

% variable updating
j=0;

for i=1:nvars
    X(i) = rand;
    sstmp = strcat(strcat('X(',int2str(i)),')');
    j=j+1;
    tmp{j} = DS.vars{i};    
    tmpl(j)= length(DS.vars{i});
    tmp_podst{j}=sstmp;
%    exprtemp = strrep(exprtemp,DS.vars{i},sstmp);
end;


if ~isempty(DS.param)
    npars = length(DS.param);
% parameters updating
    for i=1:npars
        P(i) = rand;
        sstmp = strcat(strcat('P(',int2str(i)),')');
        j=j+1;
        tmp{j} = DS.param{i};    
        tmpl(j)= length(DS.param{i});
        tmp_podst{j}=sstmp;
%       exprtemp = strrep(exprtemp,DS.param(i),sstmp);
    end;
end;

[lowfunc,upfunc] = func_list;
nf = length(lowfunc);
for i=1:nf
    exprtemp = strrep(exprtemp,lowfunc{i},upfunc{i});
end;

[sres,indx]=sort(tmpl);
for i=1:ntmp
    j = ntmp - i + 1;
    indx(j);
    exprtemp = strrep(exprtemp,tmp{indx(j)},tmp_podst{indx(j)});
end;
t = rand(1);

for i=1:nf
    exprtemp = strrep(exprtemp,upfunc{i},lowfunc{i});
end;

exprcorr = exprin;

try  
    ss=eval(exprtemp); 
catch 
    errordlg(lasterr,'Error expression!!!','reuse'); 
    rescode = 1;
    exprcorr = '';
end;   
    if rescode ==0
       exprcorr = exprtemp;
    end;
