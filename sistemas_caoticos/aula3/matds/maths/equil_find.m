function  [zres,fval,niter,code] = equil_find(t, z0)
global P;
% equil_eq - algebraic equations system solution f(x)=0 by
% Newton method
%
% t  -  time
% z0   - initial approximation 
% nmax - maximal number of iterations
% del  - accuracy of solution
% jac  - function for jacobian calcullation 
%        function A=jac(t,X)
%  Jacobian will calcullate numerically if jac is empty
%
% Example:
% [x,n]=equil_find(t,z0)

zres = z0';
niter=0;
nmax = 20;
code = 0;
del = sqrt(eps);

fval=feval('oderhs',t,zres,P);
while (norm(fval)>del) & (niter<=nmax)
   Jcb=feval('ode_jacob',t,zres,P); 
   if abs( det(Jcb) )<=eps
      code = 1;
      return;
   end;
   delta_it=-Jcb\fval;
   zres = zres + delta_it;
   fval=feval('oderhs',t,zres,P);
   niter=niter+1;
end;
if niter>nmax
   code = 2;
end;

