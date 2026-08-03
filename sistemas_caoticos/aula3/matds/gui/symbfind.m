function [r,s]=symbfind;
a=ver('symbolic');
if ~isempty([a.Name]) 
   r=1;
   s='Symbolic toolbox installed'; 
else
   r=0;
   s='Symbolic toolbox not found'; 
end;
