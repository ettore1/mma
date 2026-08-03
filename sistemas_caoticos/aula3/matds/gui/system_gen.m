function errcode=system_gen;
%
% Generation of RHS-file oderhs.m for MATDS
%
global TRJ_bufer Time_bufer;
global bufer_i;
global DS;
global matdspath;

  cd(matdspath.temp);
  [fid,mess] = fopen('oderhs.m','w');
  fprintf(fid,'%s','function dy = oderhs(t,X,P)');
%  fprintf(fid,'\n %s','global P;');
  n_eq = size(DS.vars,2);
  fprintf(fid,'\n dy=zeros( %s,1);',int2str(n_eq));
  for i=1:n_eq
      ss = strcat(strcat(strcat(strcat('dy(',int2str(i)),')='),DS.equations_w{i}),';');
      fprintf(fid,'\n %s',ss);
  end;
%  fprintf(fid,'\n %s','dy = dy'';');
  fclose(fid);

  [fid,mess] = fopen('ode_jacob.m','w');
  fprintf(fid,'%s','function Jcb = ode_jacob(t,X,P)');
%  fprintf(fid,'\n %s','global P;');
  fprintf(fid,'\n Jcb=zeros(%s);',int2str(n_eq));
  if isempty(DS(1).jacobian)==0
     for i=1:n_eq
     for j=1:n_eq
         fprintf(fid,'\n Jcb(%s,%s)=%s;',int2str(i),int2str(j),DS(1).jacobian_w{i,j});
     end;
     end;
  else
     fprintf(fid,'\n h=sqrt(eps*1000);');
     fprintf(fid,'\n fval=feval(''oderhs'',t,X,P);');
     fprintf(fid,'\n for i=1:%s',int2str(n_eq));
     fprintf(fid,'\n     de=zeros(%s,1); de(i)=h;',int2str(n_eq));
     fprintf(fid,'\n     Jcb(:,i)=( feval(''oderhs'',t,X+de,P) -fval )./h;');
     fprintf(fid,'\n end;');
  end;
  fclose(fid);

  [fid,mess] = fopen('ode_lin.m','w');
  fprintf(fid,'%s','function [f] = ode_lin( t, X, P, n, neq, n_exp )');  
  fprintf(fid,'\n %s',' f=zeros(neq,1);');
  for i=1:n_eq
      fprintf(fid,'\n f(%s,1)=%s;',int2str(i),DS.equations_w{i});
  end;
  fprintf(fid,'\n Jcb=zeros(%s);',int2str(n_eq));
  if isempty(DS(1).jacobian)==0
     for i=1:n_eq
     for j=1:n_eq
         fprintf(fid,'\n Jcb(%s,%s)=%s;',int2str(i),int2str(j),DS(1).jacobian_w{i,j});
     end;
     end;
  else
     fprintf(fid,'\n h=sqrt(eps*1000);');
     fprintf(fid,'\n fval=feval(''oderhs'',t,X(1:n),P);');
     fprintf(fid,'\n for i=1:%s',int2str(n_eq));
     fprintf(fid,'\n     de=zeros(%s,1); de(i)=h;',int2str(n_eq));
     fprintf(fid,'\n     Jcb(:,i)=( feval(''oderhs'',t,X(1:n)+de,P) -fval )./h;');
     fprintf(fid,'\n end;');
  end;
  fprintf(fid,'\n %s','for k=1:n_exp,  f(k*n+1:(k+1)*n,1)=Jcb*X(k*n+1:(k+1)*n,1); end;');

  fclose(fid);

cd(matdspath.main);
clear oderhs;  
clear ode_jacob;

  % Trajectory bufer
    TRJ_bufer = [];
    Time_bufer = [];
    neq=size(DS.vars);
    neq=neq(2);
    TRJ_bufer = zeros(1500,neq);
    Time_bufer = zeros(1500);
    for i=1:neq
       TRJ_bufer(1,i) = 10;
    end;
    bufer_i = 1;
