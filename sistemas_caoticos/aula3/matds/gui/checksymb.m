function res = checksymb(symbl)
res = 0; 
if ischar(symbl)
   if ( (symbl>=char(65) ) & (symbl<=char(90) ) ) | ...
      ( (symbl>=char(97) ) & (symbl<=char(122) ) )      
      res = 2;
   end;   
   if ( (symbl>=char(48) ) & (symbl<=char(57) )  ) | ( symbl == '_')
      res = 1;
   end;
else
   errordlg('Not char variable');
end;
