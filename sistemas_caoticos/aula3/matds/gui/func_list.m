function [lowlist,uplist]=func_list
% List of admissible function in MATDS-expressions.
% If is necessary to add some new function user must add
% its name in file func_list.m: lowlist{n+1}='name';

lowlist=[];

lowlist{1}='sin';
lowlist{2}='sinh';
lowlist{3}='asin';
lowlist{4}='asinh';
lowlist{5}='cos';
lowlist{6}='cosh';
lowlist{7}='acos';
lowlist{8}='acosh';
lowlist{9}='tan';
lowlist{10}='tanh';
lowlist{11}='atan';
lowlist{12}='atan2';
lowlist{13}='atanh';
lowlist{14}='sec';
lowlist{15}='sech';
lowlist{16}='asec';
lowlist{17}='asech';
lowlist{18}='csc';
lowlist{19}='csch';
lowlist{20}='acsc';
lowlist{21}='acsch';
lowlist{22}='cot';
lowlist{23}='coth';
lowlist{24}='acot';
lowlist{25}='acoth';
lowlist{26}='exp';
lowlist{27}='log';
lowlist{28}='log10';
lowlist{29}='log2';
lowlist{30}='pow2';
lowlist{31}='sqrt';
lowlist{32}='nextpow2';
lowlist{33}='abs';
lowlist{34}='max';
lowlist{35}='min';


% Convert symbols to upper 

uplist=upper(lowlist);

